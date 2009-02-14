Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbZBNEXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbZBNEXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 23:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZBNEW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 23:22:57 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:35255 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZBNEW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 23:22:56 -0500
To: Jesse Barnes <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 13 Feb 2009 20:23:03 -0800
Message-ID: <m1ocx5ve8o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jesse Barnes <jbarnes@virtuousgeek.org>,
	<linux-pci@vger.kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] pcie_portdriver: FIX: pcie_port_device_remove
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pcie_port_device_remove currently calls the remove method
of port drivers twice.  Ouch!

We don't get the correct interrupt mode unless there is a port device
present.

We are calling device_for_each_child multiple times for no apparent
reason.

So make it simple.  Use pcie_port_driver_ext so we always properly
know the interrupt mode the we placed the pci device in.  Place
put_device and device_unregister into remove_iter, and throw out the
rest.  Only call device_for_each_child once.

The code is simpler and actually works!

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

---
 drivers/pci/pcie/portdrv_core.c |   31 +++++++------------------------
 1 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 8b3f8c1..c642828 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -326,16 +326,9 @@ int pcie_port_device_resume(struct pci_dev *dev)
 
 static int remove_iter(struct device *dev, void *data)
 {
-	struct pcie_port_service_driver *service_driver;
-
 	if (dev->bus == &pcie_port_bus_type) {
-		if (dev->driver) {
-			service_driver = to_service_driver(dev->driver);
-			if (service_driver->remove)
-				service_driver->remove(to_pcie_device(dev));
-		}
-		*(unsigned long*)data = (unsigned long)dev;
-		return 1;
+		put_device(dev);
+		device_unregister(dev);
 	}
 	return 0;
 }
@@ -349,24 +342,14 @@ static int remove_iter(struct device *dev, void *data)
  */
 void pcie_port_device_remove(struct pci_dev *dev)
 {
-	struct device *device;
-	unsigned long device_addr;
-	int interrupt_mode = PCIE_PORT_INTx_MODE;
-	int status;
+	struct pcie_port_device_ext *p_ext = pci_get_drvdata(dev);
+
+	device_for_each_child(&dev->dev, NULL, remove_iter);
 
-	do {
-		status = device_for_each_child(&dev->dev, &device_addr, remove_iter);
-		if (status) {
-			device = (struct device*)device_addr;
-			interrupt_mode = (to_pcie_device(device))->interrupt_mode;
-			put_device(device);
-			device_unregister(device);
-		}
-	} while (status);
 	/* Switch to INTx by default if MSI enabled */
-	if (interrupt_mode == PCIE_PORT_MSIX_MODE)
+	if (p_ext->interrupt_mode == PCIE_PORT_MSIX_MODE)
 		pci_disable_msix(dev);
-	else if (interrupt_mode == PCIE_PORT_MSI_MODE)
+	else if (p_ext->interrupt_mode == PCIE_PORT_MSI_MODE)
 		pci_disable_msi(dev);
 }
 
-- 
1.6.0.6


