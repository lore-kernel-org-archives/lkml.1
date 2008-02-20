Return-Path: <linux-kernel-owner+w=401wt.eu-S932254AbYBTTt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbYBTTt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbYBTTtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:49:15 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:50932 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbYBTTtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:49:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bAR89AF1lgAjD5uJAHZOYFQJRlKe9mcXricAnmRUPYTIHmMBCK4s537fZLsqy1ZbeiQ/lfJbZ3eJFJjTg6VwNgYp3qeLqsVYSguv+aE0+05Qi9GWSIU4nTgCNImgO0hR7QJXQPUSURf7AoLGcLp5khyznW9Fi1HUJTwde/3+9cU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] falconide: fix resources reservation
Date: Wed, 20 Feb 2008 21:03:09 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
References: <200802200150.26989.bzolnier@gmail.com> <Pine.LNX.4.64.0802201039520.19893@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0802201039520.19893@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802202103.09560.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008, Geert Uytterhoeven wrote:
> On Wed, 20 Feb 2008, Bartlomiej Zolnierkiewicz wrote:
> > * Tell IDE layer to not manage resources by setting
> >   hwif->mmio flag and request resources in falconide_init().
> > 
> > * Use request_mem_region() for resources reservation.
> > 
> > * Use driver name for resources reservation.
> > 
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Michael Schmitz <schmitz@debian.org>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/legacy/falconide.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > Index: b/drivers/ide/legacy/falconide.c
> > ===================================================================
> > --- a/drivers/ide/legacy/falconide.c
> > +++ b/drivers/ide/legacy/falconide.c
> > @@ -22,6 +22,7 @@
> >  #include <asm/atariints.h>
> >  #include <asm/atari_stdma.h>
> >  
> > +#define DRV_NAME "falconide"
> >  
> >      /*
> >       *  Base of the IDE interface
> > @@ -74,6 +75,11 @@ static int __init falconide_init(void)
> >  
> >  	printk(KERN_INFO "ide: Falcon IDE controller\n");
> >  
> > +	if (!request_mem_region(ATA_HD_BASE, 0x40, DRV_NAME)) {
> > +		printk(KERN_ERR "%s: resources busy\n");
>                                  ^^
> Woops, missing parameter?

thanks, fixed

> pr_error()?

dunno...

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] falconide: fix resources reservation (take 2)

* Tell IDE layer to not manage resources by setting
  hwif->mmio flag and request resources in falconide_init().

* Use request_mem_region() for resources reservation.

* Use driver name for resources reservation.

v2:
* Fix missing printk() parameter. (Noticed by Geert Uytterhoeven)

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@debian.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/falconide.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -22,6 +22,7 @@
 #include <asm/atariints.h>
 #include <asm/atari_stdma.h>
 
+#define DRV_NAME "falconide"
 
     /*
      *  Base of the IDE interface
@@ -74,6 +75,11 @@ static int __init falconide_init(void)
 
 	printk(KERN_INFO "ide: Falcon IDE controller\n");
 
+	if (!request_mem_region(ATA_HD_BASE, 0x40, DRV_NAME)) {
+		printk(KERN_ERR "%s: resources busy\n", DRV_NAME);
+		return -EBUSY;
+	}
+
 	falconide_setup_ports(&hw);
 
 	hwif = ide_find_port();
@@ -83,6 +89,7 @@ static int __init falconide_init(void)
 
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
+		hwif->mmio = 1;
 
 		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
