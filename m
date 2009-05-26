Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbZEZV67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbZEZV67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZEZV6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:58:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55874 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbZEZV6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:58:51 -0400
Date: Tue, 26 May 2009 14:57:27 -0700
Message-Id: <200905262157.n4QLvRVH028289@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Additional x86 fixes for 2.6.30-rc8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the cleanup of Venki's WBINVD fix, and a fix for building
relocatable i386 kernels with some binutils versions.

The following changes since commit e2a1b9ee2335c35e0e34c88a024481b194b3c9cc:
  Linus Torvalds (1):
        Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Pallipadi, Venkatesh (1):
      x86: avoid back to back on_each_cpu in cpa_flush_array

Tejun Heo (1):
      x86, relocs: ignore R_386_NONE in kernel relocation entries

 arch/x86/boot/compressed/relocs.c |    7 +++++--
 arch/x86/mm/pageattr.c            |   17 +++--------------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index 857e492..bbeb0c3 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -504,8 +504,11 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 			if (sym->st_shndx == SHN_ABS) {
 				continue;
 			}
-			if (r_type == R_386_PC32) {
-				/* PC relative relocations don't need to be adjusted */
+			if (r_type == R_386_NONE || r_type == R_386_PC32) {
+				/*
+				 * NONE can be ignored and and PC relative
+				 * relocations don't need to be adjusted.
+				 */
 			}
 			else if (r_type == R_386_32) {
 				/* Visit relocations that need to be adjusted */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 0f9052b..e17efed 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -204,30 +204,19 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 	}
 }
 
-static void wbinvd_local(void *unused)
-{
-	wbinvd();
-}
-
 static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 			    int in_flags, struct page **pages)
 {
 	unsigned int i, level;
+	unsigned long do_wbinvd = cache && numpages >= 1024; /* 4M threshold */
 
 	BUG_ON(irqs_disabled());
 
-	on_each_cpu(__cpa_flush_range, NULL, 1);
+	on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);
 
-	if (!cache)
+	if (!cache || do_wbinvd)
 		return;
 
-	/* 4M threshold */
-	if (numpages >= 1024) {
-		if (boot_cpu_data.x86 >= 4)
-			on_each_cpu(wbinvd_local, NULL, 1);
-
-		return;
-	}
 	/*
 	 * We only need to flush on one CPU,
 	 * clflush is a MESI-coherent instruction that
