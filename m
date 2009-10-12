Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbZJLXdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbZJLXdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZJLXdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:33:23 -0400
Received: from claw.goop.org ([74.207.240.146]:49945 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbZJLXdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:33:22 -0400
Message-ID: <4AD3BC9B.7040501@goop.org>
Date: Mon, 12 Oct 2009 16:32:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bastian Blank <bastian@waldi.eu.org>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: Disable stack protector for irq
 helper
References: <20091004183013.GA26101@wavehammer.waldi.eu.org> <4AC92A65.40806@goop.org> <20091005013517.GA6081@wavehammer.waldi.eu.org> <4ACA2AFD.4080305@goop.org> <20091005224310.GA32144@wavehammer.waldi.eu.org> <4ACA90F2.1060909@goop.org> <20091006033050.GA6332@wavehammer.waldi.eu.org> <4ACB93F8.5010900@goop.org> <20091007163521.GA17998@wavehammer.waldi.eu.org> <4ACD3346.3010307@goop.org> <20091012205208.GE17163@elte.hu>
In-Reply-To: <20091012205208.GE17163@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/09 13:52, Ingo Molnar wrote:
> ping - any update about this fix? Since it fixes a real crash it would 
> be nice to fix this for .32.
>   

The following changes since commit 2caa731819a633bec5a56736e64c562b7e193666:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git mainline/x86-paravirt-fix

Jeremy Fitzhardinge (1):
      x86/paravirt: use normal calling sequences for irq enable/disable etc

 arch/x86/include/asm/paravirt.h       |   28 ++++------------------------
 arch/x86/include/asm/paravirt_types.h |   10 ++++++----
 2 files changed, 10 insertions(+), 28 deletions(-)

Subject: [PATCH] x86/paravirt: use normal calling sequences for irq enable/disable etc

For historical reasons irq enable/disable/save/restore had special
calling sequences to make them more efficient.  With the more
recent introduction of higher-level and more general optimisations
this is no longer necessary so we can just use the normal PVOP_
macros.  This fixes some residual bugs in the old implementations which
left edx liable to inadvertent clobbering.

Also, fix some bugs in __PVOP_VCALLEESAVE which were revealed by actual
use.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

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


