Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbZLCV56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbZLCV56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZLCV56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:57:58 -0500
Received: from mail-ew0-f222.google.com ([209.85.219.222]:42192 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZLCV55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=i6LQc/FyYy7PJnANCGuf7apTba9+nyM4Q2jreLKC8dklvOvhM4l9qMlQnzr5JJeGjo
         WoH5flqopReT+p3LBwogaXShM7lKpA3ld2KQLQTRqX2ETGX7WomDdQihM+0BBGST6FDc
         GHPiENuscsEKgT3d0uXcVMuRmTDqTzHlwETlM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Thu, 3 Dec 2009 22:56:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032242.05785.bzolnier@gmail.com> <4B1832CD.5040809@garzik.org>
In-Reply-To: <4B1832CD.5040809@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200912032256.39790.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 10:51:09 pm Jeff Garzik wrote:

> >>>         pata_via: clear UDMA transfer mode bit for PIO and MWDMA
> >>
> >> applied -- even though Alan's comment was correct.  It is standard
> >> kernel practice to place cosmetic changes into their own patches,
> >> because it is standard kernel practice to break up logically distinct
> >> changes.
> >
> > We are talking about:
> >
> >   pata_via.c |   19 +++++++++++++------
> >   1 file changed, 13 insertions(+), 6 deletions(-)
> >
> > patch here (http://lkml.org/lkml/2009/11/25/380) and cosmetic change
> > is clearly documented in the patch description.
> >
> >
> > Do people really wonder why I find upstream to be too much hassle to
> > deal with?
> 
> The thousand other kernel developers seem to be able to split up their 
> patches, separating out cosmetic changes from functional ones.  It has 
> clear engineering benefits, and has been standard practice for a decade 
> or more.
> 
> Why is it such an imposition for your patches to look like everyone 
> else's?  And by "everyone", I mean all other kernel developers, not just 
> other ATA developers.
> 
> You seem to consider standard kernel practice a hassle.  Separating out 
> cosmetic changes is not only a libata practice, it is the norm for the 
> entire kernel.

Indeed.

>From 94be9a58d7e683ac3c1df1858a17f09ebade8da0 Mon Sep 17 00:00:00 2001
From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 16 Jan 2009 10:17:09 -0500
Subject: [PATCH] [libata] get-identity ioctl: Fix use of invalid memory pointer
 for SAS drivers.

Caught by Ke Wei (and team?) at Marvell.

Also, move the ata_scsi_ioctl export to libata-scsi.c, as that seems to be the
general trend.

Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ata/libata-core.c           |    1 -
 drivers/ata/libata-scsi.c           |   17 +++++++++++++----
 drivers/scsi/ipr.c                  |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 include/linux/libata.h              |    2 ++
 5 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 71218d7..552ecae 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6638,7 +6638,6 @@ EXPORT_SYMBOL_GPL(ata_dev_pair);
 EXPORT_SYMBOL_GPL(ata_port_disable);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
 EXPORT_SYMBOL_GPL(ata_wait_register);
-EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_destroy);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9e92107..a1a6e62 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -423,9 +423,9 @@ int ata_std_bios_param(struct scsi_device *sdev, struct block_device *bdev,
  *	RETURNS:
  *	Zero on success, negative errno on error.
  */
-static int ata_get_identity(struct scsi_device *sdev, void __user *arg)
+static int ata_get_identity(struct ata_port *ap, struct scsi_device *sdev,
+			    void __user *arg)
 {
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
 	u16 __user *dst = arg;
 	char buf[40];
@@ -645,7 +645,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	return rc;
 }
 
-int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
+		     int cmd, void __user *arg)
 {
 	int val = -EINVAL, rc = -EINVAL;
 
@@ -663,7 +664,7 @@ int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 		return 0;
 
 	case HDIO_GET_IDENTITY:
-		return ata_get_identity(scsidev, arg);
+		return ata_get_identity(ap, scsidev, arg);
 
 	case HDIO_DRIVE_CMD:
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
@@ -682,6 +683,14 @@ int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ata_sas_scsi_ioctl);
+
+int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+{
+	return ata_sas_scsi_ioctl(ata_shost_to_port(scsidev->host),
+				scsidev, cmd, arg);
+}
+EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 
 /**
  *	ata_scsi_qc_new - acquire new ata_queued_cmd reference
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 841f460..0782900 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4912,7 +4912,7 @@ static int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	if (res && ipr_is_gata(res)) {
 		if (cmd == HDIO_GET_IDENTITY)
 			return -ENOTTY;
-		return ata_scsi_ioctl(sdev, cmd, arg);
+		return ata_sas_scsi_ioctl(res->sata_port->ap, sdev, cmd, arg);
 	}
 
 	return -EINVAL;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7448387..1c558d3 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -717,7 +717,7 @@ int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
 
 	if (dev_is_sata(dev))
-		return ata_scsi_ioctl(sdev, cmd, arg);
+		return ata_sas_scsi_ioctl(dev->sata_dev.ap, sdev, cmd, arg);
 
 	return -EINVAL;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b6b8a7f..73b69c7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -927,6 +927,8 @@ extern void ata_host_init(struct ata_host *, struct device *,
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
+extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
+			    int cmd, void __user *arg);
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
-- 
1.6.4.2



--
Bartlomiej Zolnierkiewicz
