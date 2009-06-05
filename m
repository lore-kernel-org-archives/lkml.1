Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZFEWBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZFEWBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZFEWA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:00:59 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:43416 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZFEWA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:00:59 -0400
Message-ID: <4A29959A.1050109@tlinx.org>
Date: Fri, 05 Jun 2009 15:00:58 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Fwd: Re: ionice priority "none: prio 0" v. "none: prio 1" v. best-effort
 	v. idle?]
X-Stationery: 0.4.8.14
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<-- vim: se sts=4 sw=4 ts=8 nosi sc ai: /-->
Thanks for the pointer to the exact C-file for the cfg scheduler, but
if you intended the 'line' tag to mean anything, line#1579
would be 38 lines beyond the end of the 1541 line file.

If you meant line 579, that points to a strict sorting based
on 'sector'  -- is that the line you meant to refer to?
I.e. if prio-class=none, then it gets "sorted into the cracks"
by sector and is serviced whenever the disk gets taken close
to that sector as governed by the 'named' (rt,be,idle) CFQ
queues?

I see no reference to the cpu priority or the nice value of
the process that has sent the request.

But if that isn't the line, I'm much more lost, since I see
no mention of a "prio=none"  I see "be","idle","rt".
But nothing for the 'none' (or unset/uninitialized case) explicitly
mentioned.  Neither do I see any reference to what might be the
cpu-priority or nice value.

In 'cfq_service_tree_add' (ln 488), I see references to:
    cfq_class_rt(cfqq), cfq_class_rt(__cfqq)
    cfq_class_idle(cfqq), cfq_class_idle(__cfqq)

Those apepar to be used to sort by rt and idle class priority,
but as already mentioned, I don't grok "idle" priority (at least
not as derived from the 'idle' classes data (of which, there is
none).

However, the 'if cases' (starting ln535) show:
1) 2 checks for relative "rt" priority & insertion
2) 2 checks for "idle" priority & insertion.
THEN
    anything that's not "rt" or "idle" gets sorted by 'key'.

Meaning if NOT "rt" or "idle", then "everything else" will be
sorted in the last if(ln543) and else(ln545) branches.

That could easily imply that 'none' OR 'be' are "equated" for
this "if-case-sort", which would mean depending on the random
value of "none"'s class data (0/4), it will get highest or
medium priority compared within the 'be' class.

Sorry, ask pointed questions, but the given source file doesn't
appear to support special treatment for the 'none' case,
OTHER than by having it be equated with the 'be' class (by default
as the schedule-class comparisons are structured as:

if (class_rt) {...}
else if (class_idle) {...}
else {
    sched with or as class_be(best_effort)
}


This would seem to indicate a fundamental error in cfq's io
scheduling.

If the above is not the case -- this is the BEST example of why
I would like "ionice" to return the actual dynamic "io-priority"
of a process -- IF, it is set by CPU priority, AND would like it
to be clear where the "cpu-governed priority" class
(currently labeled 'none', but ideally would be renamed something
like 'follow-cpu'?) maybe should be renamed 'follow-cpu'?) is
in relation to the the other named classes (idle,be,rt).


So just how confused am I, or,

Is there a problem with the code (as it appears in this module)?

Tnx,
Linda

Corrado Zoccolo wrote:
> Hi Linda,
> the ioprio class 'none' is the default class in which all processes
> are put when created, if not specified otherwise (this is in contrast
> with what I read in the man page, where it says Best Effort is the
> default).
> For CFQ (other io schedulers just ignore it), the 'none' class has a
> special meaning, in fact, looking at:
> http://git.kernel.org/?p=linux/kernel/git/aegl/linux-2.6.git;a=blob;f=block/cfq-iosched.c;h=a55a9bd75bd1baf616a3a1b7118acaeee328759f;hb=HEAD#l1579
> you will see that for processes with class 'none', the class and
> priority will be inherited from CPU scheduling (including RT
> scheduling & nice levels).
>
> HTH,
> Corrado
>
> On Fri, Jun 5, 2009 at 5:22 AM, Linda Walsh<lkml@tlinx.org> wrote:
>   
>> <-- vim: se sts=4 sw=4 ts=8 nosi sc ai: /--> I was looking at the output of
>> ionice on the various processes
>> running.
>>
>> Other than one I set for 'best-effort' (-c2), the rest all had
>> priorities of
>>   1) "none: prio 0"
>> OR
>>   2) "none: prio 4"
>>
>> Out of 183 process:
>>
>>  79 had "none: prio 0"   and
>> 103 had "none: prio 4"
>> (1 had "best effort, prio 4").
>>
>> Where does priority class  'none' fit in?  above or below 'idle'?
>>
>> Or is 'none' equal to 'best effort' (which is logical in once sense, but
>> strictly, I could argue 'none' is at least below 'best effort', and possibly
>> below idle, as 'idle' at least has been assigned a scheduling priority
>> (vs. processes that have not -- BUT, but definition, idle is clearly meant
>> to be lower precedence, so that would argue, logically, that 'none' is
>> above idle and below 'best_effort' (since processes with no assigned
>> priority would logically be below those assigned as 'best effort'.
>>
>> Within 'besteffort', 0=high, and 7=low.
>>
>> Is the same true in 'none', or are the values 'meaningless'?
>> (In which case, why do they all exist at either 4 or 0?)
>>
>> Since the iopriority DOES NOT correlate with either
>> the cpu priority nor 'nice' value, then how are different
>> processes assigned different priority values?
>> They *seem* to be mostly fixed, but very rarely I'll see maybe
>> 1 process toggle from 0 to 4 or back (but its usually fixed).
>>
>> So why is everything in the 'none' class at either "highest level" (prio
>> 0), OR the mid level of prio=4?  Um...found exception on a 32-bit i386
>> based kernel, all prio's are "none: prio 0". But two different x86_64 bit
>> kernels have "a split", majority in none:prio 4, and a minority of
>> 25-44% in 'none:prio 4'.
>>
>> I'm using the cfq scheduler on all 3 machines.
>>
>> So what is it with 'schedclass'=none?  Is it lower than 'best effort'?  (I'd
>> hope so, or like to see it that way, but wants are nice...:-))...
>>
>> If they *ARE* the same, why are 44% running at highest priority
>> (regardless of cpu prio, 'nice' value, user-id, and the rest at 'mid')?
>>
>> Why so random, but worse, why put any at 'highest' (unless they
>> ask for it).  Wouldn't 'mid' priority be consistent with 'mid-cpu-nice'
>> value of 0 (out of +/-19)?
>>
>> FWIW -- I thought once the priorities varied dynamically based on
>> cpu-nice levels (for cfq, anyway)...it would be VERY nice to see that
>> reflected in the readable ionice data for those processes.
>>
>> Thanks for clarification/enlightenment...
>> Linda
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     
>
>
>
>   


