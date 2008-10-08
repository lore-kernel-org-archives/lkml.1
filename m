Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYJHVn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYJHVn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYJHVnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:43:51 -0400
Received: from kara.rubysoft.com ([64.34.171.174]:48917 "EHLO
	kara.rubysoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbYJHVnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:43:50 -0400
Date: Wed, 8 Oct 2008 15:43:30 -0600 (MDT)
From: Jeff Hansen <x@jeffhansen.com>
X-X-Sender: ninkid@ren
Reply-To: Jeff Hansen <x@jeffhansen.com>
To: Chris Snook <csnook@redhat.com>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] Re: x86_32 tsc/pit and hrtimers
In-Reply-To: <48ED1728.5060708@redhat.com>
Message-ID: <Pine.LNX.4.64.0810081542300.14815@ren>
References: <Pine.LNX.4.64.0810071640110.25661@ren> <48ECFEDC.90305@redhat.com>
 <Pine.LNX.4.64.0810081342570.11108@ren> <48ED1728.5060708@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[HRTIMER]: Add highres=noverify option to bypass clocksource verification

This disregards the CLOCK_SOURCE_MUST_VERIFY flag on all clocksources.
This is particularly useful on legacy x86_32 systems that have no ACPI,
LAPIC, or HPET timers, where only TSC and PIT are available.

Thanks to Chris Snook for suggesting this.
---
  include/linux/clocksource.h |    2 ++
  kernel/hrtimer.c            |    2 ++
  kernel/time/clocksource.c   |    3 ++-
  3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 55e434f..90ae835 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -104,6 +104,8 @@ extern struct clocksource *clock;	/* current clocksource */
  #define CLOCK_SOURCE_WATCHDOG			0x10
  #define CLOCK_SOURCE_VALID_FOR_HRES		0x20

+extern int clocksource_noverify;
+
  /* simplify initialization of mask field */
  #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ab80515..2fdf59f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -476,6 +476,8 @@ static int __init setup_hrtimer_hres(char *str)
  		hrtimer_hres_enabled = 0;
  	else if (!strcmp(str, "on"))
  		hrtimer_hres_enabled = 1;
+	else if (!strcmp(str, "noverify"))
+		clocksource_noverify = 1;
  	else
  		return 0;
  	return 1;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index dadde53..d3c14c1 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -54,6 +54,7 @@ static LIST_HEAD(clocksource_list);
  static DEFINE_SPINLOCK(clocksource_lock);
  static char override_name[32];
  static int finished_booting;
+int clocksource_noverify;

  /* clocksource_done_booting - Called near the end of core bootup
   *
@@ -165,7 +166,7 @@ static void clocksource_check_watchdog(struct clocksource *cs)
  	unsigned long flags;

  	spin_lock_irqsave(&watchdog_lock, flags);
-	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
+	if (!clocksource_noverify && cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
  		int started = !list_empty(&watchdog_list);

  		list_add(&cs->wd_list, &watchdog_list);
-- 
1.5.6.4

On Wed, 8 Oct 2008, Chris Snook wrote:

> Jeff Hansen wrote:
>>  This worked perfectly!  I second adding a kernel option that forces
>>  trusting the TSC.  I can make a patch if you'd like.  Should the option be
>>  something like "trusttsc" or "tsc=noverify"?
>
> How about a "highres=noverify" flag, to disable all CLOCK_SOURCE_MUST_VERIFY 
> checking? People might want to use this with other timers too.
>
> -- Chris
>
>>  On Wed, 8 Oct 2008, Chris Snook wrote:
>> 
>> >  Jeff Hansen wrote:
>> > >   Linus, Ingo, All,
>> > > 
>> > >   I've been struggling with hrtimer support in 2.6.26.5 on an older
>> > >   x86_32/i386 system, and I'm wondering if there are any easy fixes 
>> > >  that you
>> > >   (or anyone else) would suggest.
>> > > 
>> > >   Basically, this system does not print out the message:
>> > > 
>> > >   "Switched to high resolution mode on CPU 0"
>> > > 
>> > >  indicating that one-shot, hrtimers, etc. won't work, since high 
>> > >  resolution
>> > >   mode has not been enabled.  I've verified that hrtimers started with
>> > >   hrtimer_start do not have the expected resolution further than 1/HZ.
>> > > 
>> > >   This system does not have LAPIC, ACPI, or HPET, so really the only
>> > >   clocksources I can use are TSC and PIT.  This should be fine (in 
>> > >  theory,
>> > >  unless it wasn't designed like that), but apparently the clocksource 
>> > >  flags
>> > >   are not initialized in such a way that one of them ever gets marked 
>> > >   as
>> > >   CLOCK_SOURCE_VALID_FOR_HRES.
>> > > 
>> > >   The flow of the flags on each of these clocksources is as follows:
>> > > 
>> > >   1) The flags on the TSC clocksource are CLOCK_SOURCE_IS_CONTINUOUS |
>> > >       CLOCK_SOURCE_MUST_VERIFY, which causes PIT to be used as the 
>> > >  watchdog
>> > >       clocksource. (see kernel/time/clocksource.c:~171)
>> > >  2) Around line 122 in kernel/time/clocksource.c, where most 
>> > >  clocksources'
>> > >       flags usually get ORed with CLOCK_SOURCE_VALID_FOR_HRES, the 
>> > >  PIT's do
>> > >       not because it is not CLOCK_SOURCE_IS_CONTINUOUS, and the TSC's 
>> > >  do not
>> > >       also because the PIT (as the watchdog) is not
>> > >       CLOCK_SOURCE_IS_CONTINUOUS.
>> > > 
>> > >  I get the same results on a new laptop booting into 32-bit Linux with 
>> > >  hpet
>> > >   and acpi disabled.
>> > > 
>> > >   Can you please tell me if this is supposed to work, and I just have a
>> > >   poorly configured kernel; or if TSC/PIT drivers were not designed to 
>> > >  work
>> > >   this way in the first place.  If it wasn't designed to do this, do 
>> > >   you
>> > >   have any tips on implementing this, since I'll be needing to do that?
>> > > 
>> > >   -Jeff Hansen
>> > 
>> >  This is not supposed to work, but it might be worthwhile to add a boot 
>> >  option to force the kernel to trust the TSC, as hardware that lacks any 
>> >  high-res timers also tends to be primitive enough that the TSC can be 
>> >  trusted, if it exists.  If you patch out the CLOCK_SOURCE_MUST_VERIFY 
>> >  flag on the TSC, do you get correctly-functioning high-res timers on 
>> >  this system?
>> > 
>> >  -- Chris
>> > 
>> > 
>> > 
>
>
>
