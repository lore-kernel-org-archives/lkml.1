Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZC2Tbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZC2Tbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZC2Tbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:31:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:34201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZC2Tbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:31:43 -0400
Message-ID: <49CFCC3D.5020205@kernel.org>
Date: Sun, 29 Mar 2009 12:30:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Prakash Punnoor <prakash@punnoor.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH] pci: don't enable too much HT MSI mapping -v6
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903281431.36572.prakash@punnoor.de> <86802c440903281352v1a12a5a2kbda5a039d72aa26f@mail.gmail.com> <200903282316.55142.prakash@punnoor.de>
In-Reply-To: <200903282316.55142.prakash@punnoor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix bug

Prakash reported that his c51-mcp51 system ondie sound card doesn't work MSI
but if he hack out the HT-MSI on mcp51, the MSI will work well with sound card.

this patch rework the nv_msi_ht_cap_quirk()
and will only try to avoid to enable ht_msi on device following that root dev,
and don't touch that root dev

v6: only do that trick with end_device on the chain.

Reported-by: Prakash Punnoor <prakash@punnoor.de>
Tested-by: Prakash Punnoor <prakash@punnoor.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index faf02dd..52714f2 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2206,6 +2206,33 @@ static int __devinit host_bridge_with_leaf(struct pci_dev *host_bridge)
 	return found;
 }
 
+#define PCI_HT_CAP_SLAVE_CTRL0     4    /* link control */
+#define PCI_HT_CAP_SLAVE_CTRL1     8    /* link control to */
+
+static int __devinit is_end_of_ht_chain(struct pci_dev *dev)
+{
+	int pos, ctrl_off;
+	int end = 0;
+	u16 flags, ctrl;
+
+	pos = pci_find_ht_capability(dev, HT_CAPTYPE_SLAVE);
+
+	if (!pos)
+		goto out;
+
+	pci_read_config_word(dev, pos + PCI_CAP_FLAGS, &flags);
+
+	ctrl_off = ((flags >> 10) & 1) ?
+			PCI_HT_CAP_SLAVE_CTRL0 : PCI_HT_CAP_SLAVE_CTRL1;
+	pci_read_config_word(dev, pos + ctrl_off, &ctrl);
+
+	if (ctrl & (1 << 6))
+		end = 1;
+
+out:
+	return end;
+}
+
 static void __devinit nv_ht_enable_msi_mapping(struct pci_dev *dev)
 {
 	struct pci_dev *host_bridge;
@@ -2230,8 +2257,9 @@ static void __devinit nv_ht_enable_msi_mapping(struct pci_dev *dev)
 	if (!found)
 		return;
 
-	/* don't enable host_bridge with leaf directly here */
-	if (host_bridge == dev && host_bridge_with_leaf(host_bridge))
+	/* don't enable end_device/host_bridge with leaf directly here */
+	if (host_bridge == dev && is_end_of_ht_chain(host_bridge) &&
+	    host_bridge_with_leaf(host_bridge))
 		goto out;
 
 	/* root did that ! */

