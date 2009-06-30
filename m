Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZF3QAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZF3QAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 12:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZF3QAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 12:00:25 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:33477 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZF3QAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 12:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=EEIlVV2TfqjDB6OeD34rW+KRtuElcgDGHwKr7CRdsANZq3L2Mu2jnxJ9scSBRqCUTY
         H3WtlDmHUzA9PLaBUAsRBFTFnkAvHbHCKEiXSjIOmWle4fQpX3tKKs6qyOfeCIZHVG21
         NZb1snkkOav42krCvCta0c87tFhDd6W6egAFg=
Message-ID: <4A4A3697.7020804@tuffmail.co.uk>
Date: Tue, 30 Jun 2009 17:00:23 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
CC: linux-pci@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: pciehp resume handler - racy?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been hacking on the PCI hotplug driver otherwise known as
eeepc-laptop.  At one point I reliably triggered a race on resume.  In
the hot-unplug case, it seemed that the resume handler would try to
remove the PCI device at the same time as an acpi notification (run in a
workqueue) tried to do the same thing.  The result was an OOPS.  My
conclusion is that the PCI hotplug core does not protect against
multiple simultaneous removals of the same device.

pciehp appears to have an analogous problem.  Assuming pciehp_force is
set, the resume handler can hot-unplug the device.  The interrupt
handler could try to hot-unplug the device at the same time.  Should the
resume handler take the slot mutex to avoid this problem?

diff --faked-up a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -382,15 +382,18 @@ static int pciehp_resume (struct pcie_device *dev)
 		/* reinitialize the chipset's event detection logic */
 		pcie_enable_notification(ctrl);
 
 		t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
+		mutex_lock(&t_slot->lock);
 
 		/* Check if slot is occupied */
 		t_slot->hpc_ops->get_adapter_status(t_slot, &status);
 		if (status)
 			pciehp_enable_slot(t_slot);
 		else
 			pciehp_disable_slot(t_slot);
+
+		mutex_unlock(&t_slot->lock);
 	}
 	return 0;
 }
 #endif /* PM */


Regards
Alan

