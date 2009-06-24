Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbZFXMSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbZFXMSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZFXMSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:18:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45064 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZFXMSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:18:21 -0400
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4A418254.9050607@lwfinger.net>
References: <4A418254.9050607@lwfinger.net>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 17:46:27 +0530
Message-Id: <1245845787.3093.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 20:33 -0500, Larry Finger wrote:
> My latest pull from Linus's tree fails to boot. Bisection leads to the
> commit entitled "x86/ACPI: Correct maximum allowed _CRS returned
> resources and warn if exceeded" with hash
> f9cde5ffed17bf74f6bef042d99edb0622f58576. I have been unable to
> capture the first error message as it scrolls off the screen, but the
> second hits the WARN_ON at drivers/ata/ahci.c:695 in routine
> ahci_enable_ahci() because HOST_AHCI_EN is not set.
> 

This patch fixes boot failure on my AMD 64 laptop, can you please test
this patch:

[PATCH] x86: fix _CRS resources return handling

We need to check for info->res_num and only handle for < PCI_BUS_NUM_RESOURCES

Also set info->bus->resource[info->res_num] for _CRS resources return handling

Fixed boot failure on some machine.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/pci/acpi.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 16c3fda..0bc015f 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -69,6 +69,9 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	struct resource *root;
 	int max_root_bus_resources = PCI_BUS_NUM_RESOURCES;
 
+	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
+		return AE_OK;
+
 	status = resource_to_addr(acpi_res, &addr);
 	if (!ACPI_SUCCESS(status))
 		return AE_OK;
@@ -94,17 +97,18 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	if (bus_has_transparent_bridge(info->bus))
 		max_root_bus_resources -= 3;
 	if (info->res_num >= max_root_bus_resources) {
-		printk(KERN_WARNING "PCI: Failed to allocate 0x%lx-0x%lx "
-			"from %s for %s due to _CRS returning more than "
-			"%d resource descriptors\n", (unsigned long) res->start,
-			(unsigned long) res->end, root->name, info->name,
-			max_root_bus_resources);
+		pr_warning("PCI: Failed to allocate 0x%lx-0x%lx "
+			   "from %s for %s due to _CRS returning more than "
+			   "%d resource descriptors\n",
+			   (unsigned long)res->start, (unsigned long)res->end,
+			   root->name, info->name, max_root_bus_resources);
+		info->bus->resource[info->res_num] = res;
 		info->res_num++;
 		return AE_OK;
 	}
 
 	if (insert_resource(root, res)) {
-		printk(KERN_ERR "PCI: Failed to allocate 0x%lx-0x%lx "
+		pr_err("PCI: Failed to allocate 0x%lx-0x%lx "
 			"from %s for %s\n", (unsigned long) res->start,
 			(unsigned long) res->end, root->name, info->name);
 	} else {
-- 
1.6.0.6



