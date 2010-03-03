Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab0CCQSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:18:00 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:52927 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab0CCQR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:17:58 -0500
Date: Wed, 03 Mar 2010 10:17:39 -0600
From: Corey Minyard <minyard@acm.org>
To: torvalds@linux-foundation.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 4/4] IPMI: Add proper offset for HP PCI interfaces
Message-id: <20100303161739.GD17623@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

On a PCI update, the offset for HP PCI interfaces to the IPMI controller
was left off.  Add the offset back in.  The "dead code" dealing with
first_reg_offset was removed in 2.6.32, so that is re-added.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

Index: linux-2.6.33/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.33.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.33/drivers/char/ipmi/ipmi_si_intf.c
@@ -2363,6 +2363,7 @@ static int __devinit ipmi_pci_probe(stru
 	int rv;
 	int class_type = pdev->class & PCI_ERMC_CLASSCODE_TYPE_MASK;
 	struct smi_info *info;
+	int first_reg_offset = 0;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -2401,6 +2402,9 @@ static int __devinit ipmi_pci_probe(stru
 	info->addr_source_cleanup = ipmi_pci_cleanup;
 	info->addr_source_data = pdev;
 
+	if (pdev->subsystem_vendor == PCI_HP_VENDOR_ID)
+		first_reg_offset = 1;
+
 	if (pci_resource_flags(pdev, 0) & IORESOURCE_IO) {
 		info->io_setup = port_setup;
 		info->io.addr_type = IPMI_IO_ADDR_SPACE;
@@ -2408,7 +2412,7 @@ static int __devinit ipmi_pci_probe(stru
 		info->io_setup = mem_setup;
 		info->io.addr_type = IPMI_MEM_ADDR_SPACE;
 	}
-	info->io.addr_data = pci_resource_start(pdev, 0);
+	info->io.addr_data = pci_resource_start(pdev, 0) + first_reg_offset;
 
 	info->io.regspacing = DEFAULT_REGSPACING;
 	info->io.regsize = DEFAULT_REGSPACING;
