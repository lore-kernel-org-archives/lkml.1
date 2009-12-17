Return-Path: <linux-kernel-owner+w=401wt.eu-S936245AbZLQEGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936245AbZLQEGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936238AbZLQEGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:06:06 -0500
Received: from kroah.org ([198.145.64.141]:52300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936158AbZLQEF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:02 2009
Message-Id: <20091217035701.923132279@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [146/151] intel-iommu: Check for an RMRR which ends before it starts.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <David.Woodhouse@intel.com>

commit 5595b528b49a702c0428c0762bab60999648254c upstream.

Some HP BIOSes report an RMRR region (a region which needs a 1:1 mapping
in the IOMMU for a given device) which has an end address lower than its
start address. Detect that and warn, rather than triggering the
BUG() in dma_pte_clear_range().

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1991,6 +1991,16 @@ static int iommu_prepare_identity_map(st
 	       "IOMMU: Setting identity map for device %s [0x%Lx - 0x%Lx]\n",
 	       pci_name(pdev), start, end);
 	
+	if (end < start) {
+		WARN(1, "Your BIOS is broken; RMRR ends before it starts!\n"
+			"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+			dmi_get_system_info(DMI_BIOS_VENDOR),
+			dmi_get_system_info(DMI_BIOS_VERSION),
+		     dmi_get_system_info(DMI_PRODUCT_VERSION));
+		ret = -EIO;
+		goto error;
+	}
+
 	if (end >> agaw_to_width(domain->agaw)) {
 		WARN(1, "Your BIOS is broken; RMRR exceeds permitted address width (%d bits)\n"
 		     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",


