Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYLVXph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYLVXph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbYLVXp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:45:29 -0500
Received: from smtp-out.google.com ([216.239.45.13]:62215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbYLVXp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:45:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=OYN8p1JUdIYwO1VxiqCDppiIMmlyf5+6MnYzIur53RlTVo2VcGbIoKa6k00TbwQ5Q
	ZeuHac3y/fXaByY9BjB7w==
MIME-Version: 1.0
In-Reply-To: <1229986967.30177.78.camel@localhost.localdomain>
References: <5df78e1d0812121626k367043c6hbb0232dc20b1db78@mail.gmail.com>
	 <1229986967.30177.78.camel@localhost.localdomain>
Date: Mon, 22 Dec 2008 15:45:24 -0800
Message-ID: <5df78e1d0812221545y3805b8e0n2ab12cb660b7c10c@mail.gmail.com>
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

On Mon, Dec 22, 2008 at 3:02 PM, Steven Rostedt <srostedt@redhat.com> wrote:
> Hi Jiaying,
>
> Sorry for taking so long to reply.
No problem. Thanks for looking at it!

>
> On Fri, 2008-12-12 at 16:26 -0800, Jiaying Zhang wrote:
>> Hi Steve,
>>
>> I am doing some load testing with our kernel tracing prototype
>> that uses the unified trace buffer for managing its data. I sometimes
>> saw kernel stack dump caused by the following checking in
>> function  __rb_reserve_next:
>>         if (unlikely(next_page == cpu_buffer->commit_page)) {
>>                  WARN_ON_ONCE(1);
>>                  goto out_unlock;
>>        }
>> The comments above the code say the problem is caused by
>> "an interrupt storm that made it all the way around the buffer".
>> But I think there is race here that a single interrupt can cause
>> the check to fail. Suppose this is what happens:
>> An event is traced and calls __rb_reserve_next. Right after it
>> gets the current tail_page (line tail_page = cpu_buffer->tail_page;),
>> an interrupt happens that is also traced. The interrupt also takes
>> the same tail_page. The interrupt event moves the tail_page
>> forward if the tail_page is full. Note that the interrupt event gets
>> the old 'write' value because the first event has not updated that yet.
>
> Good catch.
>
>> So the interrupt event may also update the commit_page if it is
>> the same as the tail_page. As a result, the above check would
>> fail after the interrupt finishes and the first event resumes its execution.
>>
>> I have seen the problem happens frequently under heavy loads
>> on a multi-core machine. Interestingly, I also saw the above
>> warning that might actually be caused by an interrupt storm.
>> I was using 64k buffer size and am not sure whether it is possible
>> for so many interrupts to happen in a short time window.
>>
>> I think we can use the time_stamp to distinguish the two cases.
>> Also, in either case, it seems bad to leave the tail_page->write with
>> an invalid value because it can cause problem when a reader
>> reads the page. Here is my proposed fix for the problem:
>>
>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>> index 7f69cfe..1500f78 100644
>> --- a/kernel/trace/ring_buffer.c
>> +++ b/kernel/trace/ring_buffer.c
>> @@ -982,8 +982,11 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>>                  * it all the way around the buffer, bail, and warn
>>                  * about it.
>>                  */
>> -               if (unlikely(next_page == cpu_buffer->commit_page)) {
>> +               if (unlikely(next_page == cpu_buffer->commit_page) &&
>> +                               tail_page->time_stamp > next_page->time_stamp) {
>>                         WARN_ON_ONCE(1);
>> +                       if (tail <= BUF_PAGE_SIZE)
>> +                               local_set(&tail_page->write, tail);
>
> Actually what we probably should do instead, is simply record the commit
> page first:
>
> +       commit_page = cpu_buffer->commit_page;
> +       barrier();
>        tail_page = cpu_buffer->tail_page;
>        write = local_add_return(length, &tail_page->write);
>
>
> And then we could test next_page == commit_page instead.
Yes. This is more clear and simpler ;).

Jiaying

>
> -- Steve
>
>
>
