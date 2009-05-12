Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbZELMka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbZELMka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 08:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZELMkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 08:40:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:52063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZELMkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 08:40:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Date: Tue, 12 May 2009 14:40:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20090511222702.352192505@arndb.de> <200905112238.55404.arnd@arndb.de> <4A08C9C0.6040202@pobox.com>
In-Reply-To: <4A08C9C0.6040202@pobox.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905121440.09315.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18qK67kMFouM/hIxufkeCQkYtPqpW9M4JKLwe5
 ZPrWJyRGfGj+m6612gMjWuDxbMwwNMdo2ZoKlngmwtZYmy9tS0
 kSy57Tq0kVVm43c1PRCdA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Jeff Garzik wrote:
> > --- a/drivers/ata/Kconfig
> > +++ b/drivers/ata/Kconfig
> > @@ -4,7 +4,7 @@
> >  
> >  menuconfig ATA
> >       tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
> > -     depends on HAS_IOMEM
> > +     depends on HAS_IOMEM && HAS_DMA
> >       depends on BLOCK
> >       depends on !(M32R || M68K) || BROKEN
> 
> What specifically is breaking?
> 
> Ideally we should be able to work with PIO-only...

CONFIG_HAS_DMA is not set on architectures that are missing
asm/dma-mapping.h or fall back to asm-generic/dma-mapping-broken.h.

In the latter case, you get a link error:
drivers/built-in.o: In function `sas_issue_ata_cmd':
/home/arnd/linux/linux-2.6/drivers/scsi/libsas/sas_ata.c(.text+0x33c50): undefined reference to `dma_map_sg'
/home/arnd/linux/linux-2.6/drivers/scsi/libsas/sas_ata.c(.text+0x33ef0): undefined reference to `dma_unmap_sg'
drivers/built-in.o: In function `ata_sg_clean':
/home/arnd/linux/linux-2.6/drivers/ata/libata-core.c(.text+0x37d18): undefined reference to `dma_unmap_sg'
drivers/built-in.o: In function `ata_qc_issue':
/home/arnd/linux/linux-2.6/drivers/ata/libata-core.c(.text+0x38774): undefined reference to `dma_map_sg'
drivers/built-in.o: In function `ata_port_start':
/home/arnd/linux/linux-2.6/drivers/ata/libata-core.c(.text+0x3bf0c): undefined reference to `dmam_alloc_coherent'

A slightly less naive (but still suboptimal) fix would be the patch below.
I could not find an easy way to force all devices to use PIO, this
patch would simply fail if someone tried to set a DMA mode.

	Arnd <><

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4629,6 +4629,7 @@ static unsigned int ata_dev_init_params(struct ata_device *dev,
  */
 void ata_sg_clean(struct ata_queued_cmd *qc)
 {
+#ifdef CONFIG_HAS_DMA
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->sg;
 	int dir = qc->dma_dir;
@@ -4642,6 +4643,7 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 
 	qc->flags &= ~ATA_QCFLAG_DMAMAP;
 	qc->sg = NULL;
+#endif /* CONFIG_HAS_DMA */
 }
 
 /**
@@ -4743,6 +4745,7 @@ void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
  */
 static int ata_sg_setup(struct ata_queued_cmd *qc)
 {
+#ifdef CONFIG_HAS_DMA
 	struct ata_port *ap = qc->ap;
 	unsigned int n_elem;
 
@@ -4758,6 +4761,10 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 	qc->flags |= ATA_QCFLAG_DMAMAP;
 
 	return 0;
+#else
+	DPRINTK("attempted to use DMA on incompatible architecture\n");
+	return -EINVAL;
+#endif /* CONFIG_HAS_DMA */
 }
 
 /**
@@ -5450,8 +5457,12 @@ int ata_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->dev;
 
+#ifdef CONFIG_HAS_DMA
 	ap->prd = dmam_alloc_coherent(dev, ATA_PRD_TBL_SZ, &ap->prd_dma,
 				      GFP_KERNEL);
+#else
+	ap->prd = devres_alloc(dev, ATA_PRD_TBL_SZ, GFP_KERNEL);
+#endif /* CONFIG_HAS_DMA */
 	if (!ap->prd)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index 59e00fa..e00271f 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -34,6 +34,7 @@ config SCSI_SAS_ATA
 	bool "ATA support for libsas (requires libata)"
 	depends on SCSI_SAS_LIBSAS
 	depends on ATA = y || ATA = SCSI_SAS_LIBSAS
+	depends on HAS_DMA
 	help
 		Builds in ATA support into libsas.  Will necessitate
 		the loading of libata along with libsas.
