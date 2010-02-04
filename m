Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab0BDXcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:32:48 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:52354 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab0BDXbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:31:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HLy0qbF1FPvxc+ohfh4dBQf8OoIogbuWLq/Vx+tEOiv1YFeKK2rq4a6HwZ+d32lSeM
         vjCz49cCkXTbM1FQZOidSwixiVo/sT4nsBz+gk1Qy2e01prJNcY/LfvLCYcX4Vqt/kPi
         M9GJ5hSkn4mrGD7/0qlD4wU69ixTUK9ts3NIs=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 13/17] MTD: export few functions from nand_base.c
Date: Fri,  5 Feb 2010 01:30:53 +0200
Message-Id: <1265326257-4446-14-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 961c98f..3949d8c 100644
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
@@ -753,6 +749,7 @@ nand_get_device(struct nand_chip *chip, struct mtd_info *mtd, int new_state)
 	remove_wait_queue(wq, &wait);
 	goto retry;
 }
+EXPORT_SYMBOL_GPL(nand_get_device);
 
 /**
  * panic_nand_wait - [GENERIC]  wait until the command is done
@@ -1532,7 +1529,7 @@ static int nand_write_oob_syndrome(struct mtd_info *mtd,
  *
  * NAND read out-of-band data from the spare area
  */
-static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
+int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 			    struct mtd_oob_ops *ops)
 {
 	int page, realpage, chipnr, sndcmd = 1;
@@ -1616,6 +1613,7 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 	ops->oobretlen = ops->ooblen;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nand_do_read_oob);
 
 /**
  * nand_read_oob - [MTD Interface] NAND read data and/or out-of-band
@@ -2108,7 +2106,7 @@ static int nand_write(struct mtd_info *mtd, loff_t to, size_t len,
  *
  * NAND write out-of-band
  */
-static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
+int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 			     struct mtd_oob_ops *ops)
 {
 	int chipnr, page, status, len;
@@ -2179,6 +2177,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nand_do_write_oob);
 
 /**
  * nand_write_oob - [MTD Interface] NAND write data and/or out-of-band
@@ -3080,6 +3079,7 @@ EXPORT_SYMBOL_GPL(nand_scan_ident);
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

