Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbXJWK4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbXJWK4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXJWK40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:56:26 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:3459 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbXJWK4Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:56:25 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] PCI: disable MSI on more ATI NorthBridges
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Tue, 23 Oct 2007 18:56:03 +0800
Message-ID: <5CAB7B5D6F8AB84AA868A46B47A507055D91F2@sshaexmb1.amd.com>
In-Reply-To: <9783dadb0710201352p28969b4bs573d817d70b1fff7@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] PCI: disable MSI on more ATI NorthBridges
Thread-Index: AcgTWyaHdBdoIAdESMy9R7ISXkvp4wB/b8NQ
References: <BLU112-W5125F6D8BEB3DF6359D53E29F0@phx.gbl>
 <20071019195749.GK29903@austin.ibm.com>
 <BLU120-W12C06900EC932864CC13A8E2980@phx.gbl>
 <9783dadb0710201352p28969b4bs573d817d70b1fff7@mail.gmail.com>
From: "Shane Huang" <Shane.Huang@amd.com>
To: "David Gaarenstroom" <david.gaarenstroom@gmail.com>,
       linux-kernel@vger.kernel.org
cc: "Linas Vepstas" <linas@austin.ibm.com>, davem@davemloft.net,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, jgarzik@pobox.com,
       "Shane Huang" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 23 Oct 2007 10:56:10.0598 (UTC)
 FILETIME=[5240C060:01C81563]
X-WSS-ID: 6B030CC107S43252-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If the pci_intx change will be applied to the SATA driver, can it be
> applied for the ATI USB-HCDs too? See
> http://lkml.org/lkml/2006/12/21/47 for more details. That should help
> most of the ATI MSI quirks. It helped me (Acer Aspire 502x laptop with
> ATI RS480/SB400).

I checked the USB MSI problem above(also has reported to our hardware
team),
the cause seems same as our SB700 SATA controller MSI problem.

I also did some small USB MSI debug on our SB700 board with 2.6.23-rc5:
The USB part of the second patch(attached at the end of this mail)
does not work for SB700 USB EHCI/OHCI controllers, no matter INTx is
enabled or disabled before enter MSI. The USB host controllers are
always using IO-APIC, which is different from SB400. I don't know why.

[root@localhost ~]# cat /proc/interrupts 
           CPU0       CPU1  
17:          0        133   IO-APIC-fasteoi   ohci_hcd:usb1,
ohci_hcd:usb2, ehci_hcd:usb6
18:          1          2   IO-APIC-fasteoi   ohci_hcd:usb3,
ohci_hcd:usb4, ohci_hcd:usb5
19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb7

Also I wonder why the USB MSI patch is not added into kernel at last?
Will it lead to other bugs?


Thanks
Best Regards
Shane


======> USB part of the second patch in lkml.org/lkml/2006/12/21/47
diff -uprdN linux/drivers/usb/core/hcd-pci.c
linux/drivers/usb/core/hcd-pci.c
--- linux/drivers/usb/core/hcd-pci.c	2006-12-16 13:34:57.000000000
-0800
+++ linux/drivers/usb/core/hcd-pci.c	2006-12-16 13:57:09.000000000
-0800
@@ -69,6 +69,7 @@ int usb_hcd_pci_probe (struct pci_dev *d
 
 	if (pci_enable_device (dev) < 0)
 		return -ENODEV;
+	pci_enable_msi(dev);
 	dev->current_state = PCI_D0;
 	dev->dev.power.power_state = PMSG_ON;
 	
@@ -139,6 +140,7 @@ int usb_hcd_pci_probe (struct pci_dev *d
 		release_region (hcd->rsrc_start, hcd->rsrc_len);
  err2:
 	usb_put_hcd (hcd);
+	pci_disable_msi (dev);
  err1:
 	pci_disable_device (dev);
 	dev_err (&dev->dev, "init %s fail, %d\n", pci_name(dev),
retval);
@@ -177,6 +179,7 @@ void usb_hcd_pci_remove (struct pci_dev 
 		release_region (hcd->rsrc_start, hcd->rsrc_len);
 	}
 	usb_put_hcd (hcd);
+	pci_disable_msi(dev);
 	pci_disable_device(dev);
 }
 EXPORT_SYMBOL (usb_hcd_pci_remove);
@@ -391,6 +394,7 @@ int usb_hcd_pci_resume (struct pci_dev *
 			"can't re-enable after resume, %d!\n", retval);
 		return retval;
 	}
+	pci_enable_msi (dev);
 	pci_set_master (dev);
 	pci_restore_state (dev);






