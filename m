Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbZEVTrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbZEVTrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZEVTro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:47:44 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:5474 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZEVTrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:47:43 -0400
X-BigFish: VPS0(zzzz1202hzzz2fh6bh)
X-FB-SS: 5,13,
Message-ID: <4A17014C.7080305@am.sony.com>
Date: Fri, 22 May 2009 12:47:24 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-omap-open-source@linux.omap.com
Subject: [PATCH] omap: add sched_clock for omap1 based on MPU timer
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2009 19:47:25.0666 (UTC) FILETIME=[219FE420:01C9DB16]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a higher-resolution sched_clock for OMAP
using the MPU timer, when it is configured on.

This produces better results from ftrace.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 arch/arm/mach-omap1/time.c  |    9 +++++++++
 arch/arm/plat-omap/common.c |    2 ++
 2 files changed, 11 insertions(+)

--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -212,6 +212,15 @@ static struct clocksource clocksource_mp
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };

+unsigned long long notrace sched_clock(void)
+{
+	unsigned long long ret;
+
+	ret = (unsigned long long) ~omap_mpu_timer_read(1);
+	ret = (ret * clocksource_mpu.mult_orig) >> clocksource_mpu.shift;
+	return ret;
+}
+
 static void __init omap_init_clocksource(unsigned long rate)
 {
 	static char err[] __initdata = KERN_ERR
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -199,6 +199,7 @@ static struct clocksource clocksource_32
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };

+#ifndef CONFIG_OMAP_MPU_TIMER
 /*
  * Returns current time from boot in nsecs. It's OK for this to wrap
  * around for now, as it's just a relative time stamp.
@@ -211,6 +212,7 @@ unsigned long long notrace sched_clock(v
 	ret = (ret * clocksource_32k.mult_orig) >> clocksource_32k.shift;
 	return ret;
 }
+#endif

 static int __init omap_init_clocksource_32k(void)
 {

