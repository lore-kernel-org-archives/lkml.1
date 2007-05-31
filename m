Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbXEaPLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbXEaPLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXEaPLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:11:11 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:12683 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbXEaPLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:11:09 -0400
Date: Thu, 31 May 2007 17:11:07 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       SCSI development list <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: 2.6.22-rc3-mm1
Message-ID: <20070531171107.3d665158@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <465EC101.7010105@garzik.org>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com>
	<20070531121557.GQ23968@parisc-linux.org>
	<20070531142048.05edf133@gondolin.boeblingen.de.ibm.com>
	<465EC101.7010105@garzik.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 08:35:13 -0400,
Jeff Garzik <jeff@garzik.org> wrote:

> Cornelia Huck wrote:
> > On Thu, 31 May 2007 06:15:57 -0600,
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > 
> >> On Thu, May 31, 2007 at 02:09:22PM +0200, Cornelia Huck wrote:
> >>> I split those functions out into a new file. Builds on s390 and i386.
> >> Why not just put #ifdef CONFIG_HAS_DMA / #endif around the pair of
> >> functions?  I don't see the need to add a new Kconfig symbol and a new
> >> file for this.
> > 
> > I prefer a new file over #ifdefs in c files. (New dma-dependent stuff
> > would also have a place where it could go to.)
> > 
> > But I'll do whatever ends up as consensus :)
> 
> 50 lines isn't much need for a new file.

OK, so here's an alternative patch:


scsi: Don't build scsi_dma_{map,unmap} for !HAS_DMA

Use #ifdef CONFIG_HAS_DMA for the two dma-dependent functions.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/scsi/scsi_lib.c  |    2 ++
 include/scsi/scsi_cmnd.h |    2 ++
 2 files changed, 4 insertions(+)

--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -2291,6 +2291,7 @@ void scsi_kunmap_atomic_sg(void *virt)
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
 
+#ifdef CONFIG_HAS_DMA
 /**
  * scsi_dma_map - perform DMA mapping against command's sg lists
  * @cmd:	scsi command
@@ -2328,3 +2329,4 @@ void scsi_dma_unmap(struct scsi_cmnd *cm
 	}
 }
 EXPORT_SYMBOL(scsi_dma_unmap);
+#endif
--- linux-2.6.orig/include/scsi/scsi_cmnd.h
+++ linux-2.6/include/scsi/scsi_cmnd.h
@@ -135,8 +135,10 @@ extern void scsi_kunmap_atomic_sg(void *
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+#ifdef CONFIG_HAS_DMA
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
+#endif
 
 #define scsi_sg_count(cmd) ((cmd)->use_sg)
 #define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
