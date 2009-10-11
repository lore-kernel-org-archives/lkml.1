Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbZJKVBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbZJKVBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZJKVBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:01:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:56118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZJKVBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:01:34 -0400
Message-ID: <4AD24766.7050205@kernel.org>
Date: Sun, 11 Oct 2009 14:00:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Brad Spengler <spender@grsecurity.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] pci: fix crash about old IA64 about pci_cfg_space_size
References: <20091011074531.GA12357@grsecurity.net> <4AD1AE0D.1030007@kernel.org>
In-Reply-To: <4AD1AE0D.1030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Brad reported that his SGI 750 (Itanium 1) will crash from 2.6.26, and bisected
to 

| commit: dfadd9edff498d767008edc6b2a6e86a7a19934d
|
|Many host bridges support a 4k config space, so check them directy
|instead of using quirks to add them.
|
|We only need to do this extra check for host bridges at this point,
|because only host bridges are known to have extended address space
|without also having a PCI-X/PCI-E caps.  Other devices with this
|property could be done with quirks (if there are any).
|
|As a bonus, we can remove the quirks for AMD host bridges with family
|10h and 11h since they're not needed any more.
|
|With this patch, we can get correct pci cfg size of new Intel CPUs/IOHs
|with host bridges.

it turns out for old IA64 without SAL 3.2 pci_cfg_space_size_ext will cause
problem and those system didn't have PCI-X and PCI-E, so that function was
not called before.

so don't call it in pci_cfg_sapce_size now.
later call it after pci ops code in ia64 could detect and use raw_pci_ops
and raw_pci_ext_ops according to SAL version.

Reported-by: Brad Spengler <spender@grsecurity.net>
Bisected-by: Brad Spengler <spender@grsecurity.net>
Tested-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..0c80a07 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -901,11 +901,24 @@ int pci_cfg_space_size(struct pci_dev *dev)
 {
 	int pos;
 	u32 status;
+
+#ifndef CONFIG_IA64
+/*
+ * not use it with IA64 at this point
+ * ia64 SAL 3.2 before doesn't support ext space, so
+ * pci_read_config_dword(dev, 0x100, &status) would cause GP
+ * the problem is not triggered, because system with SAL 3.2 before
+ * doesn't include PCI-X 2.0 or PCI Express, so pci_cfg_spce_size_ext()
+ * is not called with them.
+ * need to extend ia64 to detect sal version, and pci_root_ops
+ * to use raw_pci_ops and raw_pci_ext_ops like x86
+ */
 	u16 class;
 
 	class = dev->class >> 8;
 	if (class == PCI_CLASS_BRIDGE_HOST)
 		return pci_cfg_space_size_ext(dev);
+#endif
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!pos) {
