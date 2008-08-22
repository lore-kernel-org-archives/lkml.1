Return-Path: <linux-kernel-owner+w=401wt.eu-S1761030AbYHVCBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030AbYHVCBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760048AbYHVCA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:00:58 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:53223 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759955AbYHVCA4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:00:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=W+lsLHG3UrS/6HfYcetIVIlgHW9Qym142XRrDECWU9m/K6V7lIPfgAwfTc2nklrC;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <25387440.1219370455174.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
Date: Thu, 21 Aug 2008 19:00:55 -0700 (GMT-07:00)
From: Bruce Leonard <brucle@earthlink.net>
Reply-To: Bruce Leonard <brucle@earthlink.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: 481fc18f0ae4055094f5150ab1c16ac08868399773331e30f18af21d46c219c0e73e37448b47282f350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3e33a3cfc289e9baa41f6e7cf4d612d41b88e19b Mon Sep 17 00:00:00 2001
From: brucle <brucle@selinc.com>
Date: Wed, 13 Aug 2008 18:07:19 -0700
Subject: [PATCH] Add support for > 2GiB MTD devices

Signed-off-by: Bruce D. Leonard <brucle@selinc.com>

---
 drivers/mtd/mtdchar.c        |   16 ++++++++--------
 drivers/mtd/mtdcore.c        |    6 +++---
 drivers/mtd/nand/nand_base.c |   36 ++++++++++++++++++++++++------------
 drivers/mtd/nand/nand_bbt.c  |   30 +++++++++++++++---------------
 drivers/mtd/ubi/build.c      |    5 +++--
 include/linux/mtd/mtd.h      |   27 ++++++++++++++++++++++-----
 include/mtd/mtd-abi.h        |    4 ++--
 7 files changed, 77 insertions(+), 47 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index d2f3318..2829faa 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -70,13 +70,13 @@ static loff_t mtd_lseek (struct file *file, loff_t offset, int orig)
 		offset += file->f_pos;
 		break;
 	case SEEK_END:
-		offset += mtd->size;
+		offset += device_size(mtd);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (offset >= 0 && offset <= mtd->size)
+	if (offset >= 0 && offset <= device_size(mtd))
 		return file->f_pos = offset;
 
 	return -EINVAL;
@@ -173,8 +173,8 @@ static ssize_t mtd_read(struct file *file, char __user *buf, size_t count,loff_t
 
 	DEBUG(MTD_DEBUG_LEVEL0,"MTD_read\n");
 
-	if (*ppos + count > mtd->size)
-		count = mtd->size - *ppos;
+	if (*ppos + count > device_size(mtd))
+		count = device_size(mtd) - *ppos;
 
 	if (!count)
 		return 0;
@@ -266,11 +266,11 @@ static ssize_t mtd_write(struct file *file, const char __user *buf, size_t count
 
 	DEBUG(MTD_DEBUG_LEVEL0,"MTD_write\n");
 
-	if (*ppos == mtd->size)
+	if (*ppos == device_size(mtd))
 		return -ENOSPC;
 
-	if (*ppos + count > mtd->size)
-		count = mtd->size - *ppos;
+	if (*ppos + count > device_size(mtd))
+		count = device_size(mtd) - *ppos;
 
 	if (!count)
 		return 0;
@@ -426,7 +426,7 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 	case MEMGETINFO:
 		info.type	= mtd->type;
 		info.flags	= mtd->flags;
-		info.size	= mtd->size;
+		info.size	= device_size(mtd);
 		info.erasesize	= mtd->erasesize;
 		info.writesize	= mtd->writesize;
 		info.oobsize	= mtd->oobsize;
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index a9d2469..98bc81f 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -60,7 +60,7 @@ int add_mtd_device(struct mtd_info *mtd)
 			/* Some chips always power up locked. Unlock them now */
 			if ((mtd->flags & MTD_WRITEABLE)
 			    && (mtd->flags & MTD_POWERUP_LOCK) && mtd->unlock) {
-				if (mtd->unlock(mtd, 0, mtd->size))
+				if (mtd->unlock(mtd, 0, device_size(mtd)))
 					printk(KERN_WARNING
 					       "%s: unlock failed, "
 					       "writes may not work\n",
@@ -344,8 +344,8 @@ static inline int mtd_proc_info (char *buf, int i)
 	if (!this)
 		return 0;
 
-	return sprintf(buf, "mtd%d: %8.8x %8.8x \"%s\"\n", i, this->size,
-		       this->erasesize, this->name);
+	return sprintf(buf, "mtd%d: %16.16llx %8.8x   \"%s\"\n", i,
+		       device_size(this), this->erasesize, this->name);
 }
 
 static int mtd_read_proc (char *page, char **start, off_t off, int count,
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index d5ac675..2463250 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1179,7 +1179,7 @@ static int nand_read(struct mtd_info *mtd, loff_t from, size_t len,
 	int ret;
 
 	/* Do not allow reads past end of device */
-	if ((from + len) > mtd->size)
+	if ((from + len) > device_size(mtd))
 		return -EINVAL;
 	if (!len)
 		return 0;
@@ -1371,8 +1371,8 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 	}
 
 	/* Do not allow reads past end of device */
-	if (unlikely(from >= mtd->size ||
-		     ops->ooboffs + readlen > ((mtd->size >> chip->page_shift) -
+	if (unlikely(from >= device_size(mtd) ||
+		     ops->ooboffs + readlen > ((device_size(mtd) >> chip->page_shift) -
 					(from >> chip->page_shift)) * len)) {
 		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
 			"Attempt read beyond end of device\n");
@@ -1448,7 +1448,7 @@ static int nand_read_oob(struct mtd_info *mtd, loff_t from,
 	ops->retlen = 0;
 
 	/* Do not allow reads past end of device */
-	if (ops->datbuf && (from + ops->len) > mtd->size) {
+	if (ops->datbuf && (from + ops->len) > device_size(mtd)) {
 		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
 		      "Attempt read beyond end of device\n");
 		return -EINVAL;
@@ -1813,7 +1813,7 @@ static int nand_write(struct mtd_info *mtd, loff_t to, size_t len,
 	int ret;
 
 	/* Do not allow reads past end of device */
-	if ((to + len) > mtd->size)
+	if ((to + len) > device_size(mtd))
 		return -EINVAL;
 	if (!len)
 		return 0;
@@ -1869,9 +1869,9 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 	}
 
 	/* Do not allow reads past end of device */
-	if (unlikely(to >= mtd->size ||
+	if (unlikely(to >= device_size(mtd) ||
 		     ops->ooboffs + ops->ooblen >
-			((mtd->size >> chip->page_shift) -
+			((device_size(mtd) >> chip->page_shift) -
 			 (to >> chip->page_shift)) * len)) {
 		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
 			"Attempt write beyond end of device\n");
@@ -1928,7 +1928,7 @@ static int nand_write_oob(struct mtd_info *mtd, loff_t to,
 	ops->retlen = 0;
 
 	/* Do not allow writes past end of device */
-	if (ops->datbuf && (to + ops->len) > mtd->size) {
+	if (ops->datbuf && (to + ops->len) > device_size(mtd)) {
 		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
 		      "Attempt read beyond end of device\n");
 		return -EINVAL;
@@ -2019,8 +2019,8 @@ int nand_erase_nand(struct mtd_info *mtd, struct erase_info *instr,
 	int rewrite_bbt[NAND_MAX_CHIPS]={0};
 	unsigned int bbt_masked_page = 0xffffffff;
 
-	DEBUG(MTD_DEBUG_LEVEL3, "nand_erase: start = 0x%08x, len = %i\n",
-	      (unsigned int)instr->addr, (unsigned int)instr->len);
+	DEBUG(MTD_DEBUG_LEVEL3, "nand_erase: start = 0x%016llx, len = %i\n",
+	      instr->addr, (unsigned int)instr->len);
 
 	/* Start address must align on block boundary */
 	if (instr->addr & ((1 << chip->phys_erase_shift) - 1)) {
@@ -2036,7 +2036,7 @@ int nand_erase_nand(struct mtd_info *mtd, struct erase_info *instr,
 	}
 
 	/* Do not allow erase past end of device */
-	if ((instr->len + instr->addr) > mtd->size) {
+	if ((instr->len + instr->addr) > device_size(mtd)) {
 		DEBUG(MTD_DEBUG_LEVEL0, "nand_erase: "
 		      "Erase past end of device\n");
 		return -EINVAL;
@@ -2208,7 +2208,7 @@ static void nand_sync(struct mtd_info *mtd)
 static int nand_block_isbad(struct mtd_info *mtd, loff_t offs)
 {
 	/* Check for invalid offset */
-	if (offs > mtd->size)
+	if (offs > device_size(mtd))
 		return -EINVAL;
 
 	return nand_block_checkbad(mtd, offs, 1, 0);
@@ -2502,6 +2502,18 @@ int nand_scan_ident(struct mtd_info *mtd, int maxchips)
 	chip->numchips = i;
 	mtd->size = i * chip->chipsize;
 
+	/* Because mtd->size is 32 bits, if the total 'device size'
+	 * is greater than 2GiB it will overflow mtd->size and signal
+	 * that we need to use the new MTD mio interface.
+	 */
+	if (mtd->size == 0) {
+		mtd->num_eraseblocks = (i * (__u64)(chip->chipsize)) >>
+					chip->phys_erase_shift;
+	} else {
+		/* Can't guarantee mtd was kzalloc'ed */
+		mtd->num_eraseblocks = 0;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index 2f9f0f5..ae6e1a5 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -171,16 +171,16 @@ static int read_bbt(struct mtd_info *mtd, uint8_t *buf, int page, int num,
 				if (tmp == msk)
 					continue;
 				if (reserved_block_code && (tmp == reserved_block_code)) {
-					printk(KERN_DEBUG "nand_read_bbt: Reserved block at 0x%08x\n",
-					       ((offs << 2) + (act >> 1)) << this->bbt_erase_shift);
+					printk(KERN_DEBUG "nand_read_bbt: Reserved block at 0x%016llx\n",
+					       (loff_t)((offs << 2) + (act >> 1)) << this->bbt_erase_shift);
 					this->bbt[offs + (act >> 3)] |= 0x2 << (act & 0x06);
 					mtd->ecc_stats.bbtblocks++;
 					continue;
 				}
 				/* Leave it for now, if its matured we can move this
 				 * message to MTD_DEBUG_LEVEL0 */
-				printk(KERN_DEBUG "nand_read_bbt: Bad block at 0x%08x\n",
-				       ((offs << 2) + (act >> 1)) << this->bbt_erase_shift);
+				printk(KERN_DEBUG "nand_read_bbt: Bad block at 0x%016llx\n",
+				       (loff_t)((offs << 2) + (act >> 1)) << this->bbt_erase_shift);
 				/* Factory marked bad or worn out ? */
 				if (tmp == 0)
 					this->bbt[offs + (act >> 3)] |= 0x3 << (act & 0x06);
@@ -399,7 +399,7 @@ static int create_bbt(struct mtd_info *mtd, uint8_t *buf,
 	if (chip == -1) {
 		/* Note that numblocks is 2 * (real numblocks) here, see i+=2
 		 * below as it makes shifting and masking less painful */
-		numblocks = mtd->size >> (this->bbt_erase_shift - 1);
+		numblocks = device_size(mtd) >> (this->bbt_erase_shift - 1);
 		startblock = 0;
 		from = 0;
 	} else {
@@ -428,8 +428,8 @@ static int create_bbt(struct mtd_info *mtd, uint8_t *buf,
 
 		if (ret) {
 			this->bbt[i >> 3] |= 0x03 << (i & 0x6);
-			printk(KERN_WARNING "Bad eraseblock %d at 0x%08x\n",
-			       i >> 1, (unsigned int)from);
+			printk(KERN_WARNING "Bad eraseblock %d at 0x%016llx\n",
+			       i >> 1, from);
 			mtd->ecc_stats.badblocks++;
 		}
 
@@ -467,7 +467,7 @@ static int search_bbt(struct mtd_info *mtd, uint8_t *buf, struct nand_bbt_descr
 
 	/* Search direction top -> down ? */
 	if (td->options & NAND_BBT_LASTBLOCK) {
-		startblock = (mtd->size >> this->bbt_erase_shift) - 1;
+		startblock = (device_size(mtd) >> this->bbt_erase_shift) - 1;
 		dir = -1;
 	} else {
 		startblock = 0;
@@ -481,7 +481,7 @@ static int search_bbt(struct mtd_info *mtd, uint8_t *buf, struct nand_bbt_descr
 		startblock &= bbtblocks - 1;
 	} else {
 		chips = 1;
-		bbtblocks = mtd->size >> this->bbt_erase_shift;
+		bbtblocks = device_size(mtd) >> this->bbt_erase_shift;
 	}
 
 	/* Number of bits for each erase block in the bbt */
@@ -587,7 +587,7 @@ static int write_bbt(struct mtd_info *mtd, uint8_t *buf,
 			chip = chipsel;
 		}
 	} else {
-		numblocks = (int)(mtd->size >> this->bbt_erase_shift);
+		numblocks = (int)(device_size(mtd) >> this->bbt_erase_shift);
 		nrchips = 1;
 	}
 
@@ -719,7 +719,7 @@ static int write_bbt(struct mtd_info *mtd, uint8_t *buf,
 
 		memset(&einfo, 0, sizeof(einfo));
 		einfo.mtd = mtd;
-		einfo.addr = (unsigned long)to;
+		einfo.addr = to;
 		einfo.len = 1 << this->bbt_erase_shift;
 		res = nand_erase_nand(mtd, &einfo, 1);
 		if (res < 0)
@@ -729,8 +729,8 @@ static int write_bbt(struct mtd_info *mtd, uint8_t *buf,
 		if (res < 0)
 			goto outerr;
 
-		printk(KERN_DEBUG "Bad block table written to 0x%08x, version "
-		       "0x%02X\n", (unsigned int)to, td->version[chip]);
+		printk(KERN_DEBUG "Bad block table written to 0x%016llx, version "
+		       "0x%02X\n", to, td->version[chip]);
 
 		/* Mark it as used */
 		td->pages[chip] = page;
@@ -896,7 +896,7 @@ static void mark_bbt_region(struct mtd_info *mtd, struct nand_bbt_descr *td)
 		nrblocks = (int)(this->chipsize >> this->bbt_erase_shift);
 	} else {
 		chips = 1;
-		nrblocks = (int)(mtd->size >> this->bbt_erase_shift);
+		nrblocks = (int)(device_size(mtd) >> this->bbt_erase_shift);
 	}
 
 	for (i = 0; i < chips; i++) {
@@ -957,7 +957,7 @@ int nand_scan_bbt(struct mtd_info *mtd, struct nand_bbt_descr *bd)
 	struct nand_bbt_descr *td = this->bbt_td;
 	struct nand_bbt_descr *md = this->bbt_md;
 
-	len = mtd->size >> (this->bbt_erase_shift + 2);
+	len = device_size(mtd) >> (this->bbt_erase_shift + 2);
 	/* Allocate memory (2bit per block) and clear the memory bad block table */
 	this->bbt = kzalloc(len, GFP_KERNEL);
 	if (!this->bbt) {
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index c7630a2..6a576d8 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -561,8 +561,9 @@ static int io_init(struct ubi_device *ubi)
 	 */
 
 	ubi->peb_size   = ubi->mtd->erasesize;
-	ubi->peb_count  = ubi->mtd->size / ubi->mtd->erasesize;
-	ubi->flash_size = ubi->mtd->size;
+	ubi->peb_count  = device_size(ubi->mtd) >>
+				(ffs(ubi->mtd->erasesize) - 1);
+	ubi->flash_size = device_size(ubi->mtd);
 
 	if (ubi->mtd->block_isbad && ubi->mtd->block_markbad)
 		ubi->bad_allowed = 1;
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 9226365..ffa24b6 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -26,13 +26,13 @@
 #define MTD_ERASE_FAILED        0x10
 
 /* If the erase fails, fail_addr might indicate exactly which block failed.  If
-   fail_addr = 0xffffffff, the failure was not at the device level or was not
+   fail_addr = 0xffffffffffffffff, the failure was not at the device level or was not
    specific to any particular block. */
 struct erase_info {
 	struct mtd_info *mtd;
-	u_int32_t addr;
+	u_int64_t addr;
 	u_int32_t len;
-	u_int32_t fail_addr;
+	u_int64_t fail_addr;
 	u_long time;
 	u_long retries;
 	u_int dev;
@@ -101,6 +101,14 @@ struct mtd_info {
 	u_int32_t flags;
 	u_int32_t size;	 // Total size of the MTD
 
+	/* 'size' is becoming problematic as flash densities increase.  Since
+	 * the device's size can be calculated by multiplying the number of
+	 * erase blocks by the size of the erase block, I've added a new
+	 * field 'num_eraseblocks', and wrapped it up in a inline function
+	 * (see below).
+	 */
+	u_int64_t num_eraseblocks;
+
 	/* "Major" erase size for the device. Naïve users may take this
 	 * to be the only erase size available, or may use the more detailed
 	 * information below if they desire
@@ -188,8 +196,8 @@ struct mtd_info {
 	void (*sync) (struct mtd_info *mtd);
 
 	/* Chip-supported device locking */
-	int (*lock) (struct mtd_info *mtd, loff_t ofs, size_t len);
-	int (*unlock) (struct mtd_info *mtd, loff_t ofs, size_t len);
+	int (*lock) (struct mtd_info *mtd, loff_t ofs, u_int64_t len);
+	int (*unlock) (struct mtd_info *mtd, loff_t ofs, u_int64_t len);
 
 	/* Power Management functions */
 	int (*suspend) (struct mtd_info *mtd);
@@ -219,6 +227,15 @@ struct mtd_info {
 	void (*put_device) (struct mtd_info *mtd);
 };
 
+/*
+ * Inline function for determining the size of the MTD device, independant
+ * of old or new way of doing things.
+ *
+ */
+static inline u_int64_t device_size(struct mtd_info *a)
+{
+	return a->num_eraseblocks == 0 ? a->size : a->num_eraseblocks * a->erasesize;
+}
 
 	/* Kernel-side ioctl definitions */
 
diff --git a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
index c6c61cd..86347cf 100644
--- a/include/mtd/mtd-abi.h
+++ b/include/mtd/mtd-abi.h
@@ -6,7 +6,7 @@
 #define __MTD_ABI_H__
 
 struct erase_info_user {
-	uint32_t start;
+	uint64_t start;
 	uint32_t length;
 };
 
@@ -50,7 +50,7 @@ struct mtd_oob_buf {
 struct mtd_info_user {
 	uint8_t type;
 	uint32_t flags;
-	uint32_t size;	 // Total size of the MTD
+	uint64_t size;	 // Total size of the MTD
 	uint32_t erasesize;
 	uint32_t writesize;
 	uint32_t oobsize;   // Amount of OOB data per block (e.g. 16)
-- 
1.5.3.4


