Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYGEMvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYGEMvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 08:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYGEMvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 08:51:09 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:10928 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYGEMvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 08:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=f6Vilxs6hoWh9ZSZq9/21bJqk/mPAU3I/2TFewmSohJzf8ewClMOsPeg/A0YS9Zzkx
         CtkAbJHvyocdc8YxDeqbDcAD1gzUS+hPn1W8B1n4D1gNqNSEY37BCLbFmZTv97/XkkFT
         37cN66iP1OBNfmYvpKIzQyZuwvRloD6luYUqo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [regression] Re: 2.6.26-rc6: pcmcia stopped working
Date: Sat, 5 Jul 2008 14:48:40 +0200
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org,
       linux-ide@vger.kernel.org, Greg KH <greg@kroah.com>
References: <20080622224022.GA2066@elf.ucw.cz> <20080625220946.GA1587@elf.ucw.cz> <20080625221529.GA1600@elf.ucw.cz>
In-Reply-To: <20080625221529.GA1600@elf.ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807051448.40466.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 26 June 2008, Pavel Machek wrote:
> Hi!
> 
> > > Hmm, hitting sysrq-w produces no blocked task until I eject pcmcia
> > > card. Backtrace there is:
> > > 
> > > Greg, I believe some traces lead to sysfs, can you help here?
> > 
> > ide_unregister() does not complete :-(.
> > 
> >         device_unregister(&hwif->gendev);
> > +       printk("ide_unregister: waiting for rel_comp\n");
> >         wait_for_completion(&hwif->gendev_rel_comp);
> > 
> > ...that wait_for_completion never returns.

[...]

Thanks for narrowing it down to wait_for_completion() call,
it was an useful hint.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix hwif->gendev refcounting

class->dev_release is called by device_release() iff dev->release
is not present so ide_port_class_release() is never called and the
last hwif->gendev reference is not dropped.

Fix it by removing ide_port_class_release() and get_device() call
from ide_register_port() (device_create_drvdata() takes a hwif->gendev
reference anyway).

This patch fixes hang on wait_for_completion(&hwif->gendev_rel_comp)
in ide_unregister() reported by Pavel Machek.

Cc: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    2 --
 drivers/ide/ide.c       |    8 --------
 2 files changed, 10 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -646,8 +646,6 @@ static int ide_register_port(ide_hwif_t 
 		goto out;
 	}
 
-	get_device(&hwif->gendev);
-
 	hwif->portdev = device_create_drvdata(ide_port_class, &hwif->gendev,
 					      MKDEV(0, 0), hwif, hwif->name);
 	if (IS_ERR(hwif->portdev)) {
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1094,13 +1094,6 @@ struct bus_type ide_bus_type = {
 
 EXPORT_SYMBOL_GPL(ide_bus_type);
 
-static void ide_port_class_release(struct device *portdev)
-{
-	ide_hwif_t *hwif = dev_get_drvdata(portdev);
-
-	put_device(&hwif->gendev);
-}
-
 int ide_vlb_clk;
 EXPORT_SYMBOL_GPL(ide_vlb_clk);
 
@@ -1305,7 +1298,6 @@ static int __init ide_init(void)
 		ret = PTR_ERR(ide_port_class);
 		goto out_port_class;
 	}
-	ide_port_class->dev_release = ide_port_class_release;
 
 	init_ide_data();
 
