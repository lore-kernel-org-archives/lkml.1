Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbXDMNzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbXDMNzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXDMNzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:55:07 -0400
Received: from mail.macqel.be ([194.78.208.39]:2890 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbXDMNzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:55:05 -0400
Date: Fri, 13 Apr 2007 15:55:01 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: retry [PATCH] partition : add support for sysv68 partitions
Message-ID: <20070413135501.GA27439@ingate.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Add support for the Motorola sysv68 disk partition table (slices in motorola
doc).

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 1b54f1d81bc5 fs/partitions/Kconfig
--- a/fs/partitions/Kconfig	Thu Apr 12 15:44:52 2007 -0700
+++ b/fs/partitions/Kconfig	Fri Apr 13 15:51:58 2007 +0200
@@ -236,3 +236,12 @@ config EFI_PARTITION
 	help
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned using EFI GPT.
+
+config SYSV68_PARTITION
+	bool "SYSV68 partition table support" if PARTITION_ADVANCED
+	default y if M68K
+	help
+	  Say Y here if you would like to be able to read the hard disk
+	  partition table format used by Motorola Delta machines (using
+	  sysv68).
+	  Otherwise, say N.
diff -r 1b54f1d81bc5 fs/partitions/Makefile
--- a/fs/partitions/Makefile	Thu Apr 12 15:44:52 2007 -0700
+++ b/fs/partitions/Makefile	Fri Apr 13 15:51:58 2007 +0200
@@ -17,3 +17,4 @@ obj-$(CONFIG_IBM_PARTITION) += ibm.o
 obj-$(CONFIG_IBM_PARTITION) += ibm.o
 obj-$(CONFIG_EFI_PARTITION) += efi.o
 obj-$(CONFIG_KARMA_PARTITION) += karma.o
+obj-$(CONFIG_SYSV68_PARTITION) += sysv68.o
diff -r 1b54f1d81bc5 fs/partitions/check.c
--- a/fs/partitions/check.c	Thu Apr 12 15:44:52 2007 -0700
+++ b/fs/partitions/check.c	Fri Apr 13 15:51:58 2007 +0200
@@ -34,6 +34,7 @@
 #include "ultrix.h"
 #include "efi.h"
 #include "karma.h"
+#include "sysv68.h"
 
 #ifdef CONFIG_BLK_DEV_MD
 extern void md_autodetect_dev(dev_t dev);
@@ -104,6 +105,9 @@ static int (*check_part[])(struct parsed
 #endif
 #ifdef CONFIG_KARMA_PARTITION
 	karma_partition,
+#endif
+#ifdef CONFIG_SYSV68_PARTITION
+	sysv68_partition,
 #endif
 	NULL
 };
diff -r 1b54f1d81bc5 fs/partitions/sysv68.c
--- /dev/null	Thu Jan  1 00:00:00 1970 +0000
+++ b/fs/partitions/sysv68.c	Fri Apr 13 15:51:58 2007 +0200
@@ -0,0 +1,92 @@
+/*
+ *  fs/partitions/sysv68.c
+ *
+ *  Copyright (C) 2007 Philippe De Muyter <phdm@macqel.be>
+ */
+
+#include "check.h"
+#include "sysv68.h"
+
+/*
+ *	Volume ID structure: on first 256-bytes sector of disk
+ */
+
+struct	volumeid {
+	u8	vid_unused[248];
+	u8	vid_mac[8];	/* ASCII string "MOTOROLA" */
+};
+
+/*
+ *	config block: second 256-bytes sector on disk
+ */
+
+struct dkconfig {
+	u8	ios_unused0[128];
+	__be32	ios_slcblk;	/* Slice table block number */
+	__be16	ios_slccnt;	/* Number of entries in slice table */
+	u8	ios_unused1[122];
+};
+
+/*
+ *	combined volumeid and dkconfig block
+ */
+
+struct dkblk0 {
+	struct volumeid dk_vid;
+	struct dkconfig dk_ios;
+};
+
+/*
+ *	Slice Table Structure
+ */
+
+struct slice {
+	__be32	nblocks;		/* slice size (in blocks) */
+	__be32	blkoff;			/* block offset of slice */
+};
+
+
+int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev)
+{
+	int i, slices;
+	int slot = 1;
+	Sector sect;
+	unsigned char *data;
+	struct dkblk0 *b;
+	struct slice *slice;
+
+	data = read_dev_sector(bdev, 0, &sect);
+	if (!data)
+		return -1;
+
+	b = (struct dkblk0 *) data;
+	if (memcmp(b->dk_vid.vid_mac, "MOTOROLA", sizeof(b->dk_vid.vid_mac))) {
+		put_dev_sector(sect);
+		return 0;
+	}
+	slices = be16_to_cpu(b->dk_ios.ios_slccnt);
+	i = be32_to_cpu(b->dk_ios.ios_slcblk);
+	put_dev_sector(sect);
+
+	data = read_dev_sector(bdev, i, &sect);
+	if (!data)
+		return -1;
+
+	slices -= 1; /* last slice is the whole disk */
+	printk("sysV68: %s(s%u)", state->name, slices);
+	slice = (struct slice *)data;
+	for (i = 0 ; i < slices; i++, slice++) {
+		if (slot == state->limit)
+		        break;
+		if (be32_to_cpu(slice->nblocks)) {
+			put_partition(state, slot,
+				be32_to_cpu(slice->blkoff),
+				be32_to_cpu(slice->nblocks));
+			printk("(s%u)", i);
+		}
+		slot++;
+	}
+	printk("\n");
+	put_dev_sector(sect);
+	return 1;
+}
diff -r 1b54f1d81bc5 fs/partitions/sysv68.h
--- /dev/null	Thu Jan  1 00:00:00 1970 +0000
+++ b/fs/partitions/sysv68.h	Fri Apr 13 15:51:58 2007 +0200
@@ -0,0 +1,1 @@
+extern int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev);
