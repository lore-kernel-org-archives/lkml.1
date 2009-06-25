Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZFYCB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZFYCB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZFYCBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:01:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:43539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbZFYCBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:01:46 -0400
Message-ID: <4A42DA6F.2030305@kernel.org>
Date: Wed, 24 Jun 2009 19:01:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86/pci: fix boundary checking when using root CRS
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org>
In-Reply-To: <4A429EBB.5010209@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't touch info->res_num if we are out of space

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/acpi.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -68,6 +68,10 @@ setup_resource(struct acpi_resource *acp
 	unsigned long flags;
 	struct resource *root;
 	int max_root_bus_resources = PCI_BUS_NUM_RESOURCES;
+	u64 start, end;
+
+	if (bus_has_transparent_bridge(info->bus))
+		max_root_bus_resources -= 3;
 
 	status = resource_to_addr(acpi_res, &addr);
 	if (!ACPI_SUCCESS(status))
@@ -84,25 +88,24 @@ setup_resource(struct acpi_resource *acp
 	} else
 		return AE_OK;
 
-	res = &info->res[info->res_num];
-	res->name = info->name;
-	res->flags = flags;
-	res->start = addr.minimum + addr.translation_offset;
-	res->end = res->start + addr.address_length - 1;
-	res->child = NULL;
-
-	if (bus_has_transparent_bridge(info->bus))
-		max_root_bus_resources -= 3;
+	start = addr.minimum + addr.translation_offset;
+	end = start + addr.address_length - 1;
 	if (info->res_num >= max_root_bus_resources) {
 		printk(KERN_WARNING "PCI: Failed to allocate 0x%lx-0x%lx "
 			"from %s for %s due to _CRS returning more than "
-			"%d resource descriptors\n", (unsigned long) res->start,
-			(unsigned long) res->end, root->name, info->name,
+			"%d resource descriptors\n", (unsigned long) start,
+			(unsigned long) end, root->name, info->name,
 			max_root_bus_resources);
-		info->res_num++;
 		return AE_OK;
 	}
 
+	res = &info->res[info->res_num];
+	res->name = info->name;
+	res->flags = flags;
+	res->start = start;
+	res->end = end;
+	res->child = NULL;
+
 	if (insert_resource(root, res)) {
 		printk(KERN_ERR "PCI: Failed to allocate 0x%lx-0x%lx "
 			"from %s for %s\n", (unsigned long) res->start,
