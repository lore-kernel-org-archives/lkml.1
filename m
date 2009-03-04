Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZCDCji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZCDCji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZCDCj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:39:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:40127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbZCDCj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:39:26 -0500
Message-ID: <49ADE9D3.6080000@kernel.org>
Date: Wed, 04 Mar 2009 11:39:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, pgnet.trash@gmail.com
Subject: [PATCH 2.6.29-rc7 2/2] x86: disallow DAC for MCP51 PCI bridge
References: <49ADE82D.40103@kernel.org>
In-Reply-To: <49ADE82D.40103@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 02:38:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MCP51 corrupts DAC transfers.  Disallow it.  Reported by pgnet on
bnc#463829.

  https://bugzilla.novell.com/show_bug.cgi?id=463829

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: pgnet <pgnet.trash@gmail.com>
---
 arch/x86/kernel/pci-dma.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b254285..7b61798 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -296,4 +296,18 @@ static __devinit void via_no_dac(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
+
+/*
+ * MCP51 PCI bridge corrupts data for DAC.  Disable it.  Reported in
+ * bnc#463829.
+ */
+static __devinit void mcp51_no_dac(struct pci_dev *dev)
+{
+	if (forbid_dac == 0) {
+		printk(KERN_INFO
+		       "PCI: MCP51 PCI bridge detected. Disabling DAC.\n");
+		forbid_dac = 1;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x026f, mcp51_no_dac);
 #endif
