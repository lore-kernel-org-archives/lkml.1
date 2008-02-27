Return-Path: <linux-kernel-owner+w=401wt.eu-S1765673AbYB0DPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765673AbYB0DPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 22:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbYB0DO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 22:14:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:6638 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbYB0DO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 22:14:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=o57MOuArnW25OUucWGFS6HpSxDQGmU/GN5rWsYRkvnNHPjEOEhTmauf8T9gSFXE5Ed52HaGHqiOTBLAuCpLYE13ZEGIGCGTjkybjUqzfAlUXEiz1ARwtgnYrcGZXeIewccC7Etq9EICrM9hyJf9XIqRbFsTXBnzE82Q05KRfB7M=
Date: Wed, 27 Feb 2008 11:20:58 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: randy.dunlap@oracle.com, davej@codemonkey.org.uk, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] make boot_delay use loops_per_jiffy directly
Message-ID: <20080227032058.GB2754@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make boot_delay use loops_per_jiffy directly, this does not change the
original behaviour if apply the first patch before it.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
kernel/printk.c |   15 ++++-----------
1 file changed, 4 insertions(+), 11 deletions(-)

diff -upr linux/kernel/printk.c linux.new/kernel/printk.c
--- linux/kernel/printk.c	2008-02-26 16:54:23.000000000 +0800
+++ linux.new/kernel/printk.c	2008-02-26 16:59:02.000000000 +0800
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
