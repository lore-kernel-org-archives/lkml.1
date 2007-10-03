Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXJCWtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXJCWtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 18:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbXJCWtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 18:49:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:51896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXJCWtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 18:49:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Date: Thu, 4 Oct 2007 00:48:20 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
References: <20071002073943.GC5236@kernel.dk> <20071002092856.GG5236@kernel.dk> <200710031755.21068.arnd@arndb.de>
In-Reply-To: <200710031755.21068.arnd@arndb.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710040048.20676.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+kr0Yo0RxXp+QNDFmI0xOw7d+3Q6SH64xo1cF
 Jf1m1SecjxiGWz5a0QvI3WhYhmPkfimMWgl5Bamny6t0Dhlf4l
 gXHw+uyhGblgSTw4nYy1w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007, Arnd Bergmann wrote:
> Jens, I think the best overall solution would be to have a
> block/compat_ioctl.c file with all the compat handling for block
> devices moved over from fs/compat_ioctl.c, and done in a nicer way.
> If you agree, with this approach, I'd volunteer to come up with a
> patch.

Sometimes I find it hard to stop myself once I have the idea.
The patch below moves all block related ioctl conversion out
of fs/compat_ioctl.c into the compat_blkdev_ioctl() function.

Is that a direction we should be heading towards? If so, I
can do some testing and split this big patch into more
logical units for better review.

I also found a few interesting bugs in the process:
* BLKRASET is both ULONG_IOCTL and COMPATIBLE_IOCTL, but this should
  be entirely harmless
* BLKSECTGET writes 2 bytes normally, our compat_ version writes
  4 bytes!
* FDSETPRM32, FDDEFPRM32 and FDGETPRM32 are doing potentially dangerous
  stuff with kernel pointers. sparse actually warns about this, but
  from what I could see from floppy.c, the kernel always ignores these
  pointers. I did not check any other floppy drivers implementing the
  same calls.

	Arnd <><

Index: linux-2.6/block/Makefile
===================================================================
--- linux-2.6.orig/block/Makefile
+++ linux-2.6/block/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadli
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
+obj-$(CONFIG_COMPAT)		+= compat_ioctl.o
Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- /dev/null
+++ linux-2.6/block/compat_ioctl.c
@@ -0,0 +1,772 @@
+#include <linux/blkdev.h>
+#include <linux/blkpg.h>
+#include <linux/blktrace_api.h>
+#include <linux/cdrom.h>
+#include <linux/compat.h>
+#include <linux/elevator.h>
+#include <linux/fd.h>
+#include <linux/hdreg.h>
+#include <linux/syscalls.h>
+#include <linux/smp_lock.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include <scsi/sg.h>
+
+static int compat_put_ushort(unsigned long arg, unsigned short val)
+{
+	return put_user(val, (unsigned short __user *)compat_ptr(arg));
+}
+
+static int compat_put_int(unsigned long arg, int val)
+{
+	return put_user(val, (compat_int_t __user *)compat_ptr(arg));
+}
+
+static int compat_put_long(unsigned long arg, long val)
+{
+	return put_user(val, (compat_long_t __user *)compat_ptr(arg));
+}
+
+static int compat_put_ulong(unsigned long arg, compat_ulong_t val)
+{
+	return put_user(val, (compat_ulong_t __user *)compat_ptr(arg));
+}
+
+static int compat_put_u64(unsigned long arg, u64 val)
+{
+	return put_user(val, (compat_u64 __user *)compat_ptr(arg));
+}
+
+struct compat_hd_geometry {
+	unsigned char heads;
+	unsigned char sectors;
+	unsigned short cylinders;
+	u32 start;
+};
+
+static int compat_hdio_getgeo(struct gendisk *disk, struct block_device *bdev,
+			struct compat_hd_geometry __user *ugeo)
+{
+	struct hd_geometry geo;
+	int ret;
+
+	if (!ugeo)
+		return -EINVAL;
+	if (!disk->fops->getgeo)
+		return -ENOTTY;
+
+	/*
+	 * We need to set the startsect first, the driver may
+	 * want to override it.
+	 */
+	geo.start = get_start_sect(bdev);
+	ret = disk->fops->getgeo(bdev, &geo);
+	if (ret)
+		return ret;
+
+	ret = copy_to_user(ugeo, &geo, 4);
+	ret |= __put_user(geo.start, &ugeo->start);
+	if (ret)
+		ret = -EFAULT;
+
+	return ret;
+}
+
+static int compat_hdio_ioctl(struct inode *inode, struct file *file,
+		struct gendisk *disk, unsigned int cmd, unsigned long arg)
+{
+	mm_segment_t old_fs = get_fs();
+	unsigned long kval;
+	unsigned int __user *uvp;
+	int error;
+
+	set_fs(KERNEL_DS);
+	error = blkdev_driver_ioctl(inode, file, disk,
+				cmd, (unsigned long)(&kval));
+	set_fs(old_fs);
+
+	if (error == 0) {
+		uvp = compat_ptr(arg);
+		if(put_user(kval, uvp))
+			error = -EFAULT;
+	}
+	return error;
+}
+
+struct cdrom_read_audio32 {
+	union cdrom_addr	addr;
+	u8			addr_format;
+	compat_int_t		nframes;
+	compat_caddr_t		buf;
+};
+
+struct cdrom_generic_command32 {
+	unsigned char	cmd[CDROM_PACKET_SIZE];
+	compat_caddr_t	buffer;
+	compat_uint_t	buflen;
+	compat_int_t	stat;
+	compat_caddr_t	sense;
+	unsigned char	data_direction;
+	compat_int_t	quiet;
+	compat_int_t	timeout;
+	compat_caddr_t	reserved[1];
+};
+
+static int cdrom_do_read_audio(struct inode *inode, struct file *file,
+		struct gendisk *disk, unsigned int cmd, unsigned long arg)
+{
+	struct cdrom_read_audio __user *cdread_audio;
+	struct cdrom_read_audio32 __user *cdread_audio32;
+	__u32 data;
+	void __user *datap;
+
+	cdread_audio = compat_alloc_user_space(sizeof(*cdread_audio));
+	cdread_audio32 = compat_ptr(arg);
+
+	if (copy_in_user(&cdread_audio->addr,
+			 &cdread_audio32->addr,
+			 (sizeof(*cdread_audio32) -
+			  sizeof(compat_caddr_t))))
+		return -EFAULT;
+
+	if (get_user(data, &cdread_audio32->buf))
+		return -EFAULT;
+	datap = compat_ptr(data);
+	if (put_user(datap, &cdread_audio->buf))
+		return -EFAULT;
+
+	return blkdev_driver_ioctl(inode, file, disk, cmd,
+			(unsigned long)cdread_audio);
+}
+
+static int cdrom_do_generic_command(struct inode *inode, struct file *file,
+		struct gendisk *disk, unsigned int cmd, unsigned long arg)
+{
+	struct cdrom_generic_command __user *cgc;
+	struct cdrom_generic_command32 __user *cgc32;
+	u32 data;
+	unsigned char dir;
+	int itmp;
+
+	cgc = compat_alloc_user_space(sizeof(*cgc));
+	cgc32 = compat_ptr(arg);
+
+	if (copy_in_user(&cgc->cmd, &cgc32->cmd, sizeof(cgc->cmd)) ||
+	    get_user(data, &cgc32->buffer) ||
+	    put_user(compat_ptr(data), &cgc->buffer) ||
+	    copy_in_user(&cgc->buflen, &cgc32->buflen,
+			 (sizeof(unsigned int) + sizeof(int))) ||
+	    get_user(data, &cgc32->sense) ||
+	    put_user(compat_ptr(data), &cgc->sense) ||
+	    get_user(dir, &cgc32->data_direction) ||
+	    put_user(dir, &cgc->data_direction) ||
+	    get_user(itmp, &cgc32->quiet) ||
+	    put_user(itmp, &cgc->quiet) ||
+	    get_user(itmp, &cgc32->timeout) ||
+	    put_user(itmp, &cgc->timeout) ||
+	    get_user(data, &cgc32->reserved[0]) ||
+	    put_user(compat_ptr(data), &cgc->reserved[0]))
+		return -EFAULT;
+
+	return blkdev_driver_ioctl(inode, file, disk, cmd, (unsigned long)cgc);
+}
+
+struct compat_blkpg_ioctl_arg {
+	compat_int_t op;
+	compat_int_t flags;
+	compat_int_t datalen;
+	compat_caddr_t data;
+};
+
+static int compat_blkpg_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, struct compat_blkpg_ioctl_arg __user *ua32)
+{
+	struct blkpg_ioctl_arg __user *a = compat_alloc_user_space(sizeof(*a));
+	compat_caddr_t udata;
+	compat_int_t n;
+	int err;
+
+	err = get_user(n, &ua32->op);
+	err |= put_user(n, &a->op);
+	err |= get_user(n, &ua32->flags);
+	err |= put_user(n, &a->flags);
+	err |= get_user(n, &ua32->datalen);
+	err |= put_user(n, &a->datalen);
+	err |= get_user(udata, &ua32->data);
+	err |= put_user(compat_ptr(udata), &a->data);
+	if (err)
+		return err;
+
+	return blkdev_ioctl(inode, file, cmd, (unsigned long)a);
+}
+
+/* Fix sizeof(sizeof()) breakage */
+#define BLKBSZGET_32   _IOR(0x12,112,int)
+#define BLKBSZSET_32   _IOW(0x12,113,int)
+#define BLKGETSIZE64_32        _IOR(0x12,114,int)
+
+struct floppy_struct32 {
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
+struct floppy_drive_params32 {
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
+struct floppy_drive_struct32 {
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
+struct floppy_fdc_state32 {
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
+struct floppy_write_errors32 {
+	unsigned int	write_errors;
+	compat_ulong_t	first_error_sector;
+	compat_int_t	first_error_generation;
+	compat_ulong_t	last_error_sector;
+	compat_int_t	last_error_generation;
+	compat_uint_t	badness;
+};
+
+#define FDSETPRM32 _IOW(2, 0x42, struct floppy_struct32)
+#define FDDEFPRM32 _IOW(2, 0x43, struct floppy_struct32)
+#define FDGETPRM32 _IOR(2, 0x04, struct floppy_struct32)
+#define FDSETDRVPRM32 _IOW(2, 0x90, struct floppy_drive_params32)
+#define FDGETDRVPRM32 _IOR(2, 0x11, struct floppy_drive_params32)
+#define FDGETDRVSTAT32 _IOR(2, 0x12, struct floppy_drive_struct32)
+#define FDPOLLDRVSTAT32 _IOR(2, 0x13, struct floppy_drive_struct32)
+#define FDGETFDCSTAT32 _IOR(2, 0x15, struct floppy_fdc_state32)
+#define FDWERRORGET32  _IOR(2, 0x17, struct floppy_write_errors32)
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
+		case FDSETPRM32:
+		case FDDEFPRM32:
+		case FDGETPRM32:
+		{
+			compat_uptr_t name;
+			struct floppy_struct32 __user *uf;
+			struct floppy_struct *f;
+
+			uf = compat_ptr(arg);
+			f = karg = kmalloc(sizeof(struct floppy_struct), GFP_KERNEL);
+			if (!karg)
+				return -ENOMEM;
+			if (cmd == FDGETPRM32)
+				break;
+			err = __get_user(f->size, &uf->size);
+			err |= __get_user(f->sect, &uf->sect);
+			err |= __get_user(f->head, &uf->head);
+			err |= __get_user(f->track, &uf->track);
+			err |= __get_user(f->stretch, &uf->stretch);
+			err |= __get_user(f->gap, &uf->gap);
+			err |= __get_user(f->rate, &uf->rate);
+			err |= __get_user(f->spec1, &uf->spec1);
+			err |= __get_user(f->fmt_gap, &uf->fmt_gap);
+			err |= __get_user(name, &uf->name);
+			f->name = compat_ptr(name);
+			if (err) {
+				err = -EFAULT;
+				goto out;
+			}
+			break;
+		}
+		case FDSETDRVPRM32:
+		case FDGETDRVPRM32:
+		{
+			struct floppy_drive_params32 __user *uf;
+			struct floppy_drive_params *f;
+
+			uf = compat_ptr(arg);
+			f = karg = kmalloc(sizeof(struct floppy_drive_params), GFP_KERNEL);
+			if (!karg)
+				return -ENOMEM;
+			if (cmd == FDGETDRVPRM32)
+				break;
+			err = __get_user(f->cmos, &uf->cmos);
+			err |= __get_user(f->max_dtr, &uf->max_dtr);
+			err |= __get_user(f->hlt, &uf->hlt);
+			err |= __get_user(f->hut, &uf->hut);
+			err |= __get_user(f->srt, &uf->srt);
+			err |= __get_user(f->spinup, &uf->spinup);
+			err |= __get_user(f->spindown, &uf->spindown);
+			err |= __get_user(f->spindown_offset, &uf->spindown_offset);
+			err |= __get_user(f->select_delay, &uf->select_delay);
+			err |= __get_user(f->rps, &uf->rps);
+			err |= __get_user(f->tracks, &uf->tracks);
+			err |= __get_user(f->timeout, &uf->timeout);
+			err |= __get_user(f->interleave_sect, &uf->interleave_sect);
+			err |= __copy_from_user(&f->max_errors, &uf->max_errors, sizeof(f->max_errors));
+			err |= __get_user(f->flags, &uf->flags);
+			err |= __get_user(f->read_track, &uf->read_track);
+			err |= __copy_from_user(f->autodetect, uf->autodetect, sizeof(f->autodetect));
+			err |= __get_user(f->checkfreq, &uf->checkfreq);
+			err |= __get_user(f->native_format, &uf->native_format);
+			if (err) {
+				err = -EFAULT;
+				goto out;
+			}
+			break;
+		}
+		case FDGETDRVSTAT32:
+		case FDPOLLDRVSTAT32:
+			karg = kmalloc(sizeof(struct floppy_drive_struct), GFP_KERNEL);
+			if (!karg)
+				return -ENOMEM;
+			break;
+		case FDGETFDCSTAT32:
+			karg = kmalloc(sizeof(struct floppy_fdc_state), GFP_KERNEL);
+			if (!karg)
+				return -ENOMEM;
+			break;
+		case FDWERRORGET32:
+			karg = kmalloc(sizeof(struct floppy_write_errors), GFP_KERNEL);
+			if (!karg)
+				return -ENOMEM;
+			break;
+		default:
+			return -EINVAL;
+	}
+	set_fs (KERNEL_DS);
+	err = blkdev_driver_ioctl(inode, file, disk, kcmd, (unsigned long)karg);
+	set_fs (old_fs);
+	if (err)
+		goto out;
+	switch (cmd) {
+		case FDGETPRM32:
+		{
+			struct floppy_struct *f = karg;
+			struct floppy_struct32 __user *uf = compat_ptr(arg);
+
+			err = __put_user(f->size, &uf->size);
+			err |= __put_user(f->sect, &uf->sect);
+			err |= __put_user(f->head, &uf->head);
+			err |= __put_user(f->track, &uf->track);
+			err |= __put_user(f->stretch, &uf->stretch);
+			err |= __put_user(f->gap, &uf->gap);
+			err |= __put_user(f->rate, &uf->rate);
+			err |= __put_user(f->spec1, &uf->spec1);
+			err |= __put_user(f->fmt_gap, &uf->fmt_gap);
+			err |= __put_user((u64)f->name, (compat_caddr_t __user *)&uf->name);
+			break;
+		}
+		case FDGETDRVPRM32:
+		{
+			struct floppy_drive_params32 __user *uf;
+			struct floppy_drive_params *f = karg;
+
+			uf = compat_ptr(arg);
+			err = __put_user(f->cmos, &uf->cmos);
+			err |= __put_user(f->max_dtr, &uf->max_dtr);
+			err |= __put_user(f->hlt, &uf->hlt);
+			err |= __put_user(f->hut, &uf->hut);
+			err |= __put_user(f->srt, &uf->srt);
+			err |= __put_user(f->spinup, &uf->spinup);
+			err |= __put_user(f->spindown, &uf->spindown);
+			err |= __put_user(f->spindown_offset, &uf->spindown_offset);
+			err |= __put_user(f->select_delay, &uf->select_delay);
+			err |= __put_user(f->rps, &uf->rps);
+			err |= __put_user(f->tracks, &uf->tracks);
+			err |= __put_user(f->timeout, &uf->timeout);
+			err |= __put_user(f->interleave_sect, &uf->interleave_sect);
+			err |= __copy_to_user(&uf->max_errors, &f->max_errors, sizeof(f->max_errors));
+			err |= __put_user(f->flags, &uf->flags);
+			err |= __put_user(f->read_track, &uf->read_track);
+			err |= __copy_to_user(uf->autodetect, f->autodetect, sizeof(f->autodetect));
+			err |= __put_user(f->checkfreq, &uf->checkfreq);
+			err |= __put_user(f->native_format, &uf->native_format);
+			break;
+		}
+		case FDGETDRVSTAT32:
+		case FDPOLLDRVSTAT32:
+		{
+			struct floppy_drive_struct32 __user *uf;
+			struct floppy_drive_struct *f = karg;
+
+			uf = compat_ptr(arg);
+			err = __put_user(f->flags, &uf->flags);
+			err |= __put_user(f->spinup_date, &uf->spinup_date);
+			err |= __put_user(f->select_date, &uf->select_date);
+			err |= __put_user(f->first_read_date, &uf->first_read_date);
+			err |= __put_user(f->probed_format, &uf->probed_format);
+			err |= __put_user(f->track, &uf->track);
+			err |= __put_user(f->maxblock, &uf->maxblock);
+			err |= __put_user(f->maxtrack, &uf->maxtrack);
+			err |= __put_user(f->generation, &uf->generation);
+			err |= __put_user(f->keep_data, &uf->keep_data);
+			err |= __put_user(f->fd_ref, &uf->fd_ref);
+			err |= __put_user(f->fd_device, &uf->fd_device);
+			err |= __put_user(f->last_checked, &uf->last_checked);
+			err |= __put_user((u64)f->dmabuf, &uf->dmabuf);
+			err |= __put_user((u64)f->bufblocks, &uf->bufblocks);
+			break;
+		}
+		case FDGETFDCSTAT32:
+		{
+			struct floppy_fdc_state32 __user *uf;
+			struct floppy_fdc_state *f = karg;
+
+			uf = compat_ptr(arg);
+			err = __put_user(f->spec1, &uf->spec1);
+			err |= __put_user(f->spec2, &uf->spec2);
+			err |= __put_user(f->dtr, &uf->dtr);
+			err |= __put_user(f->version, &uf->version);
+			err |= __put_user(f->dor, &uf->dor);
+			err |= __put_user(f->address, &uf->address);
+			err |= __copy_to_user((char __user *)&uf->address + sizeof(uf->address),
+					   (char *)&f->address + sizeof(f->address), sizeof(int));
+			err |= __put_user(f->driver_version, &uf->driver_version);
+			err |= __copy_to_user(uf->track, f->track, sizeof(f->track));
+			break;
+		}
+		case FDWERRORGET32:
+		{
+			struct floppy_write_errors32 __user *uf;
+			struct floppy_write_errors *f = karg;
+
+			uf = compat_ptr(arg);
+			err = __put_user(f->write_errors, &uf->write_errors);
+			err |= __put_user(f->first_error_sector, &uf->first_error_sector);
+			err |= __put_user(f->first_error_generation, &uf->first_error_generation);
+			err |= __put_user(f->last_error_sector, &uf->last_error_sector);
+			err |= __put_user(f->last_error_generation, &uf->last_error_generation);
+			err |= __put_user(f->badness, &uf->badness);
+			break;
+		}
+		default:
+			break;
+	}
+	if (err)
+		err = -EFAULT;
+
+out:
+	kfree(karg);
+	return err;
+}
+
+static int compat_blkdev_driver_ioctl(struct inode *inode, struct file *file,
+			struct gendisk *disk, unsigned cmd, unsigned long arg)
+{
+	int ret;
+
+	switch (arg) {
+	case HDIO_GET_UNMASKINTR:
+	case HDIO_GET_MULTCOUNT:
+	case HDIO_GET_KEEPSETTINGS:
+	case HDIO_GET_32BIT:
+	case HDIO_GET_NOWERR:
+	case HDIO_GET_DMA:
+	case HDIO_GET_NICE:
+	case HDIO_GET_WCACHE:
+	case HDIO_GET_ACOUSTIC:
+	case HDIO_GET_ADDRESS:
+	case HDIO_GET_BUSSTATE:
+		return compat_hdio_ioctl(inode, file, disk, cmd, arg);
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
+	case CDROMREADAUDIO:
+		return cdrom_do_read_audio(inode, file, disk, cmd, arg);
+	case CDROM_SEND_PACKET:
+		return cdrom_do_generic_command(inode, file, disk, cmd, arg);
+
+	/*
+	 * No handler required for the ones below, we just need to
+	 * convert arg to a 64 bit pointer.
+	 */
+	case BLKSECTSET:
+	/*
+	 * 0x03 -- HD/IDE ioctl's used by hdparm and friends.
+	 *         Some need translations, these do not.
+	 */
+	case HDIO_GET_IDENTITY:
+	case HDIO_DRIVE_TASK:
+	case HDIO_DRIVE_CMD:
+	case HDIO_SCAN_HWIF:
+	/* 0x330 is reserved -- it used to be HDIO_GETGEO_BIG */
+	case 0x330:
+	/* 0x02 -- Floppy ioctls */
+	case FDMSGON:
+	case FDMSGOFF:
+	case FDSETEMSGTRESH:
+	case FDFLUSH:
+	case FDWERRORCLR:
+	case FDSETMAXERRS:
+	case FDGETMAXERRS:
+	case FDGETDRVTYP:
+	case FDEJECT:
+	case FDCLRPRM:
+	case FDFMTBEG:
+	case FDFMTEND:
+	case FDRESET:
+	case FDTWADDLE:
+	case FDFMTTRK:
+	case FDRAWCMD:
+	/* CDROM stuff */
+	case CDROMPAUSE:
+	case CDROMRESUME:
+	case CDROMPLAYMSF:
+	case CDROMPLAYTRKIND:
+	case CDROMREADTOCHDR:
+	case CDROMREADTOCENTRY:
+	case CDROMSTOP:
+	case CDROMSTART:
+	case CDROMEJECT:
+	case CDROMVOLCTRL:
+	case CDROMSUBCHNL:
+	case CDROMMULTISESSION:
+	case CDROM_GET_MCN:
+	case CDROMRESET:
+	case CDROMVOLREAD:
+	case CDROMSEEK:
+	case CDROMPLAYBLK:
+	case CDROMCLOSETRAY:
+	case CDROM_DISC_STATUS:
+	case CDROM_CHANGER_NSLOTS:
+	case CDROM_GET_CAPABILITY:
+	/* Ignore cdrom.h about these next 5 ioctls, they absolutely do
+	 * not take a struct cdrom_read, instead they take a struct cdrom_msf
+	 * which is compatible.
+	 */
+	case CDROMREADMODE2:
+	case CDROMREADMODE1:
+	case CDROMREADRAW:
+	case CDROMREADCOOKED:
+	case CDROMREADALL:
+	/* DVD ioctls */
+	case DVD_READ_STRUCT:
+	case DVD_WRITE_STRUCT:
+	case DVD_AUTH:
+		arg = (unsigned long)compat_ptr(arg);
+	/* These intepret arg as an unsigned long, not as a pointer,
+	 * so we must not do compat_ptr() conversion. */
+	case HDIO_SET_MULTCOUNT:
+	case HDIO_SET_UNMASKINTR:
+	case HDIO_SET_KEEPSETTINGS:
+	case HDIO_SET_32BIT:
+	case HDIO_SET_NOWERR:
+	case HDIO_SET_DMA:
+	case HDIO_SET_PIO_MODE:
+	case HDIO_SET_NICE:
+	case HDIO_SET_WCACHE:
+	case HDIO_SET_ACOUSTIC:
+	case HDIO_SET_BUSSTATE:
+	case HDIO_SET_ADDRESS:
+	case CDROMEJECT_SW:
+	case CDROM_SET_OPTIONS:
+	case CDROM_CLEAR_OPTIONS:
+	case CDROM_SELECT_SPEED:
+	case CDROM_SELECT_DISC:
+	case CDROM_MEDIA_CHANGED:
+	case CDROM_DRIVE_STATUS:
+	case CDROM_LOCKDOOR:
+	case CDROM_DEBUG:
+		break;
+	default:
+		/* unknown ioctl number */
+		return -ENOIOCTLCMD;
+	}
+
+	if (disk->fops->unlocked_ioctl)
+		return disk->fops->unlocked_ioctl(file, cmd, arg);
+
+	if (disk->fops->ioctl) {
+		lock_kernel();
+		ret = disk->fops->ioctl(inode, file, cmd, arg);
+		unlock_kernel();
+		return ret;
+	}
+
+	return -ENOTTY;
+}
+
+static int compat_blkdev_locked_ioctl(struct inode *inode, struct file *file,
+				struct block_device *bdev,
+				unsigned cmd, unsigned long arg)
+{
+	struct backing_dev_info *bdi;
+
+	switch (cmd) {
+	case BLKRAGET:
+	case BLKFRAGET:
+		if (!arg)
+			return -EINVAL;
+		bdi = blk_get_backing_dev_info(bdev);
+		if (bdi == NULL)
+			return -ENOTTY;
+		return compat_put_long(arg, (bdi->ra_pages * PAGE_CACHE_SIZE) / 512);
+	case BLKROGET: /* compatible */
+		return compat_put_int(arg, bdev_read_only(bdev) != 0);
+	case BLKBSZGET_32: /* get the logical block size (cf. BLKSSZGET) */
+		return compat_put_int(arg, block_size(bdev));
+	case BLKSSZGET: /* get block device hardware sector size */
+		return compat_put_int(arg, bdev_hardsect_size(bdev));
+	case BLKSECTGET:
+		return compat_put_ushort(arg, bdev_get_queue(bdev)->max_sectors);
+	case BLKRASET: /* compatible, but no compat_ptr (!) */
+	case BLKFRASET:
+		if(!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		bdi = blk_get_backing_dev_info(bdev);
+		if (bdi == NULL)
+			return -ENOTTY;
+		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
+		return 0;
+	/* The mkswap binary hard codes it to Intel value :-((( */
+	case 0x1260:
+	case BLKGETSIZE:
+		if ((bdev->bd_inode->i_size >> 9) > ~0UL)
+			return -EFBIG;
+		return compat_put_ulong(arg, bdev->bd_inode->i_size >> 9);
+
+	case BLKGETSIZE64_32:
+		return compat_put_u64(arg, bdev->bd_inode->i_size);
+
+	case BLKTRACESTART: /* compatible */
+	case BLKTRACESTOP:  /* compatible */
+	case BLKTRACESETUP32:
+	case BLKTRACETEARDOWN: /* compatible */
+		return blk_trace_ioctl(bdev, cmd, compat_ptr(arg));
+	}
+	return -ENOIOCTLCMD;
+}
+
+static int compat_blkdev_driver_ioctl(struct inode *inode, struct file *file,
+			struct gendisk *disk, unsigned cmd, unsigned long arg);
+
+/* Most of the generic ioctls are handled in the normal fallback path.
+   This assumes the blkdev's low level compat_ioctl always returns
+   ENOIOCTLCMD for unknown ioctls. */
+long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+{
+	int ret = -ENOIOCTLCMD;
+	struct inode *inode = file->f_mapping->host;
+	struct block_device *bdev = inode->i_bdev;
+	struct gendisk *disk = bdev->bd_disk;
+
+	switch (cmd) {
+	case HDIO_GETGEO:
+		return compat_hdio_getgeo(disk, bdev, compat_ptr(arg));
+	case BLKFLSBUF:
+	case BLKROSET:
+	/*
+	 * the ones below are implemented in blkdev_locked_ioctl,
+	 * but we call blkdev_ioctl, which gets the lock for us
+	 */
+	case BLKRRPART:
+		return blkdev_ioctl(inode, file, cmd,
+				(unsigned long)compat_ptr(arg));
+	case BLKBSZSET_32:
+		return blkdev_ioctl(inode, file, BLKBSZSET,
+				(unsigned long)compat_ptr(arg));
+	case BLKPG:
+		return compat_blkpg_ioctl(inode, file, cmd, compat_ptr(arg));
+	}
+
+	lock_kernel();
+	ret = compat_blkdev_locked_ioctl(inode, file, bdev, cmd, arg);
+	/* FIXME: why do we assume -> compat_ioctl needs the BKL? */
+	if (ret == -ENOIOCTLCMD && disk->fops->compat_ioctl)
+		ret = disk->fops->compat_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	if (ret != -ENOIOCTLCMD)
+		return ret;
+
+	return compat_blkdev_driver_ioctl(inode, file, disk, cmd, arg);
+}
Index: linux-2.6/block/ioctl.c
===================================================================
--- linux-2.6.orig/block/ioctl.c
+++ linux-2.6/block/ioctl.c
@@ -284,32 +284,4 @@ int blkdev_ioctl(struct inode *inode, st
 
 	return blkdev_driver_ioctl(inode, file, disk, cmd, arg);
 }
-
-/* Most of the generic ioctls are handled in the normal fallback path.
-   This assumes the blkdev's low level compat_ioctl always returns
-   ENOIOCTLCMD for unknown ioctls. */
-long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
-{
-	int ret = -ENOIOCTLCMD;
-#ifdef CONFIG_COMPAT
-	struct block_device *bdev = file->f_path.dentry->d_inode->i_bdev;
-	struct gendisk *disk = bdev->bd_disk;
-
-	switch (cmd) {
-	case BLKTRACESTART:
-	case BLKTRACESTOP:
-	case BLKTRACESETUP32:
-	case BLKTRACETEARDOWN:
-		return blk_trace_ioctl(bdev, cmd, (char __user *) arg);
-	}
-
-	if (disk->fops->compat_ioctl) {
-		lock_kernel();
-		ret = disk->fops->compat_ioctl(file, cmd, arg);
-		unlock_kernel();
-	}
-#endif
-	return ret;
-}
-
 EXPORT_SYMBOL_GPL(blkdev_ioctl);
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -21,7 +21,6 @@
 #include <linux/if.h>
 #include <linux/if_bridge.h>
 #include <linux/slab.h>
-#include <linux/hdreg.h>
 #include <linux/raid/md.h>
 #include <linux/kd.h>
 #include <linux/dirent.h>
@@ -33,12 +32,10 @@
 #include <linux/vt.h>
 #include <linux/fs.h>
 #include <linux/file.h>
-#include <linux/fd.h>
 #include <linux/ppp_defs.h>
 #include <linux/if_ppp.h>
 #include <linux/if_pppox.h>
 #include <linux/mtio.h>
-#include <linux/cdrom.h>
 #include <linux/auto_fs.h>
 #include <linux/auto_fs4.h>
 #include <linux/tty.h>
@@ -48,9 +45,6 @@
 #include <linux/netdevice.h>
 #include <linux/raw.h>
 #include <linux/smb_fs.h>
-#include <linux/blkpg.h>
-#include <linux/blkdev.h>
-#include <linux/elevator.h>
 #include <linux/rtc.h>
 #include <linux/pci.h>
 #include <linux/module.h>
@@ -62,7 +56,6 @@
 #include <linux/i2c-dev.h>
 #include <linux/wireless.h>
 #include <linux/atalk.h>
-#include <linux/blktrace_api.h>
 #include <linux/loop.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -668,53 +661,6 @@ out:
 #endif
 
 #ifdef CONFIG_BLOCK
-struct hd_geometry32 {
-	unsigned char heads;
-	unsigned char sectors;
-	unsigned short cylinders;
-	u32 start;
-};
-                        
-static int hdio_getgeo(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	mm_segment_t old_fs = get_fs();
-	struct hd_geometry geo;
-	struct hd_geometry32 __user *ugeo;
-	int err;
-	
-	set_fs (KERNEL_DS);
-	err = sys_ioctl(fd, HDIO_GETGEO, (unsigned long)&geo);
-	set_fs (old_fs);
-	ugeo = compat_ptr(arg);
-	if (!err) {
-		err = copy_to_user (ugeo, &geo, 4);
-		err |= __put_user (geo.start, &ugeo->start);
-		if (err)
-			err = -EFAULT;
-	}
-	return err;
-}
-
-static int hdio_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	mm_segment_t old_fs = get_fs();
-	unsigned long kval;
-	unsigned int __user *uvp;
-	int error;
-
-	set_fs(KERNEL_DS);
-	error = sys_ioctl(fd, cmd, (long)&kval);
-	set_fs(old_fs);
-
-	if(error == 0) {
-		uvp = compat_ptr(arg);
-		if(put_user(kval, uvp))
-			error = -EFAULT;
-	}
-	return error;
-}
-
-
 typedef struct sg_io_hdr32 {
 	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
 	compat_int_t dxfer_direction;	/* [i] data transfer direction  */
@@ -1017,8 +963,6 @@ static int ppp_ioctl_trans(unsigned int 
 	return err;
 }
 
-
-#ifdef CONFIG_BLOCK
 struct mtget32 {
 	compat_long_t	mt_type;
 	compat_long_t	mt_resid;
@@ -1089,110 +1033,6 @@ static int mt_ioctl_trans(unsigned int f
 	return err ? -EFAULT: 0;
 }
 
-struct cdrom_read_audio32 {
-	union cdrom_addr	addr;
-	u8			addr_format;
-	compat_int_t		nframes;
-	compat_caddr_t		buf;
-};
-
-struct cdrom_generic_command32 {
-	unsigned char	cmd[CDROM_PACKET_SIZE];
-	compat_caddr_t	buffer;
-	compat_uint_t	buflen;
-	compat_int_t	stat;
-	compat_caddr_t	sense;
-	unsigned char	data_direction;
-	compat_int_t	quiet;
-	compat_int_t	timeout;
-	compat_caddr_t	reserved[1];
-};
-  
-static int cdrom_do_read_audio(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	struct cdrom_read_audio __user *cdread_audio;
-	struct cdrom_read_audio32 __user *cdread_audio32;
-	__u32 data;
-	void __user *datap;
-
-	cdread_audio = compat_alloc_user_space(sizeof(*cdread_audio));
-	cdread_audio32 = compat_ptr(arg);
-
-	if (copy_in_user(&cdread_audio->addr,
-			 &cdread_audio32->addr,
-			 (sizeof(*cdread_audio32) -
-			  sizeof(compat_caddr_t))))
-	 	return -EFAULT;
-
-	if (get_user(data, &cdread_audio32->buf))
-		return -EFAULT;
-	datap = compat_ptr(data);
-	if (put_user(datap, &cdread_audio->buf))
-		return -EFAULT;
-
-	return sys_ioctl(fd, cmd, (unsigned long) cdread_audio);
-}
-
-static int cdrom_do_generic_command(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	struct cdrom_generic_command __user *cgc;
-	struct cdrom_generic_command32 __user *cgc32;
-	u32 data;
-	unsigned char dir;
-	int itmp;
-
-	cgc = compat_alloc_user_space(sizeof(*cgc));
-	cgc32 = compat_ptr(arg);
-
-	if (copy_in_user(&cgc->cmd, &cgc32->cmd, sizeof(cgc->cmd)) ||
-	    get_user(data, &cgc32->buffer) ||
-	    put_user(compat_ptr(data), &cgc->buffer) ||
-	    copy_in_user(&cgc->buflen, &cgc32->buflen,
-			 (sizeof(unsigned int) + sizeof(int))) ||
-	    get_user(data, &cgc32->sense) ||
-	    put_user(compat_ptr(data), &cgc->sense) ||
-	    get_user(dir, &cgc32->data_direction) ||
-	    put_user(dir, &cgc->data_direction) ||
-	    get_user(itmp, &cgc32->quiet) ||
-	    put_user(itmp, &cgc->quiet) ||
-	    get_user(itmp, &cgc32->timeout) ||
-	    put_user(itmp, &cgc->timeout) ||
-	    get_user(data, &cgc32->reserved[0]) ||
-	    put_user(compat_ptr(data), &cgc->reserved[0]))
-		return -EFAULT;
-
-	return sys_ioctl(fd, cmd, (unsigned long) cgc);
-}
-
-static int cdrom_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	int err;
-
-	switch(cmd) {
-	case CDROMREADAUDIO:
-		err = cdrom_do_read_audio(fd, cmd, arg);
-		break;
-
-	case CDROM_SEND_PACKET:
-		err = cdrom_do_generic_command(fd, cmd, arg);
-		break;
-
-	default:
-		do {
-			static int count;
-			if (++count <= 20)
-				printk("cdrom_ioctl: Unknown cmd fd(%d) "
-				       "cmd(%08x) arg(%08x)\n",
-				       (int)fd, (unsigned int)cmd, (unsigned int)arg);
-		} while(0);
-		err = -EINVAL;
-		break;
-	};
-
-	return err;
-}
-#endif /* CONFIG_BLOCK */
-
 #ifdef CONFIG_VT
 
 static int vt_check(struct file *file)
@@ -1536,71 +1376,11 @@ ret_einval(unsigned int fd, unsigned int
 	return -EINVAL;
 }
 
-#ifdef CONFIG_BLOCK
-static int broken_blkgetsize(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	/* The mkswap binary hard codes it to Intel value :-((( */
-	return w_long(fd, BLKGETSIZE, arg);
-}
-
-struct blkpg_ioctl_arg32 {
-	compat_int_t op;
-	compat_int_t flags;
-	compat_int_t datalen;
-	compat_caddr_t data;
-};
-
-static int blkpg_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	struct blkpg_ioctl_arg32 __user *ua32 = compat_ptr(arg);
-	struct blkpg_ioctl_arg __user *a = compat_alloc_user_space(sizeof(*a));
-	compat_caddr_t udata;
-	compat_int_t n;
-	int err;
-	
-	err = get_user(n, &ua32->op);
-	err |= put_user(n, &a->op);
-	err |= get_user(n, &ua32->flags);
-	err |= put_user(n, &a->flags);
-	err |= get_user(n, &ua32->datalen);
-	err |= put_user(n, &a->datalen);
-	err |= get_user(udata, &ua32->data);
-	err |= put_user(compat_ptr(udata), &a->data);
-	if (err)
-		return err;
-
-	return sys_ioctl(fd, cmd, (unsigned long)a);
-}
-#endif
-
 static int ioc_settimeout(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	return rw_long(fd, AUTOFS_IOC_SETTIMEOUT, arg);
 }
 
-#ifdef CONFIG_BLOCK
-/* Fix sizeof(sizeof()) breakage */
-#define BLKBSZGET_32   _IOR(0x12,112,int)
-#define BLKBSZSET_32   _IOW(0x12,113,int)
-#define BLKGETSIZE64_32        _IOR(0x12,114,int)
-
-static int do_blkbszget(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-       return sys_ioctl(fd, BLKBSZGET, (unsigned long)compat_ptr(arg));
-}
-
-static int do_blkbszset(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-       return sys_ioctl(fd, BLKBSZSET, (unsigned long)compat_ptr(arg));
-}
-
-static int do_blkgetsize64(unsigned int fd, unsigned int cmd,
-                          unsigned long arg)
-{
-       return sys_ioctl(fd, BLKGETSIZE64, (unsigned long)compat_ptr(arg));
-}
-#endif
-
 /* Bluetooth ioctls */
 #define HCIUARTSETPROTO	_IOW('U', 200, int)
 #define HCIUARTGETPROTO	_IOR('U', 201, int)
@@ -1620,333 +1400,6 @@ static int do_blkgetsize64(unsigned int 
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
@@ -2506,56 +1959,6 @@ COMPATIBLE_IOCTL(FIONREAD)  /* This is a
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
-/* 0x03 -- HD/IDE ioctl's used by hdparm and friends.
- *         Some need translations, these do not.
- */
-COMPATIBLE_IOCTL(HDIO_GET_IDENTITY)
-COMPATIBLE_IOCTL(HDIO_DRIVE_TASK)
-COMPATIBLE_IOCTL(HDIO_DRIVE_CMD)
-ULONG_IOCTL(HDIO_SET_MULTCOUNT)
-ULONG_IOCTL(HDIO_SET_UNMASKINTR)
-ULONG_IOCTL(HDIO_SET_KEEPSETTINGS)
-ULONG_IOCTL(HDIO_SET_32BIT)
-ULONG_IOCTL(HDIO_SET_NOWERR)
-ULONG_IOCTL(HDIO_SET_DMA)
-ULONG_IOCTL(HDIO_SET_PIO_MODE)
-ULONG_IOCTL(HDIO_SET_NICE)
-ULONG_IOCTL(HDIO_SET_WCACHE)
-ULONG_IOCTL(HDIO_SET_ACOUSTIC)
-ULONG_IOCTL(HDIO_SET_BUSSTATE)
-ULONG_IOCTL(HDIO_SET_ADDRESS)
-COMPATIBLE_IOCTL(HDIO_SCAN_HWIF)
-/* 0x330 is reserved -- it used to be HDIO_GETGEO_BIG */
-COMPATIBLE_IOCTL(0x330)
-/* 0x02 -- Floppy ioctls */
-COMPATIBLE_IOCTL(FDMSGON)
-COMPATIBLE_IOCTL(FDMSGOFF)
-COMPATIBLE_IOCTL(FDSETEMSGTRESH)
-COMPATIBLE_IOCTL(FDFLUSH)
-COMPATIBLE_IOCTL(FDWERRORCLR)
-COMPATIBLE_IOCTL(FDSETMAXERRS)
-COMPATIBLE_IOCTL(FDGETMAXERRS)
-COMPATIBLE_IOCTL(FDGETDRVTYP)
-COMPATIBLE_IOCTL(FDEJECT)
-COMPATIBLE_IOCTL(FDCLRPRM)
-COMPATIBLE_IOCTL(FDFMTBEG)
-COMPATIBLE_IOCTL(FDFMTEND)
-COMPATIBLE_IOCTL(FDRESET)
-COMPATIBLE_IOCTL(FDTWADDLE)
-COMPATIBLE_IOCTL(FDFMTTRK)
-COMPATIBLE_IOCTL(FDRAWCMD)
-/* 0x12 */
-#ifdef CONFIG_BLOCK
-COMPATIBLE_IOCTL(BLKRASET)
-COMPATIBLE_IOCTL(BLKROSET)
-COMPATIBLE_IOCTL(BLKROGET)
-COMPATIBLE_IOCTL(BLKRRPART)
-COMPATIBLE_IOCTL(BLKFLSBUF)
-COMPATIBLE_IOCTL(BLKSECTSET)
-COMPATIBLE_IOCTL(BLKSSZGET)
-ULONG_IOCTL(BLKRASET)
-ULONG_IOCTL(BLKFRASET)
-#endif
 /* RAID */
 COMPATIBLE_IOCTL(RAID_VERSION)
 COMPATIBLE_IOCTL(GET_ARRAY_INFO)
@@ -2803,50 +2206,6 @@ COMPATIBLE_IOCTL(PPGETMODE)
 COMPATIBLE_IOCTL(PPGETPHASE)
 COMPATIBLE_IOCTL(PPGETFLAGS)
 COMPATIBLE_IOCTL(PPSETFLAGS)
-/* CDROM stuff */
-COMPATIBLE_IOCTL(CDROMPAUSE)
-COMPATIBLE_IOCTL(CDROMRESUME)
-COMPATIBLE_IOCTL(CDROMPLAYMSF)
-COMPATIBLE_IOCTL(CDROMPLAYTRKIND)
-COMPATIBLE_IOCTL(CDROMREADTOCHDR)
-COMPATIBLE_IOCTL(CDROMREADTOCENTRY)
-COMPATIBLE_IOCTL(CDROMSTOP)
-COMPATIBLE_IOCTL(CDROMSTART)
-COMPATIBLE_IOCTL(CDROMEJECT)
-COMPATIBLE_IOCTL(CDROMVOLCTRL)
-COMPATIBLE_IOCTL(CDROMSUBCHNL)
-ULONG_IOCTL(CDROMEJECT_SW)
-COMPATIBLE_IOCTL(CDROMMULTISESSION)
-COMPATIBLE_IOCTL(CDROM_GET_MCN)
-COMPATIBLE_IOCTL(CDROMRESET)
-COMPATIBLE_IOCTL(CDROMVOLREAD)
-COMPATIBLE_IOCTL(CDROMSEEK)
-COMPATIBLE_IOCTL(CDROMPLAYBLK)
-COMPATIBLE_IOCTL(CDROMCLOSETRAY)
-ULONG_IOCTL(CDROM_SET_OPTIONS)
-ULONG_IOCTL(CDROM_CLEAR_OPTIONS)
-ULONG_IOCTL(CDROM_SELECT_SPEED)
-ULONG_IOCTL(CDROM_SELECT_DISC)
-ULONG_IOCTL(CDROM_MEDIA_CHANGED)
-ULONG_IOCTL(CDROM_DRIVE_STATUS)
-COMPATIBLE_IOCTL(CDROM_DISC_STATUS)
-COMPATIBLE_IOCTL(CDROM_CHANGER_NSLOTS)
-ULONG_IOCTL(CDROM_LOCKDOOR)
-ULONG_IOCTL(CDROM_DEBUG)
-COMPATIBLE_IOCTL(CDROM_GET_CAPABILITY)
-/* Ignore cdrom.h about these next 5 ioctls, they absolutely do
- * not take a struct cdrom_read, instead they take a struct cdrom_msf
- * which is compatible.
- */
-COMPATIBLE_IOCTL(CDROMREADMODE2)
-COMPATIBLE_IOCTL(CDROMREADMODE1)
-COMPATIBLE_IOCTL(CDROMREADRAW)
-COMPATIBLE_IOCTL(CDROMREADCOOKED)
-COMPATIBLE_IOCTL(CDROMREADALL)
-/* DVD ioctls */
-COMPATIBLE_IOCTL(DVD_READ_STRUCT)
-COMPATIBLE_IOCTL(DVD_WRITE_STRUCT)
-COMPATIBLE_IOCTL(DVD_AUTH)
 /* pktcdvd */
 COMPATIBLE_IOCTL(PACKET_CTRL_CMD)
 /* Big A */
@@ -3332,33 +2691,6 @@ HANDLE_IOCTL(SIOCGSTAMP, do_siocgstamp)
 HANDLE_IOCTL(SIOCGSTAMPNS, do_siocgstampns)
 #endif
 #ifdef CONFIG_BLOCK
-HANDLE_IOCTL(HDIO_GETGEO, hdio_getgeo)
-HANDLE_IOCTL(BLKRAGET, w_long)
-HANDLE_IOCTL(BLKGETSIZE, w_long)
-HANDLE_IOCTL(0x1260, broken_blkgetsize)
-HANDLE_IOCTL(BLKFRAGET, w_long)
-HANDLE_IOCTL(BLKSECTGET, w_long)
-HANDLE_IOCTL(BLKPG, blkpg_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_UNMASKINTR, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_MULTCOUNT, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_KEEPSETTINGS, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_32BIT, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_NOWERR, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_DMA, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_NICE, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_WCACHE, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_ACOUSTIC, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_ADDRESS, hdio_ioctl_trans)
-HANDLE_IOCTL(HDIO_GET_BUSSTATE, hdio_ioctl_trans)
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
@@ -3366,12 +2698,8 @@ HANDLE_IOCTL(PPPIOCGIDLE32, ppp_ioctl_tr
 HANDLE_IOCTL(PPPIOCSCOMPRESS32, ppp_ioctl_trans)
 HANDLE_IOCTL(PPPIOCSPASS32, ppp_sock_fprog_ioctl_trans)
 HANDLE_IOCTL(PPPIOCSACTIVE32, ppp_sock_fprog_ioctl_trans)
-#ifdef CONFIG_BLOCK
 HANDLE_IOCTL(MTIOCGET32, mt_ioctl_trans)
 HANDLE_IOCTL(MTIOCPOS32, mt_ioctl_trans)
-HANDLE_IOCTL(CDROMREADAUDIO, cdrom_ioctl_trans)
-HANDLE_IOCTL(CDROM_SEND_PACKET, cdrom_ioctl_trans)
-#endif
 #define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,unsigned int)
 HANDLE_IOCTL(AUTOFS_IOC_SETTIMEOUT32, ioc_settimeout)
 #ifdef CONFIG_VT
@@ -3411,9 +2739,6 @@ HANDLE_IOCTL(SONET_GETFRAMING, do_atm_io
 HANDLE_IOCTL(SONET_GETFRSENSE, do_atm_ioctl)
 /* block stuff */
 #ifdef CONFIG_BLOCK
-HANDLE_IOCTL(BLKBSZGET_32, do_blkbszget)
-HANDLE_IOCTL(BLKBSZSET_32, do_blkbszset)
-HANDLE_IOCTL(BLKGETSIZE64_32, do_blkgetsize64)
 /* Raw devices */
 HANDLE_IOCTL(RAW_SETBIND, raw_ioctl)
 HANDLE_IOCTL(RAW_GETBIND, raw_ioctl)
