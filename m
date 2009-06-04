Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZFDXpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZFDXpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZFDXpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:45:33 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:14082 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZFDXpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:45:32 -0400
X-IMAP-Sender: achiang
Date: Thu, 4 Jun 2009 17:35:21 -0600
X-OfflineIMAP-x602587130-6c646c-494e424f582e4f7574626f78: 1244159045-0930350799886-v6.0.3
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 07/11] ACPI: acpi_pci_unbind should clean up
	properly after acpi_pci_bind
Message-ID: <20090604233521.GA12900@ethanol>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, lenb@kernel.org,
	linux-acpi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20090604054504.18802.21690.stgit@bob.kio> <20090604055852.18802.22743.stgit@bob.kio> <4A2788FA.2050606@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2788FA.2050606@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>>  
>
> I have a concern about this change.
>
> The acpi_pci_irq_del_prt() against dev->bus removes not only
> the _PRT entries for PCI function corresponding to specified
> acpi_device, but also other _PRT entries for working PCI
> devices/functions on the same bus. As a result, interrupt
> initialization for those PCI functions would no longer work
> properly after that.
>
> So I think we should not call acpi_pci_irq_del_prt() against
> dev->bus.

Thanks for the review. I agree with you.

Here is a respun version of this patch.

From: Alex Chiang <achiang@hp.com>

ACPI: acpi_pci_unbind should clean up properly after acpi_pci_bind

In acpi_pci_bind, we set device->ops.bind and device->ops.unbind, but
never clear them out.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 62cb383..c9cc650 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -109,11 +109,13 @@ static int acpi_pci_unbind(struct acpi_device *device)
 	struct pci_dev *dev;
 
 	dev = acpi_get_pci_dev(device->handle);
-	if (!dev)
+	if (!dev || !dev->subordinate)
 		return 0;
 
-	if (dev->subordinate)
-		acpi_pci_irq_del_prt(dev->subordinate);
+	acpi_pci_irq_del_prt(dev->subordinate);
+
+	device->ops.bind = NULL;
+	device->ops.unbind = NULL;
 
 	pci_dev_put(dev);
 	return 0;
