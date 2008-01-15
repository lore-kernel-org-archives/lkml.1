Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbYAOVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbYAOVmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYAOVmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:42:05 -0500
Received: from havoc.gtf.org ([69.61.125.42]:54591 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbYAOVmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:42:04 -0500
Date: Tue, 15 Jan 2008 16:42:01 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080115214201.GA8238@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Open issues for 2.6.24:  sata_nv ADMA, sata_nv 32/64bit DMA

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c  |    4 +++-
 drivers/ata/pata_bf54x.c   |    3 ++-
 drivers/ata/pata_legacy.c  |    8 +++-----
 drivers/ata/pata_qdi.c     |    8 +++-----
 drivers/ata/pata_winbond.c |    8 +++-----
 include/linux/ata.h        |    2 --
 6 files changed, 14 insertions(+), 19 deletions(-)

Al Viro (1):
      libata fixes for sparse-found problems

Alan Cox (1):
      libata: correct handling of TSS DVD

Andrew Morton (2):
      [libata] pata_bf54x: checkpatch fixes
      [libata] core checkpatch fix

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4753a18..6380726 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6998,7 +6998,9 @@ int ata_host_start(struct ata_host *host)
 			rc = ap->ops->port_start(ap);
 			if (rc) {
 				if (rc != -ENODEV)
-					dev_printk(KERN_ERR, host->dev, "failed to start port %d (errno=%d)\n", i, rc);
+					dev_printk(KERN_ERR, host->dev,
+						"failed to start port %d "
+						"(errno=%d)\n", i, rc);
 				goto err_out;
 			}
 		}
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 088a41f..7842cc4 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1509,7 +1509,8 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
 	if (res == NULL)
 		return -EINVAL;
 
-	while (bfin_port_info[board_idx].udma_mask>0 && udma_fsclk[udma_mode] > fsclk) {
+	while (bfin_port_info[board_idx].udma_mask > 0 &&
+			udma_fsclk[udma_mode] > fsclk) {
 		udma_mode--;
 		bfin_port_info[board_idx].udma_mask >>= 1;
 	}
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 7bed8d8..17159b5 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -271,14 +271,12 @@ static void pdc_data_xfer_vlb(struct ata_device *adev, unsigned char *buf, unsig
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			u32 pad;
+			__le32 pad = 0;
 			if (write_data) {
 				memcpy(&pad, buf + buflen - slop, slop);
-				pad = le32_to_cpu(pad);
-				iowrite32(pad, ap->ioaddr.data_addr);
+				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
 			} else {
-				pad = ioread32(ap->ioaddr.data_addr);
-				pad = cpu_to_le16(pad);
+				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
 			}
 		}
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 7d4c696..a4c0e50 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -136,14 +136,12 @@ static void qdi_data_xfer(struct ata_device *adev, unsigned char *buf, unsigned
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			u32 pad;
+			__le32 pad = 0;
 			if (write_data) {
 				memcpy(&pad, buf + buflen - slop, slop);
-				pad = le32_to_cpu(pad);
-				iowrite32(pad, ap->ioaddr.data_addr);
+				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
 			} else {
-				pad = ioread32(ap->ioaddr.data_addr);
-				pad = cpu_to_le32(pad);
+				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
 			}
 		}
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 311cdb3..7116a9e 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -104,14 +104,12 @@ static void winbond_data_xfer(struct ata_device *adev, unsigned char *buf, unsig
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			u32 pad;
+			__le32 pad = 0;
 			if (write_data) {
 				memcpy(&pad, buf + buflen - slop, slop);
-				pad = le32_to_cpu(pad);
-				iowrite32(pad, ap->ioaddr.data_addr);
+				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
 			} else {
-				pad = ioread32(ap->ioaddr.data_addr);
-				pad = cpu_to_le16(pad);
+				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
 			}
 		}
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 72ab808..e672e80 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -554,8 +554,6 @@ static inline int ata_drive_40wire(const u16 *dev_id)
 
 static inline int ata_drive_40wire_relaxed(const u16 *dev_id)
 {
-	if (ata_id_is_sata(dev_id))
-		return 0;	/* SATA */
 	if ((dev_id[93] & 0x2000) == 0x2000)
 		return 0;	/* 80 wire */
 	return 1;
