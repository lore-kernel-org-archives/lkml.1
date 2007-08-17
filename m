Return-Path: <linux-kernel-owner+w=401wt.eu-S1765174AbXHQOcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765174AbXHQOcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759363AbXHQOcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:32:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41105 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896AbXHQOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:32:39 -0400
Date: Fri, 17 Aug 2007 20:15:25 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andi Kleen <ak@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][resend] i386: Fix a couple busy loops in
 mach_wakecpu.h:wait_for_init_deassert()
Message-ID: <alpine.LFD.0.999.0708172008390.3666@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Aug 2007, Satyam Sharma wrote:

> On Fri, 17 Aug 2007, Andi Kleen wrote:
> [...]
> 
> [PATCH] i386, x86_64: __const_udelay() should not be marked inline

Eek, this one wasn't quite right on both counts, (1) correctness of
kernel/crash.c did not depend on __const_udelay() being uninlined because
it used wmb() a few lines above the while loop which includes a memory
clobber anyway, and, (2) __udelay() and __ndelay() are two callsites of
__const_udelay() where it does get inlined (being in the same .c file).
Sorry, silly me.

But this one I've test-built and verified the resulting kernel images:


[PATCH] i386: Fix a couple busy loops in mach_wakecpu.h:wait_for_init_deassert()

Use cpu_relax() in the busy loops, as atomic_read() doesn't automatically
imply a compiler barrier for x86. x86_64 doesn't have this issue because
it open-codes the while loop in smpboot.c:smp_callin() itself, and already
uses cpu_relax().

For i386, however, smpboot.c:smp_callin() calls wait_for_init_deassert()
which is buggy for mach-default and mach-es7000 cases.

[ I test-built a kernel -- smp_callin() itself got inlined in its only
  callsite, smpboot.c:start_secondary() -- and the relevant piece of
  code disassembles to the following:

0xc1019704 <start_secondary+12>:        mov    0xc144c4c8,%eax
0xc1019709 <start_secondary+17>:        test   %eax,%eax
0xc101970b <start_secondary+19>:        je     0xc1019709 <start_secondary+17>

  init_deasserted (at 0xc144c4c8) gets fetched into %%eax only once and
  then we loop over the test of the stale value in the register only,
  so these look like real bugs to me. With the fix below, this becomes:

0xc1019706 <start_secondary+14>:        pause
0xc1019708 <start_secondary+16>:        cmpl   $0x0,0xc144c4c8
0xc101970f <start_secondary+23>:        je     0xc1019706 <start_secondary+14>

  which looks nice and healthy. ]

Thanks to Heiko Carstens for noticing this.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

Previously sent: http://lkml.org/lkml/2007/8/15/407

 include/asm-i386/mach-default/mach_wakecpu.h |    3 ++-
 include/asm-i386/mach-es7000/mach_wakecpu.h  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/asm-i386/mach-default/mach_wakecpu.h b/include/asm-i386/mach-default/mach_wakecpu.h
index 673b85c..3ebb178 100644
--- a/include/asm-i386/mach-default/mach_wakecpu.h
+++ b/include/asm-i386/mach-default/mach_wakecpu.h
@@ -15,7 +15,8 @@
 
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
-	while (!atomic_read(deassert));
+	while (!atomic_read(deassert))
+		cpu_relax();
 	return;
 }
 
diff --git a/include/asm-i386/mach-es7000/mach_wakecpu.h b/include/asm-i386/mach-es7000/mach_wakecpu.h
index efc903b..84ff583 100644
--- a/include/asm-i386/mach-es7000/mach_wakecpu.h
+++ b/include/asm-i386/mach-es7000/mach_wakecpu.h
@@ -31,7 +31,8 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
 #ifdef WAKE_SECONDARY_VIA_INIT
-	while (!atomic_read(deassert));
+	while (!atomic_read(deassert))
+		cpu_relax();
 #endif
 	return;
 }
