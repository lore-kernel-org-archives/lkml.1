Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbYLVXnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbYLVXnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYLVXm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:42:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50966 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYLVXm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:42:56 -0500
Subject: Re: races when reserving an event in the unified trace buffer
From: Steven Rostedt <srostedt@redhat.com>
To: Jiaying Zhang <jiayingz@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
       Michael Davidson <md@google.com>, Martin Bligh <mbligh@google.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <5df78e1d0812171600g15cb7c53m7fb8cc0893f861f3@mail.gmail.com>
References: <5df78e1d0812121626k367043c6hbb0232dc20b1db78@mail.gmail.com>
	 <5df78e1d0812171600g15cb7c53m7fb8cc0893f861f3@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 22 Dec 2008 18:42:48 -0500
Message-Id: <1229989368.30177.87.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiaying,

Again, sorry for taking so long to get back to you on this.

On Wed, 2008-12-17 at 16:00 -0800, Jiaying Zhang wrote:
> Hi Steve,
> 
> I mentioned in my last email that I saw the warning about the trace buffer
> became full because of an interrupt storm even with my posted patch applied.
> After adding more debugging messages, I found that the problem was actually
> caused by another race in the code.

Actually, the other email did find a bug.


>  I saw the events in the buffer were
> not just interrupts but include other kernel events as well. Looks
> like the commit
> page failed to advance because of a race between the update of tail_page in
> __rb_reserve_next_event and the following lines in the rb_set_commit_to_write:

>         while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
>                 cpu_buffer->commit_page->page->commit =
>                         cpu_buffer->commit_page->write;
>                 rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
>                 ...
>         }

You are saying an interrupt happens here that pushes the tail page one.

>         while (rb_commit_index(cpu_buffer) !=
>                rb_page_write(cpu_buffer->commit_page)) {
>                 cpu_buffer->commit_page->page->commit =
>                         cpu_buffer->commit_page->write;
>                 barrier();
>         }

Now here we are left with the tail page moved one forward but the commit
left back one, and thus we do not increment the commit.



> 
> The problem is that an interrupt can happen right after a kernel event finishes
> the condition check "cpu_buffer->commit_page != cpu_buffer->tail_page" but
> before it updates the commit value of the commit_page. If we were at the tail
> of the tail_page and the commit_page was the same as the tail_page when
> the first kernel event checked that, neither of the events would advance the
> commit_page pointer because the interrupt event was NOT the commit event
> before the kernel event updated the commit pointer and the kernel event did
> NOT see the change of the tail_page made by the interrupt event. Once we
> got into this situation, the trace buffer would soon become full and reject
> any further reservation requests.
> 
> A possible fix I think is to update the commit pointer of the commit_page
> both before and after updating the commit_page in rb_set_commit_to_write().
> Here is the proposed fix. Please let me know if my analysis makes sense
> to you. Thanks a lot!
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 7f69cfe..b345ba7 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -839,6 +839,12 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu
> *cpu_buffer)
>          * back to us). This allows us to do a simple loop to
>          * assign the commit to the tail.
>          */
> +       while (rb_commit_index(cpu_buffer) !=
> +              rb_page_write(cpu_buffer->commit_page)) {
> +               cpu_buffer->commit_page->page->commit =
> +                       cpu_buffer->commit_page->write;
> +               barrier();
> +       }

I do not think this solves it for us. Because the interrupt comes in
after the next check, and this is where we are left with the dangling
commit.

>         while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
>                 cpu_buffer->commit_page->page->commit =
>                         cpu_buffer->commit_page->write;

What we need is to add do while over the entire code with:

do {
	[...]
} while (cpu_buffer->commit_page != cpu_buffer->tail_page);

Thanks!

-- Steve


