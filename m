Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZBIKdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZBIKdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZBIKcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:32:50 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:30419 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZBIKct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:32:49 -0500
X-BigFish: VPS-2(z34a4jz4015Mzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KESNYD-02-X52-01
Date: Mon, 9 Feb 2009 11:32:30 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: stable@kernel.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][stable-28] x86: microcode_amd: fix wrong handling of
	equivalent CPU id
Message-ID: <20090209103230.GB6041@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Feb 2009 10:32:34.0730 (UTC) FILETIME=[B88BB0A0:01C98AA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix bug resulting in non-loaded AMD microcode

mc_header->processor_rev_id is a 2 byte value. Similar is true for
equiv_cpu in an equiv_cpu_entry -- only 2 bytes are of interest.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

This fix is already upstream.
See

 commit 3c763fd77e66e55d029052da31df0abd9920cb1e
 (x86: microcode_amd: fix wrong handling of equivalent CPU id)

Please apply to stable-28.
Thanks,

Andreas


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



