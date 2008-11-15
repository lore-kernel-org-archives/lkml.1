Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYKORQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYKORQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYKORQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:16:37 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:46070 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbYKORQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:16:36 -0500
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Date: Sat, 15 Nov 2008 18:16:31 +0100
User-Agent: KMail/1.9.9
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, corsac@debian.org
References: <20081104173300.GF6134@ics.muni.cz> <alpine.LFD.2.00.0811092226050.12263@localhost.localdomain> <200811140245.40505.elendil@planet.nl>
In-Reply-To: <200811140245.40505.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_xPwHJIq+n/mCLWh"
Message-Id: <200811151816.33209.elendil@planet.nl>
X-OriginalArrivalTime: 15 Nov 2008 17:16:33.0714 (UTC) FILETIME=[E894A120:01C94745]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_xPwHJIq+n/mCLWh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 14 November 2008, Frans Pop wrote:
> > Find below the lineup of the timers-fixes-for-linus branch of the tip
> > tree (the same as Arjan posted minus the irq fixes)
>
> Could either of you maybe give a status update on this patch set and
> the remaining issues with it that were reported (especially the high C0
> reported by powertop)?

I guess part of the answer is:
commit ae99286b4f1be7788f2d6947c66a91dbd6351eec
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Nov 10 13:20:23 2008 +0100
    nohz: disable tick_nohz_kick_tick() for now

I've just done some testing using v2.6.28-rc4-322-g58e20d8 which includes 
this patch.

CPU usage reported by powertop is now normal again (close to 100% in 
lowest C state), but I'm still getting high counts for:
- <kernel IPI> : Rescheduling interrupts
  Typically 3-5 on .26/.27; 15-17 on .28.
- <interrupt>  : extra timer interrupt
  Consistently more prominent for .28 (though not with high values)
  than for .27, but way better than for .26.

The attachment shows top wakeups between .26.3, .27.4 and .28-rc4-322 for 
comparison. There are no significant differences between running on mains 
or on battery, but it does show some powertop weirdness.

powertop questions
------------------
- What's with this change from "polling" to "C0" for the 2nd C state?
  After boot I always (both when booted on mains and on battery) get
  "polling", but after inserting or removing mains it will continue to
  show "C0" independent of any further power state changes.
- After switching to battery the first time I get something like:
  C1                0.0ms (614891469122.
  This is reproducible. I guess a rounding error due to the change in
  the number of C states. Later updates clear this.
- Looks like someone could not make up his mind between comma and slash
  here: "(long term: 26.2W,/1.6h)"

Cheers,
FJP


--Boundary-00=_xPwHJIq+n/mCLWh
Content-Type: text/plain;
  charset="iso-8859-1";
  name="powertop.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="powertop.txt"

*** 2.6.26.3 on on mains ***
     PowerTOP version 1.10      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 0.4%)         1333 Mhz     0.0%
polling           0.0ms ( 0.0%)         1200 Mhz     0.0%
C1                0.0ms ( 0.0%)         1067 Mhz     0.0%
C3               14.0ms (99.6%)          800 Mhz   100.0%


Wakeups-from-idle per second : 71.5     interval: 15.0s
no ACPI power usage estimate available

Top causes for wakeups:
  33.1% ( 23.7)       <interrupt> : iwl4965
  19.6% ( 14.1)       <interrupt> : extra timer interrupt
  11.4% (  8.1)   <kernel module> : usb_hcd_poll_rh_status (rh_timer_func)
   9.0% (  6.5)             artsd : schedule_timeout (process_timeout)
   7.1% (  5.1)      <kernel IPI> : Rescheduling interrupts
===================================================================
*** 2.6.27.4 on battery ***
     PowerTOP version 1.10      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 0.7%)         1333 Mhz     0.0%
polling           0.0ms ( 0.0%)         1200 Mhz     0.0%
C1                0.0ms ( 0.0%)         1067 Mhz     0.0%
C2                0.8ms ( 0.0%)          800 Mhz   100.0%
C4               20.1ms (99.3%)

Wakeups-from-idle per second : 49.8     interval: 15.0s
Power usage (ACPI estimate): 8.5W (4.9 hours)

Top causes for wakeups:
  21.6% (  9.3)       <interrupt> : iwlagn
  19.0% (  8.1)   <kernel module> : mod_timer (rh_timer_func)
  13.2% (  5.7)             artsd : __mod_timer (process_timeout)
  10.4% (  4.5)      <kernel IPI> : Rescheduling interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 2.6.27.4 on mains ***
     PowerTOP version 1.10      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 0.3%)         1333 Mhz     0.0%
C0                0.0ms ( 0.0%)         1200 Mhz     0.0%
C1                0.0ms ( 0.0%)         1067 Mhz     0.0%
C3               19.2ms (99.7%)          800 Mhz   100.0%


Wakeups-from-idle per second : 52.0     interval: 15.0s
no ACPI power usage estimate available

Top causes for wakeups:
  20.3% (  8.2)       <interrupt> : iwlagn
  19.8% (  8.0)   <kernel module> : mod_timer (rh_timer_func)
  13.9% (  5.6)             artsd : __mod_timer (process_timeout)
   9.3% (  3.7)      <kernel IPI> : Rescheduling interrupts
===================================================================
*** 2.6.28-rc4 on mains ***
     PowerTOP version 1.10      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 0.4%)         1333 Mhz     0.0%
polling           0.0ms ( 0.0%)         1200 Mhz     0.0%
C1                0.0ms ( 0.0%)         1067 Mhz     0.0%
C3               16.7ms (99.6%)          800 Mhz   100.0%


Wakeups-from-idle per second : 59.7     interval: 15.0s
no ACPI power usage estimate available

Top causes for wakeups:
  21.5% ( 15.6)      <kernel IPI> : Rescheduling interrupts
  13.5% (  9.8)       <interrupt> : iwlagn
  13.5% (  9.8)     <kernel core> : hrtimer_start (tick_sched_timer)
  11.0% (  8.0)   <kernel module> : mod_timer (rh_timer_func)
   9.8% (  7.1)       <interrupt> : extra timer interrupt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 2.6.28-rc4 just after switch to battery ***
     PowerTOP version 1.10      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (71.6%)         1333 Mhz     0.0%
C0                0.0ms ( 0.0%)         1200 Mhz     0.0%
C1                0.0ms (614891469122.  1067 Mhz     0.0%
C2                0.5ms ( 0.1%)          800 Mhz   100.0%
C4                3.8ms (29.5%)

Wakeups-from-idle per second : 54.4     interval: 15.0s
Power usage (ACPI estimate): 10.0W (4.4 hours)

Top causes for wakeups:
  26.8% ( 41.3)      <kernel IPI> : Rescheduling interrupts
  20.7% ( 31.9)       <interrupt> : uhci_hcd:usb4, HDA Intel
  11.8% ( 18.1)       <interrupt> : iwlagn
  10.1% ( 15.5)       <interrupt> : extra timer interrupt
   5.7% (  8.7)     <kernel core> : hrtimer_start (tick_sched_timer)
   5.2% (  8.0)   <kernel module> : mod_timer (rh_timer_func)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 2.6.28-rc4 on battery after settling down ***
     PowerTOP version 1.10      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 0.6%)         1333 Mhz     0.0%
C0                0.0ms ( 0.0%)         1200 Mhz     0.0%
C1                0.0ms ( 0.0%)         1067 Mhz     0.0%
C2                8.1ms ( 0.4%)          800 Mhz   100.0%
C4               14.5ms (99.0%)

Wakeups-from-idle per second : 69.0     interval: 15.0s
Power usage (ACPI estimate): 8.7W (4.9 hours) (long term: 26.2W,/1.6h)

Top causes for wakeups:
  24.0% ( 21.4)      <kernel IPI> : Rescheduling interrupts
  17.8% ( 15.9)       <interrupt> : extra timer interrupt
  15.7% ( 14.0)       <interrupt> : iwlagn
  10.9% (  9.7)     <kernel core> : hrtimer_start (tick_sched_timer)
   9.0% (  8.0)   <kernel module> : mod_timer (rh_timer_func)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 2.6.28-rc4 on mains again ***
     PowerTOP version 1.10      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 0.3%)         1333 Mhz     0.0%
C0                0.0ms ( 0.0%)         1200 Mhz     0.0%
C1                0.0ms ( 0.0%)         1067 Mhz     0.0%
C3               17.5ms (99.7%)          800 Mhz   100.0%


Wakeups-from-idle per second : 57.1     interval: 15.0s
no ACPI power usage estimate available

Top causes for wakeups:
  26.4% ( 17.7)      <kernel IPI> : Rescheduling interrupts
  15.1% ( 10.1)       <interrupt> : iwlagn
  11.9% (  8.0)   <kernel module> : mod_timer (rh_timer_func)
   8.9% (  6.0)       <interrupt> : extra timer interrupt
   8.4% (  5.7)     <kernel core> : hrtimer_start (tick_sched_timer)

--Boundary-00=_xPwHJIq+n/mCLWh--
