Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbZDQKQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbZDQKQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbZDQKQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:16:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55175 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051AbZDQKQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uUEC1GgXWYFhk+tBhKV0NAgCsHJZBrfv4Zfp1mlx/aoca/EL6uRSOl5Cs20UnQFu8J
         vefcGc/E22yddbmCen82be6V+DXyuVdmjcnIX6ehiGDMq7Qs09BOW5FU3qqS/m5wV8bD
         iDr+Ji/yqjLA9RE36W/fWDb6v7x1B/eYVRSAM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904170552160.20429@gandalf.stny.rr.com>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>
	 <1239912812.23397.3432.camel@laptop>
	 <c62985530904161328g299e8a67q2012a577e8a2f1a4@mail.gmail.com>
	 <1239949360.23397.4065.camel@laptop>
	 <c62985530904170159j6f3b5477g411a028e69fd93f6@mail.gmail.com>
	 <1239960548.23397.4282.camel@laptop>
	 <alpine.DEB.2.00.0904170552160.20429@gandalf.stny.rr.com>
Date: Fri, 17 Apr 2009 12:16:01 +0200
Message-ID: <c62985530904170316y86e7e4bpf66f9477da0cfb39@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] tracing/events: provide string with undefined size 
	support
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/17 Steven Rostedt <rostedt@goodmis.org>:
>
> [ /me can't sleep, trying to get tired again ]
>
>
> On Fri, 17 Apr 2009, Peter Zijlstra wrote:
>
>> On Fri, 2009-04-17 at 10:59 +0200, Fr?d?ric Weisbecker wrote:
>>
>> > struct foo {
>> >    field1;
>> >    field2;
>> >    ...
>> > };
>> >
>> > struct foo *f;
>> >
>> > event = ring_buffer_lock_reserve(sizeof(*f), ...);
>> > f = ring_buffer_event_data(event);
>> >
>> > I can't use a kmalloc here. We are tracing a random event which can happen
>> > at a random frequency, random context, etc...
>>
>> Can't you add a bit to that ring_buffer_lock_reserve() thing?
>>
>> The thing I do for perf_counters is I first iterate all the output, then
>> make the reserve large enough to fit all the output in, then copy the
>> bits into the output buffer.
>>
>> The result is that the output cannot be interpreted as a fixed offset
>> struct, but that's not much of an issue anyway.
>>
>> Another possibility is using relative pointers for strings that point
>> beyond the tail of the fixed offset struct.
>>
>> So something like:
>>
>>   __field(int, foo);
>>   __string(bar);
>>   __field(int, foo2);
>>   __string(bar2);
>>   __field(int, foo3);
>>
>> would look like:
>>
>>  struct plop {
>>    int foo;
>>    char *bar;
>>    int foo2;
>>    char *bar2;
>>    int foo3;
>>
>>    char data[0];
>>  }
>>
>> and you'd do something like:
>>
>>  size = sizeof(struct plop);
>>  size += strlen(bar) + 1;
>>  size += strlen(bar2) + 1;
>>
>>  event = ring_buffer_lock_reserve(size);
>>  offset = sizeof(struct plop);
>>  my_plop.bar = (char *)offset;
>>  offset += strlen(bar) + 1;
>>  my_plop.bar2 = (char *)offset;
>>  memcpy(&event, &my_plop, sizeof(struct plop));
>>  memcpy(&event + my_plop.bar, bar, strlen(bar)+1);
>>  memcpy(&event + my_plop.bar2, bar2, strlen(bar2)+1);
>>  ring_buffer_unlock();
>>
>> Then on reading, you'd get a variable sized entry, with a fixed size
>> fixed offset struct, that contains relative offset character pointers.
>
> When I replied to Frederic, I thought I could come up with a way to do
> something like you are proposing. Instead, I only ended up with the
> variant that Frederic implemented.
>
> I've done what you are suggesting several times in tracing. Logdev does
> this in its tracing.
>
> The problem that we have, is that we don't have actual code. We have a
> TRACE_EVENT macro that is doing the work for us. This, unfortunately,
> limits what we can do.
>
> One response is to just free code it. Well, then all users of TRACE_EVENT
> would end up doing a lot more work too.
>
> The more power we put into TRACE_EVENT, the uglier and more complex it
> ends up.
>
> But that said, one could still do what you are suggesting. The "__ending"
> wart still needs to be there, since it must happen at the end of the
> struct.
>
>
>        TP_STRUCT__entry(
>                __field(int, str2loc)
>                __field(int, str3loc)
>                __string(str1)
>                __string(str2)
>                __ending_string(data, str3)
>        ),


Or something like:

 TP_STRUCT__ending_string(
)

that would do the __ending_string itself...



>        TP_fast_assign(
>                __entry->str2loc = strlen(str1);
>                __entry->str3loc = strlen(str2) + __entry->str2loc;
>                strcpy(__entry->data, str1);
>                strcpy(__entry->data + __entry->str2loc, str2)
>                strcpy(__entry->data + __entry->str3loc, str3)
>        ),
>        TP_printk("str1:%s str2:%s str3:%s\n",
>                __entry->data,
>                __entry->data + __entry->str2loc,
>                __entry->date + __entry->str3loc)
>
>
> For this to work, we need to just add a define for the __string macro for
> the reservation:
>
> #define __string(x)  __str_size_ += strlen(x) + 1;
>
> -- Steve
>
>
