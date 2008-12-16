Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYLPSIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYLPSIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYLPSIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:08:05 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:6598 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYLPSIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:08:04 -0500
X-BigFish: VPS1(zzzzzzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KBZECX-02-VND-01
Date: Tue, 16 Dec 2008 19:07:47 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 1/10] x86: microcode_amd: fix wrong handling of equivalent
	CPU id
Message-ID: <20081216180747.GH7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:07:50.0559 (UTC) FILETIME=[35542AF0:01C95FA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc_header->processor_rev_id is a 2 byte value. Similar is true for
equiv_cpu in an equiv_cpu_entry -- only 2 bytes are of interest.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 5f8e5d7..b5bc814 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -62,7 +62,7 @@ struct microcode_header_amd {
 	unsigned int  mc_patch_data_checksum;
 	unsigned int  nb_dev_id;
 	unsigned int  sb_dev_id;
-	unsigned char processor_rev_id[2];
+	u16 processor_rev_id;
 	unsigned char nb_rev_id;
 	unsigned char sb_rev_id;
 	unsigned char bios_api_rev;
@@ -125,7 +125,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 
 	while (equiv_cpu_table[i].installed_cpu != 0) {
 		if (current_cpu_id == equiv_cpu_table[i].installed_cpu) {
-			equiv_cpu_id = equiv_cpu_table[i].equiv_cpu;
+			equiv_cpu_id = equiv_cpu_table[i].equiv_cpu & 0xffff;
 			break;
 		}
 		i++;
@@ -137,21 +137,10 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 		return 0;
 	}
 
-	if ((mc_header->processor_rev_id[0]) != (equiv_cpu_id & 0xff)) {
-		printk(KERN_ERR
-			"microcode: CPU%d patch does not match "
-			"(patch is %x, cpu extended is %x) \n",
-			cpu, mc_header->processor_rev_id[0],
-			(equiv_cpu_id & 0xff));
-		return 0;
-	}
-
-	if ((mc_header->processor_rev_id[1]) != ((equiv_cpu_id >> 16) & 0xff)) {
-		printk(KERN_ERR "microcode: CPU%d patch does not match "
-			"(patch is %x, cpu base id is %x) \n",
-			cpu, mc_header->processor_rev_id[1],
-			((equiv_cpu_id >> 16) & 0xff));
-
+	if (mc_header->processor_rev_id != equiv_cpu_id) {
+		printk(KERN_ERR	"microcode: CPU%d patch does not match "
+		       "(processor_rev_id: %x, eqiv_cpu_id: %x)\n",
+		       cpu, mc_header->processor_rev_id, equiv_cpu_id);
 		return 0;
 	}
 
-- 
1.6.0.4



