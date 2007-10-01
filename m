Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbXJAIFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbXJAIFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXJAIFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:05:17 -0400
Received: from [222.122.15.10] ([222.122.15.10]:49555 "HELO geninetworks.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751758AbXJAIFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:05:16 -0400
Subject: Re: [PATCH] PCI hotplug : Switch to pci_get_bus_and_slot instead
	of deprecated pci_find_slot.
From: Joonwoo Park <joonwpark81@gmail.com>
Reply-To: joonwpark81@gmail.com
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com
Content-Type: text/plain
Organization: GeniNetworks
Date: Mon, 01 Oct 2007 17:05:13 +0900
Message-Id: <1191225913.10738.29.camel@joonwpark-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you so much for your check & advise.
This time, I've tried on ibmphp_core.c, is it OK?

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/pci/hotplug/ibmphp_core.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 0316eea..2085023 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -761,10 +761,13 @@ static void ibm_unconfigure_device(struct pci_func *func)
 	debug("func->device << 3 | 0x0  = %x\n", func->device << 3 | 0x0);
 
 	for (j = 0; j < 0x08; j++) {
-		temp = pci_find_slot(func->busno, (func->device << 3) | j);
-		if (temp)
+		temp = pci_get_bus_and_slot(func->busno, (func->device << 3) | j);
+		if (temp) {
 			pci_remove_bus_device(temp);
+			pci_dev_put(temp);
+		}
 	}
+	pci_dev_put(func->dev);
 }
 
 /*
@@ -823,7 +826,7 @@ static int ibm_configure_device(struct pci_func *func)
 	if (!(bus_structure_fixup(func->busno)))
 		flag = 1;
 	if (func->dev == NULL)
-		func->dev = pci_find_slot(func->busno,
+		func->dev = pci_get_bus_and_slot(func->busno,
 				PCI_DEVFN(func->device, func->function));
 
 	if (func->dev == NULL) {
@@ -836,7 +839,7 @@ static int ibm_configure_device(struct pci_func *func)
 		if (num)
 			pci_bus_add_devices(bus);
 
-		func->dev = pci_find_slot(func->busno,
+		func->dev = pci_get_bus_and_slot(func->busno,
 				PCI_DEVFN(func->device, func->function));
 		if (func->dev == NULL) {
 			err("ERROR... : pci_dev still NULL\n");
---

Thanks.
Joonwoo Park

> On Mon, Oct 01, 2007 at 12:09:07PM +0900, JoonwooPark wrote:
> > This patch fixes these warnings:
> >
> > drivers/pci/hotplug/cpqphp_pci.c: In
> function ???cpqhp_configure_device???:
> > drivers/pci/hotplug/cpqphp_pci.c:92: warning: ???pci_find_slot??? is
> deprecated (declared at include/linux/pci.h:481)
> > drivers/pci/hotplug/cpqphp_pci.c:102: warning: ???pci_find_slot???
> is deprecated (declared at include/linux/pci.h:481)
> > drivers/pci/hotplug/cpqphp_pci.c: In
> function ???cpqhp_unconfigure_device???:
> > drivers/pci/hotplug/cpqphp_pci.c:126: warning: ???pci_find_slot???
> is deprecated (declared at include/linux/pci.h:481)
> > drivers/pci/hotplug/cpqphp_pci.c: In
> function ???cpqhp_save_config???:
> > drivers/pci/hotplug/cpqphp_pci.c:420: warning: ???pci_find_slot???
> is deprecated (declared at include/linux/pci.h:481)
> >
> > Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> 
> 
> Close, but you need to free the reference that you now have grabed.
>  As
> is, this patch will cause a memory leak and cause bad things to happen
> :(
> 
> Take a look at the documentation for the pci_get_bus_and_slot()
> function, it's not as easy as a simple search-and-replace.
> 
> thanks,
> 
> greg k-h
> 


