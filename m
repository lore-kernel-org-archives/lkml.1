Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbYKIWxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbYKIWxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 17:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYKIWxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 17:53:34 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:25393 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869AbYKIWxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 17:53:33 -0500
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Date: Sun, 9 Nov 2008 23:53:28 +0100
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, corsac@debian.org
References: <20081104173300.GF6134@ics.muni.cz> <20081109132438.5d81cd74@infradead.org> <alpine.LFD.2.00.0811092226050.12263@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0811092226050.12263@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811092353.30297.elendil@planet.nl>
X-OriginalArrivalTime: 09 Nov 2008 22:53:30.0705 (UTC) FILETIME=[FC5E2410:01C942BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 November 2008, Thomas Gleixner wrote:
> Find below the lineup of the timers-fixes-for-linus branch of the tip
> tree (the same as Arjan posted minus the irq fixes)

I've tested with Thomas' patch set on top of v2.6.28-rc3-261-g8b805ef.

The notebook boots normally, but spends way too much time in C0.

Cheers,
FJP


POWERTOP BEFORE
===============
This is somewhere around -rc3-200 with peek_ahead disabled with a return
in the function. System is on battery after having been suspended to RAM
a few times

Note the double C0 and missing P-states.

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 3.2%)
C0                0.0ms ( 0.0%)
C1                0.0ms ( 0.0%)
C2                0.9ms ( 0.1%)
C4                3.4ms (96.7%)

Wakeups-from-idle per second : 289.1    interval: 10.0s
Power usage (ACPI estimate): 9.8W (4.5 hours)

Top causes for wakeups:
  42.8% (136.5)       <interrupt> : extra timer interrupt
  30.5% ( 97.2)       <interrupt> : PS/2 keyboard/mouse/touchpad
  12.4% ( 39.5)      <kernel IPI> : Rescheduling interrupts
   3.6% ( 11.6)       <interrupt> : iwlagn
   2.5% (  8.0)   <kernel module> : mod_timer (rh_timer_func)
   1.7% (  5.4)             artsd : schedule_hrtimeout_range (hrtimer_wakeup)
   1.1% (  3.6)     <kernel core> : hrtimer_start (tick_sched_timer)
   1.0% (  3.1)       <interrupt> : acpi
   0.6% (  2.0)            kicker : schedule_hrtimeout_range (hrtimer_wakeup)
   0.4% (  1.2)           klipper : schedule_hrtimeout_range (hrtimer_wakeup)
   0.3% (  1.1)          kdesktop : schedule_hrtimeout_range (hrtimer_wakeup)
   0.3% (  1.0)      kwifimanager : schedule_hrtimeout_range (hrtimer_wakeup)
   0.3% (  1.0)     <kernel core> : enqueue_task_rt (sched_rt_period_timer)
   0.3% (  1.0)             artsd : hrtimer_start (it_real_fn)
   0.3% (  1.0)          kwrapper : do_nanosleep (hrtimer_wakeup)
   0.3% (  1.0)              kwin : schedule_hrtimeout_range (hrtimer_wakeup)
   0.3% (  0.9)              Xorg : schedule_hrtimeout_range (hrtimer_wakeup)
   0.2% (  0.5)            iwlagn : mod_timer (ieee80211_sta_timer)
   0.2% (  0.5)         gpg-agent : schedule_hrtimeout_range (hrtimer_wakeup)
   0.2% (  0.5)   hald-addon-stor : schedule_hrtimeout_range (hrtimer_wakeup)


POWERTOP AFTER
==============
Again on battery; P-states are back and the second C0 is now "polling"
(both same as with 2.6.27.4).

System permanently remains very high in C0!
Wakeups go down to ~30 without user input (keyboard/mouse activity), which
is a bit lower than I get with .27.4.

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (49.7%)         1333 Mhz     0.0%
polling           0.0ms ( 0.0%)         1200 Mhz     0.0%
C1                0.0ms ( 0.0%)         1067 Mhz     0.0%
C2                7.5ms ( 1.9%)          800 Mhz   100.0%
C4                8.5ms (48.4%)

Wakeups-from-idle per second : 59.6     interval: 15.0s
Power usage (ACPI estimate): 9.7W (4.4 hours)

Top causes for wakeups:
  34.6% ( 36.3)       <interrupt> : PS/2 keyboard/mouse/touchpad
  16.0% ( 16.7)      <kernel IPI> : Rescheduling interrupts
   8.9% (  9.3)       <interrupt> : iwlagn
   8.4% (  8.8)       <interrupt> : extra timer interrupt
   7.8% (  8.1)   <kernel module> : mod_timer (rh_timer_func)
   5.6% (  5.9)     <kernel core> : hrtimer_start (tick_sched_timer)
   5.2% (  5.4)             artsd : schedule_hrtimeout_range (hrtimer_wakeup)
   2.9% (  3.0)            kicker : schedule_hrtimeout_range (hrtimer_wakeup)
   1.1% (  1.2)          kdesktop : schedule_hrtimeout_range (hrtimer_wakeup)
   1.0% (  1.1)              Xorg : schedule_hrtimeout_range (hrtimer_wakeup)
   1.0% (  1.0)      kwifimanager : schedule_hrtimeout_range (hrtimer_wakeup)
   1.0% (  1.0)             artsd : hrtimer_start (it_real_fn)
   1.0% (  1.0)          kwrapper : do_nanosleep (hrtimer_wakeup)
   1.0% (  1.0)              kwin : schedule_hrtimeout_range (hrtimer_wakeup)
   1.0% (  1.0)           klipper : schedule_hrtimeout_range (hrtimer_wakeup)
   0.5% (  0.5)   hald-addon-stor : schedule_hrtimeout_range (hrtimer_wakeup)
   0.5% (  0.5)            iwlagn : mod_timer (ieee80211_sta_timer)
   0.5% (  0.5)     <kernel core> : __mod_timer (neigh_periodic_timer)
   0.4% (  0.5)         gpg-agent : schedule_hrtimeout_range (hrtimer_wakeup)
   0.4% (  0.4)           knotify : schedule_hrtimeout_range (hrtimer_wakeup)

In both cases there's no C3, but I think that's because C3 changes to C4
when on battery?

Cheers,
FJP
