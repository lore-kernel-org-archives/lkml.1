Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbZEHMTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbZEHMTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZEHMTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:19:15 -0400
Received: from science.horizon.com ([192.35.100.1]:28611 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752304AbZEHMTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:19:15 -0400
Date: 8 May 2009 08:19:13 -0400
Message-ID: <20090508121913.9039.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: johnstul@us.ibm.com, linux@horizon.com
Subject: Re: [RFC][PATCH] tsc_khz= boot option to avoid TSC calibration variance
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       ulrich.windl@rz.uni-regensburg.de, williams@redhat.com,
       zippel@linux-m68k.org
In-Reply-To: <1241742647.7518.108.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To mitigate this, I wanted to provide a tsc_khz= boot option. This would
> allow users to set the tsc_khz value at boot-up, assuming they are
> within 1Mhz of the calibrated value (to protect against bad values).
> Once the tsc_khz value is set in grub, the box will always boot with the
> same value, so the NTP drift value prior to reboot will still be correct
> after rebooting.

A run-time adjustable would be more convenient, but this is simple and works.

The 1 MHz tolerance, however, isn't implemented right.  I can't quote
figure out what you were trying to do; was that (x + (x/2))/1000 trying
to round the /1000 properly?  That should be (x + 1000/2)/1000 in that
case, which I normally write as (x/500 + 1)/2;

But in any case, no equality comparison can possibly work; there's
always a case where the measured value rounds to k and the correct
value rounds to k+1.  Also, 1 MHz is a pretty wide tolerance on
sub-GHz processors.  I'd suggest the following:

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d57de05..d7ab640 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -825,15 +825,42 @@ static void __init init_tsc_clocksource(void)
 	clocksource_register(&clocksource_tsc);
 }
 
+unsigned long tsc_khz_specified;
+static int __init tsc_khz_specified_setup(char *str)
+{
+	tsc_khz_specified = simple_strtoul(str, NULL, 0);
+	return 1;
+}
+
+__setup("tsc_khz=", tsc_khz_specified_setup);
+
+
 void __init tsc_init(void)
 {
 	u64 lpj;
 	int cpu;
+	long difference;
 
 	if (!cpu_has_tsc)
 		return;
 
 	tsc_khz = calibrate_tsc();
+
+	/*
*	 * If the calibrated TSC freq and user specified TSC freq
*	 * are close enough, pick the what the user told us.  Reject
*	 * obviously bogus values to make the option safe to use.
+	 */
+	difference = tsc_khz - tsc_khz_specified;
+	if (difference < 0)
+		difference = -difference;
+	if (difference <= tsc_khz >> 10) {	/* 1/1024 = 976 ppm */
+		printk(KERN_INFO "Using user defined TSC freq: %lu.%03lu MHz\n",
+			tsc_khz_specified/1000,
+			tsc_khz_specified%1000);
+		tsc_khz = tsc_khz_specified;
+	}
+
 	cpu_khz = tsc_khz;
 
 	if (!tsc_khz) {
