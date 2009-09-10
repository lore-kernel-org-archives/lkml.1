Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbZIJByy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbZIJByy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZIJByx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:54:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36626 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbZIJByx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:54:53 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Sep 2009 02:53:50 +0100
Message-Id: <1252547631.3423.134.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH v2] x86: Fix code patching for paravirt-alternatives on 486
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
Second try, incorporating the jmp into sync_core().

Also not signed as I know git has trouble with MIME.

Ben.

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
index 4869351..de7353c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -498,8 +498,8 @@ static void *__init_or_module text_poke_early(void *addr, const void *opcode,
 	unsigned long flags;
 	local_irq_save(flags);
 	memcpy(addr, opcode, len);
-	local_irq_restore(flags);
 	sync_core();
+	local_irq_restore(flags);
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
 	return addr;
-- 
1.6.3.3

