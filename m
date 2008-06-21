Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYFURHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYFURHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 13:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYFURHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 13:07:45 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:36063 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYFURHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 13:07:44 -0400
Message-ID: <485D356A.402@keyaccess.nl>
Date: Sat, 21 Jun 2008 19:07:54 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Re: regression, 2.6.26-rc7, pnp: quirk_system_pci_resources()
References: <485C6388.1050903@keyaccess.nl>
In-Reply-To: <485C6388.1050903@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------080602020007000403010806"
X-Spam-Score: 2.5 (++)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080602020007000403010806
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 21-06-08 04:12, Rene Herman wrote:

> I have been running with pnpacpi=off due to testing ISAPnP/PnPBIOS but 
> when testing some other ACPI related problem tonight I removed that and 
> found that unfortunately something seems to have regressed. My soundcard 
> driver (snd-es1968) won't load anymore on current mainline:
> 
> ===
> ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 10 (level, 
> low) -> IRQ 10
> PCI: Unable to reserve I/O region #1:100@de00 for device 0000:00:0a.0
> ACPI: PCI interrupt for device 0000:00:0a.0 disabled
> ES1968 (ESS Maestro): probe of 0000:00:0a.0 failed with error -16
> ===
> 
> 00:01 (PNP0c02) is keeping its I/O region occupied:
> 
> ===
> # cat /sys/bus/pnp/devices/00\:01/resources
> state = active
> io 0xde00-0xde03
> ===
> 
> Sound used to work back when I wasn't yet booting with pnpacpi=off but I 
> don't quite recall when I started doing that nor have I looked yet at 
> why quirk_system_pci_resources() isn't doing its job. I'll investigate 
> if you need me to but thought I'd first throw a heap of information your 
> way and hope you'll have a patch for me when I wake up :-/

Well, why the quirk wasn't helping is fairly obvious -- but given that I 
definitely didn't need anything like this on .25 I wonder why PnPACPI is 
all of a sudden claiming those 4 ports in the first place.

As in, this works for me and might not be bogus due to the symmetry and 
all but still needs some head scratching. In any case, I do definitely 
need something for .26...

I'll go recompile .25 onto here and see if's just my BIOS being funny or 
something to do with the kernel.

Signed-off-by: Rene Herman <rene.herman@gmail.com>

Rene.

--------------080602020007000403010806
Content-Type: text/plain;
 name="pnp-quirk_system_pci_resources-ports.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnp-quirk_system_pci_resources-ports.diff"

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 55f55ed..bbca54f 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -245,15 +245,17 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 	 */
 	for_each_pci_dev(pdev) {
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM) ||
-			    pci_resource_len(pdev, i) == 0)
+			unsigned int type;
+
+			type = pci_resource_flags(pdev, i) &
+					(IORESOURCE_IO | IORESOURCE_MEM);
+			if (!type || pci_resource_len(pdev, i) == 0)
 				continue;
 
 			pci_start = pci_resource_start(pdev, i);
 			pci_end = pci_resource_end(pdev, i);
 			for (j = 0;
-			     (res = pnp_get_resource(dev, IORESOURCE_MEM, j));
-			     j++) {
+			     (res = pnp_get_resource(dev, type, j)); j++) {
 				if (res->start == 0 && res->end == 0)
 					continue;
 
@@ -283,9 +285,10 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				 * the PCI region, and that might prevent a PCI
 				 * driver from requesting its resources.
 				 */
-				dev_warn(&dev->dev, "mem resource "
+				dev_warn(&dev->dev, "%s resource "
 					"(0x%llx-0x%llx) overlaps %s BAR %d "
 					"(0x%llx-0x%llx), disabling\n",
+					type & IORESOURCE_IO ? "port" : "mem",
 					(unsigned long long) pnp_start,
 					(unsigned long long) pnp_end,
 					pci_name(pdev), i,

--------------080602020007000403010806--
