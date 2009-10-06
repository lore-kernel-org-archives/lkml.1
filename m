Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbZJFTBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbZJFTBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbZJFTBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:01:51 -0400
Received: from claw.goop.org ([74.207.240.146]:34115 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbZJFTBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:01:50 -0400
Message-ID: <4ACB93F8.5010900@goop.org>
Date: Tue, 06 Oct 2009 12:01:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Bastian Blank <bastian@waldi.eu.org>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: Disable stack protector for irq
 helper
References: <20091004183013.GA26101@wavehammer.waldi.eu.org> <4AC92A65.40806@goop.org> <20091005013517.GA6081@wavehammer.waldi.eu.org> <4ACA2AFD.4080305@goop.org> <20091005224310.GA32144@wavehammer.waldi.eu.org> <4ACA90F2.1060909@goop.org> <20091006033050.GA6332@wavehammer.waldi.eu.org>
In-Reply-To: <20091006033050.GA6332@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/09 20:30, Bastian Blank wrote:
> The original version saves ecx, but not edx. Both are official
> caller-saved registers.
>   

Hm.  It doesn't save edx because that can be half of a 64-bit return
value, and in general both eax and edx are marked clobbered.  Except one
place; does the patch below help?

>> Besides, most of the code in that file isn't used unless you're using a
>> very old version of Xen; it will generally prefer to use the ones in
>> xen-asm_X.S.
>>     
> Well, my call stack say something different. It crashs during early
> startup without a console. The modifications to the function pointers is
> done much later.

You're right.  But you're holding out on me; can I see your backtrace? 
And the disassembly of the troublesome code (both the Xen function and
the calling function)?

Thanks,
    J

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, 6 Oct 2009 11:36:44 -0700
Subject: [PATCH] x86/paravirt: use normal calling sequences for irq enable/disable etc

For historical reasons irq enable/disable/save/restore had special
calling sequences to make them more efficient.  With the more
recent introduction of higher-level and more general optimisations
this is no longer necessary so we can just use the normal PVOP_
macros.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index e19ffe3..e8420a2 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -863,42 +863,22 @@ static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
 
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
index b9bb5e8..0b97706 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -612,8 +612,8 @@ int paravirt_disable_iospace(void);
 		       VEXTRA_CLOBBERS,					\
 		       pre, post, ##__VA_ARGS__)
 
-#define __PVOP_VCALLEESAVE(rettype, op, pre, post, ...)			\
-	____PVOP_CALL(rettype, op.func, CLBR_RET_REG,			\
+#define __PVOP_VCALLEESAVE(op, pre, post, ...)				\
+	____PVOP_VCALL(op.func, CLBR_RET_REG,				\
 		      PVOP_VCALLEE_CLOBBERS, ,				\
 		      pre, post, ##__VA_ARGS__)
 


