Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbXJFSbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbXJFSbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764951AbXJFSa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:30:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:61090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764932AbXJFSax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:30:53 -0400
Message-Id: <20071006182343.527564445@arndb.de>
References: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:09 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 7/9] compat_ioctl: move floppy handlers to block/compat_ioctl.c
Content-Disposition: inline; filename=compat-floppy-ioctl.diff
X-Provags-ID: V01U2FsdGVkX1+yEKnbPOoIvyVqC2etTCjIXSeH9srUU3HSlxT
 w7c1q0xiB6ADB51kHj1uZkef7bb0lppkaO9cyJH9o17S7eZ3UY
 Tk81x/l/xbwXP9qTbCPDw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The floppy ioctls are used by multiple drivers, so they should be
handled in a shared location. Also, add minor cleanups.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- linux-2.6.orig/block/compat_ioctl.c
+++ linux-2.6/block/compat_ioctl.c
@@ -203,6 +203,332 @@ static int compat_blkpg_ioctl(struct ino
 #define BLKBSZSET_32		_IOW(0x12, 113, int)
 #define BLKGETSIZE64_32		_IOR(0x12, 114, int)
 
+struct compat_floppy_struct {
+	compat_uint_t	size;
+	compat_uint_t	sect;
+	compat_uint_t	head;
+	compat_uint_t	track;
+	compat_uint_t	stretch;
+	unsigned char	gap;
+	unsigned char	rate;
+	unsigned char	spec1;
+	unsigned char	fmt_gap;
+	const compat_caddr_t name;
+};
+
+struct compat_floppy_drive_params {
+	char		cmos;
+	compat_ulong_t	max_dtr;
+	compat_ulong_t	hlt;
+	compat_ulong_t	hut;
+	compat_ulong_t	srt;
+	compat_ulong_t	spinup;
+	compat_ulong_t	spindown;
+	unsigned char	spindown_offset;
+	unsigned char	select_delay;
+	unsigned char	rps;
+	unsigned char	tracks;
+	compat_ulong_t	timeout;
+	unsigned char	interleave_sect;
+	struct floppy_max_errors max_errors;
+	char		flags;
+	char		read_track;
+	short		autodetect[8];
+	compat_int_t	checkfreq;
+	compat_int_t	native_format;
+};
+
+struct compat_floppy_drive_struct {
+	signed char	flags;
+	compat_ulong_t	spinup_date;
+	compat_ulong_t	select_date;
+	compat_ulong_t	first_read_date;
+	short		probed_format;
+	short		track;
+	short		maxblock;
+	short		maxtrack;
+	compat_int_t	generation;
+	compat_int_t	keep_data;
+	compat_int_t	fd_ref;
+	compat_int_t	fd_device;
+	compat_int_t	last_checked;
+	compat_caddr_t dmabuf;
+	compat_int_t	bufblocks;
+};
+
+struct compat_floppy_fdc_state {
+	compat_int_t	spec1;
+	compat_int_t	spec2;
+	compat_int_t	dtr;
+	unsigned char	version;
+	unsigned char	dor;
+	compat_ulong_t	address;
+	unsigned int	rawcmd:2;
+	unsigned int	reset:1;
+	unsigned int	need_configure:1;
+	unsigned int	perp_mode:2;
+	unsigned int	has_fifo:1;
+	unsigned int	driver_version;
+	unsigned char	track[4];
+};
+
+struct compat_floppy_write_errors {
+	unsigned int	write_errors;
+	compat_ulong_t	first_error_sector;
+	compat_int_t	first_error_generation;
+	compat_ulong_t	last_error_sector;
+	compat_int_t	last_error_generation;
+	compat_uint_t	badness;
+};
+
+#define FDSETPRM32 _IOW(2, 0x42, struct compat_floppy_struct)
+#define FDDEFPRM32 _IOW(2, 0x43, struct compat_floppy_struct)
+#define FDGETPRM32 _IOR(2, 0x04, struct compat_floppy_struct)
+#define FDSETDRVPRM32 _IOW(2, 0x90, struct compat_floppy_drive_params)
+#define FDGETDRVPRM32 _IOR(2, 0x11, struct compat_floppy_drive_params)
+#define FDGETDRVSTAT32 _IOR(2, 0x12, struct compat_floppy_drive_struct)
+#define FDPOLLDRVSTAT32 _IOR(2, 0x13, struct compat_floppy_drive_struct)
+#define FDGETFDCSTAT32 _IOR(2, 0x15, struct compat_floppy_fdc_state)
+#define FDWERRORGET32  _IOR(2, 0x17, struct compat_floppy_write_errors)
+
+static struct {
+	unsigned int	cmd32;
+	unsigned int	cmd;
+} fd_ioctl_trans_table[] = {
+	{ FDSETPRM32, FDSETPRM },
+	{ FDDEFPRM32, FDDEFPRM },
+	{ FDGETPRM32, FDGETPRM },
+	{ FDSETDRVPRM32, FDSETDRVPRM },
+	{ FDGETDRVPRM32, FDGETDRVPRM },
+	{ FDGETDRVSTAT32, FDGETDRVSTAT },
+	{ FDPOLLDRVSTAT32, FDPOLLDRVSTAT },
+	{ FDGETFDCSTAT32, FDGETFDCSTAT },
+	{ FDWERRORGET32, FDWERRORGET }
+};
+
+#define NR_FD_IOCTL_TRANS ARRAY_SIZE(fd_ioctl_trans_table)
+
+static int compat_fd_ioctl(struct inode *inode, struct file *file,
+		struct gendisk *disk, unsigned int cmd, unsigned long arg)
+{
+	mm_segment_t old_fs = get_fs();
+	void *karg = NULL;
+	unsigned int kcmd = 0;
+	int i, err;
+
+	for (i = 0; i < NR_FD_IOCTL_TRANS; i++)
+		if (cmd == fd_ioctl_trans_table[i].cmd32) {
+			kcmd = fd_ioctl_trans_table[i].cmd;
+			break;
+		}
+	if (!kcmd)
+		return -EINVAL;
+
+	switch (cmd) {
+	case FDSETPRM32:
+	case FDDEFPRM32:
+	case FDGETPRM32:
+	{
+		compat_uptr_t name;
+		struct compat_floppy_struct __user *uf;
+		struct floppy_struct *f;
+
+		uf = compat_ptr(arg);
+		f = karg = kmalloc(sizeof(struct floppy_struct), GFP_KERNEL);
+		if (!karg)
+			return -ENOMEM;
+		if (cmd == FDGETPRM32)
+			break;
+		err = __get_user(f->size, &uf->size);
+		err |= __get_user(f->sect, &uf->sect);
+		err |= __get_user(f->head, &uf->head);
+		err |= __get_user(f->track, &uf->track);
+		err |= __get_user(f->stretch, &uf->stretch);
+		err |= __get_user(f->gap, &uf->gap);
+		err |= __get_user(f->rate, &uf->rate);
+		err |= __get_user(f->spec1, &uf->spec1);
+		err |= __get_user(f->fmt_gap, &uf->fmt_gap);
+		err |= __get_user(name, &uf->name);
+		f->name = compat_ptr(name);
+		if (err) {
+			err = -EFAULT;
+			goto out;
+		}
+		break;
+	}
+	case FDSETDRVPRM32:
+	case FDGETDRVPRM32:
+	{
+		struct compat_floppy_drive_params __user *uf;
+		struct floppy_drive_params *f;
+
+		uf = compat_ptr(arg);
+		f = karg = kmalloc(sizeof(struct floppy_drive_params), GFP_KERNEL);
+		if (!karg)
+			return -ENOMEM;
+		if (cmd == FDGETDRVPRM32)
+			break;
+		err = __get_user(f->cmos, &uf->cmos);
+		err |= __get_user(f->max_dtr, &uf->max_dtr);
+		err |= __get_user(f->hlt, &uf->hlt);
+		err |= __get_user(f->hut, &uf->hut);
+		err |= __get_user(f->srt, &uf->srt);
+		err |= __get_user(f->spinup, &uf->spinup);
+		err |= __get_user(f->spindown, &uf->spindown);
+		err |= __get_user(f->spindown_offset, &uf->spindown_offset);
+		err |= __get_user(f->select_delay, &uf->select_delay);
+		err |= __get_user(f->rps, &uf->rps);
+		err |= __get_user(f->tracks, &uf->tracks);
+		err |= __get_user(f->timeout, &uf->timeout);
+		err |= __get_user(f->interleave_sect, &uf->interleave_sect);
+		err |= __copy_from_user(&f->max_errors, &uf->max_errors, sizeof(f->max_errors));
+		err |= __get_user(f->flags, &uf->flags);
+		err |= __get_user(f->read_track, &uf->read_track);
+		err |= __copy_from_user(f->autodetect, uf->autodetect, sizeof(f->autodetect));
+		err |= __get_user(f->checkfreq, &uf->checkfreq);
+		err |= __get_user(f->native_format, &uf->native_format);
+		if (err) {
+			err = -EFAULT;
+			goto out;
+		}
+		break;
+	}
+	case FDGETDRVSTAT32:
+	case FDPOLLDRVSTAT32:
+		karg = kmalloc(sizeof(struct floppy_drive_struct), GFP_KERNEL);
+		if (!karg)
+			return -ENOMEM;
+		break;
+	case FDGETFDCSTAT32:
+		karg = kmalloc(sizeof(struct floppy_fdc_state), GFP_KERNEL);
+		if (!karg)
+			return -ENOMEM;
+		break;
+	case FDWERRORGET32:
+		karg = kmalloc(sizeof(struct floppy_write_errors), GFP_KERNEL);
+		if (!karg)
+			return -ENOMEM;
+		break;
+	default:
+		return -EINVAL;
+	}
+	set_fs(KERNEL_DS);
+	err = blkdev_driver_ioctl(inode, file, disk, kcmd, (unsigned long)karg);
+	set_fs(old_fs);
+	if (err)
+		goto out;
+	switch (cmd) {
+	case FDGETPRM32:
+	{
+		struct floppy_struct *f = karg;
+		struct compat_floppy_struct __user *uf = compat_ptr(arg);
+
+		err = __put_user(f->size, &uf->size);
+		err |= __put_user(f->sect, &uf->sect);
+		err |= __put_user(f->head, &uf->head);
+		err |= __put_user(f->track, &uf->track);
+		err |= __put_user(f->stretch, &uf->stretch);
+		err |= __put_user(f->gap, &uf->gap);
+		err |= __put_user(f->rate, &uf->rate);
+		err |= __put_user(f->spec1, &uf->spec1);
+		err |= __put_user(f->fmt_gap, &uf->fmt_gap);
+		err |= __put_user((u64)f->name, (compat_caddr_t __user *)&uf->name);
+		break;
+	}
+	case FDGETDRVPRM32:
+	{
+		struct compat_floppy_drive_params __user *uf;
+		struct floppy_drive_params *f = karg;
+
+		uf = compat_ptr(arg);
+		err = __put_user(f->cmos, &uf->cmos);
+		err |= __put_user(f->max_dtr, &uf->max_dtr);
+		err |= __put_user(f->hlt, &uf->hlt);
+		err |= __put_user(f->hut, &uf->hut);
+		err |= __put_user(f->srt, &uf->srt);
+		err |= __put_user(f->spinup, &uf->spinup);
+		err |= __put_user(f->spindown, &uf->spindown);
+		err |= __put_user(f->spindown_offset, &uf->spindown_offset);
+		err |= __put_user(f->select_delay, &uf->select_delay);
+		err |= __put_user(f->rps, &uf->rps);
+		err |= __put_user(f->tracks, &uf->tracks);
+		err |= __put_user(f->timeout, &uf->timeout);
+		err |= __put_user(f->interleave_sect, &uf->interleave_sect);
+		err |= __copy_to_user(&uf->max_errors, &f->max_errors, sizeof(f->max_errors));
+		err |= __put_user(f->flags, &uf->flags);
+		err |= __put_user(f->read_track, &uf->read_track);
+		err |= __copy_to_user(uf->autodetect, f->autodetect, sizeof(f->autodetect));
+		err |= __put_user(f->checkfreq, &uf->checkfreq);
+		err |= __put_user(f->native_format, &uf->native_format);
+		break;
+	}
+	case FDGETDRVSTAT32:
+	case FDPOLLDRVSTAT32:
+	{
+		struct compat_floppy_drive_struct __user *uf;
+		struct floppy_drive_struct *f = karg;
+
+		uf = compat_ptr(arg);
+		err = __put_user(f->flags, &uf->flags);
+		err |= __put_user(f->spinup_date, &uf->spinup_date);
+		err |= __put_user(f->select_date, &uf->select_date);
+		err |= __put_user(f->first_read_date, &uf->first_read_date);
+		err |= __put_user(f->probed_format, &uf->probed_format);
+		err |= __put_user(f->track, &uf->track);
+		err |= __put_user(f->maxblock, &uf->maxblock);
+		err |= __put_user(f->maxtrack, &uf->maxtrack);
+		err |= __put_user(f->generation, &uf->generation);
+		err |= __put_user(f->keep_data, &uf->keep_data);
+		err |= __put_user(f->fd_ref, &uf->fd_ref);
+		err |= __put_user(f->fd_device, &uf->fd_device);
+		err |= __put_user(f->last_checked, &uf->last_checked);
+		err |= __put_user((u64)f->dmabuf, &uf->dmabuf);
+		err |= __put_user((u64)f->bufblocks, &uf->bufblocks);
+		break;
+	}
+	case FDGETFDCSTAT32:
+	{
+		struct compat_floppy_fdc_state __user *uf;
+		struct floppy_fdc_state *f = karg;
+
+		uf = compat_ptr(arg);
+		err = __put_user(f->spec1, &uf->spec1);
+		err |= __put_user(f->spec2, &uf->spec2);
+		err |= __put_user(f->dtr, &uf->dtr);
+		err |= __put_user(f->version, &uf->version);
+		err |= __put_user(f->dor, &uf->dor);
+		err |= __put_user(f->address, &uf->address);
+		err |= __copy_to_user((char __user *)&uf->address + sizeof(uf->address),
+				   (char *)&f->address + sizeof(f->address), sizeof(int));
+		err |= __put_user(f->driver_version, &uf->driver_version);
+		err |= __copy_to_user(uf->track, f->track, sizeof(f->track));
+		break;
+	}
+	case FDWERRORGET32:
+	{
+		struct compat_floppy_write_errors __user *uf;
+		struct floppy_write_errors *f = karg;
+
+		uf = compat_ptr(arg);
+		err = __put_user(f->write_errors, &uf->write_errors);
+		err |= __put_user(f->first_error_sector, &uf->first_error_sector);
+		err |= __put_user(f->first_error_generation, &uf->first_error_generation);
+		err |= __put_user(f->last_error_sector, &uf->last_error_sector);
+		err |= __put_user(f->last_error_generation, &uf->last_error_generation);
+		err |= __put_user(f->badness, &uf->badness);
+		break;
+	}
+	default:
+		break;
+	}
+	if (err)
+		err = -EFAULT;
+
+out:
+	kfree(karg);
+	return err;
+}
+
 struct compat_blk_user_trace_setup {
 	char name[32];
 	u16 act_mask;
@@ -268,6 +594,16 @@ static int compat_blkdev_driver_ioctl(st
 	case HDIO_GET_ADDRESS:
 	case HDIO_GET_BUSSTATE:
 		return compat_hdio_ioctl(inode, file, disk, cmd, arg);
+	case FDSETPRM32:
+	case FDDEFPRM32:
+	case FDGETPRM32:
+	case FDSETDRVPRM32:
+	case FDGETDRVPRM32:
+	case FDGETDRVSTAT32:
+	case FDPOLLDRVSTAT32:
+	case FDGETFDCSTAT32:
+	case FDWERRORGET32:
+		return compat_fd_ioctl(inode, file, disk, cmd, arg);
 	case CDROMREADAUDIO:
 		return compat_cdrom_read_audio(inode, file, disk, cmd, arg);
 	case CDROM_SEND_PACKET:
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -32,7 +32,6 @@
 #include <linux/vt.h>
 #include <linux/fs.h>
 #include <linux/file.h>
-#include <linux/fd.h>
 #include <linux/ppp_defs.h>
 #include <linux/if_ppp.h>
 #include <linux/if_pppox.h>
@@ -1407,333 +1406,6 @@ static int ioc_settimeout(unsigned int f
 #define HIDPGETCONNLIST	_IOR('H', 210, int)
 #define HIDPGETCONNINFO	_IOR('H', 211, int)
 
-#ifdef CONFIG_BLOCK
-struct floppy_struct32 {
-	compat_uint_t	size;
-	compat_uint_t	sect;
-	compat_uint_t	head;
-	compat_uint_t	track;
-	compat_uint_t	stretch;
-	unsigned char	gap;
-	unsigned char	rate;
-	unsigned char	spec1;
-	unsigned char	fmt_gap;
-	const compat_caddr_t name;
-};
-
-struct floppy_drive_params32 {
-	char		cmos;
-	compat_ulong_t	max_dtr;
-	compat_ulong_t	hlt;
-	compat_ulong_t	hut;
-	compat_ulong_t	srt;
-	compat_ulong_t	spinup;
-	compat_ulong_t	spindown;
-	unsigned char	spindown_offset;
-	unsigned char	select_delay;
-	unsigned char	rps;
-	unsigned char	tracks;
-	compat_ulong_t	timeout;
-	unsigned char	interleave_sect;
-	struct floppy_max_errors max_errors;
-	char		flags;
-	char		read_track;
-	short		autodetect[8];
-	compat_int_t	checkfreq;
-	compat_int_t	native_format;
-};
-
-struct floppy_drive_struct32 {
-	signed char	flags;
-	compat_ulong_t	spinup_date;
-	compat_ulong_t	select_date;
-	compat_ulong_t	first_read_date;
-	short		probed_format;
-	short		track;
-	short		maxblock;
-	short		maxtrack;
-	compat_int_t	generation;
-	compat_int_t	keep_data;
-	compat_int_t	fd_ref;
-	compat_int_t	fd_device;
-	compat_int_t	last_checked;
-	compat_caddr_t dmabuf;
-	compat_int_t	bufblocks;
-};
-
-struct floppy_fdc_state32 {
-	compat_int_t	spec1;
-	compat_int_t	spec2;
-	compat_int_t	dtr;
-	unsigned char	version;
-	unsigned char	dor;
-	compat_ulong_t	address;
-	unsigned int	rawcmd:2;
-	unsigned int	reset:1;
-	unsigned int	need_configure:1;
-	unsigned int	perp_mode:2;
-	unsigned int	has_fifo:1;
-	unsigned int	driver_version;
-	unsigned char	track[4];
-};
-
-struct floppy_write_errors32 {
-	unsigned int	write_errors;
-	compat_ulong_t	first_error_sector;
-	compat_int_t	first_error_generation;
-	compat_ulong_t	last_error_sector;
-	compat_int_t	last_error_generation;
-	compat_uint_t	badness;
-};
-
-#define FDSETPRM32 _IOW(2, 0x42, struct floppy_struct32)
-#define FDDEFPRM32 _IOW(2, 0x43, struct floppy_struct32)
-#define FDGETPRM32 _IOR(2, 0x04, struct floppy_struct32)
-#define FDSETDRVPRM32 _IOW(2, 0x90, struct floppy_drive_params32)
-#define FDGETDRVPRM32 _IOR(2, 0x11, struct floppy_drive_params32)
-#define FDGETDRVSTAT32 _IOR(2, 0x12, struct floppy_drive_struct32)
-#define FDPOLLDRVSTAT32 _IOR(2, 0x13, struct floppy_drive_struct32)
-#define FDGETFDCSTAT32 _IOR(2, 0x15, struct floppy_fdc_state32)
-#define FDWERRORGET32  _IOR(2, 0x17, struct floppy_write_errors32)
-
-static struct {
-	unsigned int	cmd32;
-	unsigned int	cmd;
-} fd_ioctl_trans_table[] = {
-	{ FDSETPRM32, FDSETPRM },
-	{ FDDEFPRM32, FDDEFPRM },
-	{ FDGETPRM32, FDGETPRM },
-	{ FDSETDRVPRM32, FDSETDRVPRM },
-	{ FDGETDRVPRM32, FDGETDRVPRM },
-	{ FDGETDRVSTAT32, FDGETDRVSTAT },
-	{ FDPOLLDRVSTAT32, FDPOLLDRVSTAT },
-	{ FDGETFDCSTAT32, FDGETFDCSTAT },
-	{ FDWERRORGET32, FDWERRORGET }
-};
-
-#define NR_FD_IOCTL_TRANS ARRAY_SIZE(fd_ioctl_trans_table)
-
-static int fd_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	mm_segment_t old_fs = get_fs();
-	void *karg = NULL;
-	unsigned int kcmd = 0;
-	int i, err;
-
-	for (i = 0; i < NR_FD_IOCTL_TRANS; i++)
-		if (cmd == fd_ioctl_trans_table[i].cmd32) {
-			kcmd = fd_ioctl_trans_table[i].cmd;
-			break;
-		}
-	if (!kcmd)
-		return -EINVAL;
-
-	switch (cmd) {
-		case FDSETPRM32:
-		case FDDEFPRM32:
-		case FDGETPRM32:
-		{
-			compat_uptr_t name;
-			struct floppy_struct32 __user *uf;
-			struct floppy_struct *f;
-
-			uf = compat_ptr(arg);
-			f = karg = kmalloc(sizeof(struct floppy_struct), GFP_KERNEL);
-			if (!karg)
-				return -ENOMEM;
-			if (cmd == FDGETPRM32)
-				break;
-			err = __get_user(f->size, &uf->size);
-			err |= __get_user(f->sect, &uf->sect);
-			err |= __get_user(f->head, &uf->head);
-			err |= __get_user(f->track, &uf->track);
-			err |= __get_user(f->stretch, &uf->stretch);
-			err |= __get_user(f->gap, &uf->gap);
-			err |= __get_user(f->rate, &uf->rate);
-			err |= __get_user(f->spec1, &uf->spec1);
-			err |= __get_user(f->fmt_gap, &uf->fmt_gap);
-			err |= __get_user(name, &uf->name);
-			f->name = compat_ptr(name);
-			if (err) {
-				err = -EFAULT;
-				goto out;
-			}
-			break;
-		}
-		case FDSETDRVPRM32:
-		case FDGETDRVPRM32:
-		{
-			struct floppy_drive_params32 __user *uf;
-			struct floppy_drive_params *f;
-
-			uf = compat_ptr(arg);
-			f = karg = kmalloc(sizeof(struct floppy_drive_params), GFP_KERNEL);
-			if (!karg)
-				return -ENOMEM;
-			if (cmd == FDGETDRVPRM32)
-				break;
-			err = __get_user(f->cmos, &uf->cmos);
-			err |= __get_user(f->max_dtr, &uf->max_dtr);
-			err |= __get_user(f->hlt, &uf->hlt);
-			err |= __get_user(f->hut, &uf->hut);
-			err |= __get_user(f->srt, &uf->srt);
-			err |= __get_user(f->spinup, &uf->spinup);
-			err |= __get_user(f->spindown, &uf->spindown);
-			err |= __get_user(f->spindown_offset, &uf->spindown_offset);
-			err |= __get_user(f->select_delay, &uf->select_delay);
-			err |= __get_user(f->rps, &uf->rps);
-			err |= __get_user(f->tracks, &uf->tracks);
-			err |= __get_user(f->timeout, &uf->timeout);
-			err |= __get_user(f->interleave_sect, &uf->interleave_sect);
-			err |= __copy_from_user(&f->max_errors, &uf->max_errors, sizeof(f->max_errors));
-			err |= __get_user(f->flags, &uf->flags);
-			err |= __get_user(f->read_track, &uf->read_track);
-			err |= __copy_from_user(f->autodetect, uf->autodetect, sizeof(f->autodetect));
-			err |= __get_user(f->checkfreq, &uf->checkfreq);
-			err |= __get_user(f->native_format, &uf->native_format);
-			if (err) {
-				err = -EFAULT;
-				goto out;
-			}
-			break;
-		}
-		case FDGETDRVSTAT32:
-		case FDPOLLDRVSTAT32:
-			karg = kmalloc(sizeof(struct floppy_drive_struct), GFP_KERNEL);
-			if (!karg)
-				return -ENOMEM;
-			break;
-		case FDGETFDCSTAT32:
-			karg = kmalloc(sizeof(struct floppy_fdc_state), GFP_KERNEL);
-			if (!karg)
-				return -ENOMEM;
-			break;
-		case FDWERRORGET32:
-			karg = kmalloc(sizeof(struct floppy_write_errors), GFP_KERNEL);
-			if (!karg)
-				return -ENOMEM;
-			break;
-		default:
-			return -EINVAL;
-	}
-	set_fs (KERNEL_DS);
-	err = sys_ioctl (fd, kcmd, (unsigned long)karg);
-	set_fs (old_fs);
-	if (err)
-		goto out;
-	switch (cmd) {
-		case FDGETPRM32:
-		{
-			struct floppy_struct *f = karg;
-			struct floppy_struct32 __user *uf = compat_ptr(arg);
-
-			err = __put_user(f->size, &uf->size);
-			err |= __put_user(f->sect, &uf->sect);
-			err |= __put_user(f->head, &uf->head);
-			err |= __put_user(f->track, &uf->track);
-			err |= __put_user(f->stretch, &uf->stretch);
-			err |= __put_user(f->gap, &uf->gap);
-			err |= __put_user(f->rate, &uf->rate);
-			err |= __put_user(f->spec1, &uf->spec1);
-			err |= __put_user(f->fmt_gap, &uf->fmt_gap);
-			err |= __put_user((u64)f->name, (compat_caddr_t __user *)&uf->name);
-			break;
-		}
-		case FDGETDRVPRM32:
-		{
-			struct floppy_drive_params32 __user *uf;
-			struct floppy_drive_params *f = karg;
-
-			uf = compat_ptr(arg);
-			err = __put_user(f->cmos, &uf->cmos);
-			err |= __put_user(f->max_dtr, &uf->max_dtr);
-			err |= __put_user(f->hlt, &uf->hlt);
-			err |= __put_user(f->hut, &uf->hut);
-			err |= __put_user(f->srt, &uf->srt);
-			err |= __put_user(f->spinup, &uf->spinup);
-			err |= __put_user(f->spindown, &uf->spindown);
-			err |= __put_user(f->spindown_offset, &uf->spindown_offset);
-			err |= __put_user(f->select_delay, &uf->select_delay);
-			err |= __put_user(f->rps, &uf->rps);
-			err |= __put_user(f->tracks, &uf->tracks);
-			err |= __put_user(f->timeout, &uf->timeout);
-			err |= __put_user(f->interleave_sect, &uf->interleave_sect);
-			err |= __copy_to_user(&uf->max_errors, &f->max_errors, sizeof(f->max_errors));
-			err |= __put_user(f->flags, &uf->flags);
-			err |= __put_user(f->read_track, &uf->read_track);
-			err |= __copy_to_user(uf->autodetect, f->autodetect, sizeof(f->autodetect));
-			err |= __put_user(f->checkfreq, &uf->checkfreq);
-			err |= __put_user(f->native_format, &uf->native_format);
-			break;
-		}
-		case FDGETDRVSTAT32:
-		case FDPOLLDRVSTAT32:
-		{
-			struct floppy_drive_struct32 __user *uf;
-			struct floppy_drive_struct *f = karg;
-
-			uf = compat_ptr(arg);
-			err = __put_user(f->flags, &uf->flags);
-			err |= __put_user(f->spinup_date, &uf->spinup_date);
-			err |= __put_user(f->select_date, &uf->select_date);
-			err |= __put_user(f->first_read_date, &uf->first_read_date);
-			err |= __put_user(f->probed_format, &uf->probed_format);
-			err |= __put_user(f->track, &uf->track);
-			err |= __put_user(f->maxblock, &uf->maxblock);
-			err |= __put_user(f->maxtrack, &uf->maxtrack);
-			err |= __put_user(f->generation, &uf->generation);
-			err |= __put_user(f->keep_data, &uf->keep_data);
-			err |= __put_user(f->fd_ref, &uf->fd_ref);
-			err |= __put_user(f->fd_device, &uf->fd_device);
-			err |= __put_user(f->last_checked, &uf->last_checked);
-			err |= __put_user((u64)f->dmabuf, &uf->dmabuf);
-			err |= __put_user((u64)f->bufblocks, &uf->bufblocks);
-			break;
-		}
-		case FDGETFDCSTAT32:
-		{
-			struct floppy_fdc_state32 __user *uf;
-			struct floppy_fdc_state *f = karg;
-
-			uf = compat_ptr(arg);
-			err = __put_user(f->spec1, &uf->spec1);
-			err |= __put_user(f->spec2, &uf->spec2);
-			err |= __put_user(f->dtr, &uf->dtr);
-			err |= __put_user(f->version, &uf->version);
-			err |= __put_user(f->dor, &uf->dor);
-			err |= __put_user(f->address, &uf->address);
-			err |= __copy_to_user((char __user *)&uf->address + sizeof(uf->address),
-					   (char *)&f->address + sizeof(f->address), sizeof(int));
-			err |= __put_user(f->driver_version, &uf->driver_version);
-			err |= __copy_to_user(uf->track, f->track, sizeof(f->track));
-			break;
-		}
-		case FDWERRORGET32:
-		{
-			struct floppy_write_errors32 __user *uf;
-			struct floppy_write_errors *f = karg;
-
-			uf = compat_ptr(arg);
-			err = __put_user(f->write_errors, &uf->write_errors);
-			err |= __put_user(f->first_error_sector, &uf->first_error_sector);
-			err |= __put_user(f->first_error_generation, &uf->first_error_generation);
-			err |= __put_user(f->last_error_sector, &uf->last_error_sector);
-			err |= __put_user(f->last_error_generation, &uf->last_error_generation);
-			err |= __put_user(f->badness, &uf->badness);
-			break;
-		}
-		default:
-			break;
-	}
-	if (err)
-		err = -EFAULT;
-
-out:
-	kfree(karg);
-	return err;
-}
-#endif
-
 struct mtd_oob_buf32 {
 	u_int32_t start;
 	u_int32_t length;
@@ -3025,15 +2697,6 @@ HANDLE_IOCTL(SIOCGSTAMP, do_siocgstamp)
 HANDLE_IOCTL(SIOCGSTAMPNS, do_siocgstampns)
 #endif
 #ifdef CONFIG_BLOCK
-HANDLE_IOCTL(FDSETPRM32, fd_ioctl_trans)
-HANDLE_IOCTL(FDDEFPRM32, fd_ioctl_trans)
-HANDLE_IOCTL(FDGETPRM32, fd_ioctl_trans)
-HANDLE_IOCTL(FDSETDRVPRM32, fd_ioctl_trans)
-HANDLE_IOCTL(FDGETDRVPRM32, fd_ioctl_trans)
-HANDLE_IOCTL(FDGETDRVSTAT32, fd_ioctl_trans)
-HANDLE_IOCTL(FDPOLLDRVSTAT32, fd_ioctl_trans)
-HANDLE_IOCTL(FDGETFDCSTAT32, fd_ioctl_trans)
-HANDLE_IOCTL(FDWERRORGET32, fd_ioctl_trans)
 HANDLE_IOCTL(SG_IO,sg_ioctl_trans)
 HANDLE_IOCTL(SG_GET_REQUEST_TABLE, sg_grt_trans)
 #endif

-- 

