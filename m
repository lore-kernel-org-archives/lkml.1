Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbZKBSzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbZKBSzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbZKBSzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:55:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:43984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201AbZKBSzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:55:36 -0500
Date: Mon, 2 Nov 2009 18:54:51 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091029024821.080941108@sbs-t61.sc.intel.com>
References: <20091029024821.080941108@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86_64, ftrace: Make ftrace use kernel identity mapping to modify code
Message-ID: <tip-55ca3cc1746335bb6ef1d3894ddb6d0c729b3518@git.kernel.org>
Git-Commit-ID: 55ca3cc1746335bb6ef1d3894ddb6d0c729b3518
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55ca3cc1746335bb6ef1d3894ddb6d0c729b3518
Gitweb:     http://git.kernel.org/tip/55ca3cc1746335bb6ef1d3894ddb6d0c729b3518
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 28 Oct 2009 18:46:57 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 17:16:36 +0100

x86_64, ftrace: Make ftrace use kernel identity mapping to modify code

On x86_64, kernel text mappings are mapped read-only with
CONFIG_DEBUG_RODATA. So use the kernel identity mapping instead
of the kernel text mapping to modify the kernel text.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20091029024821.080941108@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/ftrace.c |   17 +++++++++++++++++
 arch/x86/mm/pageattr.c   |    3 +--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 9dbb527..944e982 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -187,9 +187,26 @@ static void wait_for_nmi(void)
 	nmi_wait_count++;
 }
 
+static inline int
+within(unsigned long addr, unsigned long start, unsigned long end)
+{
+	return addr >= start && addr < end;
+}
+
 static int
 do_ftrace_mod_code(unsigned long ip, void *new_code)
 {
+	/*
+	 * On x86_64, kernel text mappings are mapped read-only with
+	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
+	 * of the kernel text mapping to modify the kernel text.
+	 *
+	 * For 32bit kernels, these mappings are same and we can use
+	 * kernel identity mapping to modify code.
+	 */
+	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
+		ip = (unsigned long)__va(__pa(ip));
+
 	mod_code_ip = (void *)ip;
 	mod_code_newcode = new_code;
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 8d1e8d9..09a140c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -279,8 +279,7 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA) && \
-	!defined(CONFIG_DYNAMIC_FTRACE)
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
 	/*
 	 * Once the kernel maps the text as RO (kernel_set_to_readonly is set),
 	 * kernel text mappings for the large page aligned text, rodata sections
