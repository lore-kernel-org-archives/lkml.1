Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZGSP1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZGSP1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZGSP1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:27:06 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:47154 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbZGSP1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:27:01 -0400
Date: Sun, 19 Jul 2009 17:26:58 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: kristen.c.accardi@intel.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/10] drivers/pci: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0907191726360.16542@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E,E1;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E=E1
      when != i
  if (E == NULL||...) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/pci/pcie/aspm.c             |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 3d27c97..fc8311b 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -668,10 +668,11 @@ out:
 void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 {
 	struct pci_dev *parent = pdev->bus->self;
-	struct pcie_link_state *link_state = parent->link_state;
+	struct pcie_link_state *link_state;
 
-	if (aspm_disabled || !pdev->is_pcie || !parent || !link_state)
+	if (aspm_disabled || !pdev->is_pcie || !parent || !parent->link_state)
 		return;
+	link_state = parent->link_state;
 	if (parent->pcie_type != PCI_EXP_TYPE_ROOT_PORT &&
 		parent->pcie_type != PCI_EXP_TYPE_DOWNSTREAM)
 		return;
