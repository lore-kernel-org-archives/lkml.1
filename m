Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbZC0KbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbZC0KbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZC0Ka6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:30:58 -0400
Received: from mga05.intel.com ([192.55.52.89]:39460 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754848AbZC0Ka5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:30:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="442590025"
Message-ID: <49CCAAFD.2000606@linux.intel.com>
Date: Fri, 27 Mar 2009 11:31:25 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <49CB4677.9010403@linux.intel.com> <49CC9FEC.6090300@jp.fujitsu.com>
In-Reply-To: <49CC9FEC.6090300@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:

> 
>> Any threshold in the actual error reporting should be implemented
>> in the user space processing backend, but not in the CPU, because
>> they typically need to be more fine grained than just per bank,
>> and the CPU cannot do that.
> 
> I believe that one of reasons why there is thresholding in CPU is
> because it can be help for user space.  Not all backend in the user
> space requires such fine graining.  More coarse grain also should be
> supported.

> i.e. It would be useful if the backend accounts 5 errors as 1 grain.

That's true not all require it, but then again corrected errors
are rare and it doesn't hurt to show them every event (and then skipping
every 5th in user space is trivial if they really want that). The only
cost would be a few more event transfers from kernel to user space. I haven't measured
them, but I don't think they are particularly costly.

>> The only potential reason for implementing this threshold at the
>> CPU level is if someone is concerned about CPU consumption during error storms.
>> But then the threshold should be dynamically adjusted based on the
>> current rate, otherwise it doesn't help.
> 
> So sysfs is required for such usage, right?

It just needs a kernel heuristic (perhaps a leaky bucket) roughly like:

If Too many errors in time window X
   Increase threshold
   Start timer
   If timer expires and there are no more errors in the time window lower threshold again

So basically in case you get a corrected error storm you would not log every error,
but save some CPU in not processing them all.

No sysfs needed. But again it would be somewhat complex and I didn't feel it was needed
and in any case user space might want to see every error even on a error storm
(so probably would need a new flag then to turn it off too)

BTW another thing you need to be aware of is that not all CMCI banks necessarily support
thresholds > 1. The SDM has a special algorithm to discover the counter width.
This means the scheme wouldn't work for some banks.


> I already have an another patch to have sysfs interface.

Oh no, please no sysfs interface. I know the AMD code has that, but imho it's just
a lot of (surprisingly tricky) code for very little to no gain. The surprisingly
tricky is because handling all the CPU hotplug cases correctly is not trivial.

> I'll post it next time if it helps.
> 
>> But I didn't do this so far because I didn't want to overengineer
>> and in general if you have a error storm you're likely soon dead
>> anyways.
> 
> Always it is said that corrected errors (and CE storm) will be soon
> lead an uncorrected error.  But AFAIK there is no statistics about
> that the "soon" is how much long.

User space would keep these statistics. I don't think the kernel
should bother. But that is why it is useful if it sees every event
and not only some.

> Assume that if a component starts to assert CEs, you'll not stop
> system but just schedule next maintenance by the weekend, by the
> end of the month or so.  Nothing wrong with that.

Yes that's perfectly fine, but I don't think it should be in the kernel.
Especially since it's a very user specific policy and it's definitely
not a case of "one size fits all".

> I suppose we can have something to support the few days until the
> maintenance.
> 
>> Also even if this was implemented a boot option would seem
>> like the wrong interface compared to sysfs.
> 
> CMCI is enabled before sysfs creation, isn't it?
> If someone like to disable CMCI at all, it seems sysfs is not enough.

Well they would disable a few interrupts at boot time that noone sees.
Is that a problem?

Again I'm not sure why you would want to disable CMCI, but not polling,
or polling without CMCI. Is the use case to ignore all corrected errors?
In this case you need to do something different too.
Also why can't you ignore them in the user space logging.

>> Can you please describe your rationale for this more clearly?
> 
> At first I've been asked about the default threshold of CMCI, and
> noticed there is no way to know the default value, some kind of
> "factory default."  So my concern is the "1", default value of current
> implementation, is really appropriate value or not.

It's probably a semantic issue. People know there should be a error threshold
before there's some user action to be taken for the error. Then there are other
thresholds like a threshold to prevent an error handler from taking up
too much CPU time in a storm (let's call this an interrupt threshold).
You always have to ask what threshold they mean, although I suspect
in most cases they mean the former.

These are not the same. The CMCI threshold is more useful for the later.
The former is more usefully implemented in user space, by it looking
at every error and then doing specific thresholding.

Classic case for example is to do thresholding per DIMM. But you can't
do that with the CMCI threshold because you don't have a MC bank per DIMM.
Instead you just get events with the DIMM channels. Software can do
thresholding per DIMM, but it needs to see all events then, account
them to DIMMs and keep its own thresholds.

Another problem is that for a useful threshold for maintenance
you always need aging ("leaky bucket") or ("x errors per 24h"),
otherwise you will always eventually die as soft errors accumulate over
longer uptime.

But CMCI thresholds have no aging mechanism. In theory you could
implement one in software, but it would be even more code, and
user space will do it nicer and more flexible.

> 
> I told it to querier and had some responses that:
> 1) It is heard that already there are some customer complaining about
>   error reporting for "every" CE.  So thresholding is nice solution
>   for such cases.  Is it adjustable?

Why was that a problem for the customer? It seems weird to ask
for not seeing all errors.

CMCI threshold is not a general solution for let's say only displaying every
5th CE error because not all banks support CMCI and some banks may only have
a threshold of 1.

Then again if the customer really only wants to see some subset of CE errors
I think it would be better to find out exactly what subset they want
and add an appropiate option to mcelog to only display those.

> 2) Usually reporting corrected error never have high priority so even
>   it is too higher than reference high threshold would be preferred
>   than low one.

I didn't get this. Can you explain more please?

AFAIK Thresholding has nothing to do with prioritizing? And prioritizing over what?

If you mean uncorrected errors those always get processed first anyways.

> 
> And additionally that:
> 4) It is also heard that some have no interest in correctable errors
>   at all!  In such case, kernel message "Machine check events logged"
>   for CE (it is leveled KERN_INFO and already rate-limited) can be a
>   "noise" in syslog.  Can we disable CE related stuff at all?

Currently the only way to do this is to disable mces completely.

We could add a special option, but it would be a quite different patch from the ones you
posted,

What's the use case? Is it just the sysadmin being afraid of this message or
some deeper issue?

> 5) Our BIOS provides good log enough to identify faulty component,
>   so OS log is rarely used in maintenance phase.  Comparing these log
>   will be cause of confusion, in case if they use different threshold
>   and if one reports error while another does not.  It depends on
>   the platform which log is better, but I suppose disabling OS feature
>   might be a good option for platforms where BIOS wins.

You could just not run mcelog then?  Ok I suppose still need some
way to shut up the printk in this case.


> 6) In past, EDAC driver troubled us by conflicting with BIOS since it
>   clears error information in memory controller.  It would not happen
>   in recent platforms that have processors integrated memory controller.
>   However it would be a nice workaround to have switch to disable error
>   monitoring by OS in advance, just in case there are something nasty
>   conflict in BIOS or hardware. 

mce=off ?

-Andi
