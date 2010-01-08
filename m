Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736Ab0AHPJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0AHPJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616Ab0AHPJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:09:04 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57762 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0AHPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:09:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NEcxttcljqysrOfyX6cSaQdcVrJgdE5pCmK2HPFYXNCsiQYJXrphC151J7yOR18AC0
         QsIXrfJAi0MOXTwTBr303NWHNu3eBs5gjHuiPQILsbhzeXwOV/Ev6O+ZRgQllxYMFZcb
         sSeT7ObwDiKWX+smRwDa1h/plZ6pli17PPhyk=
Subject: [PATCH 5/9] MTD: nand subsystem, export nand_do_read_oob and
 nand_do_write_oob
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262963092.12577.14.camel@maxim-laptop>
References: <1262963092.12577.14.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:08:57 +0200
Message-ID: <1262963337.12577.19.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5dbd1e5f7b5a4fe76053e25e744327156f015c6f Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 8 Jan 2010 15:54:42 +0200
Subject: [PATCH 5/9] MTD: nand subsystem, export nand_do_read_oob and nand_do_write_oob

Drivers might need sane way to read/write oob area, but can't
use mtd interface due to locking.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   10 +++++-----
 include/linux/mtd/nand.h     |    5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 8f2958f..8e31245 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -99,9 +99,6 @@ static struct nand_ecclayout nand_oob_128 = {
 static int nand_get_device(struct nand_chip *chip, struct mtd_info *mtd,
 			   int new_state);
 
-static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
-			     struct mtd_oob_ops *ops);
-
 /*
  * For devices which display every fart in the system on a separate LED. Is
  * compiled away when LED support is disabled.
@@ -1536,7 +1533,7 @@ static int nand_write_oob_syndrome(struct mtd_info *mtd,
  *
  * NAND read out-of-band data from the spare area
  */
-static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
+int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 			    struct mtd_oob_ops *ops)
 {
 	int page, realpage, chipnr, sndcmd = 1;
@@ -1620,6 +1617,7 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 	ops->oobretlen = ops->ooblen;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nand_do_read_oob);
 
 /**
  * nand_read_oob - [MTD Interface] NAND read data and/or out-of-band
@@ -2110,7 +2108,7 @@ static int nand_write(struct mtd_info *mtd, loff_t to, size_t len,
  *
  * NAND write out-of-band
  */
-static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
+int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 			     struct mtd_oob_ops *ops)
 {
 	int chipnr, page, status, len;
@@ -2181,6 +2179,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nand_do_write_oob);
 
 /**
  * nand_write_oob - [MTD Interface] NAND write data and/or out-of-band
@@ -3082,6 +3081,7 @@ EXPORT_SYMBOL_GPL(nand_scan_ident);
 EXPORT_SYMBOL_GPL(nand_scan_tail);
 EXPORT_SYMBOL_GPL(nand_release);
 
+
 static int __init nand_base_init(void)
 {
 	led_trigger_register_simple("nand-disk", &nand_led_trigger);
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index ccab9df..75575fb 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -469,6 +469,11 @@ extern int nand_erase_nand(struct mtd_info *mtd, struct erase_info *instr,
 extern int nand_do_read(struct mtd_info *mtd, loff_t from, size_t len,
 			size_t * retlen, uint8_t * buf);
 
+extern int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
+			    struct mtd_oob_ops *ops);
+
+extern int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
+			     struct mtd_oob_ops *ops);
 /**
  * struct platform_nand_chip - chip level device structure
  * @nr_chips:		max. number of chips to scan for
-- 
1.6.3.3



