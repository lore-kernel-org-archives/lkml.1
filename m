Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0CLABy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:01:54 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:23235 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0CLABv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:01:51 -0500
Subject: [PATCH v1 2/3] x86/PCI: trim _CRS windows when they conflict with
	previous reservations
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
Date: Thu, 11 Mar 2010 17:01:14 -0700
Message-ID: <20100312000114.4355.58189.stgit@bob.kio>
In-Reply-To: <20100311235954.4355.23100.stgit@bob.kio>
References: <20100311235954.4355.23100.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yanko's GA-MA78GM-S2H (BIOS F11) reports a host bridge window that overlaps
system memory:

    PCI window: [mem 0xcff00000-0x10ed0ffff]
    System RAM: [mem 0x100000000-0x22fffffff]

We can be pretty confident that the System RAM region is correct (if it
were wrong, we'd crash as soon as we tried to use any memory in that area),
so this patch tries to correct the PCI window by trimming it so it doesn't
conflict with any previous reservations.

http://bugzilla.kernel.org/show_bug.cgi?id=15480

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Reported-by: Yanko Kaneti <yaneti@declera.com>
---

 arch/x86/pci/acpi.c |   48 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 35 insertions(+), 13 deletions(-)


diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 6e22454..d255ce8 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -114,11 +114,19 @@ align_resource(struct acpi_device *bridge, struct resource *res)
 	}
 }
 
+static bool
+resource_contains(struct resource *res, resource_size_t n)
+{
+	if (n < res->start || n > res->end)
+		return false;
+	return true;
+}
+
 static acpi_status
 setup_resource(struct acpi_resource *acpi_res, void *data)
 {
 	struct pci_root_info *info = data;
-	struct resource *res;
+	struct resource *res, *conflict;
 	struct acpi_resource_address64 addr;
 	acpi_status status;
 	unsigned long flags;
@@ -157,21 +165,35 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 		return AE_OK;
 	}
 
-	if (insert_resource(root, res)) {
+	conflict = insert_resource_conflict(root, res);
+	while (conflict) {
 		dev_err(&info->bridge->dev,
-			"can't allocate host bridge window %pR\n", res);
-	} else {
-		pci_bus_add_resource(info->bus, res, 0);
-		info->res_num++;
-		if (addr.translation_offset)
-			dev_info(&info->bridge->dev, "host bridge window %pR "
-				 "(PCI address [%#llx-%#llx])\n",
-				 res, res->start - addr.translation_offset,
-				 res->end - addr.translation_offset);
+		        "host bridge window %pR conflicts with %s %pR\n",
+			res, conflict->name, conflict);
+
+		if (resource_contains(res, conflict->end))
+			res->start = conflict->end + 1;
+		else if (resource_contains(res, conflict->start))
+			res->end = conflict->start - 1;
 		else
-			dev_info(&info->bridge->dev,
-				 "host bridge window %pR\n", res);
+			return AE_OK;
+
+		if (res->start >= res->end)
+			return AE_OK;
+
+		conflict = insert_resource_conflict(root, res);
 	}
+
+	pci_bus_add_resource(info->bus, res, 0);
+	info->res_num++;
+	if (addr.translation_offset)
+		dev_info(&info->bridge->dev, "host bridge window %pR "
+			 "(PCI address [%#llx-%#llx])\n",
+			 res, res->start - addr.translation_offset,
+			 res->end - addr.translation_offset);
+	else
+		dev_info(&info->bridge->dev,
+			 "host bridge window %pR\n", res);
 	return AE_OK;
 }
 

