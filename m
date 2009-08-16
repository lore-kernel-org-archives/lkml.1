Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZHPPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZHPPez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZHPPey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:34:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58502 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465AbZHPPex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:34:53 -0400
Subject: Re: sata AHCI controller over non-PCI bus
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Subbrathnam, Swaminathan" <swami.iyer@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A88014D.9060309@garzik.org>
References: <FCCFB4CDC6E5564B9182F639FC35608702F5989152@dbde02.ent.ti.com>
	 <4A7FE245.8020002@ru.mvista.com>
	 <FCCFB4CDC6E5564B9182F639FC35608702F59891CB@dbde02.ent.ti.com>
	 <4A88014D.9060309@garzik.org>
Content-Type: text/plain
Date: Sun, 16 Aug 2009 10:34:52 -0500
Message-Id: <1250436892.3856.87.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-16 at 08:53 -0400, Jeff Garzik wrote:
> Subbrathnam, Swaminathan wrote:
> > Jeff,
> > 	From the below link (from Sergei) it seems that you have already re-factored the AHCI implementation dependency on PCI.  I would like to add support for the OMAPL138 SATA on top of your changes.  That would be the ideal way forward for me.
> > 
> > 	Have the ahci re-factoring changes queued for mainline merge already?  I just joined the list and hence do not know the status.
> > 
> > Sergei,
> > 	Appreciate the response.
> 
> I store the refactoring in git, on the "libahci" branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 
> Unfortunately, I am having second thoughts about an element of the 
> current design.  With current Linux distributions, they do not appear to 
> deal well with the multi-module dependency libata -> libahci -> ahci. 
> If I had to guess, I would say that mkinitrd creation tools only look at 
> one tree level's worth of kernel module dependencies.
> 
> Thus, ahci would wind up -not- in initrd, in a libahci solution.
> 
> I am thinking that I will just add Marvell and ATP support to ahci.c, 
> and let someone else deal with libahci separation -- which is still needed.
> 
> At this point, I would rather get Marvell/ATP support into users' hands, 
> rather than wait for distros to catch up to modern technology.

Can't you get the best of both worlds?  Do the separation but
artificially glue them together again as a module at link time.  This
solves the current distro problem and you can remove the linker hack as
soon as the distros get their act together.

James

---

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 9f7b500..10101d7 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,8 +1,10 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
-obj-$(CONFIG_SATA_AHCI)		+= libahci.o ahci.o
-obj-$(CONFIG_SATA_ACARD_AHCI)	+= libahci.o acard-ahci.o
+obj-$(CONFIG_SATA_AHCI)		+= ahci_mod.o
+obj-ahci_mod-y			+= libahci.o ahci.o
+obj-ahci_mod-$(CONFIG_SATA_ACARD_AHCI)	+= acard-ahci.o
+obj-ahci_mod-$(CONFIG_SATA_MV_AHCI)	+= mv-ahci.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
@@ -15,7 +17,6 @@ obj-$(CONFIG_SATA_SIS)		+= sata_sis.o
 obj-$(CONFIG_SATA_SX4)		+= sata_sx4.o
 obj-$(CONFIG_SATA_NV)		+= sata_nv.o
 obj-$(CONFIG_SATA_ULI)		+= sata_uli.o
-obj-$(CONFIG_SATA_MV_AHCI)	+= libahci.o mv-ahci.o
 obj-$(CONFIG_SATA_MV)		+= sata_mv.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o


