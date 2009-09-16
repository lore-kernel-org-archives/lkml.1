Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbZIPNvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbZIPNvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbZIPNvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:51:41 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:57938
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752979AbZIPNvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:51:39 -0400
X-SpamScore: 10
X-BigFish: VPS10(zza4b1ozz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KQ2H5V-03-4MW-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <torvalds@linux-foundation.org>
CC: <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/5] x86, EDAC: Provide function to return NodeId of a CPU
Date: Wed, 16 Sep 2009 15:50:47 +0200
Message-ID: <1253109050-31165-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
References: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:51:23.0316 (UTC) FILETIME=[C700B740:01CA36D4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/amd.c        |   10 ++++++++++
 drivers/edac/edac_mce_amd.c      |    2 +-
 3 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e08ea04..42a3f93 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1020,4 +1020,6 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
+extern int amd_get_nb_id(int cpu);
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 22a47c8..f32fa71 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -333,6 +333,16 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 #endif
 }
 
+int amd_get_nb_id(int cpu)
+{
+	int id = 0;
+#ifdef CONFIG_SMP
+	id = per_cpu(cpu_llc_id, cpu);
+#endif
+	return id;
+}
+EXPORT_SYMBOL_GPL(amd_get_nb_id);
+
 static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index c8ca713..0c21c37 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -405,7 +405,7 @@ void decode_mce(struct mce *m)
 		regs.nbsh  = (u32)(m->status >> 32);
 		regs.nbeal = (u32) m->addr;
 		regs.nbeah = (u32)(m->addr >> 32);
-		node       = per_cpu(cpu_llc_id, m->extcpu);
+		node       = amd_get_nb_id(m->extcpu);
 
 		amd_decode_nb_mce(node, &regs, 1);
 		break;
-- 
1.6.3.3


