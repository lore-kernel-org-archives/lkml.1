Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbZJNT3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbZJNT3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759037AbZJNT3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:29:19 -0400
Received: from claw.goop.org ([74.207.240.146]:55279 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758657AbZJNT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:16 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 02/12] x86/vgetcpu: ignore tcache in common code.
Date: Wed, 14 Oct 2009 12:28:26 -0700
Message-Id: <1255548516-15260-3-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vdso implementation of vgetcpu has been ignoring the tcache
parameter since change 4307d1e5ada595c87f9a4d16db16ba5edb70dcb1,
but that overlooked the vsyscall implementation of vgetcpu.

This change ignores tcache in the common code, but passes the
pointer in from vdso so that it can be still used if there's a
new tcache implementation which addresses the problems mentioned
in 4307d1e5ada595c87f.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/vsyscall.h |   19 ++++---------------
 arch/x86/vdso/vgetcpu.c         |    3 +--
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index 2fcd505..bb90047 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -48,27 +48,16 @@ int __vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache,
 	unsigned int p;
 	unsigned long j = 0;
 
-	/* Fast cache - only recompute value once per jiffies and avoid
-	   relatively costly rdtscp/cpuid otherwise.
-	   This works because the scheduler usually keeps the process
-	   on the same CPU and this syscall doesn't guarantee its
-	   results anyways.
-	   We do this here because otherwise user space would do it on
-	   its own in a likely inferior way (no access to jiffies).
-	   If you don't like it pass NULL. */
-	if (tcache && tcache->blob[0] == (j = jiffies)) {
-		p = tcache->blob[1];
-	} else if (vgetcpu_mode == VGETCPU_RDTSCP) {
+	/* tcache is ignored - it is too unreliable */
+
+	if (vgetcpu_mode == VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
 		native_read_tscp(&p);
 	} else {
 		/* Load per CPU data from GDT */
 		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
 	}
-	if (tcache) {
-		tcache->blob[0] = j;
-		tcache->blob[1] = p;
-	}
+
 	if (cpu)
 		*cpu = p & 0xfff;
 	if (node)
diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
index 1f19f74..2c4f9ab 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -16,8 +16,7 @@
 notrace long
 __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 {
-	/* Ignore tcache to preserve old behaviour */
-	return __vgetcpu(cpu, node, NULL, *vdso_jiffies, *vdso_vgetcpu_mode);
+	return __vgetcpu(cpu, node, tcache, *vdso_jiffies, *vdso_vgetcpu_mode);
 }
 
 long getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
-- 
1.6.2.5

