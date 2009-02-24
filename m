Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbZBYBMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbZBYBMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZBYBMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:12:20 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:46976 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751559AbZBYBMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:12:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Reply-To:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=TFHGRHC6Rqko2OI0WW36OKCS5kw/1S+GitSXFvDBxLi4zSXGcqG9fHYDV7UCjnwojWus1lw+/gPTaTsvGBXv7TPL/ldt2XLHcBDFHXap7IeP+MQkdLvfXCCGtLebTxIVTnX1poCeMeGrIDC9y6iGSiMRShSQ+eY9SjXg3pnnfWw=  ;
X-YMail-OSG: CsRU47oVM1lLi5OmxnADVDgfPkGG1_pLbOyit6fmdPvAdyvv6zcaYPRdoPYf7SzwKmmgxk9M9Jo6.AZ65IFuGTuDDwgzAAGpTss28W3Y0d5ry4NX8gPto67F3iZKQfUYxOY7wMbBtxMw03z7Q8BM7rOHSf_cvLLzBLWxZ2qflkikRZF9hlrHDmSmza3C3cbHCIa.OoRq713AuMj5Jglhwj8TxivVKSYPHi.aSw--
X-Yahoo-Newman-Property: ymail-3
To: Linux MTD <linux-mtd@lists.infradead.org>
Subject: [patch/RESEND 2.6.29-rc6] NAND:  fix "raw" reads with ECC syndrome layouts
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
Date: Tue, 24 Feb 2009 15:08:13 -0800
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902241508.13835.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

The syndrome based page read/write routines store ECC, and possibly
other "OOB" data, right after each chunk of ECC'd data.  With ECC
chunk size of 512 bytes and a large page (2KB) NAND, the layout is:

  data-0 OOB-0 data-1 OOB-1 data-2 OOB-2 data-3 OOB-3 OOB-leftover

Where OOBx is (prepad, ECC, postpad).  However, the current "raw"
routines use a traditional layout -- data OOB, disregarding the
prepad and postpad values -- so when they're used with that type of
ECC hardware, those calls mix up the data and OOB.  Which means,
in particular, that bad block tables won't be found on startup,
with data corruption and related chaos ensuing.

The current syndrome-based drivers in mainline all seem to use one
chunk per page; presumably they haven't noticed such bugs.

Fix this, by adding read/write page_raw_syndrome() routines as
siblings of the existing non-raw routines; "raw" just means to
bypass the ECC computations, not change data and OOB layout.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Observed when trying to get this working with the DaVinci NAND
driver in 4-bit ECC mode with a large page chip.

 drivers/mtd/nand/nand_base.c |  101 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 97 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -748,6 +748,8 @@ static int nand_wait(struct mtd_info *mt
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	buffer to store read data
+ *
+ * Not for syndrome calculating ecc controllers, which use a special oob layout
  */
 static int nand_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
 			      uint8_t *buf)
@@ -758,6 +760,48 @@ static int nand_read_page_raw(struct mtd
 }
 
 /**
+ * nand_read_page_raw_syndrome - [Intern] read raw page data without ecc
+ * @mtd:	mtd info structure
+ * @chip:	nand chip info structure
+ * @buf:	buffer to store read data
+ *
+ * We need a special oob layout and handling even when OOB isn't used.
+ */
+static int nand_read_page_raw_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
+			      uint8_t *buf)
+{
+	int eccsize = chip->ecc.size;
+	int eccbytes = chip->ecc.bytes;
+	uint8_t *oob = chip->oob_poi;
+	int temp;
+
+	temp = chip->ecc.steps;
+	do {
+		chip->read_buf(mtd, buf, eccsize);
+		buf += eccsize;
+
+		if (chip->ecc.prepad) {
+			chip->read_buf(mtd, oob, chip->ecc.prepad);
+			oob += chip->ecc.prepad;
+		}
+
+		chip->read_buf(mtd, oob, eccbytes);
+		oob += eccbytes;
+
+		if (chip->ecc.postpad) {
+			chip->read_buf(mtd, oob, chip->ecc.postpad);
+			oob += chip->ecc.postpad;
+		}
+	} while (--temp);
+
+	temp = mtd->oobsize - (oob - chip->oob_poi);
+	if (temp)
+		chip->read_buf(mtd, oob, temp);
+
+	return 0;
+}
+
+/**
  * nand_read_page_swecc - [REPLACABLE] software ecc based page read function
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
@@ -1482,6 +1526,8 @@ static int nand_read_oob(struct mtd_info
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	data buffer
+ *
+ * Not for syndrome calculating ecc controllers, which use a special oob layout
  */
 static void nand_write_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
 				const uint8_t *buf)
@@ -1491,6 +1537,45 @@ static void nand_write_page_raw(struct m
 }
 
 /**
+ * nand_write_page_raw_syndrome - [Intern] raw page write function
+ * @mtd:	mtd info structure
+ * @chip:	nand chip info structure
+ * @buf:	data buffer
+ *
+ * We need a special oob layout and handling even when ECC isn't used.
+ */
+static void nand_write_page_raw_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
+				const uint8_t *buf)
+{
+	int eccsize = chip->ecc.size;
+	int eccbytes = chip->ecc.bytes;
+	uint8_t *oob = chip->oob_poi;
+	int temp;
+
+	temp = chip->ecc.steps;
+	do {
+		chip->write_buf(mtd, buf, eccsize);
+		buf += eccsize;
+
+		if (chip->ecc.prepad) {
+			chip->write_buf(mtd, oob, chip->ecc.prepad);
+			oob += chip->ecc.prepad;
+		}
+
+		chip->read_buf(mtd, oob, eccbytes);
+		oob += eccbytes;
+
+		if (chip->ecc.postpad) {
+			chip->write_buf(mtd, oob, chip->ecc.postpad);
+			oob += chip->ecc.postpad;
+		}
+	} while (--temp);
+
+	temp = mtd->oobsize - (oob - chip->oob_poi);
+	if (temp)
+		chip->write_buf(mtd, oob, temp);
+}
+/**
  * nand_write_page_swecc - [REPLACABLE] software ecc based page write function
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
@@ -2569,10 +2654,6 @@ int nand_scan_tail(struct mtd_info *mtd)
 	 * check ECC mode, default to software if 3byte/512byte hardware ECC is
 	 * selected and we have 256 byte pagesize fallback to software ECC
 	 */
-	if (!chip->ecc.read_page_raw)
-		chip->ecc.read_page_raw = nand_read_page_raw;
-	if (!chip->ecc.write_page_raw)
-		chip->ecc.write_page_raw = nand_write_page_raw;
 
 	switch (chip->ecc.mode) {
 	case NAND_ECC_HW:
@@ -2581,6 +2662,10 @@ int nand_scan_tail(struct mtd_info *mtd)
 			chip->ecc.read_page = nand_read_page_hwecc;
 		if (!chip->ecc.write_page)
 			chip->ecc.write_page = nand_write_page_hwecc;
+		if (!chip->ecc.read_page_raw)
+			chip->ecc.read_page_raw = nand_read_page_raw;
+		if (!chip->ecc.write_page_raw)
+			chip->ecc.write_page_raw = nand_write_page_raw;
 		if (!chip->ecc.read_oob)
 			chip->ecc.read_oob = nand_read_oob_std;
 		if (!chip->ecc.write_oob)
@@ -2602,6 +2687,10 @@ int nand_scan_tail(struct mtd_info *mtd)
 			chip->ecc.read_page = nand_read_page_syndrome;
 		if (!chip->ecc.write_page)
 			chip->ecc.write_page = nand_write_page_syndrome;
+		if (!chip->ecc.read_page_raw)
+			chip->ecc.read_page_raw = nand_read_page_raw_syndrome;
+		if (!chip->ecc.write_page_raw)
+			chip->ecc.write_page_raw = nand_write_page_raw_syndrome;
 		if (!chip->ecc.read_oob)
 			chip->ecc.read_oob = nand_read_oob_syndrome;
 		if (!chip->ecc.write_oob)
@@ -2620,6 +2709,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 		chip->ecc.read_page = nand_read_page_swecc;
 		chip->ecc.read_subpage = nand_read_subpage;
 		chip->ecc.write_page = nand_write_page_swecc;
+		chip->ecc.read_page_raw = nand_read_page_raw;
+		chip->ecc.write_page_raw = nand_write_page_raw;
 		chip->ecc.read_oob = nand_read_oob_std;
 		chip->ecc.write_oob = nand_write_oob_std;
 		chip->ecc.size = 256;
@@ -2632,6 +2723,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 		chip->ecc.read_page = nand_read_page_raw;
 		chip->ecc.write_page = nand_write_page_raw;
 		chip->ecc.read_oob = nand_read_oob_std;
+		chip->ecc.read_page_raw = nand_read_page_raw;
+		chip->ecc.write_page_raw = nand_write_page_raw;
 		chip->ecc.write_oob = nand_write_oob_std;
 		chip->ecc.size = mtd->writesize;
 		chip->ecc.bytes = 0;
