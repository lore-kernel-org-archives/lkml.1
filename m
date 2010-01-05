Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142Ab0AEAuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0AEAuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139Ab0AEAuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:50:08 -0500
Received: from kroah.org ([198.145.64.141]:34218 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab0AEAfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/97] x86/amd-iommu: Fix initialization failure panic
Date: Mon,  4 Jan 2010 16:32:47 -0800
Message-Id: <1262651630-7354-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

commit 0f764806438d5576ac58898332e5dcf30bb8a679 upstream.

The assumption that acpi_table_parse passes the return value
of the hanlder function to the caller proved wrong
recently. The return value of the handler function is
totally ignored. This makes the initialization code for AMD
IOMMU buggy in a way that could cause a kernel panic on
initialization. This patch fixes the issue in the AMD IOMMU
driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/amd_iommu_init.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index e0b3130..c8243f0 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -136,6 +136,11 @@ LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 					   system */
 
 /*
+ * Set to true if ACPI table parsing and hardware intialization went properly
+ */
+static bool amd_iommu_initialized;
+
+/*
  * Pointer to the device table which is shared by all AMD IOMMUs
  * it is indexed by the PCI device id or the HT unit id and contains
  * information about the domain the device belongs to as well as the
@@ -913,6 +918,8 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	}
 	WARN_ON(p != end);
 
+	amd_iommu_initialized = true;
+
 	return 0;
 }
 
@@ -1263,6 +1270,9 @@ int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", init_iommu_all) != 0)
 		goto free;
 
+	if (!amd_iommu_initialized)
+		goto free;
+
 	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
 		goto free;
 
-- 
1.6.6

