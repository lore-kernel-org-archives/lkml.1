Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbXBAAGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbXBAAGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933374AbXBAAGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:06:09 -0500
Received: from patroclus.tjworld.net ([84.12.34.246]:49347 "EHLO phwoarrr.tv"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933371AbXBAAGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:06:07 -0500
X-Greylist: delayed 919 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 19:06:06 EST
Subject: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by probe
	of partitions
From: TJ <linux@tjworld.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: TJworld
Date: Wed, 31 Jan 2007 23:50:39 +0000
Message-Id: <1170287439.13764.24.camel@butch.lan.tjworld.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-Server: High Performance Mail Server - http://surgemail.com r=-2006397171
X-Authenticated-User: tj@tjworld.net 
X-DNS-Paranoid: DNS lookup didn't match (84.12.34.243)->(dns2.hornytunes.com)->()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: TJ <linux@tjworld.net>

Applies to: up-to and including 2.6.20-rc7 

This rare but critical bug has the potential to cause a hardware failure on disk drives by
allowing the system to repeatedly attempt to seek to sectors beyond the end of the physical
disk, causing sustained 'head banging'.

The bug particularly affects dmraid-managed RAID 1 stripes of the type hde+hdf where the
first physical disk hde contains a standard partition table which relates to the larger
logical disk represented by hde+hdf.

The essence is that probing of physical disks that are part of a larger logical disk
should be prevented because those disks will be managed by a driver that loads later in the
boot sequence.
This patch doesn't prevent probing of disks with 'sane' partition table entries.

At boot-time when drives are being probed the disks are scanned for partition tables by
fs/partitions/check.c:check_partition() which makes calls to all registered partition-types.

In the case of the commonly used "msdos" partition-type used for Linux, BSD, Solaris, MS-DOS,
extended and others, the checking is done in

fs/partitions/msdos.c:msdos_partition().

The partition table is only checked for validity based on the 'magic bytes' 55AA in the boot
sector. The sector values in the partition table are copied without any checks to ensure they
are within the bounds of the disk device. 

As a result, block devices are created based on the partition structures and then various
file-systems are given the task of scanning the partition to determine if it is one they will
manage.

This scanning, in a partition that has sector numbers outside the bounds of the device, causes
the errors.

Signed-off-by: TJ <linux@tjworld.net>
---

I'm not sure if this bug will affect mdraid RAID-1 stripes, or other software
RAID configurations.

The bug was discovered on a RAID 1+0 array consisting of 4x60GB drives on a
Promise FastTrak PDC20271 2-channel IDE controller (hde+hdf mirrored to hdg+hdh)
with logical block addressing (LBA).

There are 3 prolonged periods of disk-probing each lasting about 20 seconds
during which the 'head banging' is quite scary. The first two occur during the
kernel boot, and the last will occur when a GUI environment such as Gnome
initialises.

In the system where this bug appeared this caused thousands of disk-read errors
during boot (which overflowed dmesg log), and 'head bangs' the drive(s) so hard
that sometimes the system has to be powered off for a considerable time before
the disk(s) will re-initialise.

--- fs/partitions/msdos.c	2006-11-29 21:57:37.000000000 +0000
+++ fs/partitions/msdos.tj.c	2007-01-31 23:39:09.000000000 +0000
@@ -399,6 +399,79 @@ static struct {
 	{NEW_SOLARIS_X86_PARTITION, parse_solaris_x86},
 	{0, NULL},
 };
+
+/* 
+ * Check that *all* sector offsets are valid before actually building the partition structure.
+ *
+ * This prevents physical damage to disks and boot-time problems caused by an apparently valid
+ * partition table causing attempts to read sectors beyond the end of the physical disk.
+ *
+ * This is especially important where this is the first physical disk in a striped RAID array
+ * and the partition table contains sector offsets into the larger logical disk (beyond the end
+ * of this physical disk).
+ *
+ * The RAID module will correctly manage the disks.
+ *
+ * The function is re-entrant so it can call itself to check extended partitions.
+ * 
+ * @param p partition table
+ * @param bdev block device
+ * @returns -1 if insane values found; 0 otherwise
+ * @copy Copyright 31 January 2007
+ * @author TJ <linux@tjworld.net>
+ */ 
+int check_sane_values(struct partition *p, struct block_device *bdev) {
+	unsigned char *data;
+	struct partition *ext;
+	Sector sect;
+	int slot;
+	int insane;
+	int sector_size = bdev_hardsect_size(bdev) / 512;
+	int ret = 0; /* default is to report ok */
+
+	/* don't return early; allow all partition entries to be checked */
+	for (slot = 1 ; slot <= 4 ; slot++, p++) { 
+		insane = 0; /* track sanity within each table entry */
+
+		if (NR_SECTS(p) == 0)
+			continue; /* ignore zero-sized entries */
+
+		if (START_SECT(p) > bdev->bd_disk->capacity-1) { /* invalid - beyond end of disk */
+			insane |= 1; /* bit-0 flags insane start */
+		}
+		if (START_SECT(p)+NR_SECTS(p)-1 > bdev->bd_disk->capacity-1) { /* invalid - beyond end of disk */
+			insane |= 2; /* bit-1 flags insane end */
+		}
+		if (!insane && is_extended_partition(p)) { /* check the extended partition */
+			data = read_dev_sector(bdev, START_SECT(p)*sector_size, &sect); /* fetch sector from cache */
+			if (data) {
+				if (msdos_magic_present(data + 510)) { /* check for signature */
+					ext = (struct partition *) (data + 0x1be);
+					ret = check_sane_values(ext, bdev); /* recursive call */
+					if (ret == -1) /* insanity found */
+						insane |= 4; /* bit-2 flags insane extended partition contents */
+				}
+				put_dev_sector(sect); /* release sector to cache */
+			}
+			else ret = -1; /* failed to read sector from cache */
+
+		}
+		if (insane) { /* insanity found; report it */
+			ret = -1; /* error code */
+			printk("\n"); /* start error report on a fresh line */
+			if (insane | 1)
+				printk(" partition %d: start (sector %d) beyond end of disk (sector %d)\n",
+				 slot, START_SECT(p), (unsigned int) bdev->bd_disk->capacity-1);
+			if (insane | 2)
+				printk(" partition %d: end (sector %d) beyond end of disk (sector %d)\n",
+				 slot, START_SECT(p)+NR_SECTS(p)-1, (unsigned int) bdev->bd_disk->capacity-1);
+			if (insane | 4)
+				printk(" partition %d: insane extended contents\n", slot);
+		}
+	}
+	return ret;
+}
+
  
 int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
@@ -448,6 +521,18 @@ int msdos_partition(struct parsed_partit
 #endif
 	p = (struct partition *) (data + 0x1be);
 
+	/* 
+	 * Check that *all* sector offsets are valid before actually building the partition structure
+	 * Do it now rather than inside the loop that builds the partition entries to avoid having to
+	 * unwind an unknown number of put_partition() calls in this loop and in the (possible) calls
+	 * to parse_extended()
+	 * Added by TJ <linux@tjworld.net>, 31 January 2007.
+	 */
+	if (check_sane_values(p, bdev) == -1) {
+		put_dev_sector(sect); /* release to cache */
+		return -1; /* report invalid partition table */
+	}
+
 	/*
 	 * Look for partitions in two passes:
 	 * First find the primary and DOS-type extended partitions.


