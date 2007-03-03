Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXCCVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXCCVlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030461AbXCCVlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:41:45 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:49433 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030455AbXCCVln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:41:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DWnmIsV9e9cMZLo4suQ+tFkiczBgAUsAhXPO0RB6uqNCF3WlTQtqTYpwB6T13M/fBUbfZOK2D/HarqAfliGD6SxNBpBlpZviyhZjhL46DRKY9ouEX4Fi+ZJ/N/aIwOnR9b5X58cynG3A9ThLVq/0vFb2cVN12+H7ksfh+o7qub8=
Message-ID: <3d8471ca0703031341tb017419jb6507c3f6f662ef0@mail.gmail.com>
Date: Sat, 3 Mar 2007 22:41:41 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [2/3] Cleanup: Unify tsc_unstable and tsc_disable
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tsc_unstable and tsc_disable serve the same purpose.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

diff -r 6cd70e2b4c1f arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c	Sat Mar 03 21:39:09 2007 +0100
+++ b/arch/i386/kernel/tsc.c	Sat Mar 03 22:13:03 2007 +0100
@@ -49,16 +49,6 @@ static int __init tsc_setup(char *str)

 __setup("notsc", tsc_setup);

-/*
- * code to mark and check if the TSC is unstable
- * due to cpufreq or due to unsynced TSCs
- */
-static int tsc_unstable;
-
-static inline int check_tsc_unstable(void)
-{
-	return tsc_unstable;
-}

 /* Accellerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
@@ -108,7 +98,7 @@ unsigned long long sched_clock(void)
 	/*
 	 * Fall back to jiffies if there's no TSC available:
 	 */
-	if (tsc_unstable || unlikely(tsc_disable))
+	if (unlikely(tsc_disable))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);

@@ -312,8 +302,8 @@ static struct clocksource clocksource_ts

 void mark_tsc_unstable(void)
 {
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
+	if (!tsc_disable) {
+		tsc_disable = 1;
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
@@ -327,7 +317,7 @@ static int __init dmi_mark_tsc_unstable(
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
 		       d->ident);
-	tsc_unstable = 1;
+	tsc_disable = 1;
 	return 0;
 }

@@ -350,7 +340,7 @@ static struct dmi_system_id __initdata b
  */
 __cpuinit int unsynchronized_tsc(void)
 {
-	if (!cpu_has_tsc || tsc_unstable)
+	if (!cpu_has_tsc || tsc_disable)
 		return 1;
 	/*
 	 * Intel systems are normally all synchronized.
@@ -359,9 +349,9 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
-	}
-	return tsc_unstable;
+			tsc_disable = 1;
+	}
+	return tsc_disable;
 }

 /*
@@ -396,7 +386,7 @@ static int __init init_tsc_clocksource(v
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
 		/* lower the rating if we already know its unstable: */
-		if (check_tsc_unstable()) {
+		if (tsc_disable) {
 			clocksource_tsc.rating = 0;
 			clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 		}


-- 
Guillaume
