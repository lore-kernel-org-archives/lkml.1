Return-Path: <linux-kernel-owner+w=401wt.eu-S1759001AbZELCM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001AbZELCM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZELCMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:12:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57121 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbZELCMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:12:15 -0400
Subject: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
From: john stultz <johnstul@us.ibm.com>
To: George Spelvin <linux@horizon.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: ulrich.windl@rz.uni-regensburg.de, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Clark Williams <williams@redhat.com>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 11 May 2009 19:12:01 -0700
Message-Id: <1242094321.7214.156.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All, 

Despite recent tweaking, TSC calibration variance is still biting users
who care about keeping close sync with NTP servers over reboots.

Here's a recent example:
http://lkml.indiana.edu/hypermail/linux/kernel/0905.0/02061.html

The problem is, each reboot, we have to calibrate the TSC, and any
error, regardless of how small, in the calibrated freq has to be
corrected for by NTP. Assuming the error is within 500ppm NTP can
correct this, but until it finds the proper correction value for the new
TSC freq, users may see time offsets from the NTP server.

In my experience, its fairly easy to see 100khz variance from reboot to
reboot with 2.6.30-rc.

While I think its worth trying to improve the calibration further, there
will likely be a trade-off between very accurate calibration and fast
boot times.

To mitigate this, I wanted to provide a tsc_khz= boot option. This would
allow users to set the tsc_khz value at boot-up, assuming they are
within 1Mhz of the calibrated value (to protect against bad values).
Once the tsc_khz value is set in grub, the box will always boot with the
same value, so the NTP drift value prior to reboot will still be correct
after rebooting.

Thanks to George Spelvin for the idea:
	http://lkml.indiana.edu/hypermail/linux/kernel/0905.0/02807.html

Also thanks to George Spelvin for noticing and fixing the bogus
frequency comparison check in my original RFC'ed patch. This version of
the patch includes his much better comparison.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e87bdbf..4c5d6aa 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2402,6 +2402,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			Used to enable high-resolution timer mode on older
 			hardware, and in virtualized environment.
 
+	tsc_khz=	[x86] Set the TSC freq value.
+			Format: <khz>
+			Used to avoid TSC calibration error.
+			The specified tsc_khz value must be accurate to the
+			calibrated tsc value by 0.1%. Otherwise the calibrated
+			value will be used.
+
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
 			Format:
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d57de05..d47c871 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -825,15 +825,40 @@ static void __init init_tsc_clocksource(void)
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
+	 * If the calibrated TSC freq and user specified
+	 * TSC freq are close enough, pick the what the
+	 * user told us.
+	 */
+	difference = abs(tsc_khz - tsc_khz_specified);
+	if (difference <= tsc_khz >> 10) {      /* 1/1024 = 976 ppm */
+		printk(KERN_INFO "Using user defined TSC freq: %lu.%03lu MHz\n",
+			tsc_khz_specified/1000,
+			tsc_khz_specified%1000);
+		tsc_khz = tsc_khz_specified;
+	}
+
 	cpu_khz = tsc_khz;
 
 	if (!tsc_khz) {


