Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbZDQKIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbZDQKIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbZDQKIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:08:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:64411 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941AbZDQKH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CsfO9gH2icwa8ABFxcCahXs18UOvbeK9Q/4How/q0Qio4ItJ5A3lXywKyM3DwbwLVr
         1q/d34Wpo/LZU3dRLbYrVFiRvIWnl0PVaS1vPD/YczgwYO1QoNCy8XvcGdhwRxh8pwoE
         jKG7VtvXtXimqRa0+3eGzvsdhN57fHbCkuDCE=
MIME-Version: 1.0
In-Reply-To: <c62985530904170304r916d978m68c275eb5618eb78@mail.gmail.com>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>
	 <1239912812.23397.3432.camel@laptop>
	 <c62985530904161328g299e8a67q2012a577e8a2f1a4@mail.gmail.com>
	 <1239949360.23397.4065.camel@laptop>
	 <c62985530904170159j6f3b5477g411a028e69fd93f6@mail.gmail.com>
	 <1239960548.23397.4282.camel@laptop>
	 <c62985530904170304r916d978m68c275eb5618eb78@mail.gmail.com>
Date: Fri, 17 Apr 2009 12:07:57 +0200
Message-ID: <c62985530904170307q2831c9ct1a7d7c0357c09203@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] tracing/events: provide string with undefined size 
	support
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17 avril 2009 12:04, Frédéric Weisbecker <fweisbec@gmail.com> a écrit :
> Le 17 avril 2009 11:29, Peter Zijlstra <a.p.zijlstra@chello.nl> a écrit :
>> On Fri, 2009-04-17 at 10:59 +0200, Frédéric Weisbecker wrote:
>>
>>> struct foo {
>>>    field1;
>>>    field2;
>>>    ...
>>> };
>>>
>>> struct foo *f;
>>>
>>> event = ring_buffer_lock_reserve(sizeof(*f), ...);
>>> f = ring_buffer_event_data(event);
>>>
>>> I can't use a kmalloc here. We are tracing a random event which can happen
>>> at a random frequency, random context, etc...
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
>>  __field(int, foo);
>>  __string(bar);
>>  __field(int, foo2);
>>  __string(bar2);
>>  __field(int, foo3);
>>
>> would look like:
>>
>>  struct plop {
>>   int foo;
>>   char *bar;
>>   int foo2;
>>   char *bar2;
>>   int foo3;
>>
>>   char data[0];
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
>
>
> I like much this idea.
> Just a small change on it: I could use absolute addresses
>

I messed up it below, but I guess you understood it.
Well just some fixes to be sure everyone understood the idea:

entry = get_entry_from_buffer();
offset = sizeof(struct plop);
entry->bar = entry + offset;
offset += strlen(str1) + 1;
entry->bar2 = entry + offset;
strcpy(entry->bar, str1);
strcpy(entry->bar2, str2);

> So that its integration will need very few changes to support printing
> and filtering. It will just behave like usual char [..].
>
> Nice! Thanks Peter.
>
