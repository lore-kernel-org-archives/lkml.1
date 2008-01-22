Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYAVVAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYAVVAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYAVVAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:00:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:53039 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYAVVAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:00:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AqKRadGzn9UDwYUnvbhBTJO0PszcGTlVsxShaQFWcbKiW5R3s9KxJED3K3X6/Np7EksoV3pOIDYL5p0H6QrksL/sQCgHwbYtLDcWZb2k56GOUEIFdfgqnuMaW3RLPGtldsHjRG8jCbzF14bXPAKt18Rbf9rDOqy+hVB1dHT7BDY=
Subject: [PATCH] x86: make nx_enabled conditional on CONFIG_X86_PAE
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <ijc@hellion.org.uk>,
       Mika =?ISO-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20080122203611.GA12892@elte.hu>
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	 <47939363.8040603@kolumbus.fi>
	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
	 <479510CE.7010706@zytor.com>
	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>
	 <479551FD.5040801@zytor.com>
	 <1201023401.5643.52.camel@localhost.localdomain>
	 <479634A9.1090908@zytor.com>
	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>
	 <47964B7B.9000905@zytor.com>  <20080122203611.GA12892@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 13:00:11 -0800
Message-Id: <1201035611.16972.61.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nx_enabled can only be set to non-zero when CONFIG_X86_PAE is
set.  The only use not currently inside a CONFIG_X86_PAE block
is the definition, the declaration and a conditional unlikely
test in fault_32.c (is_prefetch).

When !CONFIG_X86_PAE, is_prefetch always returns 0 immediately
as nx_enabled is always 0.

When CONFIG_X86_PAE, the test is preserved, but the test against
the cpu model and stepping is deleted, this may not be correct.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, further to your nx vs !nx comment, had this lying around,
needs testing, only affects the CONFIG_X86_PAE case.

 arch/x86/mm/fault_32.c    |   17 ++++++++---------
 arch/x86/mm/fault_64.c    |   17 ++++++++---------
 arch/x86/mm/init_32.c     |    4 +---
 include/asm-x86/page_32.h |    2 ++
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 0bd2417..049c3bb 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -81,16 +81,15 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	unsigned char *max_instr;
 
 #ifdef CONFIG_X86_32
-	if (unlikely(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-		     boot_cpu_data.x86 >= 6)) {
-		/* Catch an obscure case of prefetch inside an NX page. */
-		if (nx_enabled && (error_code & PF_INSTR))
-			return 0;
-	} else {
+# ifdef CONFIG_X86_PAE
+	/* If it was a exec fault on NX page, ignore */
+	if (nx_enabled && (error_code & PF_INSTR))
 		return 0;
-	}
-#else
-	/* If it was a exec fault ignore */
+# else
+	return 0;
+# endif
+#else /* CONFIG_X86_64 */
+	/* If it was a exec fault on NX page, ignore */
 	if (error_code & PF_INSTR)
 		return 0;
 #endif
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index ccbb8e3..33e8ced 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -84,16 +84,15 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	unsigned char *max_instr;
 
 #ifdef CONFIG_X86_32
-	if (unlikely(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-		     boot_cpu_data.x86 >= 6)) {
-		/* Catch an obscure case of prefetch inside an NX page. */
-		if (nx_enabled && (error_code & PF_INSTR))
-			return 0;
-	} else {
+# ifdef CONFIG_X86_PAE
+	/* If it was a exec fault on NX page, ignore */
+	if (nx_enabled && (error_code & PF_INSTR))
 		return 0;
-	}
-#else
-	/* If it was a exec fault ignore */
+# else
+	return 0;
+# endif
+#else /* CONFIG_X86_64 */
+	/* If it was a exec fault on NX page, ignore */
 	if (error_code & PF_INSTR)
 		return 0;
 #endif
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 358d3b9..317cf5d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -478,13 +478,11 @@ void zap_low_mappings (void)
 	flush_tlb_all();
 }
 
-int nx_enabled = 0;
-
 pteval_t __supported_pte_mask __read_mostly = ~_PAGE_NX;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 #ifdef CONFIG_X86_PAE
-
+int nx_enabled = 0;
 static int disable_nx __initdata = 0;
 
 /*
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index 11c4b39..251f972 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -65,7 +65,9 @@ typedef pte_t boot_pte_t;
 #define pfn_valid(pfn)		((pfn) < max_mapnr)
 #endif /* CONFIG_FLATMEM */
 
+#ifdef CONFIG_X86_PAE
 extern int nx_enabled;
+#endif
 
 /*
  * This much address space is reserved for vmalloc() and iomap()
-- 
1.5.4.rc3.1118.gf6754c



