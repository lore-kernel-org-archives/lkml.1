Return-Path: <linux-kernel-owner+w=401wt.eu-S965359AbXBQQ6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359AbXBQQ6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992481AbXBQQ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:58:26 -0500
Received: from smtp.nokia.com ([131.228.20.171]:55296 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992475AbXBQQ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:58:09 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:57:46 +0200
Message-Id: <20070217165746.5845.80881.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 40/44 take 2] [UBI] character devices handling sub-unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:57:13.0344 (UTC) FILETIME=[ABCF7800:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185536-3C652BB0-1D5857EC/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/cdev.c tmp-to/drivers/mtd/ubi/cdev.c
--- tmp-from/drivers/mtd/ubi/cdev.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/cdev.c	2007-02-17 18:07:28.000000000 +0200
@@ -0,0 +1,1033 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Author: Artem B. Bityutskiy
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/stat.h>
+#include <linux/sched.h>
+#include <linux/ioctl.h>
+#include <linux/cdev.h>
+#include <linux/capability.h>
+#include <linux/types.h>
+#include <linux/mtd/ubi.h>
+#include <mtd/ubi-user.h>
+#include <mtd/ubi-header.h>
+#include <asm/uaccess.h>
+#include <asm/div64.h>
+#include "ubi.h"
+#include "uif.h"
+#include "upd.h"
+#include "eba.h"
+#include "cdev.h"
+#include "account.h"
+#include "debug.h"
+#include "alloc.h"
+#include "vtbl.h"
+#include "io.h"
+#include "volmgmt.h"
+#include "misc.h"
+
+static int vol_cdev_open(struct inode *inode, struct file *file);
+static int vol_cdev_release(struct inode *inode, struct file *file);
+static loff_t vol_cdev_llseek(struct file *file, loff_t offset, int origin);
+static ssize_t vol_cdev_read(struct file *file, __user char *buf,
+			     size_t count, loff_t * offp);
+static ssize_t vol_cdev_write(struct file *file, const char __user *buf,
+			      size_t count, loff_t *offp);
+static int vol_cdev_ioctl(struct inode *inode, struct file *file,
+			  unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_MTD_UBI_USERSPACE_IO
+static ssize_t vol_cdev_direct_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *offp);
+#else
+#define vol_cdev_direct_write(file, buf, count, offp) -EROFS
+#endif
+
+/* Volume character device operations */
+static struct file_operations vol_cdev_operations = {
+	.owner   = THIS_MODULE,
+	.open    = vol_cdev_open,
+	.release = vol_cdev_release,
+	.llseek  = vol_cdev_llseek,
+	.read    = vol_cdev_read,
+	.write   = vol_cdev_write,
+	.ioctl   = vol_cdev_ioctl
+};
+
+int ubi_cdev_vol_init(const struct ubi_info *ubi, struct ubi_uif_volume *vol)
+{
+	int err;
+	const struct ubi_uif_info *uif = ubi->uif;
+
+	cdev_init(&vol->cdev, &vol_cdev_operations);
+	vol->cdev.owner = THIS_MODULE;
+	err = cdev_add(&vol->cdev, MKDEV(uif->major, vol->vol_id + 1), 1);
+	if (err) {
+		ubi_err("cannot add char dev for volume %d", vol->vol_id);
+		goto out;
+	}
+
+	return 0;
+out:
+	cdev_del(&vol->cdev);
+	return err;
+}
+
+void ubi_cdev_vol_close(struct ubi_uif_volume *vol)
+{
+	cdev_del(&vol->cdev);
+}
+
+static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
+			  unsigned int cmd, unsigned long arg);
+
+/* UBI character device operations */
+static struct file_operations ubi_cdev_operations = {
+	.owner = THIS_MODULE,
+	.ioctl = ubi_cdev_ioctl,
+	.llseek = no_llseek
+};
+
+int ubi_cdev_init(struct ubi_info *ubi)
+{
+	int err;
+	dev_t dev;
+	struct ubi_uif_info *uif = ubi->uif;
+	const struct ubi_acc_info *acc = ubi->acc;
+
+	/*
+	 * Major numbers for the UBI character devices are allocated
+	 * dynamically. Major numbers of volume character devices are
+	 * equivalent to ones of the corresponding UBI character device. Minor
+	 * numbers of UBI character devices are 0, while minor numbers of
+	 * volume character devices start from 1. Thus, we allocate one major
+	 * number and acc->max_volumes + 1 minor numbers.
+	 */
+	err = alloc_chrdev_region(&dev, 0, acc->max_volumes + 1, uif->ubi_name);
+	if (err) {
+		ubi_err("cannot register UBI char devs");
+		return err;
+	}
+
+	cdev_init(&uif->cdev, &ubi_cdev_operations);
+	uif->major = MAJOR(dev);
+	uif->cdev.owner = THIS_MODULE;
+
+	dev = MKDEV(uif->major, 0);
+	err = cdev_add(&uif->cdev, dev, 1);
+	if (err) {
+		ubi_err("cannot add char dev %s", uif->ubi_name);
+		goto out_unreg;
+	}
+
+	dbg_cdev("%s major:minor is %u:0", uif->ubi_name, uif->major);
+	return 0;
+
+out_unreg:
+	unregister_chrdev_region(MKDEV(uif->major, 0), acc->max_volumes + 1);
+	return err;
+
+}
+
+void ubi_cdev_close(const struct ubi_info *ubi)
+{
+	struct ubi_uif_info *uif = ubi->uif;
+	const struct ubi_acc_info *acc = ubi->acc;
+
+	cdev_del(&uif->cdev);
+	unregister_chrdev_region(MKDEV(uif->major, 0), acc->max_volumes + 1);
+}
+
+static struct ubi_info *major2ubi_info(int major);
+
+/**
+ * vol_cdev_open - open method of volume character devices.
+ *
+ * @inode: inode of the volume character device
+ * @file: &struct file object of the volume character device
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int vol_cdev_open(struct inode *inode, struct file *file)
+{
+	struct ubi_vol_desc *desc;
+	const struct ubi_info *ubi = major2ubi_info(imajor(inode));
+	int vol_id = iminor(inode) - 1;
+	int mode;
+
+	if (file->f_mode & FMODE_WRITE)
+		mode = UBI_READWRITE;
+	else
+		mode = UBI_READONLY;
+
+	dbg_cdev("open volume %d, mode %d", vol_id, mode);
+
+	desc = ubi_open_volume(ubi->ubi_num, vol_id, mode);
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+
+	file->private_data = desc;
+	return 0;
+}
+
+/**
+ * vol_cdev_release - release method of volume character devices.
+ *
+ * @inode: inode of the volume character device
+ * @file: &struct file object of the volume character device
+ */
+static int vol_cdev_release(struct inode *inode, struct file *file)
+{
+	int err = 0;
+	struct ubi_vol_desc *desc = file->private_data;
+	struct ubi_uif_volume *vol = desc->vol;
+
+	dbg_cdev("release volume %d, mode %d", vol->vol_id, desc->mode);
+
+	if (vol->updating) {
+		ubi_warn("update of volume %d was not finished", vol->vol_id);
+		err = ubi_upd_abort(vol->ubi, vol->vol_id);
+		vol->updating = 0;
+	}
+
+	ubi_close_volume(desc);
+	return err;
+}
+
+/**
+ * vol_cdev_llseek - llseek method of volume character devices.
+ *
+ * @file: &struct file object of the volume character device
+ * @offset: file offset
+ * @origin: defines the starting point of the @offset
+ *
+ * If an update is in progress, seeking is prohibited. This function returns
+ * positive offset in case of success and a negative error code in case of
+ * failure.
+ */
+static loff_t vol_cdev_llseek(struct file *file, loff_t offset, int origin)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_vol_desc *desc = file->private_data;
+	const struct ubi_info *ubi = desc->vol->ubi;
+	struct ubi_uif_volume *vol = desc->vol;
+	loff_t new_offset;
+
+	dbg_cdev("seek volume %d, offset %lld, origin %d",
+		 vol->vol_id, offset, origin);
+
+	if (vol->updating) {
+		dbg_cdev("updating");
+		return -EBUSY;
+	}
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol->vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	switch (origin) {
+	case 0: /* SEEK_SET */
+		new_offset = offset;
+		break;
+	case 1: /* SEEK_CUR */
+		new_offset = file->f_pos + offset;
+		break;
+	case 2: /* SEEK_END */
+		new_offset = vtr->used_bytes + offset;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (new_offset < 0 || new_offset > vtr->used_bytes) {
+		dbg_err("bad seek (%lld)", new_offset);
+		return -EINVAL;
+	}
+
+	dbg_cdev("set volume %d offset at %lld", vol->vol_id, new_offset);
+	file->f_pos = new_offset;
+	return new_offset;
+}
+
+/**
+ * vol_cdev_read - read method of volume character devices
+ *
+ * @file: &struct file object of volume character device
+ * @buf: user-space buffer where to put read data
+ * @count: how many bytes to read
+ * @offp: the read position
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static ssize_t vol_cdev_read(struct file *file, __user char *buf,
+			     size_t count, loff_t * offp)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_vol_desc *desc = file->private_data;
+	struct ubi_uif_volume *vol = desc->vol;
+	const struct ubi_info *ubi = vol->ubi;
+	const struct ubi_io_info *io = ubi->io;
+	int err, lnum, off, len, tbuf_size, vol_id = desc->vol->vol_id;
+	size_t count_save = count;
+	void *tbuf;
+	uint64_t tmp;
+
+	dbg_cdev("request: read %zd bytes from offset %lld of volume %u",
+		 count, *offp, vol_id);
+
+	if (unlikely(count == 0))
+		return 0;
+
+	if (vol->updating) {
+		dbg_err("updating");
+		return -EBUSY;
+	}
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(*offp >= 0 && *offp <= vtr->used_bytes);
+
+	if (vtr->upd_marker) {
+		dbg_err("damaged volume, update marker is set");
+		return -EBADF;
+	}
+
+	if (*offp == vtr->used_bytes)
+		return 0;
+
+	if (unlikely(vtr->corrupted))
+		dbg_err("read from corrupted volume %d", vol_id);
+
+	if (*offp + count > vtr->used_bytes)
+		count_save = count = vtr->used_bytes - *offp;
+
+	/*
+	 * To optimize reading, we read in fractions of the minimum
+	 * input/output units of the flash.
+	 */
+	tbuf_size = (PAGE_SIZE / io->min_io_size) * io->min_io_size;
+	if (tbuf_size == 0)
+		tbuf_size = io->min_io_size;
+	if (tbuf_size > io->leb_size)
+		tbuf_size = io->leb_size;
+
+	tbuf = ubi_kmalloc(tbuf_size);
+	if (!tbuf)
+		return -ENOMEM;
+
+	/*
+	 * We read in portions of the minimal flash input/output unit. If we are
+	 * requested to read form a non-aligned offset, we first read up to the
+	 * nearest boundary, and later only read in units of 'tbuf_size'.
+	 */
+	if (count > tbuf_size) {
+		int rem;
+
+		tmp = *offp;
+		rem = do_div(tmp, io->min_io_size);
+		if (rem == 0)
+			len = tbuf_size;
+		else
+			len = io->min_io_size - rem;
+	} else
+		len = count;
+
+	tmp = *offp;
+	off = do_div(tmp, vtr->usable_leb_size);
+	lnum = tmp;
+
+	do {
+		cond_resched();
+
+		if (off + len >= vtr->usable_leb_size)
+			len = vtr->usable_leb_size - off;
+
+		err = ubi_eba_read_leb(ubi, vol_id, lnum, tbuf, off, len, 0);
+		if (unlikely(err))
+			break;
+
+		off += len;
+		if (off == vtr->usable_leb_size) {
+			lnum += 1;
+			off -= vtr->usable_leb_size;
+		}
+
+		count -= len;
+		*offp += len;
+
+		err = copy_to_user(buf, tbuf, len);
+		if (unlikely(err)) {
+			dbg_err("memory access error");
+			break;
+		}
+
+		buf += len;
+		len = count > tbuf_size ? tbuf_size : count;
+	} while (count);
+
+	ubi_kfree(tbuf);
+	return err ? err : count_save - count;
+}
+
+/**
+ * vol_cdev_write - write method of volume character devices
+ *
+ * @file: &struct file object of volume character device
+ * @buf: user-space buffer with the data to write
+ * @count: how many bytes to write
+ * @offp: the write position
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static ssize_t vol_cdev_write(struct file *file, const char __user *buf,
+			      size_t count, loff_t *offp)
+{
+	int err = 0;
+	struct ubi_vol_desc *desc = file->private_data;
+	struct ubi_uif_volume *vol = desc->vol;
+	const struct ubi_info *ubi = vol->ubi;
+
+	dbg_cdev("requested: write %zd bytes to offset %lld of volume %u",
+		 count, *offp, vol->vol_id);
+
+	if (!vol->updating)
+		return vol_cdev_direct_write(file, buf, count, offp);
+
+	err = ubi_upd_write_data(ubi, vol->vol_id, buf, count);
+	if (err < 0) {
+		dbg_err("cannot write %zd bytes of update data", count);
+		return err;
+	}
+
+	if (err) {
+		/* Update is finished */
+		vol->updating = 0;
+
+		err = ubi_check_volume(ubi, vol->vol_id);
+		if (err < 0)
+			return err;
+
+		if (err == 1) {
+			ubi_warn("volume %d on UBI device %d is corrupted",
+				 vol->vol_id, ubi->ubi_num);
+			err = ubi_vtbl_set_corrupted(ubi, vol->vol_id);
+			if (err)
+				return err;
+		}
+		vol->checked = 1;
+	}
+
+	*offp += count;
+	return count;
+}
+
+/**
+ * vol_cdev_ioctl - ioctl method of volume character devices.
+ *
+ * @inode: inode of the volume character device
+ * @file: &struct file object of the volume character device
+ * @cmd: ioctl command
+ * @arg: ioctl arguments
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int vol_cdev_ioctl(struct inode *inode, struct file *file,
+			  unsigned int cmd, unsigned long arg)
+{
+	int err = 0;
+	struct ubi_vol_desc *desc = file->private_data;
+	const struct ubi_info *ubi = desc->vol->ubi;
+	void __user *argp = (void __user *)arg;
+
+	if (_IOC_NR(cmd) > VOL_CDEV_IOC_MAX_SEQ ||
+	    _IOC_TYPE(cmd) != UBI_VOL_IOC_MAGIC) {
+		dbg_err("bad ioctl command");
+		return -ENOTTY;
+	}
+
+	if (_IOC_DIR(cmd) && _IOC_READ)
+		err = !access_ok(VERIFY_WRITE, argp, _IOC_SIZE(cmd));
+	else if (_IOC_DIR(cmd) && _IOC_WRITE)
+		err = !access_ok(VERIFY_READ, argp, _IOC_SIZE(cmd));
+	if (err) {
+		dbg_err("memory access error");
+		return -EFAULT;
+	}
+
+	switch (cmd) {
+
+	/* Volume update command */
+	case UBI_IOCVOLUP:
+	{
+		int64_t bytes, rsvd_bytes;
+		const struct ubi_vtbl_vtr *vtr;
+
+		if (!capable(CAP_SYS_RESOURCE)) {
+			dbg_err("no rights");
+			err = -EPERM;
+			break;
+		}
+
+		err = copy_from_user(&bytes, argp, sizeof(int64_t));
+		if (err) {
+			dbg_err("memory access error");
+			err = -EFAULT;
+			break;
+		}
+
+		dbg_cdev("update volume %u, %lld bytes",
+			 desc->vol->vol_id, (long long)bytes);
+
+		if (desc->mode == UBI_READONLY) {
+			dbg_err("read-only mode");
+			err = -EROFS;
+			break;
+		}
+
+		vtr = ubi_vtbl_get_vtr(ubi, desc->vol->vol_id);
+		rsvd_bytes = vtr->reserved_pebs *
+				(ubi->io->leb_size - vtr->data_pad);
+		if (bytes < 0 || bytes > rsvd_bytes) {
+			dbg_err("bad data size %lld", (long long)bytes);
+			err = -EINVAL;
+			break;
+		}
+
+		desc->vol->updating = 1;
+		err = ubi_upd_start(ubi, desc->vol->vol_id, bytes);
+		if (bytes == 0)
+			/* It was just volume truncation */
+			desc->vol->updating = 0;
+		file->f_pos = 0;
+		break;
+	}
+
+#ifdef CONFIG_MTD_UBI_USERSPACE_IO
+	/* An eraseblock erasure command */
+	case UBI_IOCEBER:
+	{
+		int32_t lnum;
+		const struct ubi_vtbl_vtr *vtr;
+
+		err = __get_user(lnum, (__user int32_t *)argp);
+		if (err) {
+			dbg_err("memory access error");
+			err = -EFAULT;
+			break;
+		}
+
+		if (desc->mode == UBI_READONLY) {
+			dbg_err("read-only mode");
+			err = -EROFS;
+			break;
+		}
+
+		vtr = ubi_vtbl_get_vtr(ubi, desc->vol->vol_id);
+		ubi_assert(!IS_ERR(vtr));
+		if (lnum < 0 || lnum >= vtr->reserved_pebs) {
+			dbg_err("bad lnum %d", lnum);
+			err = -EINVAL;
+			break;
+		}
+
+		if (vtr->vol_type != UBI_DYNAMIC_VOLUME) {
+			dbg_err("static volume");
+			err = -EROFS;
+			break;
+		}
+
+		dbg_cdev("erase LEB %d:%d", desc->vol->vol_id, lnum);
+		err = ubi_eba_erase_leb(ubi, desc->vol->vol_id, lnum);
+		break;
+	}
+#endif
+
+	default:
+		err = -ENOTTY;
+		break;
+	}
+
+	return err;
+}
+
+static int check_mkvol_req(const struct ubi_info *ubi,
+			   const struct ubi_mkvol_req *req);
+
+static int check_rsvol_req(const struct ubi_info *ubi,
+			   const struct ubi_rsvol_req *req);
+
+/**
+ * ubi_cdev_ioctl - ioctl method of UBI character devices.
+ *
+ * @inode: inode of the UBI character device
+ * @file: &struct file object of the UBI character device
+ * @cmd: ioctl command
+ * @arg: ioctl arguments
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int ubi_cdev_ioctl(struct inode *inode, struct file *file,
+			  unsigned int cmd, unsigned long arg)
+{
+	int err = 0;
+	const struct ubi_info *ubi;
+	void __user *argp = (void __user *)arg;
+
+	if (_IOC_NR(cmd) > UBI_CDEV_IOC_MAX_SEQ ||
+	    _IOC_TYPE(cmd) != UBI_IOC_MAGIC) {
+		dbg_err("bad ioctl command");
+		return -ENOTTY;
+	}
+
+	if (_IOC_DIR(cmd) && _IOC_READ)
+		err = !access_ok(VERIFY_WRITE, argp, _IOC_SIZE(cmd));
+	else if (_IOC_DIR(cmd) && _IOC_WRITE)
+		err = !access_ok(VERIFY_READ, argp, _IOC_SIZE(cmd));
+	if (err)
+		return -EFAULT;
+
+	if (!capable(CAP_SYS_RESOURCE)) {
+		dbg_err("no rights");
+		return -EPERM;
+	}
+
+	ubi = major2ubi_info(imajor(inode));
+	if (IS_ERR(ubi))
+		return PTR_ERR(ubi);
+
+	switch (cmd) {
+
+	/* Create volume command */
+	case UBI_IOCMKVOL:
+	{
+		char *name;
+		struct ubi_vtbl_vtr vtr;
+		struct ubi_mkvol_req req;
+		const struct ubi_io_info *io = ubi->io;
+		int pebs;
+
+		err = __copy_from_user(&req, argp,
+				       sizeof(struct ubi_mkvol_req));
+		if (err) {
+			err = -EFAULT;
+			break;
+		}
+
+		/* Make sure that user passed us sane data */
+		pebs = check_mkvol_req(ubi, &req);
+		if (pebs < 0) {
+			err = pebs;
+			break;
+		}
+
+		name = ubi_kmalloc(req.name_len + 1);
+		if (!name) {
+			err = -ENOMEM;
+			break;
+		}
+
+		err = copy_from_user(name, req.name, req.name_len + 1);
+		if (err) {
+			err = -EFAULT;
+			goto out_free;
+		}
+
+		vtr.reserved_pebs = pebs;
+		vtr.alignment = req.alignment;
+		vtr.vol_type = req.vol_type;
+		vtr.name_len = req.name_len;
+		vtr.name = name;
+		vtr.data_pad = io->leb_size % vtr.alignment;
+
+		dbg_cdev("create volume ID %d, size %d, type %d, name %s",
+		     req.vol_id, vtr.reserved_pebs, vtr.vol_type,
+		     vtr.name);
+
+		err = ubi_vmt_mkvol(ubi, req.vol_id, &vtr);
+		if (err < 0)
+			goto out_free;
+
+		req.vol_id = err;
+		err = ubi_uif_mkvol(ubi, req.vol_id);
+		if (err)
+			goto out_rmvol;
+
+		ubi_kfree(name);
+
+		err = __copy_to_user(argp, &req,
+				       sizeof(struct ubi_mkvol_req));
+		if (err) {
+			err = -EFAULT;
+			break;
+		}
+
+		break;
+
+out_rmvol:
+		ubi_vmt_rmvol(ubi, req.vol_id);
+out_free:
+		ubi_kfree(name);
+		break;
+	}
+
+	/* Remove volume command */
+	case UBI_IOCRMVOL:
+	{
+		int32_t vol_id;
+		struct ubi_vol_desc *desc;
+
+		err = __get_user(vol_id, (__user int32_t *)argp);
+		if (err) {
+			err = -EFAULT;
+			break;
+		}
+
+		dbg_cdev("remove volume %u", vol_id);
+
+		desc = ubi_open_volume(ubi->ubi_num, vol_id, UBI_EXCLUSIVE);
+		if (IS_ERR(desc)) {
+			err = PTR_ERR(desc);
+			break;
+		}
+
+		err = ubi_uif_close_and_rmvol(desc);
+		if (err) {
+			ubi_close_volume(desc);
+			break;
+		}
+
+		err = ubi_vmt_rmvol(ubi, vol_id);
+		break;
+	}
+
+	/* Re-size volume command */
+	case UBI_IOCRSVOL:
+	{
+		int rem, pebs;
+		uint64_t tmp;
+		const struct ubi_vtbl_vtr *vtr;
+		struct ubi_rsvol_req req;
+		struct ubi_vol_desc *desc;
+
+		err = __copy_from_user(&req, argp,
+				       sizeof(struct ubi_rsvol_req));
+		if (err) {
+			err = -EFAULT;
+			break;
+		}
+
+		/* Make sure that user passed us sane data */
+		err = check_rsvol_req(ubi, &req);
+		if (err)
+			break;
+
+		dbg_cdev("re-size volume %d to size %lld bytes",
+			 req.vol_id, (long long)req.bytes);
+
+		desc = ubi_open_volume(ubi->ubi_num, req.vol_id, UBI_EXCLUSIVE);
+		if (IS_ERR(desc)) {
+			err = PTR_ERR(desc);
+			break;
+		}
+
+		vtr = ubi_vtbl_get_vtr(ubi, req.vol_id);
+		ubi_assert(!IS_ERR(vtr));
+
+		tmp = req.bytes;
+		rem = do_div(tmp, vtr->usable_leb_size);
+		pebs = tmp;
+		if (rem)
+			pebs += 1;
+
+		err = ubi_vmt_rsvol(ubi, req.vol_id, pebs);
+		ubi_close_volume(desc);
+		break;
+	}
+
+	default:
+		err = -ENOTTY;
+		break;
+	}
+
+	return err;
+}
+
+/**
+ * major2ubi_info - find the UBI device description by major number of the
+ * corresponding character device.
+ *
+ * @major: major number
+ *
+ * This function returns a pointer to the UBI description object.
+ */
+static struct ubi_info *major2ubi_info(int major)
+{
+	int i;
+
+	for (i = 0; i < ubis_num; i++)
+		if (ubis[i] && ubis[i]->uif->major == major)
+			return ubis[i];
+
+	BUG();
+	return NULL;
+}
+
+/**
+ * check_mkvol_req - check sanity of a volume creation request.
+ *
+ * @ubi: the UBI device description object
+ * @req: the request to check
+ *
+ * This function returns a positive volume size in eraseblocks if the request
+ * is sane, and %-EINVAL if not.
+ */
+static int check_mkvol_req(const struct ubi_info *ubi,
+			   const struct ubi_mkvol_req *req)
+{
+	int n, err, rem, ebs, usable_leb_size;
+	char *name = NULL;
+	const struct ubi_io_info *io = ubi->io;
+	uint64_t bytes;
+
+	name = ubi_kmalloc(req->name_len + 1);
+	if (!name)
+		return -ENOMEM;
+
+	if (req->bytes < 0 || req->alignment < 0 || req->vol_type < 0 ||
+	    req->name_len < 0) {
+		dbg_err("negative values");
+		goto bad;
+	}
+
+	if ((req->vol_id < 0 || req->vol_id >= ubi->acc->max_volumes) &&
+	    req->vol_id != UBI_VOL_NUM_AUTO) {
+		dbg_err("bad vol_id %d", req->vol_id);
+		goto bad;
+	}
+
+	if (req->alignment == 0) {
+		dbg_err("zero alignment");
+		goto bad;
+	}
+
+	if (req->bytes == 0) {
+		dbg_err("zero bytes");
+		goto bad;
+	}
+
+	if (req->vol_type != UBI_DYNAMIC_VOLUME &&
+	    req->vol_type != UBI_STATIC_VOLUME) {
+		dbg_err("bad vol_type");
+		goto bad;
+	}
+
+	if (req->alignment > io->leb_size) {
+		dbg_err("too large alignment");
+		goto bad;
+	}
+
+	n = req->alignment % io->min_io_size;
+	if (req->alignment != 1 && n) {
+		dbg_err("alignment is not multiple of min I/O unit size");
+		goto bad;
+	}
+
+	if (req->name_len > UBI_VOL_NAME_MAX) {
+		dbg_err("too long volume name, max is %d", UBI_VOL_NAME_MAX);
+		goto bad;
+	}
+
+	if (!req->name) {
+		dbg_err("NULL volume name");
+		goto bad;
+	}
+
+	err = copy_from_user(name, req->name, req->name_len + 1);
+	if (err)
+		return err;
+
+	n = strnlen(name, req->name_len + 1);
+	if (n != req->name_len) {
+		dbg_err("bad name_len");
+		goto bad;
+	}
+
+	ubi_kfree(name);
+
+	/* Calculate how many eraseblocks are requested */
+	usable_leb_size = io->leb_size - io->leb_size % req->alignment;
+	bytes = req->bytes;
+	rem = do_div(bytes, usable_leb_size);
+	ebs = bytes;
+	if (rem)
+		ebs += 1;
+
+	return ebs;
+
+bad:
+	dbg_err("bad volume creation request");
+	ubi_dbg_dump_mkvol_req(req, name);
+	ubi_kfree(name);
+	return -EINVAL;
+}
+
+/**
+ * check_rsvol_req - check sanity of a volume re-size request.
+ *
+ * @ubi: the UBI device description object
+ * @req: the re-size request to check
+ *
+ * This function returns zero if the request is sane, and %-EINVAL if not.
+ */
+static int check_rsvol_req(const struct ubi_info *ubi,
+			   const struct ubi_rsvol_req *req)
+{
+	if (req->bytes <= 0) {
+		dbg_err("bad bytes %lld", (long long)req->bytes);
+		return -EINVAL;
+	}
+
+	if (req->vol_id < 0 || req->vol_id >= ubi->acc->max_volumes) {
+		dbg_err("bad vol_id %d", req->vol_id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_MTD_UBI_USERSPACE_IO
+
+/**
+ * vol_cdev_direct_write - write to volume character devices directly (nothing
+ * to do with O_DIRECT!).
+ *
+ * @file: &struct file object of volume character device
+ * @buf: user-space buffer with the data to write
+ * @count: how many bytes to write
+ * @offp: the write position
+ *
+ * This function allows to directly write to dynamic UBI volumes, without
+ * issuing the volume update operation. This function returns zero in case of
+ * success and a negative error code in case of failure.
+ */
+static ssize_t vol_cdev_direct_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *offp)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_vol_desc *desc = file->private_data;
+	struct ubi_uif_volume *vol = desc->vol;
+	const struct ubi_info *ubi = vol->ubi;
+	const struct ubi_io_info *io = ubi->io;
+	int lnum, off, len, tbuf_size, vol_id = vol->vol_id, err = 0;
+	size_t count_save = count;
+	char *tbuf;
+	uint64_t tmp;
+
+	dbg_cdev("requested: write %zd bytes to offset %lld of volume %u",
+		 count, *offp, desc->vol->vol_id);
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(!vol->updating);
+	ubi_assert(*offp >= 0 && *offp <= vtr->used_bytes);
+
+	if (vtr->vol_type == UBI_STATIC_VOLUME) {
+		dbg_err("static volume");
+		return -EROFS;
+	}
+
+	tmp = *offp;
+	off = do_div(tmp, vtr->usable_leb_size);
+	lnum = tmp;
+
+	if (off % io->min_io_size) {
+		dbg_err("unaligned position");
+		return -EIO;
+	}
+
+	if (*offp + count > vtr->used_bytes)
+		count_save = count = vtr->used_bytes - *offp;
+
+	/*
+	 * We can only write in fractions of the minimum input/output unit of
+	 * the flash.
+	 */
+	if (count % io->min_io_size) {
+		dbg_err("unaligned write length");
+		return -EINVAL;
+	}
+
+	tbuf_size = (PAGE_SIZE / io->min_io_size) * io->min_io_size;
+	if (tbuf_size == 0)
+		tbuf_size = io->min_io_size;
+	if (tbuf_size > io->leb_size)
+		tbuf_size = io->leb_size;
+
+	tbuf = ubi_kmalloc(tbuf_size);
+	if (!tbuf)
+		return -ENOMEM;
+
+	len = count > tbuf_size ? tbuf_size : count;
+
+	while (count) {
+		cond_resched();
+
+		if (off + len >= vtr->usable_leb_size)
+			len = vtr->usable_leb_size - off;
+
+		dbg_cdev("copy %d bytes of user data", len);
+		err = copy_from_user(tbuf, buf, len);
+		if (err) {
+			dbg_err("memory access error");
+			err = -EFAULT;
+			break;
+		}
+
+		dbg_cdev("write %d bytes to LEB %d:%d, offset %d",
+			 len, vol_id, lnum, off);
+
+		err = ubi_eba_write_leb(ubi, vol_id, lnum, tbuf, off, len,
+					UBI_DATA_UNKNOWN);
+		if (unlikely(err))
+			break;
+
+		off += len;
+		if (off == vtr->usable_leb_size) {
+			lnum += 1;
+			off -= vtr->usable_leb_size;
+		}
+
+		count -= len;
+		*offp += len;
+		buf += len;
+		len = count > tbuf_size ? tbuf_size : count;
+	}
+
+	ubi_kfree(tbuf);
+	return err ? err : count_save - count;
+}
+
+#endif /* CONFIG_MTD_UBI_USERSPACE_IO */
