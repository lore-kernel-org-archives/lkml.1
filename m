Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbZAWBPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbZAWBPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZAWBOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:40 -0500
Received: from kroah.org ([198.145.64.141]:50299 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755144AbZAWBOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:38 -0500
Date: Thu, 22 Jan 2009 17:11:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Shaohua Li <shaohua.li@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 01/46] PCI: keep ASPM link state consistent throughout PCIe
	hierarchy
Message-ID: <20090123011126.GB19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-keep-aspm-link-state-consistent-throughout-pcie-hierarchy.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 46bbdfa44cfc0d352148a0dc33ba9f6db02ccdf0 upstream.

In a PCIe hierarchy with a switch present, if the link state of an
endpoint device is changed, we must check the whole hierarchy from the
endpoint device to root port, and for each link in the hierarchy, the new
link state should be configured. Previously, the implementation checked
the state but forgot to configure the links between root port to switch.
Fixes Novell bz #448987.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Tested-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aspm.c |  127 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 107 insertions(+), 20 deletions(-)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -33,6 +33,11 @@ struct endpoint_state {
 struct pcie_link_state {
 	struct list_head sibiling;
 	struct pci_dev *pdev;
+	bool downstream_has_switch;
+
+	struct pcie_link_state *parent;
+	struct list_head children;
+	struct list_head link;
 
 	/* ASPM state */
 	unsigned int support_state;
@@ -125,7 +130,7 @@ static void pcie_set_clock_pm(struct pci
 	link_state->clk_pm_enabled = !!enable;
 }
 
-static void pcie_check_clock_pm(struct pci_dev *pdev)
+static void pcie_check_clock_pm(struct pci_dev *pdev, int blacklist)
 {
 	int pos;
 	u32 reg32;
@@ -149,10 +154,26 @@ static void pcie_check_clock_pm(struct p
 		if (!(reg16 & PCI_EXP_LNKCTL_CLKREQ_EN))
 			enabled = 0;
 	}
-	link_state->clk_pm_capable = capable;
 	link_state->clk_pm_enabled = enabled;
 	link_state->bios_clk_state = enabled;
-	pcie_set_clock_pm(pdev, policy_to_clkpm_state(pdev));
+	if (!blacklist) {
+		link_state->clk_pm_capable = capable;
+		pcie_set_clock_pm(pdev, policy_to_clkpm_state(pdev));
+	} else {
+		link_state->clk_pm_capable = 0;
+		pcie_set_clock_pm(pdev, 0);
+	}
+}
+
+static bool pcie_aspm_downstream_has_switch(struct pci_dev *pdev)
+{
+	struct pci_dev *child_dev;
+
+	list_for_each_entry(child_dev, &pdev->subordinate->devices, bus_list) {
+		if (child_dev->pcie_type == PCI_EXP_TYPE_UPSTREAM)
+			return true;
+	}
+	return false;
 }
 
 /*
@@ -419,9 +440,9 @@ static unsigned int pcie_aspm_check_stat
 {
 	struct pci_dev *child_dev;
 
-	/* If no child, disable the link */
+	/* If no child, ignore the link */
 	if (list_empty(&pdev->subordinate->devices))
-		return 0;
+		return state;
 	list_for_each_entry(child_dev, &pdev->subordinate->devices, bus_list) {
 		if (child_dev->pcie_type == PCI_EXP_TYPE_PCI_BRIDGE) {
 			/*
@@ -462,6 +483,9 @@ static void __pcie_aspm_config_link(stru
 	int valid = 1;
 	struct pcie_link_state *link_state = pdev->link_state;
 
+	/* If no child, disable the link */
+	if (list_empty(&pdev->subordinate->devices))
+		state = 0;
 	/*
 	 * if the downstream component has pci bridge function, don't do ASPM
 	 * now
@@ -493,20 +517,52 @@ static void __pcie_aspm_config_link(stru
 	link_state->enabled_state = state;
 }
 
+static struct pcie_link_state *get_root_port_link(struct pcie_link_state *link)
+{
+	struct pcie_link_state *root_port_link = link;
+	while (root_port_link->parent)
+		root_port_link = root_port_link->parent;
+	return root_port_link;
+}
+
+/* check the whole hierarchy, and configure each link in the hierarchy */
 static void __pcie_aspm_configure_link_state(struct pci_dev *pdev,
 	unsigned int state)
 {
 	struct pcie_link_state *link_state = pdev->link_state;
+	struct pcie_link_state *root_port_link = get_root_port_link(link_state);
+	struct pcie_link_state *leaf;
 
-	if (link_state->support_state == 0)
-		return;
 	state &= PCIE_LINK_STATE_L0S|PCIE_LINK_STATE_L1;
 
-	/* state 0 means disabling aspm */
-	state = pcie_aspm_check_state(pdev, state);
+	/* check all links who have specific root port link */
+	list_for_each_entry(leaf, &link_list, sibiling) {
+		if (!list_empty(&leaf->children) ||
+			get_root_port_link(leaf) != root_port_link)
+			continue;
+		state = pcie_aspm_check_state(leaf->pdev, state);
+	}
+	/* check root port link too in case it hasn't children */
+	state = pcie_aspm_check_state(root_port_link->pdev, state);
+
 	if (link_state->enabled_state == state)
 		return;
-	__pcie_aspm_config_link(pdev, state);
+
+	/*
+	 * we must change the hierarchy. See comments in
+	 * __pcie_aspm_config_link for the order
+	 **/
+	if (state & PCIE_LINK_STATE_L1) {
+		list_for_each_entry(leaf, &link_list, sibiling) {
+			if (get_root_port_link(leaf) == root_port_link)
+				__pcie_aspm_config_link(leaf->pdev, state);
+		}
+	} else {
+		list_for_each_entry_reverse(leaf, &link_list, sibiling) {
+			if (get_root_port_link(leaf) == root_port_link)
+				__pcie_aspm_config_link(leaf->pdev, state);
+		}
+	}
 }
 
 /*
@@ -570,6 +626,7 @@ void pcie_aspm_init_link_state(struct pc
 	unsigned int state;
 	struct pcie_link_state *link_state;
 	int error = 0;
+	int blacklist;
 
 	if (aspm_disabled || !pdev->is_pcie || pdev->link_state)
 		return;
@@ -580,29 +637,58 @@ void pcie_aspm_init_link_state(struct pc
 	if (list_empty(&pdev->subordinate->devices))
 		goto out;
 
-	if (pcie_aspm_sanity_check(pdev))
-		goto out;
+	blacklist = !!pcie_aspm_sanity_check(pdev);
 
 	mutex_lock(&aspm_lock);
 
 	link_state = kzalloc(sizeof(*link_state), GFP_KERNEL);
 	if (!link_state)
 		goto unlock_out;
-	pdev->link_state = link_state;
 
-	pcie_aspm_configure_common_clock(pdev);
-
-	pcie_aspm_cap_init(pdev);
+	link_state->downstream_has_switch = pcie_aspm_downstream_has_switch(pdev);
+	INIT_LIST_HEAD(&link_state->children);
+	INIT_LIST_HEAD(&link_state->link);
+	if (pdev->bus->self) {/* this is a switch */
+		struct pcie_link_state *parent_link_state;
+
+		parent_link_state = pdev->bus->parent->self->link_state;
+		if (!parent_link_state) {
+			kfree(link_state);
+			goto unlock_out;
+		}
+		list_add(&link_state->link, &parent_link_state->children);
+		link_state->parent = parent_link_state;
+	}
 
-	/* config link state to avoid BIOS error */
-	state = pcie_aspm_check_state(pdev, policy_to_aspm_state(pdev));
-	__pcie_aspm_config_link(pdev, state);
+	pdev->link_state = link_state;
 
-	pcie_check_clock_pm(pdev);
+	if (!blacklist) {
+		pcie_aspm_configure_common_clock(pdev);
+		pcie_aspm_cap_init(pdev);
+	} else {
+		link_state->enabled_state = PCIE_LINK_STATE_L0S|PCIE_LINK_STATE_L1;
+		link_state->bios_aspm_state = 0;
+		/* Set support state to 0, so we will disable ASPM later */
+		link_state->support_state = 0;
+	}
 
 	link_state->pdev = pdev;
 	list_add(&link_state->sibiling, &link_list);
 
+	if (link_state->downstream_has_switch) {
+		/*
+		 * If link has switch, delay the link config. The leaf link
+		 * initialization will config the whole hierarchy. but we must
+		 * make sure BIOS doesn't set unsupported link state
+		 **/
+		state = pcie_aspm_check_state(pdev, link_state->bios_aspm_state);
+		__pcie_aspm_config_link(pdev, state);
+	} else
+		__pcie_aspm_configure_link_state(pdev,
+			policy_to_aspm_state(pdev));
+
+	pcie_check_clock_pm(pdev, blacklist);
+
 unlock_out:
 	if (error)
 		free_link_state(pdev);
@@ -635,6 +721,7 @@ void pcie_aspm_exit_link_state(struct pc
 	/* All functions are removed, so just disable ASPM for the link */
 	__pcie_aspm_config_one_dev(parent, 0);
 	list_del(&link_state->sibiling);
+	list_del(&link_state->link);
 	/* Clock PM is for endpoint device */
 
 	free_link_state(parent);

