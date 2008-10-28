Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbYJ1POa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbYJ1POa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYJ1POU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:14:20 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:63937 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYJ1POT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:14:19 -0400
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K9GFN3-03-QI2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Jouni Malinen <jkmalinen@gmail.com>, Oliver Neukum <oliver@neukum.org>,
       Nicolas Bareil <nico@chdir.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, j@w1.fi, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86, gart: fix gart detection for Fam11h CPUs
Date: Tue, 28 Oct 2008 16:13:54 +0100
Message-ID: <1225206834-6189-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <e785a1360810280207p1c162decs5a70b8915ea08476@mail.gmail.com>
References: <e785a1360810280207p1c162decs5a70b8915ea08476@mail.gmail.com>
X-OriginalArrivalTime: 28 Oct 2008 15:13:54.0135 (UTC) FILETIME=[CA7E7E70:01C9390F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD Fam11h CPUs have a K8 northbridge. This northbridge is different
from other familys because it lacks GART support (as I just learned).
But the kernel implicitly expects a GART if it finds an AMD northbridge.
Fix this by removing the Fam11h northbridge id from the scan list of K8
northbridges. This patch also changes the message in the GART driver
about missing K8 northbridges to tell that the GART is missing which is
the correct information in this case.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/k8.c          |    1 -
 arch/x86/kernel/pci-gart_64.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index 304d8ba..cbc4332 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -18,7 +18,6 @@ static u32 *flush_words;
 struct pci_device_id k8_nb_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{}
 };
 EXPORT_SYMBOL(k8_nb_ids);
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index e3f75bb..a42b02b 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -744,7 +744,7 @@ void __init gart_iommu_init(void)
 	long i;
 
 	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0) {
-		printk(KERN_INFO "PCI-GART: No AMD northbridge found.\n");
+		printk(KERN_INFO "PCI-GART: No AMD GART found.\n");
 		return;
 	}
 
-- 
1.5.6.4


