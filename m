Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYEMD2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYEMD2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYEMD2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:28:22 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62351 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754482AbYEMD2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:28:21 -0400
Date: Tue, 13 May 2008 04:25:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>
cc: rtc-linux@googlegroups.com, i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] RTC: Use class devices as a persistent clock (#2)
Message-ID: <Pine.LNX.4.55.0805130214460.535@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

 This is the second stage of patch submission for this change.  Thanks
everybody for all the useful suggestions and testing.  As I understand the
changes are in line with the intent of everyone concerned.  At this
moment, unless anybody complains, I consider these patches ready to be
applied upstream.

 These patches provide means to switch to the RTC class devices for the
purpose of providing the backup clock for timekeeping.  The API in
question are the read_persistent_clock() and update_persistent_clock()  
functions used mostly by the NTP support code.

 The notable gain is the removal of the additional burden from platform
code -- all that has be implemented is support for the RTC chip the
platform has.  I have added the rtc_read_persistent_clock() and
rtc_update_persistent_clock() functions to the RTC suite that can serve as
the implementation of the API and work the same (hardware implementation
permitting) regardless of the exact RTC chip used.  There is even support
for the ubiquitous derivatives of the MC146818 available as a class device
already.  Additionally, if there is more than one RTC chip in a given
system, the user can select which of the chips to use.

 The drawback is some implementations behind these functions may sleep,
for example because hardware is slow to access.  The current calling
context of update_persistent_clock() (which is the softirq) does not
permit the function to sleep.  To rectify I have moved the call into the
process context, but it now means the latency between getnstimeofday() and
the writeback into the RTC will be yet less predictable and potentially
higher.  This should not matter in practice, because the RTC generally
cannot guarantee suitable precision to be a reliable sub-second resolution
device for providing time while the NTP daemon is not running and one who
cares about timekeeping will run NTP during normal system operation anyway
which will correct any inaccuracy gathered from the RTC.  I am mentioning
it though as I think it should be noted.

 Significant changes from the first iteration:

1. MIPS Makefile changes are now separate so that they can go straight
   into the MIPS tree without relying on I2C changes.

2. M41T80 driver changes have been simplified -- thanks, Jean and DavidB,
   for your feedback letting me understand the I2C core better.

 Individual patches follow, feedback is welcome.  All have been
successfully tested at the run time with a big-endian 64-bit MIPS
configuration (a Broadcom BCM91250A board), using the usual SMP vs non-SMP
and PREEMPT vs non-PREEMPT configurations, with spinlock, etc. debugging
on; no checkpatch.pl nor sparse problems either.  They have been
successfully built for a 32-bit x86 and Alpha configuration as well.

  Maciej
