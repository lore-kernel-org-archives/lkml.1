Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZC3JGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZC3JGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZC3JGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:06:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58899 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbZC3JGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:06:21 -0400
Message-ID: <49D08B85.9040206@jp.fujitsu.com>
Date: Mon, 30 Mar 2009 18:06:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <49CB4677.9010403@linux.intel.com> <49CC9FEC.6090300@jp.fujitsu.com> <49CCAAFD.2000606@linux.intel.com>
In-Reply-To: <49CCAAFD.2000606@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto wrote:
>>> The only potential reason for implementing this threshold at the
>>> CPU level is if someone is concerned about CPU consumption during error storms.
>>> But then the threshold should be dynamically adjusted based on the
>>> current rate, otherwise it doesn't help.
>> So sysfs is required for such usage, right?
> 
> It just needs a kernel heuristic (perhaps a leaky bucket) roughly like:
> 
> If Too many errors in time window X
>    Increase threshold
>    Start timer
>    If timer expires and there are no more errors in the time window lower threshold again
> 
> So basically in case you get a corrected error storm you would not log every error,
> but save some CPU in not processing them all.

FYI, on IPF, it switches CMCI to polling once error storm (5times/s) happened.
And it return to CMCI if no error detected in a polling interval.

I'm difficult to say which is better, however having such heuristic is good idea.

> No sysfs needed. But again it would be somewhat complex and I didn't feel it was needed
> and in any case user space might want to see every error even on a error storm
> (so probably would need a new flag then to turn it off too)

I suppose AMD's threshold sysfs looks complex because it is per-bank.
User rarely knows which bank is for what kind of errors, and it may be
varies on models of the processor.

And it seems there are no user land backend that utilize the per-bank
threshold.  It can be said that the per-bank threshold is too difficult
for users who don't know about banks, and also that it is too useless for
backends who knows about banks and who can have threshold in itself.

> BTW another thing you need to be aware of is that not all CMCI banks necessarily support
> thresholds > 1. The SDM has a special algorithm to discover the counter width.
> This means the scheme wouldn't work for some banks.

My current implementation already follows the SDM.
It discovers maximum threshold the bank supports (which can be "1"),
and set the lower threshold, i.e. either the specified or the maximum. 

I should have document that "if the maximum threshold the bank supports
is lower than the specified, the maximum is used."

>> I already have an another patch to have sysfs interface.
> 
> Oh no, please no sysfs interface. I know the AMD code has that, but imho it's just
> a lot of (surprisingly tricky) code for very little to no gain. The surprisingly
> tricky is because handling all the CPU hotplug cases correctly is not trivial.

Do you say no even if it is not per-bank?
I'd like to have only one file that controls global value for all banks.
It is rather simple and easy to use for users (not for intelligent backend).

And again if a backend want to have different threshold for each bank, it
can implement it by itself in user land.

>>> Also even if this was implemented a boot option would seem
>>> like the wrong interface compared to sysfs.
>> CMCI is enabled before sysfs creation, isn't it?
>> If someone like to disable CMCI at all, it seems sysfs is not enough.
> 
> Well they would disable a few interrupts at boot time that noone sees.
> Is that a problem?
> 
> Again I'm not sure why you would want to disable CMCI, but not polling,
> or polling without CMCI. Is the use case to ignore all corrected errors?
> In this case you need to do something different too.
> Also why can't you ignore them in the user space logging.

Such staggered disablements is not what comes first.
As Ingo pointed, I think "CMCI is a new CPU feature so having boot controls
to disable it is generally a good idea" + "and it might be handy if the hw
is misbehaving."

Summarize:
 - Disabling CMCI (=use polling instead) is nice to have.
 - Disabling polling (but use CMCI) is pointless.
    (only use on trouble that only break polling?)
 - Disabling stuff for CE (both of polling and CMCI) will be help for some
   particular cases.
 - Increasing threshold is not so good idea?

Personally, instead of "mce=nopoll" and "mce_threshold=[0|N]", an alternative
combination, one like "mce=no_corrected" or "mce=ignore_ce" for disable both
and another like "mce=no_cmci" for disabling CMCI, would be also OK.
Which do you prefer?

>>> Can you please describe your rationale for this more clearly?
>> At first I've been asked about the default threshold of CMCI, and
>> noticed there is no way to know the default value, some kind of
>> "factory default."  So my concern is the "1", default value of current
>> implementation, is really appropriate value or not.
> 
> It's probably a semantic issue. People know there should be a error threshold
> before there's some user action to be taken for the error. Then there are other
> thresholds like a threshold to prevent an error handler from taking up
> too much CPU time in a storm (let's call this an interrupt threshold).
> You always have to ask what threshold they mean, although I suspect
> in most cases they mean the former.
> 
> These are not the same. The CMCI threshold is more useful for the later.
> The former is more usefully implemented in user space, by it looking
> at every error and then doing specific thresholding.
> 
> Classic case for example is to do thresholding per DIMM. But you can't
> do that with the CMCI threshold because you don't have a MC bank per DIMM.
> Instead you just get events with the DIMM channels. Software can do
> thresholding per DIMM, but it needs to see all events then, account
> them to DIMMs and keep its own thresholds.

I don't doubt that threshold "1" is best setting for intelligent backend.

>> I told it to querier and had some responses that:
>> 1) It is heard that already there are some customer complaining about
>>   error reporting for "every" CE.  So thresholding is nice solution
>>   for such cases.  Is it adjustable?
> 
> Why was that a problem for the customer? It seems weird to ask
> for not seeing all errors.

IIRC, the complain was from user of IPF, because it was "noise" for him.
Or just there was "it would be acceptable if the rate were 1/5" or so.
Real solution will be killing CE related stuff in kernel at all, anyway.

>> 2) Usually reporting corrected error never have high priority so even
>>   it is too higher than reference high threshold would be preferred
>>   than low one.
> 
> I didn't get this. Can you explain more please?

Maybe, in other words, "fine grain is not always required."

(It seems there is not, but) If there were reference values for threshold,
and if it varies on banks (for example it is "100 for bankA" and "50 for
bankB"), it means "100 in bankA" and "50 in bankB" is weighted as same level
at least in the reference.  If fail rate of componentA linked to bankA close
to be 100% at 10000 count, fail rate of componentB is supposed to be close
to 100% at 5000.

I should have ask this first:
  Are there any reference value for CMCI threshold?

>> And additionally that:
>> 4) It is also heard that some have no interest in correctable errors
>>   at all!  In such case, kernel message "Machine check events logged"
>>   for CE (it is leveled KERN_INFO and already rate-limited) can be a
>>   "noise" in syslog.  Can we disable CE related stuff at all?
> 
> Currently the only way to do this is to disable mces completely.

The "mce=off" (and "nomce") have side effects.
It prevents not only initialization/registration of machine check handler, but
also prevents setting bit in CR4, i.e. enabling machine check exception.

According to SDM 3A 5.15 Interrupt 18―Machine-Check Exception (#MC):
  "If the machine-check mechanism is not enabled (the MCE flag in control
   register CR4 is clear), a machine-check exception causes the processor
   to enter the shutdown state."

In short, it changes behavior on uncorrected errors, from "panic" to "hang up."
It also changes #MC to IERR#, and it could let BIOS to different operation.

>> 5) Our BIOS provides good log enough to identify faulty component,
>>   so OS log is rarely used in maintenance phase.  Comparing these log
>>   will be cause of confusion, in case if they use different threshold
>>   and if one reports error while another does not.  It depends on
>>   the platform which log is better, but I suppose disabling OS feature
>>   might be a good option for platforms where BIOS wins.
> 
> You could just not run mcelog then?  Ok I suppose still need some
> way to shut up the printk in this case.

The printk is, yes, need to be shut up, I also suppose.

>> 6) In past, EDAC driver troubled us by conflicting with BIOS since it
>>   clears error information in memory controller.  It would not happen
>>   in recent platforms that have processors integrated memory controller.
>>   However it would be a nice workaround to have switch to disable error
>>   monitoring by OS in advance, just in case there are something nasty
>>   conflict in BIOS or hardware. 
> 
> mce=off ?

It doesn't help.  The side effect will be a another issue.


Thanks,
H.Seto

