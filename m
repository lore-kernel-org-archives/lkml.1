Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbZHFSwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbZHFSwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZHFSwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:52:43 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4496 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZHFSwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:52:42 -0400
Subject: Re: [PATCH] pci_ids.h: add new Atheros USB vendor ID
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <greg@kroah.com>, Marcel Holtmann <marcel@holtmann.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       zhifeng.cai@atheros.com, stephen.chen@atheros.com,
       linux-usb@vger.kernel.org
In-Reply-To: <20090806181546.GA11589@redhat.com>
References: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com>
	 <1249532170.21101.3.camel@localhost.localdomain>
	 <43e72e890908052126v53aa1b4sb7a48e19f98fdfa6@mail.gmail.com>
	 <1249533357.21101.5.camel@localhost.localdomain>
	 <20090806050932.GA25015@kroah.com>  <20090806181546.GA11589@redhat.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 11:50:39 -0700
Message-Id: <1249584639.3467.60.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 14:15 -0400, Dave Jones wrote:
> On Wed, Aug 05, 2009 at 10:09:32PM -0700, Greg Kroah-Hartman wrote:
>  > > the closest we have is drivers/hid/hid-ids.h and we might just should
>  > > have Greg create a usb-ids.h file.
>  > Ick, no, there's no such file for a good reason.  Put your device ids in
>  > the driver files, no need to share it across the whole kernel.
> I agree. In fact, I'd go further, and say that the bulk of what we have
> in pci_ids.h is also pointlessly shared. Only a tiny fraction of the device
> entries in that file are used by multiple files in the kernel.

I created some scripts a while ago to go through the
kernel to convert struct pci_device definitions to use
PCI_VDEVICE and PCI_DEVICE.

I could move definitions out of the pci_ids.h file at
the same time and closer to their actual use if those
definitions were not globally used.  Maybe move them
by module or by specific file.

Perhaps like this example unsigned, not to be applied,
patch below:

diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
index d2ba04d..e978eb8 100644
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -264,30 +264,12 @@ static void amd_iso_dev_put(void)
 
 /* List of quirks for OHCI */
 static const struct pci_device_id ohci_pci_quirks[] = {
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x740c),
-		.driver_data = (unsigned long)ohci_quirk_amd756,
-	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_OPTI, 0xc861),
-		.driver_data = (unsigned long)ohci_quirk_opti,
-	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_ANY_ID),
-		.driver_data = (unsigned long)ohci_quirk_ns,
-	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xa0f8),
-		.driver_data = (unsigned long)ohci_quirk_zfmicro,
-	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA_2, 0x01b6),
-		.driver_data = (unsigned long)ohci_quirk_toshiba_scc,
-	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_NEC, PCI_DEVICE_ID_NEC_USB),
-		.driver_data = (unsigned long)ohci_quirk_nec,
-	},
+	{ PCI_UNNAMED_DEVICE(AMD, 0x740c), .driver_data = (unsigned long)ohci_quirk_amd756 },
+	{ PCI_UNNAMED_DEVICE(OPTI, 0xc861), .driver_data = (unsigned long)ohci_quirk_opti },
+	{ PCI_UNNAMED_DEVICE(NS, PCI_ANY_ID), .driver_data = (unsigned long)ohci_quirk_ns },
+	{ PCI_UNNAMED_DEVICE(COMPAQ, 0xa0f8), .driver_data = (unsigned long)ohci_quirk_zfmicro },
+	{ PCI_UNNAMED_DEVICE(TOSHIBA_2, 0x01b6), .driver_data = (unsigned long)ohci_quirk_toshiba_scc },
+	{ PCI_NAMED_DEVICE(NEC, NEC_USB), .driver_data = (unsigned long)ohci_quirk_nec },
 	{
 		/* Toshiba portege 4000 */
 		.vendor		= PCI_VENDOR_ID_AL,
@@ -296,22 +278,10 @@ static const struct pci_device_id ohci_pci_quirks[] = {
 		.subdevice	= 0x0004,
 		.driver_data	= (unsigned long) broken_suspend,
 	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_ITE, 0x8152),
-		.driver_data = (unsigned long) broken_suspend,
-	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_ATI, 0x4397),
-		.driver_data = (unsigned long)ohci_quirk_amd700,
-	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_ATI, 0x4398),
-		.driver_data = (unsigned long)ohci_quirk_amd700,
-	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_ATI, 0x4399),
-		.driver_data = (unsigned long)ohci_quirk_amd700,
-	},
+	{ PCI_UNNAMED_DEVICE(ITE, 0x8152), .driver_data = (kernel_ulong_t)broken_suspend },
+	{ PCI_UNNAMED_DEVICE(ATI, 0x4397), .driver_data = (kernel_ulong_t)ohci_quirk_amd700 },
+	{ PCI_UNNAMED_DEVICE(ATI, 0x4398), .driver_data = (kernel_ulong_t)ohci_quirk_amd700 },
+	{ PCI_UNNAMED_DEVICE(ATI, 0x4399), .driver_data = (kernel_ulong_t)ohci_quirk_amd700 },
 
 	/* FIXME for some of the early AMD 760 southbridges, OHCI
 	 * won't work at all.  blacklist them.
diff --git a/drivers/usb/host/whci/hcd.c b/drivers/usb/host/whci/hcd.c
index e019a50..91e6563 100644
--- a/drivers/usb/host/whci/hcd.c
+++ b/drivers/usb/host/whci/hcd.c
@@ -351,7 +351,7 @@ static void __exit whci_hc_driver_exit(void)
 module_exit(whci_hc_driver_exit);
 
 /* PCI device ID's that we handle (so it gets loaded) */
-static struct pci_device_id whci_hcd_id_table[] = {
+static const struct pci_device_id whci_hcd_id_table[]  = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_WIRELESS_WHCI, ~0) },
 	{ /* empty last entry */ }
 };


