Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753369AbYLRAAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYLRAAl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 19:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYLRAAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 19:00:31 -0500
Received: from smtp-out.google.com ([216.239.45.13]:31438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYLRAAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 19:00:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=c5qPxvBgzwrRkqAfRAJZRL1Qz9UA/tFTtoN4qyDPJIVIk/vVGZBPQMTNXMb2/mzLy
	V+blGmb3pV3Nuw8Tn375Q==
MIME-Version: 1.0
In-Reply-To: <5df78e1d0812121626k367043c6hbb0232dc20b1db78@mail.gmail.com>
References: <5df78e1d0812121626k367043c6hbb0232dc20b1db78@mail.gmail.com>
Date: Wed, 17 Dec 2008 16:00:27 -0800
Message-ID: <5df78e1d0812171600g15cb7c53m7fb8cc0893f861f3@mail.gmail.com>
Subject: Re: races when reserving an event in the unified trace buffer
From: Jiaying Zhang <jiayingz@google.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        Michael Davidson <md@google.com>, Martin Bligh <mbligh@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

I mentioned in my last email that I saw the warning about the trace buffer
became full because of an interrupt storm even with my posted patch applied.
After adding more debugging messages, I found that the problem was actually
caused by another race in the code. I saw the events in the buffer were
not just interrupts but include other kernel events as well. Looks
like the commit
page failed to advance because of a race between the update of tail_page in
__rb_reserve_next_event and the following lines in the rb_set_commit_to_write:

        while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
                cpu_buffer->commit_page->page->commit =
                        cpu_buffer->commit_page->write;
                rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
                ...
        }
        while (rb_commit_index(cpu_buffer) !=
               rb_page_write(cpu_buffer->commit_page)) {
                cpu_buffer->commit_page->page->commit =
                        cpu_buffer->commit_page->write;
                barrier();
        }

The problem is that an interrupt can happen right after a kernel event finishes
the condition check "cpu_buffer->commit_page != cpu_buffer->tail_page" but
before it updates the commit value of the commit_page. If we were at the tail
of the tail_page and the commit_page was the same as the tail_page when
the first kernel event checked that, neither of the events would advance the
commit_page pointer because the interrupt event was NOT the commit event
before the kernel event updated the commit pointer and the kernel event did
NOT see the change of the tail_page made by the interrupt event. Once we
got into this situation, the trace buffer would soon become full and reject
any further reservation requests.

A possible fix I think is to update the commit pointer of the commit_page
both before and after updating the commit_page in rb_set_commit_to_write().
Here is the proposed fix. Please let me know if my analysis makes sense
to you. Thanks a lot!

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7f69cfe..b345ba7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -839,6 +839,12 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu
*cpu_buffer)
         * back to us). This allows us to do a simple loop to
         * assign the commit to the tail.
         */
+       while (rb_commit_index(cpu_buffer) !=
+              rb_page_write(cpu_buffer->commit_page)) {
+               cpu_buffer->commit_page->page->commit =
+                       cpu_buffer->commit_page->write;
+               barrier();
+       }
        while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
                cpu_buffer->commit_page->page->commit =
                        cpu_buffer->commit_page->write;

Jiaying

On Fri, Dec 12, 2008 at 4:26 PM, Jiaying Zhang <jiayingz@google.com> wrote:
> Hi Steve,
>
> I am doing some load testing with our kernel tracing prototype
> that uses the unified trace buffer for managing its data. I sometimes
> saw kernel stack dump caused by the following checking in
> function  __rb_reserve_next:
>        if (unlikely(next_page == cpu_buffer->commit_page)) {
>                 WARN_ON_ONCE(1);
>                 goto out_unlock;
>       }
> The comments above the code say the problem is caused by
> "an interrupt storm that made it all the way around the buffer".
> But I think there is race here that a single interrupt can cause
> the check to fail. Suppose this is what happens:
> An event is traced and calls __rb_reserve_next. Right after it
> gets the current tail_page (line tail_page = cpu_buffer->tail_page;),
> an interrupt happens that is also traced. The interrupt also takes
> the same tail_page. The interrupt event moves the tail_page
> forward if the tail_page is full. Note that the interrupt event gets
> the old 'write' value because the first event has not updated that yet.
> So the interrupt event may also update the commit_page if it is
> the same as the tail_page. As a result, the above check would
> fail after the interrupt finishes and the first event resumes its execution.
>
> I have seen the problem happens frequently under heavy loads
> on a multi-core machine. Interestingly, I also saw the above
> warning that might actually be caused by an interrupt storm.
> I was using 64k buffer size and am not sure whether it is possible
> for so many interrupts to happen in a short time window.
>
> I think we can use the time_stamp to distinguish the two cases.
> Also, in either case, it seems bad to leave the tail_page->write with
> an invalid value because it can cause problem when a reader
> reads the page. Here is my proposed fix for the problem:
>
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 7f69cfe..1500f78 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -982,8 +982,11 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>                 * it all the way around the buffer, bail, and warn
>                 * about it.
>                 */
> -               if (unlikely(next_page == cpu_buffer->commit_page)) {
> +               if (unlikely(next_page == cpu_buffer->commit_page) &&
> +                               tail_page->time_stamp > next_page->time_stamp) {
>                        WARN_ON_ONCE(1);
> +                       if (tail <= BUF_PAGE_SIZE)
> +                               local_set(&tail_page->write, tail);
>                        goto out_unlock;
>                }
>
>
> Jiaying
>
