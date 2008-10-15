Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYJOTut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYJOTut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYJOTuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:50:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:59673 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbYJOTuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=FL61y4ULD7sDYhgZfM0ddNtU8ne1Lq3l/7G11WQIF7rQH+Puf9QywWQWShz2figHza
         aptxmNQ5OO2RfO9mtscjWQXHGlaXpn3tkh2bVsIf+6oqBJj+e/I/w1bMj7iyC05tm94s
         2ezGOrJu+kXyWgy+xTUiW/g8rbOrVadYCsAto=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 1/2] hpt366: add hpt3xx_disable_fast_irq() helper
Date: Wed, 15 Oct 2008 20:11:18 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200808021915.03424.bzolnier@gmail.com> <48F50649.9080507@ru.mvista.com>
In-Reply-To: <48F50649.9080507@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810152011.18478.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 October 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > * Factor out disabling of "fast interrupt" prediction from
> >   init_hwif_hpt366() to hpt3xx_disable_fast_irq() helper.
> 
> > * Use hpt3xx_disable_fast_irq() in ->init_chipset instead of
> >   ->init_hwif method.
> 
> >   This is a preparation for adding proper PCI PM support.
> 
> > While at it:
> 
> > * Cache chip type in chip_type variable in hpt3xx_disable_fast_irq().
> 
> > There should be no functional changes caused by this patch.
> 
>     Except a warning. ;-)

Sorry for that but... shit happens. ;)

> > Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> > Index: b/drivers/ide/pci/hpt366.c
> > ===================================================================
> > --- a/drivers/ide/pci/hpt366.c
> > +++ b/drivers/ide/pci/hpt366.c
> > @@ -1265,7 +1297,6 @@ static void __devinit init_hwif_hpt366(i
> >  	struct hpt_info *info	= host->host_priv + (hwif->dev == host->dev[1]);
> >  	int serialize		= HPT_SERIALIZE_IO;
> >  	u8  chip_type		= info->chip_type;
> > -	u8  new_mcr, old_mcr	= 0;
> >  
> >  	/* Cache the channel's MISC. control registers' offset */
> >  	hwif->select_data	= hwif->channel ? 0x54 : 0x50;
> > @@ -1288,29 +1319,6 @@ static void __devinit init_hwif_hpt366(i
> >  	/* Serialize access to this device if needed */
> >  	if (serialize && hwif->mate)
> >  		hwif->serialized = hwif->mate->serialized = 1;
> > -
> > -	/*
> > -	 * Disable the "fast interrupt" prediction.  Don't hold off
> > -	 * on interrupts. (== 0x01 despite what the docs say)
> > -	 */
> > -	pci_read_config_byte(dev, hwif->select_data + 1, &old_mcr);
> > -
> > -	if (info->chip_type >= HPT374)
> > -		new_mcr = old_mcr & ~0x07;
> > -	else if (info->chip_type >= HPT370) {
> > -		new_mcr = old_mcr;
> > -		new_mcr &= ~0x02;
> > -
> > -#ifdef HPT_DELAY_INTERRUPT
> > -		new_mcr &= ~0x01;
> > -#else
> > -		new_mcr |=  0x01;
> > -#endif
> > -	} else					/* HPT366 and HPT368  */
> > -		new_mcr = old_mcr & ~0x80;
> > -
> > -	if (new_mcr != old_mcr)
> > -		pci_write_config_byte(dev, hwif->select_data + 1, new_mcr);
> >  }
> 
>    CC      drivers/ide/pci/hpt366.o
> drivers/ide/pci/hpt366.c: In function `init_hwif_hpt366':
> drivers/ide/pci/hpt366.c:1290: warning: unused variable `dev'
> 
>     You've removed the users of that variable but left the variable itself... 
> alas, it's too late to fix the patch. :-/

Not such a big deal, we just have to make an another one...

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] hpt366: fix compile warning

Fixup for commit 1785192b5310ee25165768f5bb80f13146788e3e
("hpt366: add hpt3xx_disable_fast_irq() helper"):

   CC      drivers/ide/pci/hpt366.o
drivers/ide/pci/hpt366.c: In function `init_hwif_hpt366':
drivers/ide/pci/hpt366.c:1290: warning: unused variable `dev'

Reported-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/hpt366.c |    1 -
 1 file changed, 1 deletion(-)

Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1289,7 +1289,6 @@ static u8 hpt3xx_cable_detect(ide_hwif_t
 
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
