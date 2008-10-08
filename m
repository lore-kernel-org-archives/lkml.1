Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYJHSlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYJHSlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 14:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYJHSlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 14:41:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39396 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYJHSlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 14:41:16 -0400
Message-ID: <48ECFEDC.90305@redhat.com>
Date: Wed, 08 Oct 2008 14:41:32 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeff Hansen <x@jeffhansen.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: x86_32 tsc/pit and hrtimers
References: <Pine.LNX.4.64.0810071640110.25661@ren>
In-Reply-To: <Pine.LNX.4.64.0810071640110.25661@ren>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Hansen wrote:
> Linus, Ingo, All,
> 
> I've been struggling with hrtimer support in 2.6.26.5 on an older 
> x86_32/i386 system, and I'm wondering if there are any easy fixes that you
> (or anyone else) would suggest.
> 
> Basically, this system does not print out the message:
> 
> "Switched to high resolution mode on CPU 0"
> 
> indicating that one-shot, hrtimers, etc. won't work, since high resolution
> mode has not been enabled.  I've verified that hrtimers started with
> hrtimer_start do not have the expected resolution further than 1/HZ.
> 
> This system does not have LAPIC, ACPI, or HPET, so really the only
> clocksources I can use are TSC and PIT.  This should be fine (in theory,
> unless it wasn't designed like that), but apparently the clocksource flags
> are not initialized in such a way that one of them ever gets marked as
> CLOCK_SOURCE_VALID_FOR_HRES.
> 
> The flow of the flags on each of these clocksources is as follows:
> 
> 1) The flags on the TSC clocksource are CLOCK_SOURCE_IS_CONTINUOUS |
>     CLOCK_SOURCE_MUST_VERIFY, which causes PIT to be used as the watchdog
>     clocksource. (see kernel/time/clocksource.c:~171)
> 2) Around line 122 in kernel/time/clocksource.c, where most clocksources'
>     flags usually get ORed with CLOCK_SOURCE_VALID_FOR_HRES, the PIT's do
>     not because it is not CLOCK_SOURCE_IS_CONTINUOUS, and the TSC's do not
>     also because the PIT (as the watchdog) is not
>     CLOCK_SOURCE_IS_CONTINUOUS.
> 
> I get the same results on a new laptop booting into 32-bit Linux with hpet
> and acpi disabled.
> 
> Can you please tell me if this is supposed to work, and I just have a
> poorly configured kernel; or if TSC/PIT drivers were not designed to work
> this way in the first place.  If it wasn't designed to do this, do you
> have any tips on implementing this, since I'll be needing to do that?
> 
> -Jeff Hansen

This is not supposed to work, but it might be worthwhile to add a boot option to 
force the kernel to trust the TSC, as hardware that lacks any high-res timers 
also tends to be primitive enough that the TSC can be trusted, if it exists.  If 
you patch out the CLOCK_SOURCE_MUST_VERIFY flag on the TSC, do you get 
correctly-functioning high-res timers on this system?

-- Chris
