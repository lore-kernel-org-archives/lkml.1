Return-Path: <linux-kernel-owner+w=401wt.eu-S1761946AbZBMUUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946AbZBMUUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760906AbZBMUTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:19:17 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:9554 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761160AbZBMUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:19:15 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH v2 04/12] PCI: properly clean up ASPM link state on device
	remove
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>, Alex Chiang <achiang@hp.com>
Date: Fri, 13 Feb 2009 13:19:13 -0700
Message-ID: <20090213201913.19262.74817.stgit@bob.kio>
In-Reply-To: <20090213201135.19262.67924.stgit@bob.kio>
References: <20090213201135.19262.67924.stgit@bob.kio>
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

