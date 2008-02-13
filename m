Return-Path: <linux-kernel-owner+w=401wt.eu-S932834AbYBMSTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbYBMSTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbYBMSTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:19:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45907 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbYBMSTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:19:18 -0500
Date: Wed, 13 Feb 2008 10:16:55 -0800
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080213181655.GB8960@kroah.com>
References: <20080213001506.GA13933@kroah.com> <20080213021737.72b9815d@core> <20080213044536.GC10101@kroah.com> <200802131334.12351.bzolnier@gmail.com> <20080213172824.GB10733@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213172824.GB10733@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 09:28:24AM -0800, Greg KH wrote:
> On Wed, Feb 13, 2008 at 01:34:12PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 13 February 2008, Greg KH wrote:
> > > On Wed, Feb 13, 2008 at 02:17:37AM +0000, Alan Cox wrote:
> > > > > Why does the calgary driver need this?  Can we just use pci_get_device()
> > > > > instead?  Why do you need to walk the device list backwards?  Do you get
> > > > > false positives going forward?
> > > > 
> > > > It doesn't look to be performance critical so the driver can
> > > > pci_get_device until the end and use the final hit anyway.
> > > 
> > > That would make more sense.
> > > 
> > > > IDE reverse is more problematic but nobody seems to use it.
> > > 
> > > I've seen two posters say they use it.  I'm wondering what it is really
> > > solving if they use it, and why if it's really needed, scsi never had to
> > > implement such a hack...
> > 
> > It is no longer solving anything, just adds more pain. ;)
> > 
> > [ The option comes from 2.2.x (so long before LABEL=/ and /dev/disk/by-id/
> >   became popular).  Some "off-board" controllers integrated on motherboards
> >   used to appear before "on-board" IDE on PCI bus so this option was meant
> >   to preserve the legacy ordering. ]
> > 
> > Since it is valid only when "Probe IDE PCI devices in the PCI bus order
> > (DEPRECATED)" config option is used it is already on its way out (though
> > marking it as obsoleted would make it more explicit).
> > 
> > I think that removing "ide=reverse" in 2.6.26 would be OK...
> 
> Great, thanks for your blessing.  I'll make up a patch and send it to
> you for approval.

How does the patch below look?  I didn't want to remove the whole config
option, as there is more to the logic than just the "reverse order"
stuff there.

If you don't mind, can I take this through the PCI tree so as to allow
the removal of this pci function afterwards?

thanks,

greg k-h

--------
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: IDE: remove ide=reverse IDE core

This option is obsolete and can be removed safely.

It allows us to remove the pci_get_device_reverse() function from the
PCI core.


Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-scan-pci.c |    9 ++-------
 drivers/ide/ide.c          |   12 ------------
 include/linux/ide.h        |    1 -
 3 files changed, 2 insertions(+), 20 deletions(-)

--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -88,13 +88,8 @@ static int __init ide_scan_pcibus(void)
 	struct list_head *l, *n;
 
 	pre_init = 0;
-	if (!ide_scan_direction)
-		while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)))
-			ide_scan_pcidev(dev);
-	else
-		while ((dev = pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID,
-						     dev)))
-			ide_scan_pcidev(dev);
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)))
+		ide_scan_pcidev(dev);
 
 	/*
 	 *	Hand the drivers over to the PCI layer now we
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -92,10 +92,6 @@ static int system_bus_speed;	/* holds wh
 DEFINE_MUTEX(ide_cfg_mtx);
  __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 
-#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
-int ide_scan_direction; /* THIS was formerly 2.2.x pci=reverse */
-#endif
-
 int noautodma = 0;
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
@@ -1227,14 +1223,6 @@ static int __init ide_setup(char *s)
 		goto obsolete_option;
 	}
 
-#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
-	if (!strcmp(s, "ide=reverse")) {
-		ide_scan_direction = 1;
-		printk(" : Enabled support for IDE inverse scan order.\n");
-		return 1;
-	}
-#endif
-
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	if (!strcmp(s, "ide=noacpi")) {
 		//printk(" : Disable IDE ACPI support.\n");
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -988,7 +988,6 @@ extern void do_ide_request(struct reques
 void ide_init_disk(struct gendisk *, ide_drive_t *);
 
 #ifdef CONFIG_IDEPCI_PCIBUS_ORDER
-extern int ide_scan_direction;
 extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *owner, const char *mod_name);
 #define ide_pci_register_driver(d) __ide_pci_register_driver(d, THIS_MODULE, KBUILD_MODNAME)
 #else
