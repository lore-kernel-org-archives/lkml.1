Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbZJMH0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbZJMH0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933668AbZJMH0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:26:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:46262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933661AbZJMH0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:26:15 -0400
Date: Tue, 13 Oct 2009 07:25:11 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jeremy.fitzhardinge@citrix.com, jeremy@goop.org, stable@kernel.org,
       bastian@waldi.eu.org, tglx@linutronix.de, mingo@elte.hu,
       xen-devel@lists.xensource.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, jeremy@goop.org, stable@kernel.org,
       bastian@waldi.eu.org, tglx@linutronix.de, xen-devel@lists.xensource.com,
       mingo@elte.hu
In-Reply-To: <4AD3BC9B.7040501@goop.org>
References: <4AD3BC9B.7040501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/paravirt: Use normal calling sequences for irq enable/disable
Message-ID: <tip-71999d9862e667f1fd14f8fbfa0cce6d855bad3f@git.kernel.org>
Git-Commit-ID: 71999d9862e667f1fd14f8fbfa0cce6d855bad3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 07:25:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71999d9862e667f1fd14f8fbfa0cce6d855bad3f
Gitweb:     http://git.kernel.org/tip/71999d9862e667f1fd14f8fbfa0cce6d855bad3f
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Mon, 12 Oct 2009 16:32:43 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Oct 2009 09:22:01 +0200

x86/paravirt: Use normal calling sequences for irq enable/disable

Bastian Blank reported a boot crash with stackprotector enabled,
and debugged it back to edx register corruption.

For historical reasons irq enable/disable/save/restore had special
calling sequences to make them more efficient.  With the more
recent introduction of higher-level and more general optimisations
this is no longer necessary so we can just use the normal PVOP_
macros.

This fixes some residual bugs in the old implementations which left
edx liable to inadvertent clobbering. Also, fix some bugs in
__PVOP_VCALLEESAVE which were revealed by actual use.

Reported-by: Bastian Blank <bastian@waldi.eu.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Stable Kernel <stable@kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>
LKML-Reference: <4AD3BC9B.7040501@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/paravirt.h       |   28 ++++------------------------
 arch/x86/include/asm/paravirt_types.h |   10 ++++++----
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 8aebcc4..efb3899 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -840,42 +840,22 @@ static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
 
 static inline unsigned long __raw_local_save_flags(void)
 {
-	unsigned long f;
-
-	asm volatile(paravirt_alt(PARAVIRT_CALL)
-		     : "=a"(f)
-		     : paravirt_type(pv_irq_ops.save_fl),
-		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc");
-	return f;
+	return PVOP_CALLEE0(unsigned long, pv_irq_ops.save_fl);
 }
 
 static inline void raw_local_irq_restore(unsigned long f)
 {
-	asm volatile(paravirt_alt(PARAVIRT_CALL)
-		     : "=a"(f)
-		     : PV_FLAGS_ARG(f),
-		       paravirt_type(pv_irq_ops.restore_fl),
-		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc");
+	PVOP_VCALLEE1(pv_irq_ops.restore_fl, f);
 }
 
 static inline void raw_local_irq_disable(void)
 {
-	asm volatile(paravirt_alt(PARAVIRT_CALL)
-		     :
-		     : paravirt_type(pv_irq_ops.irq_disable),
-		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc");
+	PVOP_VCALLEE0(pv_irq_ops.irq_disable);
 }
 
 static inline void raw_local_irq_enable(void)
 {
-	asm volatile(paravirt_alt(PARAVIRT_CALL)
-		     :
-		     : paravirt_type(pv_irq_ops.irq_enable),
-		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc");
+	PVOP_VCALLEE0(pv_irq_ops.irq_enable);
 }
 
 static inline unsigned long __raw_local_irq_save(void)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index dd0f5b3..9357473 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -494,10 +494,11 @@ int paravirt_disable_iospace(void);
 #define EXTRA_CLOBBERS
 #define VEXTRA_CLOBBERS
 #else  /* CONFIG_X86_64 */
+/* [re]ax isn't an arg, but the return val */
 #define PVOP_VCALL_ARGS					\
 	unsigned long __edi = __edi, __esi = __esi,	\
-		__edx = __edx, __ecx = __ecx
-#define PVOP_CALL_ARGS		PVOP_VCALL_ARGS, __eax
+		__edx = __edx, __ecx = __ecx, __eax = __eax
+#define PVOP_CALL_ARGS		PVOP_VCALL_ARGS
 
 #define PVOP_CALL_ARG1(x)		"D" ((unsigned long)(x))
 #define PVOP_CALL_ARG2(x)		"S" ((unsigned long)(x))
@@ -509,6 +510,7 @@ int paravirt_disable_iospace(void);
 				"=c" (__ecx)
 #define PVOP_CALL_CLOBBERS	PVOP_VCALL_CLOBBERS, "=a" (__eax)
 
+/* void functions are still allowed [re]ax for scratch */
 #define PVOP_VCALLEE_CLOBBERS	"=a" (__eax)
 #define PVOP_CALLEE_CLOBBERS	PVOP_VCALLEE_CLOBBERS
 
@@ -583,8 +585,8 @@ int paravirt_disable_iospace(void);
 		       VEXTRA_CLOBBERS,					\
 		       pre, post, ##__VA_ARGS__)
 
-#define __PVOP_VCALLEESAVE(rettype, op, pre, post, ...)			\
-	____PVOP_CALL(rettype, op.func, CLBR_RET_REG,			\
+#define __PVOP_VCALLEESAVE(op, pre, post, ...)				\
+	____PVOP_VCALL(op.func, CLBR_RET_REG,				\
 		      PVOP_VCALLEE_CLOBBERS, ,				\
 		      pre, post, ##__VA_ARGS__)
 
