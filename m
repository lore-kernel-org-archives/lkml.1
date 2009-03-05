Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZCENjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZCENjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZCENhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:37:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:49905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbZCENho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:37:44 -0500
Date: Thu, 5 Mar 2009 13:37:07 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-5-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-5-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: ifdef 32-bit specific setup in init_memory_mapping()
Message-ID: <tip-54e63f3a4282a8bc5b39db29095f076ece2b1073@git.kernel.org>
Git-Commit-ID: 54e63f3a4282a8bc5b39db29095f076ece2b1073
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:37:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54e63f3a4282a8bc5b39db29095f076ece2b1073
Gitweb:     http://git.kernel.org/tip/54e63f3a4282a8bc5b39db29095f076ece2b1073
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:54:56 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:12 +0100

x86: ifdef 32-bit specific setup in init_memory_mapping()

Impact: cleanup

Enabling NX, PSE, and PGE are only required on 32-bit so ifdef them
in both versions of the function.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-5-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |    2 ++
 arch/x86/mm/init_64.c |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index cfc68d6..eb98cb9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -948,6 +948,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
+#ifdef CONFIG_X86_32
 #ifdef CONFIG_X86_PAE
 	set_nx();
 	if (nx_enabled)
@@ -963,6 +964,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		set_in_cr4(X86_CR4_PGE);
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
+#endif
 
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 151e5ba..c3c0be5 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -712,6 +712,24 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
+#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_PAE
+	set_nx();
+	if (nx_enabled)
+		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
+#endif
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+#endif
+
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
 	if (use_pse)
