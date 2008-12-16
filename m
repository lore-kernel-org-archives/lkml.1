Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYLPSUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYLPSUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYLPSUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:20:39 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:62166 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYLPSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:20:38 -0500
X-BigFish: VPS1(zzzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBZEXU-02-WBB-01
Date: Tue, 16 Dec 2008 19:20:21 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 8/10] x86: microcode_amd: remove (wrong) chipset deivce ID
	checks
Message-ID: <20081216182021.GO7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:20:25.0099 (UTC) FILETIME=[F711D5B0:01C95FAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no chipset specific ucode. The checks are incorrect
anyway (e.g. pci device IDs are 16 bit and not 8 bit).

Thus I remove the stuff for the time being and will reintroduce it if
it's foreseeable that it is really needed.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   32 +++++---------------------------
 1 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e68e723..2e8af6e 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -108,7 +108,6 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 static int get_matching_microcode(int cpu, void *mc, int rev)
 {
 	struct microcode_header_amd *mc_header = mc;
-	struct pci_dev *nb_pci_dev, *sb_pci_dev;
 	unsigned int current_cpu_id;
 	unsigned int equiv_cpu_id = 0x00;
 	unsigned int i = 0;
@@ -137,32 +136,11 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 		return 0;
 	}
 
-	/* ucode may be northbridge specific */
-	if (mc_header->nb_dev_id) {
-		nb_pci_dev = pci_get_device(PCI_VENDOR_ID_AMD,
-					    (mc_header->nb_dev_id & 0xff),
-					    NULL);
-		if ((!nb_pci_dev) ||
-		    (mc_header->nb_rev_id != nb_pci_dev->revision)) {
-			printk(KERN_ERR "microcode: CPU%d NB mismatch\n", cpu);
-			pci_dev_put(nb_pci_dev);
-			return 0;
-		}
-		pci_dev_put(nb_pci_dev);
-	}
-
-	/* ucode may be southbridge specific */
-	if (mc_header->sb_dev_id) {
-		sb_pci_dev = pci_get_device(PCI_VENDOR_ID_AMD,
-					    (mc_header->sb_dev_id & 0xff),
-					    NULL);
-		if ((!sb_pci_dev) ||
-		    (mc_header->sb_rev_id != sb_pci_dev->revision)) {
-			printk(KERN_ERR "microcode: CPU%d SB mismatch\n", cpu);
-			pci_dev_put(sb_pci_dev);
-			return 0;
-		}
-		pci_dev_put(sb_pci_dev);
+	/* ucode might be chipset specific -- currently we don't support this */
+	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
+		printk(KERN_WARNING "microcode: CPU%d loading of chipset "
+		       "specific code not yet supported\n", cpu);
+		return 0;
 	}
 
 	if (mc_header->patch_id <= rev)
-- 
1.6.0.4



