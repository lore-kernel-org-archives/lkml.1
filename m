Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZKBSzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZKBSzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbZKBSzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:55:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:43992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618AbZKBSzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:55:51 -0500
Date: Mon, 2 Nov 2009 18:55:06 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091029024821.164525222@sbs-t61.sc.intel.com>
References: <20091029024821.164525222@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86_64, cpa: Use only text section in set_kernel_text_rw/ro
Message-ID: <tip-e7d23dde9b7ebb575e2bcee2abefc9ec1e4adde9@git.kernel.org>
Git-Commit-ID: e7d23dde9b7ebb575e2bcee2abefc9ec1e4adde9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7d23dde9b7ebb575e2bcee2abefc9ec1e4adde9
Gitweb:     http://git.kernel.org/tip/e7d23dde9b7ebb575e2bcee2abefc9ec1e4adde9
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 28 Oct 2009 18:46:58 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 17:17:24 +0100

x86_64, cpa: Use only text section in set_kernel_text_rw/ro

set_kernel_text_rw()/set_kernel_text_ro() are marking pages
starting from _text to __start_rodata as RW or RO.

With CONFIG_DEBUG_RODATA, there might be free pages (associated
with padding the sections to 2MB large page boundary) between
text and rodata sections that are given back to page allocator.
So we should use only use the start (__text) and end
(__stop___ex_table) of the text section in
set_kernel_text_rw()/set_kernel_text_ro().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20091029024821.164525222@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_64.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4b507c0..5198b9b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -700,7 +700,7 @@ int kernel_set_to_readonly;
 void set_kernel_text_rw(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
-	unsigned long end = PFN_ALIGN(__start_rodata);
+	unsigned long end = PFN_ALIGN(__stop___ex_table);
 
 	if (!kernel_set_to_readonly)
 		return;
@@ -708,13 +708,18 @@ void set_kernel_text_rw(void)
 	pr_debug("Set kernel text: %lx - %lx for read write\n",
 		 start, end);
 
+	/*
+	 * Make the kernel identity mapping for text RW. Kernel text
+	 * mapping will always be RO. Refer to the comment in
+	 * static_protections() in pageattr.c
+	 */
 	set_memory_rw(start, (end - start) >> PAGE_SHIFT);
 }
 
 void set_kernel_text_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
-	unsigned long end = PFN_ALIGN(__start_rodata);
+	unsigned long end = PFN_ALIGN(__stop___ex_table);
 
 	if (!kernel_set_to_readonly)
 		return;
@@ -722,6 +727,9 @@ void set_kernel_text_ro(void)
 	pr_debug("Set kernel text: %lx - %lx for read only\n",
 		 start, end);
 
+	/*
+	 * Set the kernel identity mapping for text RO.
+	 */
 	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
 }
 
