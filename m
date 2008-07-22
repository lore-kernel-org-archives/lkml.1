Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbYGVUu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbYGVUu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYGVUu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:50:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:54898 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbYGVUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=R1yneZtWHYwPD7Bt+5J+WVLRKaqLdWImkTulHTIOkJtDnYBDkPa0ZYMCh1wIJwJNLy
         Bubo59Dg9gEQUo5pfIwzLB0a4MUjpNJbp5zK/e4yq82x+hlW1wY3lkYjXAw9G9rc/Mrt
         aOUS4SFlk6Lx/Gu53gOSw+nCSmTHEgAfN4+Mk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ide: use proper printk() KERN_* levels in ide-probe.c
Date: Tue, 22 Jul 2008 22:44:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807212108.15505.bzolnier@gmail.com> <20080721214535.6de8c6a0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080721214535.6de8c6a0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807222244.38752.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2008, Alan Cox wrote:
> On Mon, 21 Jul 2008 21:08:15 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > While at it:
> > 
> > - fixup printk() messages in save_match() and hwif_init().
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-probe.c |   54 ++++++++++++++++++++++++++----------------------
> >  1 file changed, 30 insertions(+), 24 deletions(-)
> > 
> > Index: b/drivers/ide/ide-probe.c
> > ===================================================================
> > --- a/drivers/ide/ide-probe.c
> > +++ b/drivers/ide/ide-probe.c
> > @@ -141,7 +141,8 @@ static inline void do_identify (ide_driv
> >  	 */
> >  	if ((id->model[0] == 'P' && id->model[1] == 'M') ||
> >  	    (id->model[0] == 'S' && id->model[1] == 'K')) {
> > -		printk("%s: EATA SCSI HBA %.10s\n", drive->name, id->model);
> > +		printk(KERN_ERR "%s: EATA SCSI HBA %.10s\n",
> > +			drive->name, id->model);
> 
> That isn't an error. It occurs normally using legacy IDE with an EATA HBA
> present in ATA emulating mode.

Thanks for noticing, fix below.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix for EATA SCSI HBA in ATA emulating mode

IDE probing code used to skip devices attached to EATA SCSI HBA
in ATA emulating mode but because of warm-plug support port I/O
resources are no longer freed if no devices are detected on a port
and the decision about the driver to use is left up to the user.

Remove no longer valid EATA SCSI HBA quirk from do_identify().

Noticed-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes before "ide: use proper printk() KERN_* levels in ide-probe.c"
patch in pata tree

 drivers/ide/ide-probe.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -134,18 +134,6 @@ static inline void do_identify (ide_driv
 #endif
 	ide_fix_driveid(id);
 
-#if defined (CONFIG_SCSI_EATA_PIO) || defined (CONFIG_SCSI_EATA)
-	/*
-	 * EATA SCSI controllers do a hardware ATA emulation:
-	 * Ignore them if there is a driver for them available.
-	 */
-	if ((id->model[0] == 'P' && id->model[1] == 'M') ||
-	    (id->model[0] == 'S' && id->model[1] == 'K')) {
-		printk("%s: EATA SCSI HBA %.10s\n", drive->name, id->model);
-		goto err_misc;
-	}
-#endif /* CONFIG_SCSI_EATA || CONFIG_SCSI_EATA_PIO */
-
 	/*
 	 *  WIN_IDENTIFY returns little-endian info,
 	 *  WIN_PIDENTIFY *usually* returns little-endian info.
