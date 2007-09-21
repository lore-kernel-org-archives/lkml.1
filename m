Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbXIUI4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbXIUI4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXIUI40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:56:26 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2428 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbXIUI4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:56:24 -0400
Date: Fri, 21 Sep 2007 10:57:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: What's in linux-2.6-block.git for 2.6.24
Message-ID: <20070921085711.GG2367@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This details the contents of the block git repo of items that are bound
for a 2.6.24 merge. The SCSI data buffer accessor patch from Tomo will
also be going in through the block tree, but it's not merged up yet.
That's mainly due to my laziness, not because the code isn't ready. That
will happen sometime during today.

Misc bits:
- Various bug fixes from Neil Brown, part of his larger patchset for
  allowing arbitrarily sized bios.
- Various little bug fixes and documentation updates.

Barriers:
- The empty bio barrier patches from me. These allow sending down a bio
  with no data attached, for insertion a barrier in a request queue.
  They are useful for dm and md, but also cleans up the sync
  blkdev_issue_flush() interface - it's now no longer an addon hack, but
  just a natural use of empty bio barriers.

SG chaining bits:
- This is the bulk of the patchset. It consists of three major
  components:

        - sglist-core, which add helpers for iterating sg lists and
          switches the block layer and SCSI to use those. Should not
          have any functional changes.
        - sglist-drivers, which converts drivers to use the sg list
          helpers. Again, should not contain functional changes.
        - sglist-arch, which adds support to most architectures and
          actually enables sg chaining.

The goal of sg chaining is to allow support for very large sgtables,
without requiring that they be allocated from one contigious piece of
memory.

Shortlog:

Adrian Bunk (1):
      remove ide_get_error_location()

Andrew Morton (1):
      Fixup u14-34f ENABLE_SG_CHAINING

Dhaval Giani (1):
      Corrections in Documentation/block/ioprio.txt

FUJITA Tomonori (9):
      ips: sg chaining support
      zfcp: sg chaining support
      libata sg chaining support fix
      qla1280: sg chaining fixes
      add use_sg_chaining option to scsi_host_template
      qla1280: enable use_sg_chaining option
      revert sg segment size ifdefs
      remove blk_queue_max_phys_segments in libata
      remove sglist_len

Jens Axboe (45):
      [BLOCK] Fixup rq_for_each_segment() indentation
      Fix warnings with !CONFIG_BLOCK
      block: ll_rw_blk.c: cosmetics
      bio: use memset() in bio_init()
      bio: make freeing of ->bi_io_vec conditional in bio_free()
      block: add end_queued_request() and end_dequeued_request() helpers
      block: factor our bio_check_eod()
      block: Initial support for data-less (or empty) barrier support
      block: convert blkdev_issue_flush() to use empty barriers
      pktcdvd: don't rely on bio_init() preserving bio->bi_io_vec
      crypto: don't pollute the global namespace with sg_next()
      Add sg helpers for iterating over a scatterlist table
      block: convert to using sg helpers
      scsi: convert to using sg helpers
      Add chained sg support to linux/scatterlist.h
      ll_rw_blk: temporarily enable max_segments tweaking
      scsi: simplify scsi_free_sgtable()
      SCSI: support for allocating large scatterlists
      libata: convert to using sg helpers
      scsi_debug: support sg chaining
      scsi generic: sg chaining support
      qla1280: sg chaining support
      aic94xx: sg chaining support
      qlogicpti: sg chaining support
      ide-scsi: sg chaining support
      gdth: sg chaining support
      aha1542: convert to use the data buffer accessors
      advansys: convert to use the data buffer accessors
      infiniband: sg chaining support
      USB storage: sg chaining support
      Fusion: sg chaining support
      i2o: sg chaining support
      IDE: sg chaining support
      i386 dma_map_sg: convert to using sg helpers
      i386: enable sg chaining
      swiotlb: sg chaining support
      x86-64: update calgary iommu to sg helpers
      x86-64: update nommu to sg helpers
      x86-64: update pci-gart iommu to sg helpers
      x86-64: enable sg chaining
      IA64: sg chaining support
      PS3: sg chaining support
      PPC: sg chaining support
      SPARC: sg chaining support
      SPARC64: sg chaining support

Laurent Riffard (1):
      pktcdvd: don't rely on bio_init() preserving bio->bi_destructor

Lee Schermerhorn (1):
      Panic in blk_rq_map_sg() from CCISS driver

Mel Gorman (1):
      Build failure on ppc64 drivers/block/ps3disk.c

NeilBrown (6):
      Merge blk_recount_segments into blk_recalc_rq_segments
      [BLOCK] Introduce rq_for_each_segment replacing rq_for_each_bio
      Fix various abuse of bio fields in umem.c
      New function blk_req_append_bio
      Stop exporting blk_rq_bio_prep
      Share code between init_request_from_bio and blk_rq_bio_prep

Satyam Sharma (1):
      ll_rw_blk: blk_cpu_notifier should be __cpuinitdata

saeed bishara (1):
      use sg helper function in DMA mapping documentation

 Documentation/DMA-mapping.txt             |    2 
 Documentation/block/biodoc.txt            |   20 
 Documentation/block/ioprio.txt            |   11 
 arch/ia64/hp/common/sba_iommu.c           |   14 
 arch/ia64/hp/sim/simscsi.c                |    1 
 arch/ia64/sn/pci/pci_dma.c                |   11 
 arch/powerpc/kernel/dma_64.c              |    5 
 arch/powerpc/kernel/ibmebus.c             |   11 
 arch/powerpc/kernel/iommu.c               |   23 
 arch/powerpc/platforms/ps3/system-bus.c   |    7 
 arch/sparc/kernel/ioport.c                |   25 -
 arch/sparc/mm/io-unit.c                   |   12 
 arch/sparc/mm/iommu.c                     |   10 
 arch/sparc/mm/sun4c.c                     |   10 
 arch/sparc64/kernel/iommu.c               |   39 +
 arch/sparc64/kernel/pci_sun4v.c           |   32 -
 arch/x86_64/kernel/pci-calgary.c          |   24 -
 arch/x86_64/kernel/pci-gart.c             |   63 +-
 arch/x86_64/kernel/pci-nommu.c            |    5 
 block/elevator.c                          |   17 
 block/ll_rw_blk.c                         |  522 +++++++++++++---------
 crypto/digest.c                           |    2 
 crypto/scatterwalk.c                      |    2 
 crypto/scatterwalk.h                      |    2 
 drivers/ata/libata-core.c                 |   35 -
 drivers/ata/libata-scsi.c                 |    2 
 drivers/block/cciss.c                     |    1 
 drivers/block/floppy.c                    |   81 +--
 drivers/block/lguest_blk.c                |   36 -
 drivers/block/nbd.c                       |   59 +-
 drivers/block/pktcdvd.c                   |    7 
 drivers/block/ps3disk.c                   |   63 --
 drivers/block/umem.c                      |   38 +
 drivers/block/xen-blkfront.c              |   32 -
 drivers/ide/cris/ide-cris.c               |    3 
 drivers/ide/ide-disk.c                    |   29 -
 drivers/ide/ide-dma.c                     |    2 
 drivers/ide/ide-floppy.c                  |   52 +-
 drivers/ide/ide-io.c                      |   38 -
 drivers/ide/ide-probe.c                   |    2 
 drivers/ide/ide-taskfile.c                |   18 
 drivers/ide/mips/au1xxx-ide.c             |    2 
 drivers/ide/pci/sgiioc4.c                 |    3 
 drivers/ide/ppc/pmac.c                    |    2 
 drivers/infiniband/hw/ipath/ipath_dma.c   |   10 
 drivers/infiniband/ulp/iser/iser_memory.c |   76 +--
 drivers/md/dm-emc.c                       |   10 
 drivers/md/dm-table.c                     |   28 -
 drivers/md/dm.c                           |   16 
 drivers/md/dm.h                           |    1 
 drivers/md/linear.c                       |   20 
 drivers/md/md.c                           |    1 
 drivers/md/multipath.c                    |   30 -
 drivers/md/raid0.c                        |   21 
 drivers/md/raid1.c                        |   31 -
 drivers/md/raid10.c                       |   31 -
 drivers/md/raid5.c                        |   31 -
 drivers/message/fusion/mptscsih.c         |    6 
 drivers/message/i2o/i2o_block.c           |   24 -
 drivers/s390/block/dasd_diag.c            |   37 -
 drivers/s390/block/dasd_eckd.c            |   28 -
 drivers/s390/block/dasd_fba.c             |   28 -
 drivers/s390/char/tape_34xx.c             |   32 -
 drivers/s390/char/tape_3590.c             |   37 -
 drivers/s390/scsi/zfcp_def.h              |    1 
 drivers/s390/scsi/zfcp_qdio.c             |    6 
 drivers/scsi/3w-9xxx.c                    |    1 
 drivers/scsi/3w-xxxx.c                    |    1 
 drivers/scsi/BusLogic.c                   |    1 
 drivers/scsi/NCR53c406a.c                 |    3 
 drivers/scsi/a100u2w.c                    |    1 
 drivers/scsi/aacraid/linit.c              |    1 
 drivers/scsi/advansys.c                   |   12 
 drivers/scsi/aha1542.c                    |   32 -
 drivers/scsi/aha1740.c                    |    1 
 drivers/scsi/aic7xxx/aic79xx_osm.c        |    1 
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |    1 
 drivers/scsi/aic7xxx_old.c                |    1 
 drivers/scsi/aic94xx/aic94xx_task.c       |    6 
 drivers/scsi/arcmsr/arcmsr_hba.c          |    1 
 drivers/scsi/dc395x.c                     |    1 
 drivers/scsi/dpt_i2o.c                    |    1 
 drivers/scsi/eata.c                       |    3 
 drivers/scsi/gdth.c                       |   45 -
 drivers/scsi/hosts.c                      |    1 
 drivers/scsi/hptiop.c                     |    1 
 drivers/scsi/ibmmca.c                     |    1 
 drivers/scsi/ibmvscsi/ibmvscsi.c          |    1 
 drivers/scsi/ide-scsi.c                   |   31 -
 drivers/scsi/initio.c                     |    1 
 drivers/scsi/ips.c                        |   14 
 drivers/scsi/lpfc/lpfc_scsi.c             |    2 
 drivers/scsi/mac53c94.c                   |    1 
 drivers/scsi/megaraid.c                   |    1 
 drivers/scsi/megaraid/megaraid_mbox.c     |    1 
 drivers/scsi/megaraid/megaraid_sas.c      |    1 
 drivers/scsi/mesh.c                       |    1 
 drivers/scsi/nsp32.c                      |    1 
 drivers/scsi/pcmcia/sym53c500_cs.c        |    1 
 drivers/scsi/qla1280.c                    |   70 +-
 drivers/scsi/qla2xxx/qla_os.c             |    2 
 drivers/scsi/qla4xxx/ql4_os.c             |    1 
 drivers/scsi/qlogicfas.c                  |    1 
 drivers/scsi/qlogicpti.c                  |   15 
 drivers/scsi/scsi_debug.c                 |   30 -
 drivers/scsi/scsi_lib.c                   |  248 +++++++---
 drivers/scsi/scsi_tgt_lib.c               |    4 
 drivers/scsi/sd.c                         |   23 
 drivers/scsi/sg.c                         |   16 
 drivers/scsi/stex.c                       |    1 
 drivers/scsi/sym53c416.c                  |    1 
 drivers/scsi/sym53c8xx_2/sym_glue.c       |    1 
 drivers/scsi/u14-34f.c                    |    3 
 drivers/scsi/ultrastor.c                  |    1 
 drivers/scsi/wd7000.c                     |    1 
 drivers/usb/storage/alauda.c              |   16 
 drivers/usb/storage/datafab.c             |   10 
 drivers/usb/storage/jumpshot.c            |   10 
 drivers/usb/storage/protocol.c            |   20 
 drivers/usb/storage/protocol.h            |    2 
 drivers/usb/storage/sddr09.c              |   16 
 drivers/usb/storage/sddr55.c              |   16 
 drivers/usb/storage/shuttle_usbat.c       |   17 
 fs/bio.c                                  |   23 
 fs/fs-writeback.c                         |    1 
 include/asm-i386/dma-mapping.h            |   13 
 include/asm-i386/scatterlist.h            |    2 
 include/asm-ia64/dma-mapping.h            |    1 
 include/asm-ia64/scatterlist.h            |    2 
 include/asm-powerpc/dma-mapping.h         |   17 
 include/asm-powerpc/scatterlist.h         |    2 
 include/asm-sparc/scatterlist.h           |    2 
 include/asm-sparc64/scatterlist.h         |    2 
 include/asm-x86_64/dma-mapping.h          |    3 
 include/asm-x86_64/scatterlist.h          |    2 
 include/linux/bio.h                       |   19 
 include/linux/blkdev.h                    |   32 -
 include/linux/i2o.h                       |    3 
 include/linux/ide.h                       |    7 
 include/linux/libata.h                    |   16 
 include/linux/scatterlist.h               |   84 +++
 include/linux/writeback.h                 |    1 
 include/scsi/scsi.h                       |    7 
 include/scsi/scsi_cmnd.h                  |    7 
 include/scsi/scsi_host.h                  |   13 
 kernel/sched.c                            |    1 
 lib/swiotlb.c                             |   19 
 mm/bounce.c                               |    6 
 mm/readahead.c                            |    1 
 149 files changed, 1515 insertions(+), 1348 deletions(-)

-- 
Jens Axboe

