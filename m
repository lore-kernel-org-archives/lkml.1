Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbXLRB5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbXLRB5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXLRB5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:57:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:44173 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbXLRB5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:57:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,178,1196668800"; 
   d="scan'208";a="298982018"
Subject: [patch 3/3]pci: avoid save the same type of cap multiple times
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 09:57:09 +0800
Message-Id: <1197943029.17023.18.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid adding the same type of cap multiple times, otherwise we will see dead loop.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c	2007-12-18 09:37:12.000000000 +0800
+++ linux/drivers/pci/pci.c	2007-12-18 09:41:26.000000000 +0800
@@ -551,6 +551,7 @@ static int pci_save_pcie_state(struct pc
 	int pos, i = 0;
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
+	int found = 0;
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (pos <= 0)
@@ -559,6 +560,8 @@ static int pci_save_pcie_state(struct pc
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
 	if (!save_state)
 		save_state = kzalloc(sizeof(*save_state) + sizeof(u16) * 4, GFP_KERNEL);
+	else
+		found = 1;
 	if (!save_state) {
 		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
 		return -ENOMEM;
@@ -570,7 +573,8 @@ static int pci_save_pcie_state(struct pc
 	pci_read_config_word(dev, pos + PCI_EXP_SLTCTL, &cap[i++]);
 	pci_read_config_word(dev, pos + PCI_EXP_RTCTL, &cap[i++]);
 	save_state->cap_nr = PCI_CAP_ID_EXP;
-	pci_add_saved_cap(dev, save_state);
+	if (!found)
+		pci_add_saved_cap(dev, save_state);
 	return 0;
 }
 
@@ -598,6 +602,7 @@ static int pci_save_pcix_state(struct pc
 	int pos, i = 0;
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
+	int found = 0;
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
 	if (pos <= 0)
@@ -606,6 +611,8 @@ static int pci_save_pcix_state(struct pc
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
 	if (!save_state)
 		save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
+	else
+		found = 1;
 	if (!save_state) {
 		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
 		return -ENOMEM;
@@ -614,7 +621,8 @@ static int pci_save_pcix_state(struct pc
 
 	pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
 	save_state->cap_nr = PCI_CAP_ID_PCIX;
-	pci_add_saved_cap(dev, save_state);
+	if (!found)
+		pci_add_saved_cap(dev, save_state);
 	return 0;
 }
 


