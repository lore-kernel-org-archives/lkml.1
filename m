Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab0CKRcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:32:13 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42012 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab0CKRcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:32:07 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/3] of/flattree: Make unflatten_device_tree() safe to call
	from any arch
To: devicetree-discuss@lists.ozlabs.org, benh@kernel.crashing.org,
       davem@davemloft.net, jeremy.kerr@canonical.com, monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Date: Thu, 11 Mar 2010 10:32:03 -0700
Message-ID: <20100311173203.4423.8733.stgit@angua>
In-Reply-To: <20100311173024.4423.53178.stgit@angua>
References: <20100311173024.4423.53178.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes unflatten_device_tree() safe to call from any arch
setup code with the following changes:
- Make sure initial_boot_params actually points to a device tree blob
  before unflattening
- Make sure the initial_boot_params->magic field is correct
- If CONFIG_OF_FLATTREE is not set, then make unflatten_device_tree()
  an empty #define.

This patch also adds some additional debug output to the top of
unflatten_device_tree().

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/of/fdt.c       |   15 +++++++++++++++
 include/linux/of_fdt.h |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 406757a..5ce7bd5 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -553,6 +553,21 @@ void __init unflatten_device_tree(void)
 
 	pr_debug(" -> unflatten_device_tree()\n");
 
+	if (!initial_boot_params) {
+		pr_debug("No device tree pointer\n");
+		return;
+	}
+
+	pr_debug("Unflattening device tree:\n");
+	pr_debug("magic: %08x\n", be32_to_cpu(initial_boot_params->magic));
+	pr_debug("size: %08x\n", be32_to_cpu(initial_boot_params->totalsize));
+	pr_debug("version: %08x\n", be32_to_cpu(initial_boot_params->version));
+
+	if (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER) {
+		pr_err("Invalid device tree blob header\n");
+		return;
+	}
+
 	/* First pass, scan for size */
 	start = ((unsigned long)initial_boot_params) +
 		be32_to_cpu(initial_boot_params->off_dt_struct);
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index f0fdd1f..54399f1 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -99,6 +99,8 @@ extern int early_init_dt_scan_root(unsigned long node, const char *uname,
 /* Other Prototypes */
 extern void unflatten_device_tree(void);
 extern void early_init_devtree(void *);
+#else /* CONFIG_OF_FLATTREE */
+static inline void define unflatten_device_tree(void) {}
 #endif /* CONFIG_OF_FLATTREE */
 
 #endif /* __ASSEMBLY__ */

