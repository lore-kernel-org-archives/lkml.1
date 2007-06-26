Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbXFZWRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbXFZWRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbXFZWRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:17:08 -0400
Received: from verein.lst.de ([213.95.11.210]:39226 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843AbXFZWRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:17:07 -0400
From: Torsten Duwe <duwe@lst.de>
Organization: LST e.V.
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: EDD build error
Date: Wed, 27 Jun 2007 00:16:44 +0200
User-Agent: KMail/1.9.7
Cc: lkml <linux-kernel@vger.kernel.org>
References: <20070626132622.3226261a.randy.dunlap@oracle.com>
In-Reply-To: <20070626132622.3226261a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MBZgGmygjNQjC/t"
Message-Id: <200706270016.44999.duwe@lst.de>
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_MBZgGmygjNQjC/t
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 26 June 2007, Randy Dunlap wrote:

> ERROR: "pci_get_bus_and_slot" [drivers/firmware/edd.ko] undefined!
> make[1]: *** [__modpost] Error 1
>
> Should EDD depend on PCI or should some parts of edd.c be stubbed?

I'd suggest to simply stub it, as attached (untested, as my crap-Awarded BIOS
only has 2.1). It may not be nice to pull in the PCI defs and then return NULL
regardless, but should be safe in your case. Does that work?

	Torsten


--Boundary-00=_MBZgGmygjNQjC/t
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="EDD-diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="EDD-diff"

--- drivers/firmware/edd.c.orig	2007-04-26 05:08:32.000000000 +0200
+++ drivers/firmware/edd.c	2007-06-26 23:56:32.000000000 +0200
@@ -669,10 +669,14 @@
 	struct edd_info *info = edd_dev_get_info(edev);
 
 	if (edd_dev_is_type(edev, "PCI")) {
+#ifdef CONFIG_PCI
 		return pci_find_slot(info->params.interface_path.pci.bus,
 				     PCI_DEVFN(info->params.interface_path.pci.slot,
 					       info->params.interface_path.pci.
 					       function));
+#else
+		printk(KERN_WARNING "EDD referenced a PCI device for drive 0x%02x, but PCI is not configured\n", edev->index);
+#endif
 	}
 	return NULL;
 }

--Boundary-00=_MBZgGmygjNQjC/t--
