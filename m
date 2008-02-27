Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbYB0Eho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbYB0Eho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYB0Ehd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:37:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:27105 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbYB0Ehc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:37:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=r7OpFIBQpfE0jrDNLMbxz7XxPGSo2R6IXYhCbkSWXU5TqNyDNeGYayXZ1/3xhEzZ34FbgYsboxpIAKEfuS5V+ufsw9hVlZEQX0Xlr35Efv1Ooy8j3cg9D/X1wsS4c8rlp0pH2dqyGxfo69DL3jrfxghbbCNTVDrWfGVNRSJE7Q4=
Date: Wed, 27 Feb 2008 12:43:27 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: randy.dunlap@oracle.com, davej@codemonkey.org.uk, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] make boot_delay use loops_per_jiffy directly
Message-ID: <20080227044327.GB2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make printk boot_delay use loops_per_jiffy directly,
declare preset_lpj as static, and set lpj value to loops_per_jiffy in lpj_setup. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
init/calibrate.c |    6 +++---
kernel/printk.c  |   15 ++++-----------
2 files changed, 7 insertions(+), 14 deletions(-)

diff -upr linux/init/calibrate.c linux.new/init/calibrate.c
--- linux/init/calibrate.c	2008-02-27 10:54:15.000000000 +0800
+++ linux.new/init/calibrate.c	2008-02-27 12:32:11.000000000 +0800
@@ -9,10 +9,11 @@
 #include <linux/init.h>
 #include <linux/timex.h>
 
-unsigned long preset_lpj;
+static unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
 {
-	preset_lpj = simple_strtoul(str,NULL,0);
+	loops_per_jiffy = simple_strtoul(str, NULL, 0);
+	preset_lpj = 1;
 	return 1;
 }
 
@@ -117,7 +118,6 @@ void __cpuinit calibrate_delay(void)
 	int lps_precision = LPS_PREC;
 
 	if (preset_lpj) {
-		loops_per_jiffy = preset_lpj;
 		printk("Calibrating delay loop (skipped)... "
 			"%lu.%02lu BogoMIPS preset\n",
 			loops_per_jiffy/(500000/HZ),
diff -upr linux/kernel/printk.c linux.new/kernel/printk.c
--- linux/kernel/printk.c	2008-02-27 12:30:43.000000000 +0800
+++ linux.new/kernel/printk.c	2008-02-27 12:32:22.000000000 +0800
@@ -173,24 +173,14 @@ __setup("log_buf_len=", log_buf_len_setu
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static unsigned int boot_delay; /* msecs delay after each printk during bootup */
-static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
 
 static int __init boot_delay_setup(char *str)
 {
-	unsigned long lpj;
-	unsigned long long loops_per_msec;
-
-	lpj = preset_lpj ? preset_lpj : 1000000;	/* some guess */
-	loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
-
 	get_option(&str, &boot_delay);
 	if (boot_delay > 10 * 1000)
 		boot_delay = 0;
 
-	printk_delay_msec = loops_per_msec;
-	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
-		"HZ: %d, printk_delay_msec: %llu\n",
-		boot_delay, preset_lpj, lpj, HZ, printk_delay_msec);
+	printk(KERN_DEBUG "boot_delay: %u\n", boot_delay);
 	return 1;
 }
 __setup("boot_delay=", boot_delay_setup);
@@ -199,6 +189,9 @@ static void boot_delay_msec(void)
 {
 	unsigned long long k;
 	unsigned long timeout;
+	unsigned long long printk_delay_msec;
+
+	printk_delay_msec = (unsigned long long)loops_per_jiffy / 1000 * HZ;
 
 	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
 		return;
