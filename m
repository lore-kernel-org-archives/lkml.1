Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbXEQG32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbXEQG32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXEQG3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:29:21 -0400
Received: from brick.kernel.dk ([80.160.20.94]:17612 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbXEQG3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:29:20 -0400
Date: Thu, 17 May 2007 08:27:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
Message-ID: <20070517062742.GW23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk> <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com> <20070515172001.GB23798@kernel.dk> <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com> <20070515175025.GE23798@kernel.dk> <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16 2007, Badari Pulavarty wrote:
> On Tue, 2007-05-15 at 19:50 +0200, Jens Axboe wrote:
> > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > On Tue, 2007-05-15 at 19:20 +0200, Jens Axboe wrote:
> > > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > > On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > Updated version of the patch - this time I'll just attach the patch
> > > > > > file...
> > > > > 
> > > > > Missing scatterlist.h inclusions..
> > > > > 
> > > > > drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_scatter???:
> > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
> > > > > of function ???for_each_sg???
> > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ???;??? before ???{???
> > > > > token
> > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ???tp???
> > > > > make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> > > > > 
> > > > > 
> > > > > drivers/scsi/qla2xxx/qla_iocb.c: In function ???qla24xx_build_scsi_iocbs???:
> > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
> > > > > function ???for_each_sg???
> > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ???;??? before ???{???
> > > > > token
> > > > 
> > > > Thanks, will fix those. What arch? I tested it here.
> > > 
> > > I am playing with them on ppc64.
> > 
> > Ah ok, you need the updated patch series for ppc64 support. Builds fine
> > here on ppc64. See the #sglist branch of the block repo:
> > 
> > git://git.kernel.dk/data/git/linux-2.6-block.git
> > 
> > I can mail you an updated patch, if you want.
> 
> 
> Here is the whole panic stack..

Thanks will fix that up, the IDE part is totally untested. Can you try
and backout this patch and see if it boots?

diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index ca0341c..3565c76 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -951,7 +951,8 @@ static int cris_ide_build_dmatable (ide_drive_t *drive)
 		/* group sequential buffers into one large buffer */
 		addr = page_to_phys(sg->page) + sg->offset;
 		size = sg_dma_len(sg);
-		while (sg++, --i) {
+		while (--i) {
+			sg = sg_next(sg);
 			if ((addr + size) != page_to_phys(sg->page) + sg->offset)
 				break;
 			size += sg_dma_len(sg);
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index b77b7d1..aa13309 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -292,7 +292,7 @@ int ide_build_dmatable (ide_drive_t *drive, struct request *rq)
 			}
 		}
 
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 30175c7..412ba5e 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -259,6 +259,7 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *cursg = hwif->cursg;
 	struct page *page;
 #ifdef CONFIG_HIGHMEM
 	unsigned long flags;
@@ -266,8 +267,14 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 	unsigned int offset;
 	u8 *buf;
 
-	page = sg[hwif->cursg].page;
-	offset = sg[hwif->cursg].offset + hwif->cursg_ofs * SECTOR_SIZE;
+	cursg = hwif->cursg;
+	if (!cursg) {
+		cursg = sg;
+		hwif->cursg = sg;
+	}
+
+	page = cursg->page;
+	offset = cursg->offset + hwif->cursg_ofs * SECTOR_SIZE;
 
 	/* get the current page and offset */
 	page = nth_page(page, (offset >> PAGE_SHIFT));
@@ -281,8 +288,8 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 	hwif->nleft--;
 	hwif->cursg_ofs++;
 
-	if ((hwif->cursg_ofs * SECTOR_SIZE) == sg[hwif->cursg].length) {
-		hwif->cursg++;
+	if ((hwif->cursg_ofs * SECTOR_SIZE) == cursg->length) {
+		hwif->cursg = sg_next(hwif->cursg);
 		hwif->cursg_ofs = 0;
 	}
 
@@ -363,6 +370,8 @@ static ide_startstop_t task_error(ide_drive_t *drive, struct request *rq,
 
 static void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 {
+	HWIF(drive)->cursg = NULL;
+
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = rq->special;
 
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index ca95e99..35b0d1e 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -324,7 +324,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 			cur_addr += tc;
 			cur_len -= tc;
 		}
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index d3185e2..511e734 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -531,7 +531,7 @@ sgiioc4_build_dma_table(ide_drive_t * drive, struct request *rq, int ddir)
 			}
 		}
 
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 45fc36f..2a7555d 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1648,7 +1648,7 @@ pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 			cur_len -= tc;
 			++table;
 		}
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 07aba87..fe81b05 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -764,7 +764,7 @@ typedef struct hwif_s {
 
 	unsigned int nsect;
 	unsigned int nleft;
-	unsigned int cursg;
+	struct scatterlist *cursg;
 	unsigned int cursg_ofs;
 
 	int		rqsize;		/* max sectors per request */

-- 
Jens Axboe

