Return-Path: <linux-kernel-owner+w=401wt.eu-S965363AbXG1HbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363AbXG1HbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 03:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759940AbXG1HbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 03:31:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:54335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116AbXG1HbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 03:31:01 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CONFIG_SUSPEND? (was: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1)
Date: Sat, 28 Jul 2007 03:30:26 -0400
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <200707251238.50218.lenb@kernel.org> <200707262248.09187.rjw@sisk.pl> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707280330.26991.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007 16:55, Linus Torvalds wrote:

> Anyway, I think the ACPI problem really is as trivial as the following 
> three-liner removal fix. If the user doesn't want suspend, ACPI shouldn't 
> force it on him.
...
> -	# for sleep
> -	select HOTPLUG_CPU if X86 && SMP
> -	select SUSPEND_SMP if X86 && SMP

That three-liner will crash ACPI+SMP-HOTPLUG_CPU kernels on resume.
While cpu0 is in a known state when the power goes out,
without HOTPLUG_CPU the other cpus (and the memory they touch)
are in an indeterminate state.

Yes, we could invent a new mechanism to offline the other CPUS
before suspend and online them upon resume,
but that is what the more general HOTPLUG_CPU code does for us already.
Indeed, that is pretty much _all_ that HOTPLUG_CPU code does on X86 --
as we don't have any physical hotplug support today beneath
this the logical hotplug support -- you could call it CONFIG_CPU_OFFLINE_ONLINE...

> A nicer fix might be to also make some of the ACPI helper routines depend 
> on whether they are needed or not (which in turn will depend on whether 
> suspend support has been compiled into the kernel), but quite frankly, 
> that's secondary at least for me.
> 
> So if we have a few ACPI routines that will never get called (because we 
> don't even enable the interfaces that would *cause* them to be called), I 
> don't think that's a huge problem. It's a beauty wart, but nobody really 
> cares (and it's even something that we could get the compiler to optimize 
> away for us if we really cared).

Re: warts, I agree.
My question is why the HOTPLUG_CPU=y code is any different.
When I compile HOTPLUG_CPU out of an x86_64 kernel, the kernel shrinks
by only 18KB, which on a kernel that has ACPI+SMP doesn't seem
like such a big wart.

Yes, now that you brought it up, I think it would be just dandy if
HOTPLUG_CPU simply got folded into SMP -- for I see little to no benefit
to having it as its own config option.

But on the assumption that you are not swayed (when was the last time you were?)
and you still feel strongly we should be able to exclude ACPI_SLEEP and HOTPLUG_CPU
from ACPI+SMP kernels, I'll send you a patch do to that properly.
It will largely restores things to how we had them in 2.6.22.
It looks like a step backwards to me, but you may see it differently.

-Len
