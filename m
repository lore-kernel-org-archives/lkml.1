Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbZELXfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbZELXfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759069AbZELXbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:31:51 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53977 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114AbZELXbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:31:50 -0400
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
From: john stultz <johnstul@us.ibm.com>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: George Spelvin <linux@horizon.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       ulrich.windl@rz.uni-regensburg.de, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Clark Williams <williams@redhat.com>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <87d4aejw5b.fsf@depni.sinp.msu.ru>
References: <1242094321.7214.156.camel@localhost.localdomain>
	 <87d4aejw5b.fsf@depni.sinp.msu.ru>
Content-Type: text/plain
Date: Tue, 12 May 2009 16:31:47 -0700
Message-Id: <1242171107.3462.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 17:20 +0400, Serge Belyshev wrote:
> Please *please* don't set arbitrary limits.  Just use user supplied value.

Ok, fair enough. As I was not trying to deal with incorrect calibration
results, just calibration variance, I was hoping to avoid dealing with
error reports where users pushed the tsc_khz value outside of a sane
range.

But I guess throwing a warning when its outside of a sane range is
better then ignoring user defined boot options.

thanks
-john

So one more time....

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

Also thanks to Serge Belyshev for suggesting instead of ignoring out of
range values, to always use the user provided tsc_khz value but throw a
warning.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e87bdbf..cc5b2c1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2402,6 +2402,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			Used to enable high-resolution timer mode on older
 			hardware, and in virtualized environment.
 
+	tsc_khz=	[x86] Set the TSC freq value.
+			Format: <khz>
+			Used to override the calibrated TSC freq.
+			This can be useful to avoid TSC calibration error
+			causing problems with NTP synchronization across
+			reboots.
+
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
 			Format:
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d57de05..31a1b27 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -825,6 +825,16 @@ static void __init init_tsc_clocksource(void)
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
@@ -834,6 +844,25 @@ void __init tsc_init(void)
 		return;
 
 	tsc_khz = calibrate_tsc();
+
+	if (tsc_khz_specified) {
+		long difference = abs(tsc_khz - tsc_khz_specified);
+		/*
+		 * Make a fair amount of noise if tsc_khz boot option
+		 * is more then 0.1% off of the calibrated tsc_khz value
+		 */
+		if (difference > tsc_khz/1000) {
+			printk(KERN_WARNING "WARNING! Specified tsc_khz is"
+				" more then 0.1%% off from the calibrated TSC"
+				" freq.\n\tThis may cause severe time"
+				" problems.\n");
+		}
+		printk(KERN_INFO "Using user defined TSC freq: %lu.%03lu MHz\n",
+			tsc_khz_specified/1000,
+			tsc_khz_specified%1000);
+		tsc_khz = tsc_khz_specified;
+	}
+
 	cpu_khz = tsc_khz;
 
 	if (!tsc_khz) {



