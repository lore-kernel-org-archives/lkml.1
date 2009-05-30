Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZE3JF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZE3JF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 05:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZE3JFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 05:05:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54390 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbZE3JFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 05:05:20 -0400
Message-ID: <4A20F71F.6030703@cn.fujitsu.com>
Date: Sat, 30 May 2009 17:06:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/filters: use strcmp() instead of strncmp()
References: <4A1F9FAC.6020506@cn.fujitsu.com> <c62985530905290651id2435bfx7f57ec561fe366e3@mail.gmail.com>
In-Reply-To: <c62985530905290651id2435bfx7f57ec561fe366e3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> 2009/5/29 Li Zefan <lizf@cn.fujitsu.com>:
>> Trace filter is not working normally:
>>
>>  # echo 'name == et' > tracing/events/irq/irq_handler_entry/filter
>>  # echo 1 > tracing/events/irq/irq_handler_entry/enable
>>  # cat trace_pipe
>>      <idle>-0     [001]  1363.423175: irq_handler_entry: irq=18 handler=eth0
>>      <idle>-0     [001]  1363.934528: irq_handler_entry: irq=18 handler=eth0
>>      ...
>>
>> It's because we pass to trace_define_field() the information of
>> __str_loc_##item, but not the actual string, so pred->str_len == field->size
>> == sizeof(unsigned short), thus it always compare at most 2 bytes when
>> filtering on __string() field.
> 
> 
> Weird, I was about sure I set the size of each string() to FILTER_MAX_STRING (or
> something like that).
> 
> Anyway this patch looks good but it does more than just fixing the
> issue, it removes
> the string len boundary security we had with strncmp() for every
> string (static and
> dynamic size).
> 
> The potential side effect that comes along this patch would disappear if
> you just turn strncmp into strcmp only in filter_pred_strloc().
> 
> If you do that also for fixed size strings, then it should be done in
> a second patch,
> although I guess turning anything here into strcmp is fine because the
> strings given
> by the user are always limited in their size. But we never know...
> 

I don't think there's any security issue. It's irrelevant how big the user-input
strings are. The point is those strings are guaranteed to be NULL-terminated.
Am I missing something?

And I don't think it's necessary to make 2 patches that each patch converts
one strncmp to strcmp. But maybe it's better to improve this changelog?

> 
> Thanks,
> Frederic.
> 
> 
>> Since __string() is dynamic size, we are not able to set field->size to
>> string length. Thus this patch uses strcmp() instead of strncmp().
>>
>> [ Impact: make filter facility working normally for __string() field ]
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
