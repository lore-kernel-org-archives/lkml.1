Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXIEHOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXIEHOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 03:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbXIEHOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 03:14:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:46929 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbXIEHOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 03:14:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,210,1186383600"; 
   d="scan'208";a="293557552"
Date: Wed, 5 Sep 2007 15:13:07 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [AGPGART] intel_agp: fix GTT map size on G33
Message-ID: <20070905071307.GB5817@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.22-rc6 i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] [AGPGART] intel_agp: fix GTT map size on G33

G33 has 1MB GTT table range. Fix GTT mapping
in case like 512MB aperture size.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 20d50d0..6a5c555 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -919,6 +919,7 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
 	struct aper_size_info_fixed *size;
 	int num_entries;
 	u32 temp, temp2;
+	int gtt_map_size = 256 * 1024;
 
 	size = agp_bridge->current_size;
 	page_order = size->page_order;
@@ -928,7 +929,9 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
 	pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
 	pci_read_config_dword(intel_private.pcidev, I915_PTEADDR,&temp2);
 
-	intel_private.gtt = ioremap(temp2, 256 * 1024);
+	if (IS_G33)
+	    gtt_map_size = 1024 * 1024; /* 1M on G33 */
+	intel_private.gtt = ioremap(temp2, gtt_map_size);
 	if (!intel_private.gtt)
 		return -ENOMEM;
 
-- 
1.5.2.3
