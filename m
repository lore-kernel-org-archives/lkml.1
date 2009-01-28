Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZA1WAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZA1WAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbZA1V7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:59:20 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:6753 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbZA1V7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:59:19 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH 03/10] PCI: properly clean up ASPM link state on device
	remove
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>, Alex Chiang <achiang@hp.com>
Date: Wed, 28 Jan 2009 14:59:18 -0700
Message-ID: <20090128215918.28003.58805.stgit@bob.kio>
In-Reply-To: <20090128213814.28003.34634.stgit@bob.kio>
References: <20090128213814.28003.34634.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only want to disable ASPM when the last function is removed from
the parent's device list. We determine this by checking to see if
the parent's device list is completely empty.

Unfortunately, we never hit that code because the parent is considered
an upstream port, and never had an ASPM link_state associated with it.

The early check for !link_state causes us to return early, we never
discover that our device list is empty, and thus we never remove the
downstream ports' link_state nodes.

Instead of checking to see if the parent's device list is empty, we can
check to see if we are the last device on the list, and if so, then we
know that we can clean up properly.

Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/pcie/aspm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 586b6f7..b0367f1 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -718,9 +718,9 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 
 	/*
 	 * All PCIe functions are in one slot, remove one function will remove
-	 * the the whole slot, so just wait
+	 * the whole slot, so just wait until we are the last function left.
 	 */
-	if (!list_empty(&parent->subordinate->devices))
+	if (!list_is_last(&pdev->bus_list, &parent->subordinate->devices))
 		goto out;
 
 	/* All functions are removed, so just disable ASPM for the link */

