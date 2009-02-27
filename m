Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZB0D25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZB0D25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZB0D2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:28:48 -0500
Received: from n69.bullet.mail.sp1.yahoo.com ([98.136.44.41]:20904 "HELO
	n69.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753295AbZB0D2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:28:47 -0500
X-Yahoo-Newman-Id: 547789.91543.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ySlj4vuUHRp3j+0murpgiSlvrOjMoVbnWIvF218lS5WUuxqltELDQdFnnZmUqZn/wKTEZTzZzc7P2I3fx3X7dAL7k8Rd7L2NofxkR5/ZVZFfdbwJkS9gi6LafBjytk8A8DQoDIUtwE//bhOHIlLwO5QVyvPdbsiDPA+lBSU8LBE=  ;
X-YMail-OSG: tB7raAYVM1naE5NmkIIz.P.RCylaqWofqfEEGEulVkSg.fX7SgULnznPTiiHfNh0vQJJ07.n0N63J9A7C_wVnTByP2ff4XqN9hH7jGTOS.j9cF0hh.W1vGIOgzdRitGwbpTz0xBCWnhZu_RE6eGUk242midHsjP9JmFazFUBrQFGpxurMd8beNfeYYsr5QOmerGZveAeRwiehOCau2AgVzZ19ubnvVVopVmyXA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch/RESEND 2.6.29-rc6] NAND:  fix "raw" reads with ECC syndrome layouts
Date: Thu, 26 Feb 2009 19:28:43 -0800
User-Agent: KMail/1.9.10
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <200902241508.13835.david-b@pacbell.net> <20090226122543.797eac77.akpm@linux-foundation.org>
In-Reply-To: <20090226122543.797eac77.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902261928.43642.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Andrew Morton wrote:
> > +     temp = chip->ecc.steps;
> > +     do {
> > +             ...
> > +     } while (--temp);
> 
> It would be clearer to code this as a plain old up-counting for loop.

Downside:  GCC adds a pointless jump-to-loop-test instruction at
the top of the loop ... but we know there's at least one step,
so there's no need to do that.  And up-counting needs an extra
variable, with initialization etc.


======== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

Cosmetic fixes to the patch fixing raw HW_SYNDROME read/write.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mtd/nand/nand_base.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -773,10 +773,9 @@ static int nand_read_page_raw_syndrome(s
 	int eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
 	uint8_t *oob = chip->oob_poi;
-	int temp;
+	int steps, size;
 
-	temp = chip->ecc.steps;
-	do {
+	for (steps = chip->ecc.steps; steps > 0; steps--) {
 		chip->read_buf(mtd, buf, eccsize);
 		buf += eccsize;
 
@@ -792,11 +791,11 @@ static int nand_read_page_raw_syndrome(s
 			chip->read_buf(mtd, oob, chip->ecc.postpad);
 			oob += chip->ecc.postpad;
 		}
-	} while (--temp);
+	}
 
-	temp = mtd->oobsize - (oob - chip->oob_poi);
-	if (temp)
-		chip->read_buf(mtd, oob, temp);
+	size = mtd->oobsize - (oob - chip->oob_poi);
+	if (size)
+		chip->read_buf(mtd, oob, size);
 
 	return 0;
 }
@@ -1542,7 +1541,7 @@ static void nand_write_page_raw(struct m
  * @chip:	nand chip info structure
  * @buf:	data buffer
  *
- * We need a special oob layout and handling even when ECC isn't used.
+ * We need a special oob layout and handling even when ECC isn't checked.
  */
 static void nand_write_page_raw_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
 				const uint8_t *buf)
@@ -1550,10 +1549,9 @@ static void nand_write_page_raw_syndrome
 	int eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
 	uint8_t *oob = chip->oob_poi;
-	int temp;
+	int steps, size;
 
-	temp = chip->ecc.steps;
-	do {
+	for (steps = chip->ecc.steps; steps > 0; steps--) {
 		chip->write_buf(mtd, buf, eccsize);
 		buf += eccsize;
 
@@ -1569,11 +1567,11 @@ static void nand_write_page_raw_syndrome
 			chip->write_buf(mtd, oob, chip->ecc.postpad);
 			oob += chip->ecc.postpad;
 		}
-	} while (--temp);
+	}
 
-	temp = mtd->oobsize - (oob - chip->oob_poi);
-	if (temp)
-		chip->write_buf(mtd, oob, temp);
+	size = mtd->oobsize - (oob - chip->oob_poi);
+	if (size)
+		chip->write_buf(mtd, oob, size);
 }
 /**
  * nand_write_page_swecc - [REPLACABLE] software ecc based page write function


