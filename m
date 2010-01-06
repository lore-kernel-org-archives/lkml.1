Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359Ab0AFVta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0AFVta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331Ab0AFVt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:49:29 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37320 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab0AFVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:49:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZWLl8ejPMRR0TJaERyWjSucbjFpvF5cGXbC0aQ2K0yWwJ2UgdhIo3ZoNb8h9osoJsz
         +dIl22c3X4rSu8S/0K69fBJVDosnqZv57HPRvPH00UKjrICkwW/xUokeXfdJTezPzE5Y
         0MWz7sOlIJdb/fXMVIThxuMWFsNKr9lR1/ftc=
Subject: [PATCH 5/9] NAND: export nand_do_read_oob and nand_do_write_oob
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262814216.14552.22.camel@maxim-laptop>
References: <1262814216.14552.22.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 23:49:23 +0200
Message-ID: <1262814563.14552.29.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 42a44a48f270f45e44595b6f3906df4a6cf28ba5 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Tue, 5 Jan 2010 23:25:20 +0200
Subject: [PATCH 5/9] NAND: export nand_do_read_oob and nand_do_write_oob

Drivers might need sane way to read/write oob area, but can't
use mtd interface due to locking

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   10 +++++-----
 include/linux/mtd/nand.h     |    7 +++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 2957cc7..787e751 100644
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
@@ -1458,7 +1455,7 @@ static int nand_write_oob_syndrome(struct mtd_info *mtd,
  *
  * NAND read out-of-band data from the spare area
  */
-static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
+int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 			    struct mtd_oob_ops *ops)
 {
 	int page, realpage, chipnr, sndcmd = 1;
@@ -1993,7 +1990,7 @@ static int nand_write(struct mtd_info *mtd, loff_t to, size_t len,
  *
  * NAND write out-of-band
  */
-static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
+int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 			     struct mtd_oob_ops *ops)
 {
 	int chipnr, page, status, len;
@@ -2962,6 +2959,9 @@ EXPORT_SYMBOL_GPL(nand_scan);
 EXPORT_SYMBOL_GPL(nand_scan_ident);
 EXPORT_SYMBOL_GPL(nand_scan_tail);
 EXPORT_SYMBOL_GPL(nand_release);
+EXPORT_SYMBOL_GPL(nand_do_read_oob);
+EXPORT_SYMBOL_GPL(nand_do_write_oob);
+
 
 static int __init nand_base_init(void)
 {
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 7a232a9..7c3ff57 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -548,6 +548,13 @@ extern int nand_erase_nand(struct mtd_info *mtd, struct erase_info *instr,
 extern int nand_do_read(struct mtd_info *mtd, loff_t from, size_t len,
 			size_t * retlen, uint8_t * buf);
 
+extern int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
+			    struct mtd_oob_ops *ops);
+
+extern int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
+			     struct mtd_oob_ops *ops);
+
+
 /*
 * Constants for oob configuration
 */
-- 
1.6.3.3



