Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbZBQV01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbZBQV01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZBQVZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:25:56 -0500
Received: from havoc.gtf.org ([69.61.125.42]:59495 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZBQVZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:25:55 -0500
Date: Tue, 17 Feb 2009 16:25:51 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090217212551.GA8468@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-sff.c |   28 +++++++++++++++++++++-------
 drivers/ata/sata_nv.c    |   14 ++++++++------
 2 files changed, 29 insertions(+), 13 deletions(-)

Sergei Shtylyov (1):
      libata-sff: fix 32-bit PIO ATAPI regression

Tejun Heo (1):
      sata_nv: give up hardreset on nf2

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 0b299b0..714cb04 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -773,18 +773,32 @@ unsigned int ata_sff_data_xfer32(struct ata_device *dev, unsigned char *buf,
 	else
 		iowrite32_rep(data_addr, buf, words);
 
+	/* Transfer trailing bytes, if any */
 	if (unlikely(slop)) {
-		__le32 pad;
+		unsigned char pad[4];
+
+		/* Point buf to the tail of buffer */
+		buf += buflen - slop;
+
+		/*
+		 * Use io*_rep() accessors here as well to avoid pointlessly
+		 * swapping bytes to and fro on the big endian machines...
+		 */
 		if (rw == READ) {
-			pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-			memcpy(buf + buflen - slop, &pad, slop);
+			if (slop < 3)
+				ioread16_rep(data_addr, pad, 1);
+			else
+				ioread32_rep(data_addr, pad, 1);
+			memcpy(buf, pad, slop);
 		} else {
-			memcpy(&pad, buf + buflen - slop, slop);
-			iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
+			memcpy(pad, buf, slop);
+			if (slop < 3)
+				iowrite16_rep(data_addr, pad, 1);
+			else
+				iowrite32_rep(data_addr, pad, 1);
 		}
-		words++;
 	}
-	return words << 2;
+	return (buflen + 1) & ~1;
 }
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 444af04..55a8eed 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -421,19 +421,21 @@ static struct ata_port_operations nv_generic_ops = {
 	.hardreset		= ATA_OP_NULL,
 };
 
-/* OSDL bz3352 reports that nf2/3 controllers can't determine device
- * signature reliably.  Also, the following thread reports detection
- * failure on cold boot with the standard debouncing timing.
+/* nf2 is ripe with hardreset related problems.
+ *
+ * kernel bz#3352 reports nf2/3 controllers can't determine device
+ * signature reliably.  The following thread reports detection failure
+ * on cold boot with the standard debouncing timing.
  *
  * http://thread.gmane.org/gmane.linux.ide/34098
  *
- * Debounce with hotplug timing and request follow-up SRST.
+ * And bz#12176 reports that hardreset simply doesn't work on nf2.
+ * Give up on it and just don't do hardreset.
  */
 static struct ata_port_operations nv_nf2_ops = {
-	.inherits		= &nv_common_ops,
+	.inherits		= &nv_generic_ops,
 	.freeze			= nv_nf2_freeze,
 	.thaw			= nv_nf2_thaw,
-	.hardreset		= nv_noclassify_hardreset,
 };
 
 /* For initial probing after boot and hot plugging, hardreset mostly
