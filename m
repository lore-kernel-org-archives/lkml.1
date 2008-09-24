Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYIXLrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYIXLrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYIXLro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:47:44 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42369 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbYIXLrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:47:42 -0400
Date: Wed, 24 Sep 2008 13:47:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: What's in in the block git tree for 2.6.28?
Message-ID: <20080924114719.GK13454@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems it is about time to send out that mail on what I have queued up
for merging in the block layer for 2.6.28. So here it is, summarized and
in no particular order:

- IO scheduler fixes
        deadline: documentation fixes, cleanups, and allow
                  non-sequential request batching.
        cfq: fix queue depth detection.

- Support for handling online resizing of block devices.

- xen: support more than 16 devices in blkfront driver.

- Adds block layer support for the 'discard' operation, which can be
  used to tell devices that blocks are no longer in use anymore. Useful
  for SSD/flash and such.

- Lots of block IO mapping updates, mainly for moving large parts of
  that code out of SG and into the block core.

- Drop virtual merging support. It was largely a big cause of bugs, and
  its merrits are really low. By dropping it we can also shrink request
  and bio size, since we don't have to carry two seperate segment counts
  around.

- Add support for IO CPU affinity. This has been a long project with
  lots of architecture bits needing to get done first (are in 2.6.26),
  now we get to reap the benefits of this by adding simple support for
  controlling where we get IO completions on each individual request.
  Typical benefits are less variations in runtime for testing and a good
  reduction in system time due to less lock contention and bouncing.
  There's a coarse mode setting that migrates each completion to the
  submitter CPU (in sysfs, dev/queue/rq_affinity) and also support for
  letting the queuer (eg the fs) control completion location.

- Unify request timeout handling. This moves the timeout code out of
  SCSI and supports it directly in the block layer. The timeout concept
  is modified from being a per-request timer to a per-queue timer,
  greatly reducing the fiddling we have to do with timers on each IO. So
  it should be a performance improvement, as well as a space and code
  saver. Required for moving libata out of SCSI.

- Add FAULT_ config option for testing request timeouts.

- Detect SSD devices in libata and inform the block layer of such. Then
  we can make some better decisions in the IO scheduler about when to
  idle the queue, etc. Improves SSD performance with CFQ/AS.

- Various driver fixlets and driver/core cleanups.

- Add request update/submission interface, needed for request based DM
  support.

- kerneldoc updates.

- Support for extended and sparse device space. Required for moving
  libata out of SCSI.

I have probably forgotten a thing or two, if in doubt check the below
diffstat.

Aaron Carroll (4):
      deadline-iosched: allow non-sequential batching
      deadline-iosched: non-functional fixes
      block: update documentation for deadline fifo_batch tunable
      cfq-iosched: fix queue depth detection

Andrew Patterson (6):
      Wrapper for lower-level revalidate_disk routines.
      Adjust block device size after an online resize of a disk.
      Check for device resize when rescanning partitions
      SCSI sd driver calls revalidate_disk wrapper.
      Added flush_disk to factor out common buffer cache flushing code.
      Call flush_disk() after detecting an online resize.

Chris Lalancette (1):
      block: Expand Xen blkfront for > 16 xvd

David Woodhouse (10):
      Fix up comments about matching flags between bio and rq
      Add 'discard' request handling
      Let the block device know when sectors can be discarded
      Support 'discard sectors' operation in translation layer support core
      Support 'discard sectors' operation.
      blktrace: support discard requests
      blktrace: simplify flags handling in __blk_add_trace
      Add BLKDISCARD ioctl to allow userspace to discard sectors
      Allow elevators to sort/merge discard requests
      Kill REQ_TYPE_FLUSH

FUJITA Tomonori (19):
      block: add gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov
      block: introduce struct rq_map_data to use reserved pages
      sg: convert the non-data path to use the block layer
      sg: convert the direct IO path to use the block layer
      sg: convert the indirect IO path to use the block layer
      bio: convert bio_copy_kern to use bio_copy_user
      block: add blk_rq_aligned helper function
      sg: use blk_rq_aligned helper function
      block: make blk_rq_map_user take a NULL user-space buffer
      sg: set dxferp to NULL for READ with the older SG interface
      sg: rename sg_cmd_done sg_rq_end_io
      sg: remove SG_ALLOW_DIO_CODE define
      sg: remove b_malloc_len in sg_scatter_hold struct
      sg: remove __sg_start_req
      sg: incorporate sg_build_direct into sg_start_req
      sg: remove sg_write_xfer
      sg: remove sg_read_xfer
      sg: remove unnecessary blk_rq_unmap_user
      fix an example of scatterlists handling in DMA-API.txt

Fernando Luis Vázquez Cao (1):
      virtio_blk: use a wrapper function to access io context information of IO requests

Harvey Harrison (1):
      block: kmalloc args reversed, small function definition fixes

Hugh Dickins (1):
      block: adjust blkdev_issue_discard for swap

Jens Axboe (22):
      block: add bio_has_data() to detect whether a bio carries data or not
      block: use bio_has_data() to check for data carrying bio
      block: use bio_has_data() in the IO completion path
      highmem: use bio_has_data() in the bounce path
      block: raid fixups for removal of bi_hw_segments
      block: make bi_phys_segments an unsigned int instead of short
      block: use linux/uaccess.h in elevator.c instead of asm variant
      block: split softirq handling into blk-softirq.c
      block: make kblockd_schedule_work() take the queue as parameter
      block: add support for IO CPU affinity
      block: inherit CPU completion on bio->rq and rq->rq merges
      block: don't use bio_has_data() in the completion path
      Change default value of CONFIG_DEBUG_BLOCK_EXT_DEVT to 'n'
      block: update comment on end_request()
      block: unify request timeout handling
      block: add bio_kmalloc()
      block: add fault injection mechanism for faking request timeouts
      block: use rq complete marking in blk_abort_request()
      block: cleanup some of the integrity stuff in blkdev.h
      block: blk_cleanup_queue() should call blk_sync_queue()
      block: add queue flag for SSD/non-rotational devices
      libata: set queue SSD flag for SSD devices

Julia Lawall (1):
      drivers/block: Use DIV_ROUND_UP

Keith Wansbrough (1):
      floppy: support arbitrary first-sector numbers

Kiyoshi Ueda (3):
      block: add request update interface
      block: add request submission interface
      block: add a queue flag for request stacking support

Mike Anderson (2):
      block: Add interface to abort queued requests
      dm: Call blk_abort_queue on failed paths

Mikulas Patocka (2):
      block: drop virtual merging accounting
      drop vmerge accounting

OGAWA Hirofumi (1):
      Use WRITE_BARRIER in blkdev_issue_flush(), not (1<<BIO_RW_BARRIER)

Randy Dunlap (1):
      Add some block/ source files to the kernel-api docbook. Fix kernel-doc notation in them as needed. Fix changed function parameter names. Fix typos/spellos. In comments, change REQ_SPECIAL to REQ_TYPE_SPECIAL and REQ_BLOCK_PC to REQ_TYPE_BLOCK_PC.

Tejun Heo (32):
      klist: don't iterate over deleted entries
      driver-core: use klist for class device list and implement iterator
      block: fix partition info printouts
      block: don't grab block_class_lock unnecessarily
      block: use class_dev_iterator instead of class_for_each_device()
      block: allow deleting zero length partition
      block: update add_partition() error handling
      block: misc updates
      block: make variable and argument names more consistent
      block: don't depend on consecutive minor space
      block: fix disk->part[] dereferencing race
      block: fix diskstats access
      block: implement extended dev numbers
      block: adjust formatting for large minors and add ext_range sysfs attr
      sd/ide-disk: apply extended minors to sd and ide
      block: implement CONFIG_DEBUG_BLOCK_EXT_DEVT
      block: implement and use {disk|part}_to_dev()
      block: introduce partition 0
      block: move capacity from disk to part0
      block: move __dev from disk to part0
      block: unify sysfs size node handling
      block: move policy from disk to part0
      block: move holder_dir from disk to part0
      block: always set bdev->bd_part
      block: kill GENHD_FL_FAIL and use part0->make_it_fail
      block: move stats from disk to part0
      block: make partition array dynamic
      block: replace @ext_minors with GENHD_FL_EXT_DEVT
      block: allow disk to have extended device number
      block: don't test for partition size in bdget_disk() and blk_lookup_devt()
      init: DEBUG_BLOCK_EXT_DEVT requires explicit root= param
      block: fix duplicate headers for /proc/partitions

scameron@beardog.cca.cpqcorp.net (1):
      cciss: Fix cciss SCSI rescan code to better notice device changes

xiphmont@xiph.org (1):
      SG_IO block filter whitelist missing MMC SET READ AHEAD command

 Documentation/DMA-API.txt                |    2 +-
 Documentation/DocBook/kernel-api.tmpl    |    4 +
 Documentation/block/deadline-iosched.txt |   14 +-
 block/Makefile                           |    4 +-
 block/as-iosched.c                       |   12 +-
 block/blk-barrier.c                      |   72 +++-
 block/blk-core.c                         |  525 +++++++++--------
 block/blk-exec.c                         |    6 +-
 block/blk-integrity.c                    |    9 +-
 block/blk-map.c                          |   68 ++-
 block/blk-merge.c                        |  129 +----
 block/blk-settings.c                     |   37 +-
 block/blk-softirq.c                      |  175 ++++++
 block/blk-sysfs.c                        |   35 +-
 block/blk-tag.c                          |    8 +-
 block/blk-timeout.c                      |  238 ++++++++
 block/blk.h                              |   48 ++
 block/blktrace.c                         |   29 +-
 block/bsg.c                              |    6 +-
 block/cfq-iosched.c                      |   55 ++-
 block/cmd-filter.c                       |    9 +-
 block/compat_ioctl.c                     |    1 +
 block/deadline-iosched.c                 |   40 +-
 block/elevator.c                         |   36 +-
 block/genhd.c                            |  965 ++++++++++++++++++++----------
 block/ioctl.c                            |  124 ++++-
 block/scsi_ioctl.c                       |    8 +-
 drivers/ata/libata-eh.c                  |   13 +-
 drivers/ata/libata-scsi.c                |    4 +
 drivers/ata/libata.h                     |    2 +-
 drivers/base/base.h                      |    2 +-
 drivers/base/class.c                     |  136 ++++-
 drivers/base/core.c                      |    6 +-
 drivers/block/aoe/aoeblk.c               |    6 +-
 drivers/block/aoe/aoecmd.c               |   19 +-
 drivers/block/aoe/aoedev.c               |    2 +-
 drivers/block/cciss.c                    |    8 +-
 drivers/block/cciss_scsi.c               |  151 +++--
 drivers/block/cciss_scsi.h               |    4 +
 drivers/block/cpqarray.c                 |    2 +-
 drivers/block/floppy.c                   |   31 +-
 drivers/block/nbd.c                      |    4 +-
 drivers/block/pktcdvd.c                  |    2 +-
 drivers/block/ps3disk.c                  |   11 +-
 drivers/block/virtio_blk.c               |    4 +-
 drivers/block/xen-blkfront.c             |   76 ++-
 drivers/cdrom/cdrom.c                    |    2 +-
 drivers/char/random.c                    |    6 +-
 drivers/ide/ide-cd.c                     |    2 +-
 drivers/ide/ide-disk.c                   |   15 +-
 drivers/ide/ide-probe.c                  |    2 +-
 drivers/md/dm-ioctl.c                    |    6 +-
 drivers/md/dm-mpath.c                    |   15 +-
 drivers/md/dm-stripe.c                   |    4 +-
 drivers/md/dm.c                          |   40 +-
 drivers/md/linear.c                      |    8 +-
 drivers/md/md.c                          |   15 +-
 drivers/md/multipath.c                   |    8 +-
 drivers/md/raid0.c                       |    8 +-
 drivers/md/raid1.c                       |   13 +-
 drivers/md/raid10.c                      |   12 +-
 drivers/md/raid5.c                       |   75 ++-
 drivers/memstick/core/mspro_block.c      |    2 +-
 drivers/mmc/card/block.c                 |    2 +-
 drivers/mtd/ftl.c                        |   24 +
 drivers/mtd/mtd_blkdevs.c                |   16 +
 drivers/s390/block/dasd_proc.c           |    3 +-
 drivers/s390/block/dcssblk.c             |    4 +-
 drivers/scsi/aacraid/aachba.c            |    2 +-
 drivers/scsi/gdth.c                      |   60 ++-
 drivers/scsi/gdth.h                      |    2 +-
 drivers/scsi/gdth_proc.c                 |   66 --
 drivers/scsi/gdth_proc.h                 |    3 -
 drivers/scsi/ibmvscsi/ibmvscsi.c         |    2 +-
 drivers/scsi/ide-scsi.c                  |    2 +-
 drivers/scsi/ipr.c                       |    3 +-
 drivers/scsi/ips.c                       |    2 +-
 drivers/scsi/libiscsi.c                  |   17 +-
 drivers/scsi/libsas/sas_ata.c            |    2 +-
 drivers/scsi/libsas/sas_internal.h       |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c      |   30 +-
 drivers/scsi/megaraid/megaraid_sas.c     |    6 +-
 drivers/scsi/ncr53c8xx.c                 |    4 +-
 drivers/scsi/qla1280.c                   |    4 +-
 drivers/scsi/qla4xxx/ql4_os.c            |    4 +-
 drivers/scsi/scsi.c                      |   92 +---
 drivers/scsi/scsi_error.c                |   90 +---
 drivers/scsi/scsi_lib.c                  |   17 +-
 drivers/scsi/scsi_priv.h                 |    7 +-
 drivers/scsi/scsi_sysfs.c                |    7 +-
 drivers/scsi/scsi_tgt_lib.c              |    2 +-
 drivers/scsi/scsi_transport_fc.c         |    6 +-
 drivers/scsi/sd.c                        |   95 ++-
 drivers/scsi/sg.c                        |  667 +++++----------------
 drivers/scsi/sr.c                        |    7 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c      |    4 +-
 fs/bio-integrity.c                       |   31 +
 fs/bio.c                                 |  252 +++++----
 fs/block_dev.c                           |  181 ++++--
 fs/fat/fatent.c                          |   14 +
 fs/partitions/check.c                    |  268 +++++----
 fs/partitions/check.h                    |    4 +-
 include/linux/ata.h                      |    6 +
 include/linux/bio.h                      |   81 ++--
 include/linux/blkdev.h                   |  146 +++--
 include/linux/blktrace_api.h             |    6 +
 include/linux/device.h                   |   14 +-
 include/linux/elevator.h                 |    9 +-
 include/linux/fd.h                       |    8 +-
 include/linux/fs.h                       |    9 +-
 include/linux/genhd.h                    |  363 ++++++------
 include/linux/klist.h                    |    3 +-
 include/linux/major.h                    |    2 +
 include/linux/mtd/blktrans.h             |    2 +
 include/scsi/scsi_cmnd.h                 |    3 -
 include/scsi/scsi_host.h                 |    9 +-
 include/scsi/scsi_transport.h            |    3 +-
 init/do_mounts.c                         |    4 +
 lib/Kconfig.debug                        |   35 +-
 lib/klist.c                              |   96 +++-
 mm/bounce.c                              |    2 +-
 121 files changed, 3663 insertions(+), 2517 deletions(-)
 create mode 100644 block/blk-softirq.c
 create mode 100644 block/blk-timeout.c

-- 
Jens Axboe

