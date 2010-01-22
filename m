Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692Ab0AVQAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0AVQAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658Ab0AVQAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:00:40 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37589 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0AVQA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:00:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QZQ3d03pn38qnUXKz2GSWjHEy206GxW7BNrks3tzdat3Eb2iGBE8JcYIEfzCe+BbvU
         O4J4SapGxzwQydSXl1x9+s/YBpi/9xKKkx6mxSVt85U0evyFUdBQaDTWqJm/Cy2Ef1SP
         appuukMyIljkjJxx7h83gy3nyl5BiY5ArRYYw=
Subject: [PATCH 4/6] MTD: export few functions from nand_base.c
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1264175781.24012.42.camel@maxim-laptop>
References: <1264175781.24012.42.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 18:00:20 +0200
Message-ID: <1264176020.24012.46.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 682591265a03966b495f21ff6b77dfb5fadcbefa Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 22 Jan 2010 16:41:34 +0200
Subject: [PATCH 4/6] MTD: export few functions from nand_base.c

This exports:

nand_do_read_oob
nand_do_write_oob
nand_get_device
nand_put_device

This functions will be used to implement custom oob based
bad block handling in upcoming smartmedia common module

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   18 +++++++++---------
 include/linux/mtd/nand.h     |   12 ++++++++++++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 29e986e..e433103 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -96,11 +96,6 @@ static struct nand_ecclayout nand_oob_128 = {
 		 .length = 78}}
 };
 
-static int nand_get_device(struct nand_chip *chip, struct mtd_info *mtd,
-			   int new_state);
-
-static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
-			     struct mtd_oob_ops *ops);
 
 /*
  * For devices which display every fart in the system on a separate LED. Is
@@ -114,7 +109,7 @@ DEFINE_LED_TRIGGER(nand_led_trigger);
  *
  * Deselect, release chip lock and wake up anyone waiting on the device
  */
-static void nand_release_device(struct mtd_info *mtd)
+void nand_release_device(struct mtd_info *mtd)
 {
 	struct nand_chip *chip = mtd->priv;
 
@@ -128,6 +123,7 @@ static void nand_release_device(struct mtd_info *mtd)
 	wake_up(&chip->controller->wq);
 	spin_unlock(&chip->controller->lock);
 }
+EXPORT_SYMBOL_GPL(nand_release_device);
 
 /**
  * nand_read_byte - [DEFAULT] read one byte from the chip
@@ -721,7 +717,7 @@ static void panic_nand_get_device(struct nand_chip *chip,
  *
  * Get the device and lock it for exclusive access
  */
-static int
+int
 nand_get_device(struct nand_chip *chip, struct mtd_info *mtd, int new_state)
 {
 	spinlock_t *lock = &chip->controller->lock;
@@ -756,6 +752,7 @@ nand_get_device(struct nand_chip *chip, struct mtd_info *mtd, int new_state)
 	remove_wait_queue(wq, &wait);
 	goto retry;
 }
+EXPORT_SYMBOL_GPL(nand_get_device);
 
 /**
  * panic_nand_wait - [GENERIC]  wait until the command is done
@@ -1535,7 +1532,7 @@ static int nand_write_oob_syndrome(struct mtd_info *mtd,
  *
  * NAND read out-of-band data from the spare area
  */
-static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
+int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 			    struct mtd_oob_ops *ops)
 {
 	int page, realpage, chipnr, sndcmd = 1;
@@ -1619,6 +1616,7 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 	ops->oobretlen = ops->ooblen;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nand_do_read_oob);
 
 /**
  * nand_read_oob - [MTD Interface] NAND read data and/or out-of-band
@@ -2111,7 +2109,7 @@ static int nand_write(struct mtd_info *mtd, loff_t to, size_t len,
  *
  * NAND write out-of-band
  */
-static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
+int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 			     struct mtd_oob_ops *ops)
 {
 	int chipnr, page, status, len;
@@ -2182,6 +2180,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nand_do_write_oob);
 
 /**
  * nand_write_oob - [MTD Interface] NAND write data and/or out-of-band
@@ -3083,6 +3082,7 @@ EXPORT_SYMBOL_GPL(nand_scan_ident);
 EXPORT_SYMBOL_GPL(nand_scan_tail);
 EXPORT_SYMBOL_GPL(nand_release);
 
+
 static int __init nand_base_init(void)
 {
 	led_trigger_register_simple("nand-disk", &nand_led_trigger);
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index ccab9df..8c2333a 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -469,6 +469,18 @@ extern int nand_erase_nand(struct mtd_info *mtd, struct erase_info *instr,
 extern int nand_do_read(struct mtd_info *mtd, loff_t from, size_t len,
 			size_t * retlen, uint8_t * buf);
 
+extern int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
+			    struct mtd_oob_ops *ops);
+
+extern int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
+			     struct mtd_oob_ops *ops);
+
+extern int nand_get_device(struct nand_chip *chip,
+			struct mtd_info *mtd, int new_state);
+
+extern void nand_release_device(struct mtd_info *mtd);
+
+
 /**
  * struct platform_nand_chip - chip level device structure
  * @nr_chips:		max. number of chips to scan for
-- 
1.6.3.3



