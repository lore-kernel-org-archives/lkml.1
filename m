Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbZFITJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbZFITJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZFITJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:09:12 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:12902 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbZFITJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:09:11 -0400
Date: Tue, 9 Jun 2009 13:09:11 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 07/11] ACPI: acpi_pci_unbind should clean up
	properly after acpi_pci_bind
Message-ID: <20090609190911.GE23647@ldl.fc.hp.com>
References: <20090604054504.18802.21690.stgit@bob.kio> <20090604055852.18802.22743.stgit@bob.kio> <4A2788FA.2050606@jp.fujitsu.com> <20090604233521.GA12900@ethanol> <4A2C8429.2020401@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2C8429.2020401@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
>> diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
>> index 62cb383..c9cc650 100644
>> --- a/drivers/acpi/pci_bind.c
>> +++ b/drivers/acpi/pci_bind.c
>> @@ -109,11 +109,13 @@ static int acpi_pci_unbind(struct acpi_device *device)
>>  	struct pci_dev *dev;
>>   	dev = acpi_get_pci_dev(device->handle);
>> -	if (!dev)
>> +	if (!dev || !dev->subordinate)
>>  		return 0;
>
> This would leak the pci_dev's refcount
> if dev != NULL && dev->subordinate == NULL.

Yes, of course you are correct. Thanks for correcting my
sloppiness.

Here is the correct fix.

From: Alex Chiang <achiang@hp.com>

ACPI: acpi_pci_unbind should clean up properly after acpi_pci_bind

In acpi_pci_bind, we set device->ops.bind and device->ops.unbind, but
never clear them out.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 62cb383..af75784 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -109,12 +109,15 @@ static int acpi_pci_unbind(struct acpi_device *device)
 	struct pci_dev *dev;
 
 	dev = acpi_get_pci_dev(device->handle);
-	if (!dev)
-		return 0;
+	if (!dev || !dev->subordinate)
+		goto out:
 
-	if (dev->subordinate)
-		acpi_pci_irq_del_prt(dev->subordinate);
+	acpi_pci_irq_del_prt(dev->subordinate);
 
+	device->ops.bind = NULL;
+	device->ops.unbind = NULL;
+
+out:
 	pci_dev_put(dev);
 	return 0;
 }
