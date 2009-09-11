Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZIKATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZIKATn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZIKATm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:19:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:32813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZIKATl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:19:41 -0400
Date: Fri, 11 Sep 2009 00:19:15 GMT
From: tip-bot for Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ben@decadent.org.uk
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ben@decadent.org.uk
In-Reply-To: <1252547631.3423.134.camel@localhost>
References: <1252547631.3423.134.camel@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Fix code patching for paravirt-alternatives on 486
Message-ID: <tip-5367b6887e7d8c870a5da7d9b8c6e9c207684e43@git.kernel.org>
Git-Commit-ID: 5367b6887e7d8c870a5da7d9b8c6e9c207684e43
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 11 Sep 2009 00:19:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5367b6887e7d8c870a5da7d9b8c6e9c207684e43
Gitweb:     http://git.kernel.org/tip/5367b6887e7d8c870a5da7d9b8c6e9c207684e43
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Thu, 10 Sep 2009 02:53:50 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Sep 2009 16:50:19 -0700

x86: Fix code patching for paravirt-alternatives on 486

As reported in <http://bugs.debian.org/511703> and
<http://bugs.debian.org/515982>, kernels with paravirt-alternatives
enabled crash in text_poke_early() on at least some 486-class
processors.

The problem is that text_poke_early() itself uses inline functions
affected by paravirt-alternatives and so will modify instructions that
have already been prefetched.  Pentium and later processors will
invalidate the prefetched instructions in this case, but 486-class
processors do not.

Change sync_core() to limit prefetching on 486-class (and 386-class)
processors, and move the call to sync_core() above the call to the
modifiable local_irq_restore().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
LKML-Reference: <1252547631.3423.134.camel@localhost>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/include/asm/processor.h |   16 +++++++++++++---
 arch/x86/kernel/alternative.c    |    2 +-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c776826..2db56c5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -703,13 +703,23 @@ static inline void cpu_relax(void)
 	rep_nop();
 }
 
-/* Stop speculative execution: */
+/* Stop speculative execution and prefetching of modified code. */
 static inline void sync_core(void)
 {
 	int tmp;
 
-	asm volatile("cpuid" : "=a" (tmp) : "0" (1)
-		     : "ebx", "ecx", "edx", "memory");
+#if defined(CONFIG_M386) || defined(CONFIG_M486)
+	if (boot_cpu_data.x86 < 5)
+		/* There is no speculative execution.
+		 * jmp is a barrier to prefetching. */
+		asm volatile("jmp 1f\n1:\n" ::: "memory");
+	else
+#endif
+		/* cpuid is a barrier to speculative execution.
+		 * Prefetched instructions are automatically
+		 * invalidated when modified. */
+		asm volatile("cpuid" : "=a" (tmp) : "0" (1)
+			     : "ebx", "ecx", "edx", "memory");
 }
 
 static inline void __monitor(const void *eax, unsigned long ecx,
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f576587..b8ebd0b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -490,8 +490,8 @@ void *text_poke_early(void *addr, const void *opcode, size_t len)
 	unsigned long flags;
 	local_irq_save(flags);
 	memcpy(addr, opcode, len);
-	local_irq_restore(flags);
 	sync_core();
+	local_irq_restore(flags);
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
 	return addr;
