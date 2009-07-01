Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZGATeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZGATeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZGATeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:34:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:41304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbZGATeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:34:10 -0400
Message-ID: <4A4BBA12.8070507@kernel.org>
Date: Wed, 01 Jul 2009 12:33:38 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] fix round_up/down
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <4A484A8A.9020704@zytor.com> <19016.41349.636663.515540@pilspetsen.it.uu.se> <20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com> <4A4966EF.6010809@kernel.org> <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain> <4A496D4B.3040608@kernel.org> <19017.53428.834539.389495@pilspetsen.it.uu.se> <4A4A25B1.5010102@zytor.com> <4A4A6888.30001@kernel.org> <4A4A6B1C.7030405@zytor.com> <4A4A701F.3050700@kernel.org> <4A4A81C9.9070008@zytor.com> <4A4A88A2.7010509@kernel.org> <alpine.LFD.2.01.0906301456170.3605@localhost.localdomain> <4A4A921F.7080100@kernel.org> <alpine.LFD.2.01.0906301559390.3605@localhost.localdomain> <alpine.LFD.2.01.0906301603280.3605@localhost.localdomain> <4A4A9C2F.80808@kernel.org> <4A4A9D8E.5080500@zytor.com> <4A4BB9C2.8020304@kernel.org>
In-Reply-To: <4A4BB9C2.8020304@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

round_up with __type_of__
round_up use mask and | tricks from HPA and linus
    also move round_up/down to kernel.h

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/um/sys-x86_64/signal.c     |    2 --
 arch/x86/include/asm/proto.h    |    3 ---
 drivers/md/dm-exception-store.c |   10 ----------
 include/linux/kernel.h          |    6 ++++++
 4 files changed, 6 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/include/asm/proto.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/proto.h
+++ linux-2.6/arch/x86/include/asm/proto.h
@@ -22,7 +22,4 @@ extern int reboot_force;
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 
-#define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
-#define round_down(x, y) ((x) & ~((y) - 1))
-
 #endif /* _ASM_X86_PROTO_H */
Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -140,6 +140,7 @@ extern const char linux_proc_banner[];
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+#define rounddown(x, y) (((x) / (y)) * (y))
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
 {							\
 	typeof(divisor) __divisor = divisor;		\
@@ -147,6 +148,11 @@ extern const char linux_proc_banner[];
 }							\
 )
 
+/* need y is 2^n */
+#define __round_mask(x,y) ((__typeof__(x))((y)-1))
+#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
+#define round_down(x,y) ((x) & ~__round_mask(x,y))
+
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
 
Index: linux-2.6/arch/um/sys-x86_64/signal.c
===================================================================
--- linux-2.6.orig/arch/um/sys-x86_64/signal.c
+++ linux-2.6/arch/um/sys-x86_64/signal.c
@@ -165,8 +165,6 @@ struct rt_sigframe
 	struct _fpstate fpstate;
 };
 
-#define round_down(m, n) (((m) / (n)) * (n))
-
 int setup_signal_stack_si(unsigned long stack_top, int sig,
 			  struct k_sigaction *ka, struct pt_regs * regs,
 			  siginfo_t *info, sigset_t *set)
Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -138,16 +138,6 @@ int dm_exception_store_type_unregister(s
 }
 EXPORT_SYMBOL(dm_exception_store_type_unregister);
 
-/*
- * Round a number up to the nearest 'size' boundary.  size must
- * be a power of 2.
- */
-static ulong round_up(ulong n, ulong size)
-{
-	size--;
-	return (n + size) & ~size;
-}
-
 static int set_chunk_size(struct dm_exception_store *store,
 			  const char *chunk_size_arg, char **error)
 {
