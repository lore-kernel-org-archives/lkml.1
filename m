Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbYFOSwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbYFOSwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 14:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYFOSwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 14:52:45 -0400
Received: from aun.it.uu.se ([130.238.12.36]:63167 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYFOSwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 14:52:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18517.25839.523939.668307@harpo.it.uu.se>
Date: Sun, 15 Jun 2008 20:52:31 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG] IDE: 2.6.26-rc5-git5 ide_generic leaks resources breaking my NE2000 NIC
In-Reply-To: <200806151612.21248.bzolnier@gmail.com>
References: <200806151155.m5FBtoou029056@harpo.it.uu.se>
	<200806151612.21248.bzolnier@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz writes:
 > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
 > Subject: [PATCH] ide-generic: don't probe all legacy ISA IDE ports by default
 > 
 > We can't probe all legacy ISA IDE ports by default as the resources may be
 > occupied by other ISA devices.  Add "probe_mask" module parameter and probe
 > only first two ISA IDE ports by default leaving the decision about probing
 > the rest to the user (systems with ISA ide2-6 should be very, very rare).
 > 
 > This fixes a regression caused by:
 > 
 > commit 343a3451e20314d5959b59b992e33fbaadfe52bf
 > Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
 > Date:   Tue Jun 10 20:56:36 2008 +0200
 > 
 >     ide-generic: add missing hwif->chipset setup
 > ...
 > 
 > Reported-by: Mikael Pettersson <mikpe@it.uu.se>
 > Bisected-by: Mikael Pettersson <mikpe@it.uu.se>
 > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
 > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

This fixes the regression on my old box. Thanks.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>

 > ---
 >  drivers/ide/ide-generic.c |    9 ++++++++-
 >  1 file changed, 8 insertions(+), 1 deletion(-)
 > 
 > Index: b/drivers/ide/ide-generic.c
 > ===================================================================
 > --- a/drivers/ide/ide-generic.c
 > +++ b/drivers/ide/ide-generic.c
 > @@ -22,6 +22,10 @@
 >  
 >  #define DRV_NAME	"ide_generic"
 >  
 > +static int probe_mask = 0x03;
 > +module_param(probe_mask, int, 0);
 > +MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
 > +
 >  static ssize_t store_add(struct class *cls, const char *buf, size_t n)
 >  {
 >  	ide_hwif_t *hwif;
 > @@ -89,6 +93,9 @@ static int __init ide_generic_init(void)
 >  	u8 idx[MAX_HWIFS];
 >  	int i;
 >  
 > +	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
 > +			 "parameter for probing all legacy ISA IDE ports\n");
 > +
 >  	for (i = 0; i < MAX_HWIFS; i++) {
 >  		ide_hwif_t *hwif;
 >  		unsigned long io_addr = ide_default_io_base(i);
 > @@ -96,7 +103,7 @@ static int __init ide_generic_init(void)
 >  
 >  		idx[i] = 0xff;
 >  
 > -		if (io_addr) {
 > +		if ((probe_mask & (1 << i)) && io_addr) {
 >  			if (!request_region(io_addr, 8, DRV_NAME)) {
 >  				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
 >  						"not free.\n",
 > 
