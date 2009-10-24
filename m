Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZJXBEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZJXBEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZJXBD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:03:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:51526 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbZJXBD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:03:58 -0400
Date: Sat, 24 Oct 2009 01:03:39 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20091014220254.063193621@sbs-t61.sc.intel.com>
References: <20091014220254.063193621@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] x86-64: preserve large page mapping for 1st 2MB kernel txt with CONFIG_DEBUG_RODATA
Message-ID: <tip-b9af7c0d44b8bb71e3af5e94688d076414aa8c87@git.kernel.org>
Git-Commit-ID: b9af7c0d44b8bb71e3af5e94688d076414aa8c87
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9af7c0d44b8bb71e3af5e94688d076414aa8c87
Gitweb:     http://git.kernel.org/tip/b9af7c0d44b8bb71e3af5e94688d076414aa8c87
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 14 Oct 2009 14:46:55 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 20 Oct 2009 14:46:00 +0900

x86-64: preserve large page mapping for 1st 2MB kernel txt with CONFIG_DEBUG_RODATA

In the first 2MB, kernel text is co-located with kernel static
page tables setup by head_64.S.  CONFIG_DEBUG_RODATA chops this
2MB large page mapping to small 4KB pages as we mark the kernel text as RO,
leaving the static page tables as RW.

With CONFIG_DEBUG_RODATA disabled, OLTP run on NHM-EP shows 1% improvement
with 2% reduction in system time and 1% improvement in iowait idle time.

To recover this, move the kernel static page tables to .data section, so that
we don't have to break the first 2MB of kernel text to small pages with
CONFIG_DEBUG_RODATA.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20091014220254.063193621@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/head_64.S |    3 ++-
 arch/x86/mm/init_64.c     |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 780cd92..b55ee4f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -262,11 +262,11 @@ ENTRY(secondary_startup_64)
 	.quad	x86_64_start_kernel
 	ENTRY(initial_gs)
 	.quad	INIT_PER_CPU_VAR(irq_stack_union)
-	__FINITDATA
 
 	ENTRY(stack_start)
 	.quad  init_thread_union+THREAD_SIZE-8
 	.word  0
+	__FINITDATA
 
 bad_address:
 	jmp bad_address
@@ -340,6 +340,7 @@ ENTRY(name)
 	i = i + 1 ;					\
 	.endr
 
+	.data
 	/*
 	 * This default setting generates an ident mapping at address 0x100000
 	 * and a mapping for the kernel that precisely maps virtual address
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index c20d30b..7dafd41 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -699,7 +699,7 @@ static int kernel_set_to_readonly;
 
 void set_kernel_text_rw(void)
 {
-	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long start = PFN_ALIGN(_text);
 	unsigned long end = PFN_ALIGN(__start_rodata);
 
 	if (!kernel_set_to_readonly)
@@ -713,7 +713,7 @@ void set_kernel_text_rw(void)
 
 void set_kernel_text_ro(void)
 {
-	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long start = PFN_ALIGN(_text);
 	unsigned long end = PFN_ALIGN(__start_rodata);
 
 	if (!kernel_set_to_readonly)
@@ -727,7 +727,7 @@ void set_kernel_text_ro(void)
 
 void mark_rodata_ro(void)
 {
-	unsigned long start = PFN_ALIGN(_stext), end = PFN_ALIGN(__end_rodata);
+	unsigned long start = PFN_ALIGN(_text), end = PFN_ALIGN(__end_rodata);
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 
