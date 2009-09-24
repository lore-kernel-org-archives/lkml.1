Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZIXTOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZIXTOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZIXTOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:14:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:58986 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZIXTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:14:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANxhu0qrR7O6/2dsb2JhbAC/MIhTAZALBYQc
X-IronPort-AV: E=Sophos;i="4.44,446,1249257600"; 
   d="scan'208";a="395465384"
From: Roland Dreier <rdreier@cisco.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] intel-iommu: Decode (and ignore) RHSA entries
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Sep 2009 12:14:00 -0700
Message-ID: <adafxac17gn.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Sep 2009 19:14:01.0306 (UTC) FILETIME=[2C9193A0:01CA3D4B]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently got a system where the DMAR table included a couple of RHSA
(remapping hardware static affinity) entries.  Rather than printing a
message about an "Unknown DMAR structure," it would probably be more
useful to dump the RHSA structure (as other DMAR structures are dumped).

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/pci/dmar.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 14bbaa1..b233163 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -354,6 +354,7 @@ dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_reserved_memory *rmrr;
 	struct acpi_dmar_atsr *atsr;
+	struct acpi_dmar_rhsa *rhsa;
 
 	switch (header->type) {
 	case ACPI_DMAR_TYPE_HARDWARE_UNIT:
@@ -375,6 +376,12 @@ dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 		atsr = container_of(header, struct acpi_dmar_atsr, header);
 		printk(KERN_INFO PREFIX "ATSR flags: %#x\n", atsr->flags);
 		break;
+	case ACPI_DMAR_HARDWARE_AFFINITY:
+		rhsa = container_of(header, struct acpi_dmar_rhsa, header);
+		printk(KERN_INFO PREFIX "RHSA base: %#016Lx proximity domain: %#x\n",
+		       (unsigned long long)rhsa->base_address,
+		       rhsa->proximity_domain);
+		break;
 	}
 }
 
@@ -459,6 +466,9 @@ parse_dmar_table(void)
 			ret = dmar_parse_one_atsr(entry_header);
 #endif
 			break;
+		case ACPI_DMAR_HARDWARE_AFFINITY:
+			/* We don't do anything with RHSA (yet?) */
+			break;
 		default:
 			printk(KERN_WARNING PREFIX
 				"Unknown DMAR structure type\n");
