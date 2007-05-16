Return-Path: <linux-kernel-owner+w=401wt.eu-S1762884AbXEPIhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762884AbXEPIhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762367AbXEPIeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:34:10 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6601 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762216AbXEPIeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:34:04 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/19] Chaining sg lists for big IO commands v6
Date: Wed, 16 May 2007 10:32:14 +0200
Message-Id: <11793043533744-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(please ignore last posting, git send-email got hold of the
wrong directory...)

Hi,

Round 6 of the sg chaining patch set. Changes since v5:

- Support for more architectures. It should now run and work on
  i386, x86-64, sparc, sparc64, ia64, and ppc (32 and 64-bit).
  I have only tested i386/x86-64/ppc64 myself.

- Large command support is now automatically enabled by the
  SCSI mid layer, if the arch supports sg chaining. The debug
  queue entry in /sys/block/<dev>/queue/max_segments still exists
  if you want to tweak it further. The default limit is now
  2048 entries, or at least 8mb ios. Remember that you still need
  to tweak the soft limit to allow the block layer to build large
  commands, that is the max_sectors_kb variable in the same directory.

- Add kerneldoc documentation to scatterlist.h

It's solid here, so please give it a spin. I'd like to get some
performance results as well, if someone feels inclined to do so.


 arch/ia64/hp/common/sba_iommu.c           |   14 -
 arch/ia64/hp/sim/simscsi.c                |   23 +-
 arch/ia64/sn/pci/pci_dma.c                |   11 -
 arch/powerpc/kernel/dma_64.c              |    5 
 arch/powerpc/kernel/ibmebus.c             |   11 -
 arch/powerpc/kernel/iommu.c               |   18 +
 arch/powerpc/platforms/ps3/system-bus.c   |    5 
 arch/sparc/kernel/ioport.c                |   25 +-
 arch/sparc/mm/io-unit.c                   |   12 -
 arch/sparc/mm/iommu.c                     |   10 
 arch/sparc/mm/sun4c.c                     |   10 
 arch/sparc64/kernel/pci_iommu.c           |   39 ++-
 arch/sparc64/kernel/pci_sun4v.c           |   32 +-
 arch/sparc64/kernel/sbus.c                |   44 ++--
 arch/x86_64/kernel/pci-calgary.c          |   25 +-
 arch/x86_64/kernel/pci-gart.c             |   60 ++---
 arch/x86_64/kernel/pci-nommu.c            |    5 
 block/ll_rw_blk.c                         |   42 +++
 crypto/digest.c                           |    2 
 crypto/scatterwalk.c                      |    2 
 crypto/scatterwalk.h                      |    2 
 drivers/ata/libata-core.c                 |   30 +-
 drivers/ide/cris/ide-cris.c               |    3 
 drivers/ide/ide-dma.c                     |    2 
 drivers/ide/ide-taskfile.c                |   17 +
 drivers/ide/mips/au1xxx-ide.c             |    2 
 drivers/ide/pci/sgiioc4.c                 |    2 
 drivers/ide/ppc/pmac.c                    |    2 
 drivers/infiniband/hw/ipath/ipath_dma.c   |    9 
 drivers/infiniband/ulp/iser/iser_memory.c |   75 +++---
 drivers/infiniband/ulp/srp/ib_srp.c       |   22 +-
 drivers/message/fusion/mptscsih.c         |    4 
 drivers/scsi/3w-9xxx.c                    |    8 
 drivers/scsi/3w-xxxx.c                    |    8 
 drivers/scsi/53c700.c                     |   16 -
 drivers/scsi/BusLogic.c                   |    7 
 drivers/scsi/NCR53c406a.c                 |   18 -
 drivers/scsi/a100u2w.c                    |    9 
 drivers/scsi/aacraid/aachba.c             |   29 +-
 drivers/scsi/advansys.c                   |   21 -
 drivers/scsi/aha1542.c                    |   21 -
 drivers/scsi/aha1740.c                    |    8 
 drivers/scsi/aic7xxx/aic79xx_osm.c        |    3 
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |   12 -
 drivers/scsi/aic94xx/aic94xx_task.c       |    6 
 drivers/scsi/arcmsr/arcmsr_hba.c          |   11 -
 drivers/scsi/dc395x.c                     |    7 
 drivers/scsi/dpt_i2o.c                    |   13 -
 drivers/scsi/eata.c                       |    8 
 drivers/scsi/esp_scsi.c                   |    5 
 drivers/scsi/gdth.c                       |   45 ++--
 drivers/scsi/hptiop.c                     |    8 
 drivers/scsi/ibmmca.c                     |   11 -
 drivers/scsi/ibmvscsi/ibmvscsi.c          |    4 
 drivers/scsi/ide-scsi.c                   |   31 +-
 drivers/scsi/initio.c                     |   12 -
 drivers/scsi/ipr.c                        |    9 
 drivers/scsi/ips.c                        |   74 +++---
 drivers/scsi/iscsi_tcp.c                  |   43 ++-
 drivers/scsi/jazz_esp.c                   |   27 +-
 drivers/scsi/lpfc/lpfc_scsi.c             |    9 
 drivers/scsi/mac53c94.c                   |    9 
 drivers/scsi/megaraid.c                   |   13 -
 drivers/scsi/megaraid/megaraid_mbox.c     |    7 
 drivers/scsi/megaraid/megaraid_sas.c      |   16 -
 drivers/scsi/mesh.c                       |   12 -
 drivers/scsi/ncr53c8xx.c                  |    7 
 drivers/scsi/nsp32.c                      |    9 
 drivers/scsi/pcmcia/sym53c500_cs.c        |   18 -
 drivers/scsi/qla1280.c                    |   66 +++---
 drivers/scsi/qla2xxx/qla_iocb.c           |    9 
 drivers/scsi/qla4xxx/ql4_iocb.c           |    8 
 drivers/scsi/qlogicfas408.c               |    9 
 drivers/scsi/qlogicpti.c                  |   15 -
 drivers/scsi/scsi_debug.c                 |   29 +-
 drivers/scsi/scsi_lib.c                   |  239 ++++++++++++++++------
 drivers/scsi/scsi_tgt_lib.c               |    4 
 drivers/scsi/sg.c                         |   16 -
 drivers/scsi/sym53c416.c                  |    9 
 drivers/scsi/sym53c8xx_2/sym_glue.c       |    7 
 drivers/scsi/u14-34f.c                    |   10 
 drivers/scsi/ultrastor.c                  |   10 
 drivers/scsi/wd7000.c                     |    7 
 drivers/usb/storage/alauda.c              |   16 -
 drivers/usb/storage/datafab.c             |   10 
 drivers/usb/storage/jumpshot.c            |   10 
 drivers/usb/storage/protocol.c            |   20 +
 drivers/usb/storage/protocol.h            |    2 
 drivers/usb/storage/sddr09.c              |   16 -
 drivers/usb/storage/sddr55.c              |   16 -
 drivers/usb/storage/shuttle_usbat.c       |   17 -
 include/asm-i386/dma-mapping.h            |   13 -
 include/asm-i386/scatterlist.h            |    2 
 include/asm-ia64/dma-mapping.h            |    1 
 include/asm-ia64/scatterlist.h            |    2 
 include/asm-powerpc/dma-mapping.h         |    2 
 include/asm-powerpc/scatterlist.h         |    2 
 include/asm-sparc/scatterlist.h           |    2 
 include/asm-sparc64/scatterlist.h         |    2 
 include/asm-x86_64/dma-mapping.h          |    3 
 include/asm-x86_64/scatterlist.h          |    2 
 include/linux/i2o.h                       |    2 
 include/linux/ide.h                       |    2 
 include/linux/libata.h                    |   16 -
 include/linux/scatterlist.h               |   84 +++++++
 include/scsi/scsi.h                       |    7 
 include/scsi/scsi_cmnd.h                  |    3 
 lib/swiotlb.c                             |   19 +
 108 files changed, 1104 insertions(+), 744 deletions(-)



