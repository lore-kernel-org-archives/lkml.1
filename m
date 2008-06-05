Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYFEJGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYFEJGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYFEJGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:06:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:59859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYFEJGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:06:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH] fs code: Push the BKL down into the file system ioctl handlers
Date: Thu, 5 Jun 2008 10:59:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org
References: <20080522231524.52e21eb8@core> <200806041843.20965.arnd@arndb.de>
In-Reply-To: <200806041843.20965.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806051059.49952.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18nMv40949w0+OWJqL11Una5tNhn5TDFTjr/bH
 jAvW2c4ROIaNMDn0flMhRT0w9NSvjvfeTZmuKJI6XHeUo5jWo1
 QsiDqo60mDTsaGQuwKp/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008, Arnd Bergmann wrote:
> I suppose the right fix for this will be to make the blkdev
> unlocked_ioctl and compat_ioctl take a bdev argument instead
> of file and inode.

Ok, I tried that, and it mostly worked fine. I have a patch
now that converts all block drivers to use unlocked_ioctl,
and, where appropriate, compat_ioctl.

I tried changing the prototype from 

long (*unlocked_ioctl) (struct file *file, unsigned, unsigned long);

to

int (*unlocked_ioctl) (block_device *bdev, unsigned, unsigned long);

There are two problems with removing the file argument:

* A handful of drivers use file->f_mode to check for permissions.
Obviously, this needs to keep working, so we must pass either
the whole struct file or the mode argument down to each ioctl
function.
I'd prefer the mode argument, because there are a number of
places where we pass a NULL file, or the file does not actually
represent the inode/bdev, e.g. in pktcdvd, ide-scsi or raw.
Currently, it's easy to introduce bugs in device drivers because
of this.

* There is exactly one place in the code, which uses another
member of struct file: 
SG_SCSI_RESET in scsi_nonblockable_ioctl() checks the O_NONBLOCK
open flag. Does it even make sense for this driver to support
both blocking and nonblocking operation? I'd say if we need both,
it's better to pass both bdev and file to each ioctl handler:

int (*unlocked_ioctl) (block_device *bdev, struct file *file,
			unsigned, unsigned long);

otherwise, we can simply pass the mode, as in

int (*unlocked_ioctl) (block_device *bdev, mode_t mode,
			unsigned, unsigned long);

in order to reduce the potential amount of confusion.

	Arnd <><

 Documentation/filesystems/Locking      |    4 ++
 arch/um/drivers/ubd_kern.c             |   22 +++++++--
 block/scsi_ioctl.c                     |   40 +++++++--------
 drivers/block/amiflop.c                |   23 +++++++--
 drivers/block/ataflop.c                |   22 ++++++--
 drivers/block/brd.c                    |    9 ++-
 drivers/block/cciss.c                  |   58 +++++++++++----------
 drivers/block/cpqarray.c               |   35 +++++++++++--
 drivers/block/floppy.c                 |   15 +++++-
 drivers/block/loop.c                   |   40 ++++++++-------
 drivers/block/nbd.c                    |   42 ++++++++++-----
 drivers/block/paride/pcd.c             |   16 +++++--
 drivers/block/paride/pd.c              |   11 +++-
 drivers/block/paride/pf.c              |   12 +++--
 drivers/block/pktcdvd.c                |   50 ++++++++++++++++--
 drivers/block/swim3.c                  |   21 ++++++--
 drivers/block/ub.c                     |    6 +-
 drivers/block/virtio_blk.c             |   20 +++++--
 drivers/block/xd.c                     |   16 +++++-
 drivers/cdrom/cdrom.c                  |   10 ++--
 drivers/cdrom/gdrom.c                  |   16 +++++--
 drivers/cdrom/viocd.c                  |   16 +++++--
 drivers/ide/ide-cd.c                   |   20 ++++++--
 drivers/ide/ide-disk.c                 |   20 ++++++--
 drivers/ide/ide-floppy.c               |   26 ++++++++--
 drivers/ide/ide-tape.c                 |   33 +++++++++++--
 drivers/ide/ide.c                      |    2 +-
 drivers/md/dm-linear.c                 |    3 +-
 drivers/md/dm-mpath.c                  |    3 +-
 drivers/md/dm.c                        |   10 ++--
 drivers/md/md.c                        |   10 +++-
 drivers/message/i2o/i2o_block.c        |   20 ++++++-
 drivers/mtd/mtd_blkdevs.c              |   16 ++++--
 drivers/s390/block/dasd.c              |    2 +-
 drivers/s390/block/dasd_int.h          |    4 +-
 drivers/s390/block/dasd_ioctl.c        |   24 ++++++---
 drivers/s390/char/tape_block.c         |   13 ++---
 drivers/scsi/ide-scsi.c                |    7 +--
 drivers/scsi/sd.c                      |   11 ++--
 drivers/scsi/sr.c                      |   24 ++++++++--
 include/linux/blkdev.h                 |    8 ++--
 include/linux/device-mapper.h          |    3 +-
 include/linux/fs.h                     |    5 +-
 include/linux/ide.h                    |    2 +-
 44 files changed, 540 insertions(+), 232 deletions(-)
