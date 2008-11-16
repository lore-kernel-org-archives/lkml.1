Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYKPT15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYKPT15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 14:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYKPT1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 14:27:49 -0500
Received: from cpsmtpo-eml02.KPNXCHANGE.COM ([213.75.38.151]:6729 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbYKPT1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 14:27:48 -0500
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [2.6.28-rc5] TSC sync error and high hrtimer_start (was: Bootup time regression from 2.6.27 to 2.6.28-rc3+)
Date: Sun, 16 Nov 2008 20:27:43 +0100
User-Agent: KMail/1.9.9
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, corsac@debian.org
References: <20081104173300.GF6134@ics.muni.cz> <alpine.LFD.2.00.0811092226050.12263@localhost.localdomain> <200811140245.40505.elendil@planet.nl>
In-Reply-To: <200811140245.40505.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811162027.44988.elendil@planet.nl>
X-OriginalArrivalTime: 16 Nov 2008 19:27:45.0401 (UTC) FILETIME=[66E27E90:01C94821]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008, Frans Pop wrote:
> Could either of you maybe give a status update on this patch set and
> the remaining issues with it that were reported (especially the high C0
> reported by powertop)?

My previous tests were on my laptop. This is for my desktop running -rc5.
I had not tested my desktop with earlier .28 releases.

For .28 powertop prominently shows hrtimer_start (tick_sched_timer) which
was not present for .27. The list below that is virtually identical to .27.

Total wakeups for .28 is lower though. Something to look into or not?

Possibly this may be related to this diff in the boot messages:
-checking TSC synchronization [CPU#0 -> CPU#1]: passed.
+checking TSC synchronization [CPU#0 -> CPU#1]:
+Measured 696 cycles TSC warp between CPUs, turning off TSC clock.
+Marking TSC unstable due to check_tsc_sync_source failed

With .27.4 TSC _always_ passed. Now, with .28-rc5 I get this warp. I've
done two boots so far, for the other one the warp was 680 cycles.

Cheers,
FJP

Powertop output for idle system:
*** 2.6.27.4 ***
Wakeups-from-idle per second : 68.7     interval: 10.0s
no ACPI power usage estimate available

Top causes for wakeups:
  31.5% ( 17.8)     <kernel core> : __mod_timer (neigh_periodic_timer)
  14.5% (  8.2)   <kernel module> : mod_timer (rh_timer_func)
  11.3% (  6.4)             artsd : __mod_timer (process_timeout)
   9.2% (  5.2)        ksysguardd : __mod_timer (process_timeout)
   4.2% (  2.4)            kicker : __mod_timer (process_timeout)
   3.5% (  2.0)     <kernel core> : add_timer_on (clocksource_watchdog)

*** 2.6.28-rc5 ***
Wakeups-from-idle per second : 55.6     interval: 10.0s
no ACPI power usage estimate available

Top causes for wakeups:
  28.5% ( 23.4)     <kernel core> : hrtimer_start (tick_sched_timer)
  21.7% ( 17.8)     <kernel core> : __mod_timer (neigh_periodic_timer)
   9.7% (  8.0)   <kernel module> : mod_timer (rh_timer_func)
   7.8% (  6.4)             artsd : schedule_hrtimeout_range (hrtimer_wakeup)
   5.4% (  4.4)        ksysguardd : __mod_timer (process_timeout)
   2.8% (  2.3)            kicker : schedule_hrtimeout_range (hrtimer_wakeup)
   2.4% (  2.0)     <kernel core> : add_timer_on (clocksource_watchdog)
