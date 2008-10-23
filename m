Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYJWKBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYJWKBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 06:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJWKB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 06:01:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38498 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYJWKBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 06:01:25 -0400
Date: Thu, 23 Oct 2008 11:01:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: [git pull] bdev API series
Message-ID: <20081023100124.GK28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Get rid of struct file/struct inode mess in block device
->open()/->release()/->ioctl(); switch them to saner prototype, kill
fake on-stack struct file, etc. brought by bogosity of old API,
sanitize f_mode handling in that area, provide a way for drivers
to DTRT with respect to closing r/o vs. closing r/w (e.g. it finally
becomes possible to fix the mess in cdrom_release() now).

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/bdev.git/ master

Shortlog:
Al Viro (66):
      introduce fmode_t, do annotations
      eliminate use of ->f_flags in block methods
      pass mode instead of file to sg_io()
      switch sg_scsi_ioctl() to passing fmode_t
      switch scsi_cmd_ioctl() to passing fmode_t
      lose the unused file argument in generic_ide_ioctl()
      lose unused arguments in dm ioctl callbacks
      move block_device_operations to blkdev.h
      switch cdrom_{open,release,ioctl} to sane APIs
      switch pktcdvd to blkdev_driver_ioctl()
      introduce __blkdev_driver_ioctl()
      don't mess with file in scsi_nonblockable_ioctl()
      switch ide_disk_ops ->ioctl() to sane prototype
      beginning of methods conversion
      switch ubd
      switch DAC960
      switch amiflop
      switch aoeblk
      switch ataflop
      switch brd
      switch cciss
      switch cpqarray
      switch floppy
      switch loop
      switch nbd
      switch pcd
      switch pd
      switch pf
      switch pktdvdcd
      switch swim3
      switch ub
      switch viodasd
      switch virtio_blk
      switch xd
      switch xen
      switch xyspace
      switch z2ram
      switch gdrom
      switch viocd
      switch ide-cd
      switch ide-gd
      switch ide-tape
      switch dm
      switch md
      switch memstick
      switch i2o
      switch mmc
      switch mtd_blkdevs
      switch dasd
      switch dcssblk
      switch tape_block
      switch ide-scsi
      switch sd
      switch sr
      end of methods switch: remove the old ones
      trim file propagation in block/compat_ioctl.c
      kill the unused bsize on the send side of /dev/loop
      pass fmode_t to blkdev_put()
      propagate mode through open_bdev_excl/close_bdev_excl
      propagate mode through swsusp_close()
      remember mode of reiserfs journal
      sanitize blkdev_get() and friends
      get rid of blkdev_driver_ioctl()
      get rid of blkdev_locked_ioctl()
      get rid of struct file use in blkdev_ioctl() BLKBSZSET
      kill the rest of struct file propagation in block ioctls

Diffstat:
 arch/um/drivers/ubd_kern.c          |   19 ++--
 block/bsg.c                         |    9 +-
 block/cmd-filter.c                  |    2 +-
 block/compat_ioctl.c                |  175 ++++++++++++++---------------------
 block/ioctl.c                       |  173 ++++++++++++++++++-----------------
 block/scsi_ioctl.c                  |   33 +++----
 drivers/block/DAC960.c              |    6 +-
 drivers/block/amiflop.c             |   46 +++++-----
 drivers/block/aoe/aoeblk.c          |   12 +--
 drivers/block/ataflop.c             |   37 ++++----
 drivers/block/brd.c                 |    5 +-
 drivers/block/cciss.c               |   71 +++++++-------
 drivers/block/cpqarray.c            |   28 +++---
 drivers/block/floppy.c              |   54 +++++------
 drivers/block/loop.c                |   59 ++++++------
 drivers/block/nbd.c                 |   28 +++---
 drivers/block/paride/pcd.c          |   21 ++--
 drivers/block/paride/pd.c           |   14 ++--
 drivers/block/paride/pf.c           |   22 ++--
 drivers/block/paride/pt.c           |    2 +-
 drivers/block/pktcdvd.c             |   56 ++++++------
 drivers/block/swim3.c               |   32 +++---
 drivers/block/ub.c                  |   22 ++---
 drivers/block/viodasd.c             |   10 +-
 drivers/block/virtio_blk.c          |    8 +-
 drivers/block/xd.c                  |    4 +-
 drivers/block/xd.h                  |    2 +-
 drivers/block/xen-blkfront.c        |   15 ++--
 drivers/block/xsysace.c             |   11 +-
 drivers/block/z2ram.c               |    7 +-
 drivers/cdrom/cdrom.c               |   23 ++---
 drivers/cdrom/gdrom.c               |   14 ++--
 drivers/cdrom/viocd.c               |   21 ++--
 drivers/char/nvram.c                |    6 +-
 drivers/char/raw.c                  |    8 +-
 drivers/ide/ide-cd.c                |   22 ++---
 drivers/ide/ide-disk.h              |    2 +-
 drivers/ide/ide-disk_ioctl.c        |    5 +-
 drivers/ide/ide-floppy.h            |    4 +-
 drivers/ide/ide-floppy_ioctl.c      |   17 ++--
 drivers/ide/ide-gd.c                |   20 ++--
 drivers/ide/ide-ioctls.c            |    3 +-
 drivers/ide/ide-tape.c              |   17 +--
 drivers/md/dm-ioctl.c               |    4 +-
 drivers/md/dm-linear.c              |   13 +--
 drivers/md/dm-mpath.c               |   14 +--
 drivers/md/dm-table.c               |   16 ++--
 drivers/md/dm.c                     |   27 ++----
 drivers/md/md.c                     |   20 ++--
 drivers/memstick/core/mspro_block.c |    9 +-
 drivers/message/i2o/i2o_block.c     |   13 +--
 drivers/mmc/card/block.c            |   13 +--
 drivers/mtd/devices/block2mtd.c     |    4 +-
 drivers/mtd/mtd_blkdevs.c           |   24 ++---
 drivers/mtd/mtdchar.c               |   10 +-
 drivers/parisc/eisa_eeprom.c        |    2 +-
 drivers/s390/block/dasd.c           |   11 +--
 drivers/s390/block/dasd_genhd.c     |    4 +-
 drivers/s390/block/dasd_int.h       |    3 +-
 drivers/s390/block/dasd_ioctl.c     |   15 +---
 drivers/s390/block/dcssblk.c        |   17 ++--
 drivers/s390/char/tape_block.c      |   25 ++---
 drivers/scsi/ide-scsi.c             |   22 ++---
 drivers/scsi/scsi_ioctl.c           |    6 +-
 drivers/scsi/sd.c                   |   35 +++----
 drivers/scsi/sg.c                   |    2 +-
 drivers/scsi/sr.c                   |   40 ++++-----
 drivers/scsi/st.c                   |    7 +-
 fs/block_dev.c                      |  111 ++++++++++------------
 fs/ext2/xip.c                       |    1 +
 fs/ext3/super.c                     |    4 +-
 fs/ext4/super.c                     |    4 +-
 fs/fifo.c                           |    6 +-
 fs/file_table.c                     |    4 +-
 fs/hostfs/hostfs_kern.c             |    5 +-
 fs/jfs/jfs_logmgr.c                 |    4 +-
 fs/locks.c                          |    3 +-
 fs/ocfs2/cluster/heartbeat.c        |    6 +-
 fs/open.c                           |    2 +-
 fs/partitions/check.c               |    4 +-
 fs/proc/base.c                      |    4 +-
 fs/reiserfs/journal.c               |   11 ++-
 fs/super.c                          |   14 ++-
 fs/xfs/linux-2.6/xfs_super.c        |    4 +-
 include/linux/blkdev.h              |   27 +++++-
 include/linux/cdrom.h               |   10 +-
 include/linux/device-mapper.h       |   11 +-
 include/linux/file.h                |    4 +-
 include/linux/fs.h                  |   49 ++++------
 include/linux/fsnotify.h            |    2 +-
 include/linux/ide.h                 |    7 +-
 include/linux/reiserfs_fs_sb.h      |    1 +
 include/linux/types.h               |    1 +
 include/scsi/scsi_ioctl.h           |    2 +-
 ipc/shm.c                           |    2 +-
 kernel/power/disk.c                 |    2 +-
 kernel/power/power.h                |    2 +-
 kernel/power/swap.c                 |   14 ++--
 sound/core/oss/pcm_oss.c            |    2 +-
 sound/oss/au1550_ac97.c             |    2 +-
 sound/oss/dmasound/dmasound.h       |    4 +-
 sound/oss/dmasound/dmasound_atari.c |    4 +-
 sound/oss/dmasound/dmasound_core.c  |   10 +-
 sound/oss/msnd.h                    |    2 +-
 sound/oss/sound_config.h            |   20 +---
 sound/oss/swarm_cs4297a.c           |    2 +-
 sound/oss/vwsnd.c                   |    2 +-
 107 files changed, 868 insertions(+), 1002 deletions(-)

