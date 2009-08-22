Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbZHVQh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbZHVQh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 12:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932616AbZHVQh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 12:37:57 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60613 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597AbZHVQhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 12:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=EUSKU7vCQ9MJBOf465Vqi7JNoQ1nFZid+8voav3vXUbsj9HKVRN+qwps1N178JPeI4
         hAeIhID6BRGlNmLfDe/Uk1Jg5/gRYmEYL4/1oy9c1SGNCJgQNQ1VS2oO4wxFvWzpK50P
         D1+S7dG2kW2er8okgODu3tiOceYQp4v/LCmhs=
Date: Sat, 22 Aug 2009 18:37:50 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, AMD: Disable wrongly set
 X86_FEATURE_LAHF_LM CPUID bit
Message-ID: <20090822163750.GA31631@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	mingo@redhat.com, linux-kernel@vger.kernel.org,
	kjwinchester@gmail.com, tglx@linutronix.de, borislav.petkov@amd.com,
	linux-tip-commits@vger.kernel.org
References: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com>
 <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org>
 <20090816064132.GA16278@elte.hu>
 <20090816214934.GB7765@liondog.tnic>
 <4A8EDC02.8000508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A8EDC02.8000508@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 10:40:18AM -0700, H. Peter Anvin wrote:
> If we're going to modify the paravirt_crap for yet another MSR
> operation, then let's at least make it something like "write_msr_edi"
> and have it take a parameter for the EDI value.  Perhaps we should let
> it set EBX and ESI as well (and the same for the read operation, even
> though it already exists.)

Ok, how about making all rdmsr* variants indirectly call into a
native_read_msr_safe_reg() helper which takes esi and edi as additional
arguments. There was no room for ebx since paravirt has a PVOP_CALL4
macro which takes the largest number of args - 4 and I am lazy, of
course, to implement a PVOP_CALL5 thing :o)

The wrmsr variants could be done similarly.

Suggestions, comments?

--
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 48ad9d2..2fec363 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -55,8 +55,10 @@ static inline unsigned long long native_read_msr(unsigned int msr)
 	return EAX_EDX_VAL(val, low, high);
 }
 
-static inline unsigned long long native_read_msr_safe(unsigned int msr,
-						      int *err)
+static inline unsigned long long native_read_msr_safe_reg(unsigned int msr,
+							  int *err,
+							  unsigned int edi,
+							  unsigned int esi)
 {
 	DECLARE_ARGS(val, low, high);
 
@@ -67,24 +69,15 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 		     ".previous\n\t"
 		     _ASM_EXTABLE(2b, 3b)
 		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr), [fault] "i" (-EFAULT));
+		     : "c" (msr), [fault] "i" (-EFAULT), "D" (edi), "S" (esi));
+
 	return EAX_EDX_VAL(val, low, high);
 }
 
-static inline unsigned long long native_read_msr_amd_safe(unsigned int msr,
+static inline unsigned long long native_read_msr_safe(unsigned int msr,
 						      int *err)
 {
-	DECLARE_ARGS(val, low, high);
-
-	asm volatile("2: rdmsr ; xor %0,%0\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  mov %3,%0 ; jmp 1b\n\t"
-		     ".previous\n\t"
-		     _ASM_EXTABLE(2b, 3b)
-		     : "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr), "D" (0x9c5a203a), "i" (-EFAULT));
-	return EAX_EDX_VAL(val, low, high);
+	return native_read_msr_safe_reg(msr, err, 0, 0);
 }
 
 static inline void native_write_msr(unsigned int msr,
@@ -181,11 +174,12 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 	*p = native_read_msr_safe(msr, &err);
 	return err;
 }
+
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
 	int err;
 
-	*p = native_read_msr_amd_safe(msr, &err);
+	*p = native_read_msr_safe_reg(msr, &err, 0x9c5a203a, 0);
 	return err;
 }
 
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 4fb37c8..d49e1ee 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -166,8 +166,9 @@ struct pv_cpu_ops {
 
 	/* MSR, PMC and TSR operations.
 	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
-	u64 (*read_msr_amd)(unsigned int msr, int *err);
 	u64 (*read_msr)(unsigned int msr, int *err);
+	u64 (*read_msr_reg)(unsigned int msr, int *err, unsigned edi,
+			    unsigned esi);
 	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
 
 	u64 (*read_tsc)(void);
@@ -820,9 +821,10 @@ static inline u64 paravirt_read_msr(unsigned msr, int *err)
 {
 	return PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
 }
-static inline u64 paravirt_read_msr_amd(unsigned msr, int *err)
+static inline u64 paravirt_read_msr_reg(unsigned msr, int *err, unsigned edi,
+					unsigned esi)
 {
-	return PVOP_CALL2(u64, pv_cpu_ops.read_msr_amd, msr, err);
+	return PVOP_CALL4(u64, pv_cpu_ops.read_msr_reg, msr, err, edi, esi);
 }
 static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 {
@@ -873,7 +875,7 @@ static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
 	int err;
 
-	*p = paravirt_read_msr_amd(msr, &err);
+	*p = paravirt_read_msr_reg(msr, &err, 0x9c5a203a, 0);
 	return err;
 }
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 70ec9b9..ecac58d 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -362,7 +362,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 #endif
 	.wbinvd = native_wbinvd,
 	.read_msr = native_read_msr_safe,
-	.read_msr_amd = native_read_msr_amd_safe,
+	.read_msr_reg = native_read_msr_safe_reg,
 	.write_msr = native_write_msr_safe,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,

-- 
Regards/Gruss,
    Boris.
