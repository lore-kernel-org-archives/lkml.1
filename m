Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbXEJKXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbXEJKXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758748AbXEJKW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:22:29 -0400
Received: from brick.kernel.dk ([80.160.20.94]:8913 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbXEJKWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:22:25 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/13] Chaining sg lists for bio IO commands v3
Date: Thu, 10 May 2007 12:21:42 +0200
Message-Id: <11787925152319-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Third version of the patchset. Changes since v2:

- Get rid of ->next and use the ->page field as a next pointer.
  This saves some space in the scatterlist structure, at the cost
  of one extra sg segment per chained list. Should definitely be
  a space win.

- Cleanup linux/scatterlist.h, most of the stuff is outside
  the ARCH_HAS_SG_CHAIN ifdef now.

- Convert the x86-64 iommu code, enable it on x86-64.

- Convert all (hopefully) SCSI drivers to use the sg helpers so
  chaining can be supported globally. I collated all the SCSI
  driver patches into the 13/13 patch, as not to post a huge
  patch series. I would much appreciate some eye balls on this part,
  catching any dumb mistakes I may have made. The changes are usually
  trivial, but some are not and I do clown around occasionally :-)

Like v2, you still need to enable large commands manually for a
device, ala:

# cd /sys/block/sda/queue
# echo 1024 > max_segments
# cat max_hw_sectors_kb > max_sectors_kb

which would limit you to 1024 segments (effectively 8 scatterlists
chained), and should give you IO's of at least 4mb. You can go larger
than 1024, there's no real limit.

 arch/ia64/hp/sim/simscsi.c            |   23 +-
 arch/x86_64/kernel/pci-calgary.c      |   25 +-
 arch/x86_64/kernel/pci-gart.c         |   44 ++--
 arch/x86_64/kernel/pci-nommu.c        |    5 
 block/ll_rw_blk.c                     |   41 +++-
 crypto/digest.c                       |    2 
 crypto/scatterwalk.c                  |    2 
 crypto/scatterwalk.h                  |    2 
 drivers/ata/libata-core.c             |   30 +--
 drivers/infiniband/ulp/srp/ib_srp.c   |   22 +-
 drivers/scsi/3w-9xxx.c                |    8 
 drivers/scsi/3w-xxxx.c                |    8 
 drivers/scsi/53c700.c                 |   16 -
 drivers/scsi/BusLogic.c               |    7 
 drivers/scsi/NCR53c406a.c             |   18 +-
 drivers/scsi/a100u2w.c                |    9 -
 drivers/scsi/aacraid/aachba.c         |   29 +--
 drivers/scsi/advansys.c               |   21 +-
 drivers/scsi/aha1542.c                |   21 +-
 drivers/scsi/aha1740.c                |    8 
 drivers/scsi/aic7xxx/aic79xx_osm.c    |    3 
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |   12 -
 drivers/scsi/aic94xx/aic94xx_task.c   |    6 
 drivers/scsi/arcmsr/arcmsr_hba.c      |   11 -
 drivers/scsi/dc395x.c                 |    7 
 drivers/scsi/dpt_i2o.c                |   13 -
 drivers/scsi/eata.c                   |    8 
 drivers/scsi/esp_scsi.c               |    5 
 drivers/scsi/gdth.c                   |   45 ++---
 drivers/scsi/hptiop.c                 |    8 
 drivers/scsi/ibmmca.c                 |   11 -
 drivers/scsi/ibmvscsi/ibmvscsi.c      |    4 
 drivers/scsi/ide-scsi.c               |   31 ++-
 drivers/scsi/initio.c                 |   12 -
 drivers/scsi/ipr.c                    |    9 -
 drivers/scsi/ips.c                    |   74 ++++----
 drivers/scsi/iscsi_tcp.c              |   43 ++--
 drivers/scsi/jazz_esp.c               |   27 +--
 drivers/scsi/lpfc/lpfc_scsi.c         |    9 -
 drivers/scsi/mac53c94.c               |    9 -
 drivers/scsi/megaraid.c               |   13 -
 drivers/scsi/megaraid/megaraid_mbox.c |    7 
 drivers/scsi/megaraid/megaraid_sas.c  |   16 -
 drivers/scsi/mesh.c                   |   12 -
 drivers/scsi/ncr53c8xx.c              |    7 
 drivers/scsi/nsp32.c                  |    9 -
 drivers/scsi/pcmcia/sym53c500_cs.c    |   18 +-
 drivers/scsi/qla1280.c                |   66 ++++---
 drivers/scsi/qla2xxx/qla_iocb.c       |    9 -
 drivers/scsi/qla4xxx/ql4_iocb.c       |    8 
 drivers/scsi/qlogicfas408.c           |    9 -
 drivers/scsi/qlogicpti.c              |   15 -
 drivers/scsi/scsi_debug.c             |   14 -
 drivers/scsi/scsi_lib.c               |  230 +++++++++++++++++++-------
 drivers/scsi/scsi_tgt_lib.c           |    4 
 drivers/scsi/sym53c416.c              |    9 -
 drivers/scsi/sym53c8xx_2/sym_glue.c   |    7 
 drivers/scsi/u14-34f.c                |   10 -
 drivers/scsi/ultrastor.c              |   10 -
 drivers/scsi/wd7000.c                 |    7 
 include/asm-i386/dma-mapping.h        |   13 -
 include/asm-i386/scatterlist.h        |    2 
 include/asm-x86_64/dma-mapping.h      |    3 
 include/asm-x86_64/scatterlist.h      |    2 
 include/linux/libata.h                |   16 +
 include/linux/scatterlist.h           |   55 ++++++
 include/scsi/scsi.h                   |    7 
 include/scsi/scsi_cmnd.h              |    3 
 68 files changed, 753 insertions(+), 516 deletions(-)


