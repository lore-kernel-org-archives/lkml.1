Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZFPJCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZFPJCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZFPJCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:02:24 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:45095 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZFPJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=jrHlwyVXUXlUo6Y+z3AjcBQOldjNf7cVQ4TIsTzYiJxI7zweCrf90HkEKnGkNhFauU
         RoBvv8ItV6M10adiY+x4zJpfKJtXfWG8Q+t/ON1G3HSZrNsgtueSfAbF79SAN6oFcD+B
         ngAeFWUHr6o8qMZKwRI3TDxBQymVM4Tj/dxlU=
MIME-Version: 1.0
Date: Tue, 16 Jun 2009 17:02:24 +0800
Message-ID: <a8e1da0906160202r7124b8a7x29ace04cd910df52@mail.gmail.com>
Subject: [PATCH] printk boot_delay: use loops_per_msec instead of 
	printk_delay_msec
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, should post this firstly because the previous printk_delay
patch depends on this,
please review, thanks.
--

Use loops_per_msec instead of printk_delay_msec for boot printk delay.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
kernel/printk.c |   10 ++++------
1 file changed, 4 insertions(+), 6 deletions(-)

--- linux-2.6.orig/kernel/printk.c	2009-06-15 10:53:10.000000000 +0800
+++ linux-2.6/kernel/printk.c	2009-06-15 13:17:13.000000000 +0800
@@ -198,12 +198,11 @@ __setup("log_buf_len=", log_buf_len_setu
 #ifdef CONFIG_BOOT_PRINTK_DELAY

 static unsigned int boot_delay; /* msecs delay after each printk
during bootup */
-static unsigned long long printk_delay_msec; /* per msec, based on
boot_delay */
+static unsigned long long loops_per_msec;

 static int __init boot_delay_setup(char *str)
 {
 	unsigned long lpj;
-	unsigned long long loops_per_msec;

 	lpj = preset_lpj ? preset_lpj : 1000000;	/* some guess */
 	loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
@@ -212,10 +211,9 @@ static int __init boot_delay_setup(char
 	if (boot_delay > 10 * 1000)
 		boot_delay = 0;

-	printk_delay_msec = loops_per_msec;
 	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
-		"HZ: %d, printk_delay_msec: %llu\n",
-		boot_delay, preset_lpj, lpj, HZ, printk_delay_msec);
+		"HZ: %d, loops_per_msec: %llu\n",
+		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
 	return 1;
 }
 __setup("boot_delay=", boot_delay_setup);
@@ -228,7 +226,7 @@ static void boot_delay_msec(void)
 	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
 		return;

-	k = (unsigned long long)printk_delay_msec * boot_delay;
+	k = (unsigned long long)loops_per_msec * boot_delay;

 	timeout = jiffies + msecs_to_jiffies(boot_delay);
 	while (k) {
