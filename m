Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZADE2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZADE2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 23:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZADE2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 23:28:24 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57913 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751954AbZADE2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 23:28:24 -0500
Message-ID: <49603AE4.80809@sgi.com>
Date: Sat, 03 Jan 2009 20:28:20 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] cpus4096 tree, part 3
References: <200901011149.18401.rusty@rustcorp.com.au> <20090103203621.GA2491@elte.hu> <alpine.LFD.2.00.0901031244090.3179@localhost.localdomain> <200901041405.15096.rusty@rustcorp.com.au>
In-Reply-To: <200901041405.15096.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Sunday 04 January 2009 07:26:03 Linus Torvalds wrote:
>> On Sat, 3 Jan 2009, Ingo Molnar wrote:
>>>> Has anybody looked at what the stack size is with MAXSMP set with an 
>>>> allyesconfig? And what areas are still problematic, if any? Are we going 
>>>> to have some code-paths that still essentially have 1kB+ of stack space 
>>>> just because they haven't been converted and still have the cpu mask on 
>>>> stack?
>>> ok, indeed testing of that is in order now.
>> Well, since I can compile a allyesconfig pretty quickly, I did the static 
>> part. It looks better than it used to, and I think most of the huge stacks 
>> are totally unrealted to cpu masks. But not all.
>>
>> But it looks like we have a few:
>>
>>  - flush_tlb_current_task:
>> 	cpumask_t cpu_mask;
>>  - flush_tlb_mm:
>> 	cpumask_t cpu_mask;
> ...
>>  - acpi_cpufreq_target:
>> 	cpumask_t online_policy_cpus
> 
> Mike?  These are x86-specific...

I've been testing the heck out of it... ;-)

> 
>>  - local_cpus_show:
>> 	cpumask_t mask;
>>  - local_cpulist_show:
>> 	cpumask_t mask;

Yes, these are in my "real soon now" patchset.  Trivial.
> 
> Yes, this removal is still in my queue.  I'll double-check that all the
> archs have the new "cpumask_of_pcibus". (cpumask:replace-and-remove-pcibus_to_cpumask.patch "cpumask: remove the now-obsoleted pcibus_to_cpumask()").
> 
>> and then we have a number of things that have "struct cpufreq_policy" on 
>> the stack, and those things have two cpumask_t's in each.
> 
> Yep, we have the conversion for that too.  Mike, it's cpumask:convert-drivers_acpi.patch "cpumask: convert struct cpufreq_policy to cpumask_var_t."
> 
That's part of what I'm testing above.

>> The rest of the high-stack-usage cases - from a _very_ quick look - seem 
>> to be unrelated to CPU masks, but in the "more than 1kB of stack" group 
>> about a third (wild handwaving eyeballing) of them do seem to be related 
>> to cpumask.
> 
> Mike was tracking this; I think he has a script to set NR_CPUS small then
> large and dump the changes.

It's looking pretty good, only 11 > 1k and 19 more > 512.
 
Thanks,
Mike
