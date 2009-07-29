Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbZG2Nmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbZG2Nmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbZG2Nmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:42:46 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:50065 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbZG2Nmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:42:40 -0400
Message-Id: <20090729134125.313191633@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 15:41:25 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>
Subject: [RFC][patch 00/12] clocksource / timekeeping rework V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
version 2 of the clocksource / timekeeping cleanup patches. The series
has grown quite a bit, what started with a simple idea to replace the
tick based clocksource update with stop_machine is now a full fledged
code rework.

The code is working on s390 and on my Athlon system at home which has
a broken tsc clocksource:

[    0.000000] Fast TSC calibration using PIT
[    0.000341] hpet clockevent registered
[    0.000343] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.204021] hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
[    0.204027] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.208007] Switching to clock hpet
[    0.211544] Switched to high resolution mode on CPU 0
[    0.211960] Switched to high resolution mode on CPU 1
[    8.000020] Clocksource tsc unstable (delta = -172310085 ns)

So the clocksource switch via stop_machine and the clocksource watchdog
are working. I keep the fingers crossed that nothing else breaks.

The patch set is based on todays upstream tree plus the patches from
the tip tree, if anyone wants to try them you need to pull from the
master branch of
    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip

There is still more room for improvement. Some sore points are:

1) The cycle_last value still is in the struct clocksource. It should
   be in the struct timekeeper but the check against cycles_last in the
   read function of the TSC clock source makes it hard.
2) read_persistent_clock returns seconds. With a really good initial
   time source this is not very precise. read_persistent_clock should
   return a struct timespec.
3) xtime, raw_time, total_sleep_time, timekeeping_suspended, jiffies,
   the ntp state and probably a few other values may be better located
   in the struct timekeeper as well.

and a few more I forgot.

Many thanks to John who pushed me into the right directions.
-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

