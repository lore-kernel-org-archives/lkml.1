Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZKBS45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZKBS45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbZKBS44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:56:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:44017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703AbZKBS4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:56:55 -0500
Date: Mon, 2 Nov 2009 18:54:35 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091029024820.996634347@sbs-t61.sc.intel.com>
References: <20091029024820.996634347@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, cpa: Fix kernel text RO checks in static_protection()
Message-ID: <tip-502f660466ba7a66711ffdf414b1f7f1131dcbf7@git.kernel.org>
Git-Commit-ID: 502f660466ba7a66711ffdf414b1f7f1131dcbf7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  502f660466ba7a66711ffdf414b1f7f1131dcbf7
Gitweb:     http://git.kernel.org/tip/502f660466ba7a66711ffdf414b1f7f1131dcbf7
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 28 Oct 2009 18:46:56 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 17:16:35 +0100

x86, cpa: Fix kernel text RO checks in static_protection()

Steven Rostedt reported that we are unconditionally making the
kernel text mapping as read-only. i.e., if someone does cpa() to
the kernel text area for setting/clearing any page table
attribute, we unconditionally clear the read-write attribute for
the kernel text mapping that is set at compile time.

We should delay (to forbid the write attribute) and enforce only
after the kernel has mapped the text as read-only.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20091029024820.996634347@sbs-t61.sc.intel.com>
[ marked kernel_set_to_readonly as __read_mostly ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/cacheflush.h |    1 +
 arch/x86/mm/init_32.c             |    2 +-
 arch/x86/mm/init_64.c             |    2 +-
 arch/x86/mm/pageattr.c            |   10 ++++++----
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index b54f6af..eebb2cd 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -176,6 +176,7 @@ void clflush_cache_range(void *addr, unsigned int size);
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 extern const int rodata_test_data;
+extern int kernel_set_to_readonly;
 void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
 #else
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index f64d0d5..c973f8e 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -997,7 +997,7 @@ static noinline int do_test_wp_bit(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
-static int kernel_set_to_readonly;
+int kernel_set_to_readonly __read_mostly;
 
 void set_kernel_text_rw(void)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0ed09fa..4b507c0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -695,7 +695,7 @@ void __init mem_init(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
-static int kernel_set_to_readonly;
+int kernel_set_to_readonly;
 
 void set_kernel_text_rw(void)
 {
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 78d3168..8d1e8d9 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -282,14 +282,16 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA) && \
 	!defined(CONFIG_DYNAMIC_FTRACE)
 	/*
-	 * Kernel text mappings for the large page aligned .rodata section
-	 * will be read-only. For the kernel identity mappings covering
-	 * the holes caused by this alignment can be anything.
+	 * Once the kernel maps the text as RO (kernel_set_to_readonly is set),
+	 * kernel text mappings for the large page aligned text, rodata sections
+	 * will be always read-only. For the kernel identity mappings covering
+	 * the holes caused by this alignment can be anything that user asks.
 	 *
 	 * This will preserve the large page mappings for kernel text/data
 	 * at no extra cost.
 	 */
-	if (within(address, (unsigned long)_text,
+	if (kernel_set_to_readonly &&
+	    within(address, (unsigned long)_text,
 		   (unsigned long)__end_rodata_hpage_align))
 		pgprot_val(forbidden) |= _PAGE_RW;
 #endif
