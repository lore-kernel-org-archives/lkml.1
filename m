Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbZC3KFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbZC3KFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 06:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZC3KFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 06:05:09 -0400
Received: from mga06.intel.com ([134.134.136.21]:32640 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755832AbZC3KFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 06:05:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,445,1233561600"; 
   d="scan'208";a="398638545"
Message-ID: <49D0996D.1050106@linux.intel.com>
Date: Mon, 30 Mar 2009 12:05:33 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <49CB4677.9010403@linux.intel.com> <49CC9FEC.6090300@jp.fujitsu.com> <49CCAAFD.2000606@linux.intel.com> <49D08B85.9040206@jp.fujitsu.com>
In-Reply-To: <49D08B85.9040206@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
>> BTW another thing you need to be aware of is that not all CMCI banks necessarily support
>> thresholds > 1. The SDM has a special algorithm to discover the counter width.
>> This means the scheme wouldn't work for some banks.
> 
> My current implementation already follows the SDM.

Yes didn't want to doubt that, just saying that it's not very useful
to play with the thresholds on those "only one" banks.

> I should have document that "if the maximum threshold the bank supports
> is lower than the specified, the maximum is used."
> 
>>> I already have an another patch to have sysfs interface.
>> Oh no, please no sysfs interface. I know the AMD code has that, but imho it's just
>> a lot of (surprisingly tricky) code for very little to no gain. The surprisingly
>> tricky is because handling all the CPU hotplug cases correctly is not trivial.
> 
> Do you say no even if it is not per-bank?

It'll be messy even without per bank. sysfs doesn't have a framework
for per cpu values, so everything has to be reimplemented in everyone.
e.g. one issue is also shared banks: you have to pass ownership
to another CPU when someone offlines a sibling. It's quite messy.

> I'd like to have only one file that controls global value for all banks.
> It is rather simple and easy to use for users (not for intelligent backend).

My main problem is that there is imho no useful use case for it.
And adding code for something that has no use case seems .... wasteful.
I typically don't object if it's only a few lines, but if it's complicated
then I do.

> Such staggered disablements is not what comes first.
> As Ingo pointed, I think "CMCI is a new CPU feature so having boot controls
> to disable it is generally a good idea" + "and it might be handy if the hw
> is misbehaving."

Ok, that would argue for a boot parameter.

I'm not 100% sure of its wisdom because I know you'll get some misbehavior
on Nehalem if you turn it off because of shared banks.


> Summarize:
>  - Disabling CMCI (=use polling instead) is nice to have.

with a boot parameter.

>  - Disabling polling (but use CMCI) is pointless.
>     (only use on trouble that only break polling?)

You can already do that by setting check_interval == 0


>  - Disabling stuff for CE (both of polling and CMCI) will be help for some
>    particular cases.

Actually I have my doubts of that (if you think of the SMI logging
which should be able to get them first anyways without kernel options),
but a boot option for this at least wouldn't be particularly
bloated. I suspect the use case would be to mainly shut off
the printk.

>  - Increasing threshold is not so good idea?

Yes.

> 
> Personally, instead of "mce=nopoll" and "mce_threshold=[0|N]", an alternative
> combination, one like "mce=no_corrected" or "mce=ignore_ce" for disable both
> and another like "mce=no_cmci" for disabling CMCI, would be also OK.
> Which do you prefer?

mce=ignore_ce and mce=no_cmci

However I think you can do the ignore_ce part in your BIOS
too if you want (SMI code could as well clean those after
logging)

And for no_cmci see the caveats above.

Also it's still open if you want to do the logging of left over
errors from boot too or not included with this.

How about UC errors that are left over from the last panic?
If you want to disable those too (I suspect you might because
your BIOS probably logged them) then the ignore_ce option would
be misnamed because it would need to apply to UC too.

> IIRC, the complain was from user of IPF, because it was "noise" for him.
> Or just there was "it would be acceptable if the rate were 1/5" or so.
> Real solution will be killing CE related stuff in kernel at all, anyway.

Or in the BIOS. We can do it in the kernel, but I suspect for you
it would be user friendlier if the BIOS just never made them
visible.

> I should have ask this first:
>   Are there any reference value for CMCI threshold?

Not that I know of.

I actually asked and I was told the CMCI threshold was more for avoiding
(very) theoretical storms than to do real error thresholding.

> 
> In short, it changes behavior on uncorrected errors, from "panic" to "hang up."

Playing devils advocate here, but if your BIOS is really that intelligent
isn't that what you want?  As far as I understand your patches seem
to be all about moving things from the OS to the BIOS and that
would be the ultimate way to move UC errors to the BIOS too.

-Andi
