Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXDFPmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXDFPmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932943AbXDFPmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:42:06 -0400
Received: from mail.macqel.be ([194.78.208.39]:29175 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933AbXDFPmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:42:05 -0400
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 11:42:04 EDT
Date: Fri, 6 Apr 2007 17:23:51 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] partition : add support for sysv68 partitions
Message-ID: <20070406152351.GA26889@ingate.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Add support for the Motorola sysv68 disk partition (slices in motorola doc).

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -ruN fs/partitionsbk/check.c fs/partitions/check.c
--- fs/partitionsbk/check.c	2006-09-20 05:42:06.000000000 +0200
+++ fs/partitions/check.c	2007-04-06 10:52:21.000000000 +0200
@@ -34,6 +34,7 @@
 #include "ultrix.h"
 #include "efi.h"
 #include "karma.h"
+#include "sysv68.h"
 
 #ifdef CONFIG_BLK_DEV_MD
 extern void md_autodetect_dev(dev_t dev);
@@ -105,6 +106,9 @@
 #ifdef CONFIG_KARMA_PARTITION
 	karma_partition,
 #endif
+#ifdef CONFIG_SYSV68_PARTITION
+	sysv68_partition,
+#endif
 	NULL
 };
  
diff -ruN fs/partitionsbk/Kconfig fs/partitions/Kconfig
--- fs/partitionsbk/Kconfig	2006-09-20 05:42:06.000000000 +0200
+++ fs/partitions/Kconfig	2007-04-04 15:14:57.000000000 +0200
@@ -237,3 +237,12 @@
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned using EFI GPT.  Presently only useful on the
 	  IA-64 platform.
+
+config SYSV68_PARTITION
+	bool "SYSV68 partition table support" if PARTITION_ADVANCED
+	default y if M68K
+	help
+	  Say Y here if you would like to be able to read the hard disk
+	  partition table format used by Motorola Delta machines (using
+	  sysv68).
+	  Otherwise, say N.
diff -ruN fs/partitionsbk/Makefile fs/partitions/Makefile
--- fs/partitionsbk/Makefile	2006-09-20 05:42:06.000000000 +0200
+++ fs/partitions/Makefile	2007-04-04 15:53:01.000000000 +0200
@@ -17,3 +17,4 @@
 obj-$(CONFIG_IBM_PARTITION) += ibm.o
 obj-$(CONFIG_EFI_PARTITION) += efi.o
 obj-$(CONFIG_KARMA_PARTITION) += karma.o
+obj-$(CONFIG_SYSV68_PARTITION) += sysv68.o
diff -ruN fs/partitionsbk/sysv68.c fs/partitions/sysv68.c
--- fs/partitionsbk/sysv68.c	1970-01-01 01:00:00.000000000 +0100
+++ fs/partitions/sysv68.c	2007-04-06 16:34:33.000000000 +0200
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
+			break;
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
diff -ruN fs/partitionsbk/sysv68.h fs/partitions/sysv68.h
--- fs/partitionsbk/sysv68.h	1970-01-01 01:00:00.000000000 +0100
+++ fs/partitions/sysv68.h	2007-04-06 16:30:22.000000000 +0200
@@ -0,0 +1 @@
+extern int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev);
-- 
Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
