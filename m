Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbXJKTMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbXJKTMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbXJKTMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:12:48 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33261 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbXJKTMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:12:47 -0400
Date: Thu, 11 Oct 2007 15:12:46 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ISDN/hysdn: convert to PCI hotplug API
Message-ID: <20071011191246.GA23826@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
This is a re-send of a previously sent patch.

This patch is UNTESTED, and it would be nice to at least get somebody
to say it works before queueing it in the ISDN tree (for upstream)
or whatever.

As such, I will make sure the patch stays alive, until its tested,
but am not requesting that it be upstreamed at this time.


 drivers/isdn/hysdn/hysdn_init.c |  274 ++++++++++++++++++----------------------
 1 file changed, 130 insertions(+), 144 deletions(-)

98064f35b2afa503ded1c425276dc07e328e5a96
diff --git a/drivers/isdn/hysdn/hysdn_init.c b/drivers/isdn/hysdn/hysdn_init.c
index 9e01748..b7cc5c2 100644
--- a/drivers/isdn/hysdn/hysdn_init.c
+++ b/drivers/isdn/hysdn/hysdn_init.c
@@ -20,10 +20,15 @@
 #include "hysdn_defs.h"
 
 static struct pci_device_id hysdn_pci_tbl[] = {
-	{PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX, PCI_ANY_ID, PCI_SUBDEVICE_ID_HYPERCOPE_METRO},
-	{PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX, PCI_ANY_ID, PCI_SUBDEVICE_ID_HYPERCOPE_CHAMP2},
-	{PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX, PCI_ANY_ID, PCI_SUBDEVICE_ID_HYPERCOPE_ERGO},
-	{PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX, PCI_ANY_ID, PCI_SUBDEVICE_ID_HYPERCOPE_OLD_ERGO},
+	{ PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
+	  PCI_ANY_ID, PCI_SUBDEVICE_ID_HYPERCOPE_METRO, 0, 0, BD_METRO },
+	{ PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
+	  PCI_ANY_ID, PCI_SUBDEVICE_ID_HYPERCOPE_CHAMP2, 0, 0, BD_CHAMP2 },
+	{ PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
+	  PCI_ANY_ID, PCI_SUBDEVICE_ID_HYPERCOPE_ERGO, 0, 0, BD_ERGO },
+	{ PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
+	  PCI_ANY_ID, PCI_SUBDEVICE_ID_HYPERCOPE_OLD_ERGO, 0, 0, BD_ERGO },
+
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, hysdn_pci_tbl);
@@ -34,128 +39,7 @@ MODULE_LICENSE("GPL");
 static char *hysdn_init_revision = "$Revision: 1.6.6.6 $";
 static int cardmax;		/* number of found cards */
 hysdn_card *card_root = NULL;	/* pointer to first card */
-
-/**********************************************/
-/* table assigning PCI-sub ids to board types */
-/* the last entry contains all 0              */
-/**********************************************/
-static struct {
-	unsigned short subid;		/* PCI sub id */
-	unsigned char cardtyp;		/* card type assigned */
-} pci_subid_map[] = {
-
-	{
-		PCI_SUBDEVICE_ID_HYPERCOPE_METRO, BD_METRO
-	},
-	{
-		PCI_SUBDEVICE_ID_HYPERCOPE_CHAMP2, BD_CHAMP2
-	},
-	{
-		PCI_SUBDEVICE_ID_HYPERCOPE_ERGO, BD_ERGO
-	},
-	{
-		PCI_SUBDEVICE_ID_HYPERCOPE_OLD_ERGO, BD_ERGO
-	},
-	{
-		0, 0
-	}			/* terminating entry */
-};
-
-
-/*********************************************************************/
-/* search_cards searches for available cards in the pci config data. */
-/* If a card is found, the card structure is allocated and the cards */
-/* ressources are reserved. cardmax is incremented.                  */
-/*********************************************************************/
-static void
-search_cards(void)
-{
-	struct pci_dev *akt_pcidev = NULL;
-	hysdn_card *card, *card_last;
-	int i;
-
-	card_root = NULL;
-	card_last = NULL;
-	while ((akt_pcidev = pci_find_device(PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
-					     akt_pcidev)) != NULL) {
-		if (pci_enable_device(akt_pcidev))
-			continue;
-
-		if (!(card = kzalloc(sizeof(hysdn_card), GFP_KERNEL))) {
-			printk(KERN_ERR "HYSDN: unable to alloc device mem \n");
-			return;
-		}
-		card->myid = cardmax;	/* set own id */
-		card->bus = akt_pcidev->bus->number;
-		card->devfn = akt_pcidev->devfn;	/* slot + function */
-		card->subsysid = akt_pcidev->subsystem_device;
-		card->irq = akt_pcidev->irq;
-		card->iobase = pci_resource_start(akt_pcidev, PCI_REG_PLX_IO_BASE);
-		card->plxbase = pci_resource_start(akt_pcidev, PCI_REG_PLX_MEM_BASE);
-		card->membase = pci_resource_start(akt_pcidev, PCI_REG_MEMORY_BASE);
-		card->brdtype = BD_NONE;	/* unknown */
-		card->debug_flags = DEF_DEB_FLAGS;	/* set default debug */
-		card->faxchans = 0;	/* default no fax channels */
-		card->bchans = 2;	/* and 2 b-channels */
-		for (i = 0; pci_subid_map[i].subid; i++)
-			if (pci_subid_map[i].subid == card->subsysid) {
-				card->brdtype = pci_subid_map[i].cardtyp;
-				break;
-			}
-		if (card->brdtype != BD_NONE) {
-			if (ergo_inithardware(card)) {
-				printk(KERN_WARNING "HYSDN: card at io 0x%04x already in use\n", card->iobase);
-				kfree(card);
-				continue;
-			}
-		} else {
-			printk(KERN_WARNING "HYSDN: unknown card id 0x%04x\n", card->subsysid);
-			kfree(card);	/* release mem */
-			continue;
-		}
-		cardmax++;
-		card->next = NULL;	/*end of chain */
-		if (card_last)
-			card_last->next = card;		/* pointer to next card */
-		else
-			card_root = card;
-		card_last = card;	/* new chain end */
-	}			/* device found */
-}				/* search_cards */
-
-/************************************************************************************/
-/* free_resources frees the acquired PCI resources and returns the allocated memory */
-/************************************************************************************/
-static void
-free_resources(void)
-{
-	hysdn_card *card;
-
-	while (card_root) {
-		card = card_root;
-		if (card->releasehardware)
-			card->releasehardware(card);	/* free all hardware resources */
-		card_root = card_root->next;	/* remove card from chain */
-		kfree(card);	/* return mem */
-
-	}			/* while card_root */
-}				/* free_resources */
-
-/**************************************************************************/
-/* stop_cards disables (hardware resets) all cards and disables interrupt */
-/**************************************************************************/
-static void
-stop_cards(void)
-{
-	hysdn_card *card;
-
-	card = card_root;	/* first in chain */
-	while (card) {
-		if (card->stopcard)
-			card->stopcard(card);
-		card = card->next;	/* remove card from chain */
-	}			/* while card */
-}				/* stop_cards */
+static hysdn_card *card_last = NULL;	/* pointer to first card */
 
 
 /****************************************************************************/
@@ -191,31 +75,138 @@ hysdn_getrev(const char *revision)
 /* and the module is added to the list in /proc/modules, otherwise an error */
 /* is assumed and the module will not be kept in memory.                    */
 /****************************************************************************/
+
+static int __devinit hysdn_pci_init_one(struct pci_dev *akt_pcidev,
+					const struct pci_device_id *ent)
+{
+	hysdn_card *card;
+	int rc;
+
+	rc = pci_enable_device(akt_pcidev);
+	if (rc)
+		return rc;
+
+	if (!(card = kzalloc(sizeof(hysdn_card), GFP_KERNEL))) {
+		printk(KERN_ERR "HYSDN: unable to alloc device mem \n");
+		rc = -ENOMEM;
+		goto err_out;
+	}
+	card->myid = cardmax;	/* set own id */
+	card->bus = akt_pcidev->bus->number;
+	card->devfn = akt_pcidev->devfn;	/* slot + function */
+	card->subsysid = akt_pcidev->subsystem_device;
+	card->irq = akt_pcidev->irq;
+	card->iobase = pci_resource_start(akt_pcidev, PCI_REG_PLX_IO_BASE);
+	card->plxbase = pci_resource_start(akt_pcidev, PCI_REG_PLX_MEM_BASE);
+	card->membase = pci_resource_start(akt_pcidev, PCI_REG_MEMORY_BASE);
+	card->brdtype = BD_NONE;	/* unknown */
+	card->debug_flags = DEF_DEB_FLAGS;	/* set default debug */
+	card->faxchans = 0;	/* default no fax channels */
+	card->bchans = 2;	/* and 2 b-channels */
+	card->brdtype = ent->driver_data;
+
+	if (ergo_inithardware(card)) {
+		printk(KERN_WARNING "HYSDN: card at io 0x%04x already in use\n", card->iobase);
+		rc = -EBUSY;
+		goto err_out_card;
+	}
+
+	cardmax++;
+	card->next = NULL;	/*end of chain */
+	if (card_last)
+		card_last->next = card;		/* pointer to next card */
+	else
+		card_root = card;
+	card_last = card;	/* new chain end */
+
+	pci_set_drvdata(akt_pcidev, card);
+	return 0;
+
+err_out_card:
+	kfree(card);
+err_out:
+	pci_disable_device(akt_pcidev);
+	return rc;
+}
+
+static void __devexit hysdn_pci_remove_one(struct pci_dev *akt_pcidev)
+{
+	hysdn_card *card = pci_get_drvdata(akt_pcidev);
+
+	pci_set_drvdata(akt_pcidev, NULL);
+
+	if (card->stopcard)
+		card->stopcard(card);
+
+#ifdef CONFIG_HYSDN_CAPI
+	hycapi_capi_release(card);
+#endif
+
+	if (card->releasehardware)
+		card->releasehardware(card);   /* free all hardware resources */
+
+	if (card == card_root) {
+		card_root = card_root->next;
+		if (!card_root)
+			card_last = NULL;
+	} else {
+		hysdn_card *tmp = card_root;
+		while (tmp) {
+			if (tmp->next == card)
+				tmp->next = card->next;
+			card_last = tmp;
+			tmp = tmp->next;
+		}
+	}
+
+	kfree(card);
+	pci_disable_device(akt_pcidev);
+}
+
+static struct pci_driver hysdn_pci_driver = {
+	.name		= "hysdn",
+	.id_table	= hysdn_pci_tbl,
+	.probe		= hysdn_pci_init_one,
+	.remove		= __devexit_p(hysdn_pci_remove_one),
+};
+
+static int hysdn_have_procfs;
+
 static int __init
 hysdn_init(void)
 {
 	char tmp[50];
+	int rc;
 
 	strcpy(tmp, hysdn_init_revision);
 	printk(KERN_NOTICE "HYSDN: module Rev: %s loaded\n", hysdn_getrev(tmp));
 	strcpy(tmp, hysdn_net_revision);
 	printk(KERN_NOTICE "HYSDN: network interface Rev: %s \n", hysdn_getrev(tmp));
-	search_cards();
+
+	rc = pci_register_driver(&hysdn_pci_driver);
+	if (rc)
+		return rc;
+
 	printk(KERN_INFO "HYSDN: %d card(s) found.\n", cardmax);
 
-	if (hysdn_procconf_init()) {
-		free_resources();	/* proc file_sys not created */
-		return (-1);
-	}
+	if (!hysdn_procconf_init())
+		hysdn_have_procfs = 1;
+
 #ifdef CONFIG_HYSDN_CAPI
 	if(cardmax > 0) {
 		if(hycapi_init()) {
 			printk(KERN_ERR "HYCAPI: init failed\n");
-			return(-1);
+
+			if (hysdn_have_procfs)
+				hysdn_procconf_release();
+
+			pci_unregister_driver(&hysdn_pci_driver);
+			return -ESPIPE;
 		}
 	}
 #endif /* CONFIG_HYSDN_CAPI */
-	return (0);		/* no error */
+
+	return 0;		/* no error */
 }				/* init_module */
 
 
@@ -230,20 +221,15 @@ hysdn_init(void)
 static void __exit
 hysdn_exit(void)
 {
+	if (hysdn_have_procfs)
+		hysdn_procconf_release();
+
+	pci_unregister_driver(&hysdn_pci_driver);
+
 #ifdef CONFIG_HYSDN_CAPI
-	hysdn_card *card;
-#endif /* CONFIG_HYSDN_CAPI */
-	stop_cards();
-#ifdef CONFIG_HYSDN_CAPI
-	card = card_root;	/* first in chain */
-	while (card) {
-		hycapi_capi_release(card);
-		card = card->next;	/* remove card from chain */
-	}			/* while card */
 	hycapi_cleanup();
 #endif /* CONFIG_HYSDN_CAPI */
-	hysdn_procconf_release();
-	free_resources();
+
 	printk(KERN_NOTICE "HYSDN: module unloaded\n");
 }				/* cleanup_module */
 
