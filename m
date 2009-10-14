Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZJNT3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZJNT3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbZJNT3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:29:20 -0400
Received: from claw.goop.org ([74.207.240.146]:55293 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349AbZJNT3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:18 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 01/12] x86/vsyscall: use common implementation for vgetcpu
Date: Wed, 14 Oct 2009 12:28:25 -0700
Message-Id: <1255548516-15260-2-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were two implementations of vgetcpu: one for vdso and one for
vsyscalls.  They are actually functionally different, as the vdso one
ignores the tcache parameter (due to change 4307d1e5ada595c8), but the
vsyscall implementation honours it.  This patch preserves that functional
difference, but a subsequent will make both behave the same way.

The actual compiled code is still duplicated as the vdso and vsyscall
environments are quite different (variable vs fixed address, for example),
and the access to kernel variables is different as well.  The
implementation is made common as an inline functions, so there's only
one copy of the source.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/vsyscall.h |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/vsyscall_64.c   |   30 +-----------------------------
 arch/x86/vdso/vgetcpu.c         |   18 +++---------------
 3 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index d0983d2..2fcd505 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -39,6 +39,44 @@ extern struct timezone sys_tz;
 
 extern void map_vsyscall(void);
 
+#include <linux/getcpu.h>
+
+static __always_inline
+int __vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache,
+	      unsigned long jiffies, int vgetcpu_mode)
+{
+	unsigned int p;
+	unsigned long j = 0;
+
+	/* Fast cache - only recompute value once per jiffies and avoid
+	   relatively costly rdtscp/cpuid otherwise.
+	   This works because the scheduler usually keeps the process
+	   on the same CPU and this syscall doesn't guarantee its
+	   results anyways.
+	   We do this here because otherwise user space would do it on
+	   its own in a likely inferior way (no access to jiffies).
+	   If you don't like it pass NULL. */
+	if (tcache && tcache->blob[0] == (j = jiffies)) {
+		p = tcache->blob[1];
+	} else if (vgetcpu_mode == VGETCPU_RDTSCP) {
+		/* Load per CPU data from RDTSCP */
+		native_read_tscp(&p);
+	} else {
+		/* Load per CPU data from GDT */
+		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+	}
+	if (tcache) {
+		tcache->blob[0] = j;
+		tcache->blob[1] = p;
+	}
+	if (cpu)
+		*cpu = p & 0xfff;
+	if (node)
+		*node = p >> 12;
+	return 0;
+}
+
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 25ee06a..f71dda9 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -190,35 +190,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 long __vsyscall(2)
 vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 {
-	unsigned int p;
-	unsigned long j = 0;
-
-	/* Fast cache - only recompute value once per jiffies and avoid
-	   relatively costly rdtscp/cpuid otherwise.
-	   This works because the scheduler usually keeps the process
-	   on the same CPU and this syscall doesn't guarantee its
-	   results anyways.
-	   We do this here because otherwise user space would do it on
-	   its own in a likely inferior way (no access to jiffies).
-	   If you don't like it pass NULL. */
-	if (tcache && tcache->blob[0] == (j = __jiffies)) {
-		p = tcache->blob[1];
-	} else if (__vgetcpu_mode == VGETCPU_RDTSCP) {
-		/* Load per CPU data from RDTSCP */
-		native_read_tscp(&p);
-	} else {
-		/* Load per CPU data from GDT */
-		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
-	}
-	if (tcache) {
-		tcache->blob[0] = j;
-		tcache->blob[1] = p;
-	}
-	if (cpu)
-		*cpu = p & 0xfff;
-	if (node)
-		*node = p >> 12;
-	return 0;
+	return __vgetcpu(cpu, node, tcache, __jiffies, __vgetcpu_mode);
 }
 
 static long __vsyscall(3) venosys_1(void)
diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
index 9fbc6b2..1f19f74 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -14,22 +14,10 @@
 #include "vextern.h"
 
 notrace long
-__vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
+__vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 {
-	unsigned int p;
-
-	if (*vdso_vgetcpu_mode == VGETCPU_RDTSCP) {
-		/* Load per CPU data from RDTSCP */
-		native_read_tscp(&p);
-	} else {
-		/* Load per CPU data from GDT */
-		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
-	}
-	if (cpu)
-		*cpu = p & 0xfff;
-	if (node)
-		*node = p >> 12;
-	return 0;
+	/* Ignore tcache to preserve old behaviour */
+	return __vgetcpu(cpu, node, NULL, *vdso_jiffies, *vdso_vgetcpu_mode);
 }
 
 long getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
-- 
1.6.2.5

