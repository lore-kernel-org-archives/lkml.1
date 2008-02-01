Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbYBALO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbYBALO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYBALOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:14:21 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:13565 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbYBALOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CfYhETLkkEeRomhPmEnznsq6JcoetYtWqMFzxRsrdy1qzj23FJcgG7ZmQA5sZT4/+29SkrNftus/ZLMP6PcBnyYZ3njWd53OKh/kOdtOpc0d7SACWzwFKwk4IMVEa2k/KMelX3gzzf1LeQytnGKXowtJKLsJj/P3eLNg+Ru5feg=
Subject: [PATCH] x86: fixes for lookup_address args
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 03:13:34 -0800
Message-Id: <1201864414.23523.111.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signedness mismatches in level argument.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, my other patch changing lookup_address was truncated and
missed the other call sites, here's the rest.  You can either
fold this into that patch or apply separately.

 arch/x86/kernel/efi_64.c    |    2 +-
 arch/x86/mm/fault.c         |    2 +-
 arch/x86/mm/ioremap.c       |    3 ++-
 arch/x86/mm/pageattr-test.c |    4 ++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
index 4b73992..674f237 100644
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -44,7 +44,7 @@ static void __init early_mapping_set_exec(unsigned long start,
 					  int executable)
 {
 	pte_t *kpte;
-	int level;
+	unsigned int level;
 
 	while (start < end) {
 		kpte = lookup_address((unsigned long)__va(start), &level);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e28cc52..e4440d0 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -382,7 +382,7 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 #ifdef CONFIG_X86_PAE
 	if (error_code & PF_INSTR) {
-		int level;
+		unsigned int level;
 		pte_t *pte = lookup_address(address, &level);
 
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index a177d76..c004d94 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -75,7 +75,8 @@ static int ioremap_change_attr(unsigned long paddr, unsigned long size,
 {
 	unsigned long vaddr = (unsigned long)__va(paddr);
 	unsigned long nrpages = size >> PAGE_SHIFT;
-	int err, level;
+	unsigned int level;
+	int err;
 
 	/* No change for pages after the last mapping */
 	if ((paddr + size - 1) >= (max_pfn_mapped << PAGE_SHIFT))
diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index 06353d4..7573e78 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -42,7 +42,7 @@ static __init int print_split(struct split_state *s)
 	s->max_exec = 0;
 	for (i = 0; i < max_pfn_mapped; ) {
 		unsigned long addr = (unsigned long)__va(i << PAGE_SHIFT);
-		int level;
+		unsigned int level;
 		pte_t *pte;
 
 		pte = lookup_address(addr, &level);
@@ -106,7 +106,7 @@ static __init int exercise_pageattr(void)
 	unsigned long *bm;
 	pte_t *pte, pte0;
 	int failed = 0;
-	int level;
+	unsigned int level;
 	int i, k;
 	int err;
 
-- 
1.5.4.rc4.1142.gf5a97



