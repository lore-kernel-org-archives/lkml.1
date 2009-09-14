Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZINCrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZINCrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZINCrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:47:12 -0400
Received: from mga07.intel.com ([143.182.124.22]:39018 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754908AbZINCrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:47:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,381,1249282800"; 
   d="scan'208";a="187186410"
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: airlied@gmail.com
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Stable Team <stable@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/2] agp/intel: remove restore in resume
Date: Mon, 14 Sep 2009 10:47:06 +0800
Message-Id: <1252896427-11669-1-git-send-email-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As early pci resume has already restored config for host
bridge and graphics device, don't need to restore it again,
This removes an original order hack for graphics device restore.

This fixed the resume hang issue found by Alan Stern on 845G,
caused by extra config restore on graphics device.

Cc: Stable Team <stable@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/char/agp/intel-agp.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index e8dc75f..6a45365 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -2335,15 +2335,6 @@ static int agp_intel_resume(struct pci_dev *pdev)
 	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
 	int ret_val;
 
-	pci_restore_state(pdev);
-
-	/* We should restore our graphics device's config space,
-	 * as host bridge (00:00) resumes before graphics device (02:00),
-	 * then our access to its pci space can work right.
-	 */
-	if (intel_private.pcidev)
-		pci_restore_state(intel_private.pcidev);
-
 	if (bridge->driver == &intel_generic_driver)
 		intel_configure();
 	else if (bridge->driver == &intel_850_driver)
-- 
1.6.3.3

