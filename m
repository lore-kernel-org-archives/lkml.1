Return-Path: <linux-kernel-owner+w=401wt.eu-S1751561AbZLNFfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbZLNFfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZLNFfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:35:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56618 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZLNFe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:34:59 -0500
Date: Mon, 14 Dec 2009 16:34:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Albert Herranz <albert_herranz@yahoo.es>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
Subject: linux-next: 52xx-and-virtex tree build failure
Message-Id: <20091214163456.e2e948cc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

arch/powerpc/mm/pgtable_32.c: In function 'mapin_ram':
arch/powerpc/mm/pgtable_32.c:318: error: too many arguments to function 'mmu_mapin_ram'

Casued by commit de32400dd26e743c5d500aa42d8d6818b79edb73 ("wii: use both
mem1 and mem2 as ram").

I applied the following patch for today, but this may be too much or
there may be a better solution.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 14 Dec 2009 16:04:15 +1100
Subject: [PATCH] powerpc: fix up for mmu_mapin_ram api change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/mm/40x_mmu.c       |    2 +-
 arch/powerpc/mm/44x_mmu.c       |    2 +-
 arch/powerpc/mm/fsl_booke_mmu.c |    2 +-
 arch/powerpc/mm/mmu_decl.h      |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/mm/40x_mmu.c b/arch/powerpc/mm/40x_mmu.c
index f5e7b9c..08dfa8e 100644
--- a/arch/powerpc/mm/40x_mmu.c
+++ b/arch/powerpc/mm/40x_mmu.c
@@ -91,7 +91,7 @@ void __init MMU_init_hw(void)
 #define LARGE_PAGE_SIZE_16M	(1<<24)
 #define LARGE_PAGE_SIZE_4M	(1<<22)
 
-unsigned long __init mmu_mapin_ram(void)
+unsigned long __init mmu_mapin_ram(unsigned long top)
 {
 	unsigned long v, s, mapped;
 	phys_addr_t p;
diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
index 98052ac..3986264 100644
--- a/arch/powerpc/mm/44x_mmu.c
+++ b/arch/powerpc/mm/44x_mmu.c
@@ -88,7 +88,7 @@ void __init MMU_init_hw(void)
 	flush_instruction_cache();
 }
 
-unsigned long __init mmu_mapin_ram(void)
+unsigned long __init mmu_mapin_ram(unsigned long top)
 {
 	unsigned long addr;
 
diff --git a/arch/powerpc/mm/fsl_booke_mmu.c b/arch/powerpc/mm/fsl_booke_mmu.c
index fcfcb6e..c539472 100644
--- a/arch/powerpc/mm/fsl_booke_mmu.c
+++ b/arch/powerpc/mm/fsl_booke_mmu.c
@@ -207,7 +207,7 @@ unsigned long map_mem_in_cams(unsigned long ram, int max_cam_idx)
 	return amount_mapped;
 }
 
-unsigned long __init mmu_mapin_ram(void)
+unsigned long __init mmu_mapin_ram(unsigned long top)
 {
 	return tlbcam_addrs[tlbcam_index - 1].limit - PAGE_OFFSET + 1;
 }
diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
index eef7aaf..d49a775 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -139,15 +139,15 @@ extern void wii_memory_fixups(void);
  */
 #if defined(CONFIG_8xx)
 #define MMU_init_hw()		do { } while(0)
-#define mmu_mapin_ram()		(0UL)
+#define mmu_mapin_ram(top)	(0UL)
 
 #elif defined(CONFIG_4xx)
 extern void MMU_init_hw(void);
-extern unsigned long mmu_mapin_ram(void);
+extern unsigned long mmu_mapin_ram(unsigned long top);
 
 #elif defined(CONFIG_FSL_BOOKE)
 extern void MMU_init_hw(void);
-extern unsigned long mmu_mapin_ram(void);
+extern unsigned long mmu_mapin_ram(unsigned long top);
 extern void adjust_total_lowmem(void);
 
 #elif defined(CONFIG_PPC32)
-- 
1.6.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
