Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbZLBFf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbZLBFf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZLBFf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:35:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:43336 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZLBFf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:35:27 -0500
Message-ID: <4B15FCAB.7000209@windriver.com>
Date: Wed, 02 Dec 2009 13:35:39 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, acme@redhat.com, rostedt@goodmis.org,
       jbaron@redhat.com, tglx@linutronix.de, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com
Subject: Re: [tip:perf/core] perf probe: Add --list option for listing current
 probe events
References: <20091201002017.10235.76575.stgit@harusame> <tip-4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a@git.kernel.org> <4B15E913.1040105@windriver.com> <4B15F36F.5040304@redhat.com>
In-Reply-To: <4B15F36F.5040304@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2009 05:34:38.0731 (UTC) FILETIME=[23E4B5B0:01CA7311]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Wang Liming wrote:
>> Hi Masami,
>>
>> tip-bot for Masami Hiramatsu wrote:
>>> Commit-ID:  4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a
>>> Gitweb:    
>>> http://git.kernel.org/tip/4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a
>>> Author:     Masami Hiramatsu <mhiramat@redhat.com>
>>> AuthorDate: Mon, 30 Nov 2009 19:20:17 -0500
>>> Committer:  Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Tue, 1 Dec 2009 08:20:02 +0100
>>>
>>> perf probe: Add --list option for listing current probe events
>>>
>>> Add --list option for listing currently defined probe events
>>> in the kernel. This shows events in below format;
>>>
>>>  [group:event]    <perf-probe probe-definition>
>>>
>>> for example:
>>>
>>>  [probe:schedule_0]    schedule+30 cpu
>>>
>>> Note that source file/line information is not supported yet.
>>> So even if you added a probe by line, it will be shown in
>>> <symbol+offset>.
>> ...
>>> +
>>> +    /* Scan event and group name. */
>>> +    ret = sscanf(argv[0], "%c:%m[^/ \t]/%m[^ \t]",
>>> +             &pr, group, event);
>> "%m" are typos?
> 
> No, %m is glibc extension of sscanf modifier, which allocate
> memory for scanned string in sscanf. You can see "man sscanf"
> if your glibc is not so old (hopefully..). Please refer below;
> 
> http://www.kernel.org/doc/man-pages/online/pages/man3/scanf.3.html#NOTES
Yes, my glibc is old so that "perf" can't be built. I'm using ubuntu 8.04.

Thanks a lot.
> 
> Anyway, thank you for reviewing!
> 
>>> +    if (ret != 3)
>>> +        semantic_error("Failed to parse event name: %s", argv[0]);
>>> +    pr_debug("Group:%s Event:%s probe:%c\n", *group, *event, pr);
>>> +
>>> +    if (!pp)
>>> +        goto end;
>>> +
>>> +    pp->retprobe = (pr == 'r');
>>> +
>>> +    /* Scan function name and offset */
>>> +    ret = sscanf(argv[1], "%m[^+]+%d", &pp->function, &pp->offset);
>> the same error? fix attached below.
>>
>> -- 
>>
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index e42f3ac..8d46521 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -199,8 +199,8 @@ void parse_trace_kprobe_event(const char *str, char
>> **group, char **event,
>>          semantic_error("Too less arguments.");
>>
>>      /* Scan event and group name. */
>> -    ret = sscanf(argv[0], "%c:%m[^/ \t]/%m[^ \t]",
>> -             &pr, group, event);
>> +    ret = sscanf(argv[0], "%c:%s[^/ \t]/%s[^ \t]",
>> +             &pr, *group, *event);
>>      if (ret != 3)
>>          semantic_error("Failed to parse event name: %s", argv[0]);
>>      pr_debug("Group:%s Event:%s probe:%c\n", *group, *event, pr);
>> @@ -211,7 +211,7 @@ void parse_trace_kprobe_event(const char *str, char
>> **group, char **event,
>>      pp->retprobe = (pr == 'r');
>>
>>      /* Scan function name and offset */
>> -    ret = sscanf(argv[1], "%m[^+]+%d", &pp->function, &pp->offset);
>> +    ret = sscanf(argv[1], "%s[^+]+%d", pp->function, &pp->offset);
>>      if (ret == 1)
>>          pp->offset = 0;
>>
>>
>>
>>
> 

