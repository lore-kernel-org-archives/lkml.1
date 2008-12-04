Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYLDPgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYLDPgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYLDPgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:36:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbYLDPgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:36:40 -0500
Message-ID: <4937F8F1.3070402@redhat.com>
Date: Thu, 04 Dec 2008 17:36:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: Steven Rostedt <srostedt@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com>	 <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com>	 <20081130210406.GA17952@hades> <493528D8.8010904@redhat.com>	 <20081202190914.GA12115@hades>  <20081202194610.GA4864@hades> <1228249509.4886.11.camel@localhost.localdomain> <49359CDF.5060300@redhat.com>
In-Reply-To: <49359CDF.5060300@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010305040409050707030300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010305040409050707030300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Avi Kivity wrote:
> Steven Rostedt wrote:
>> The following must be available without recursion for the function
>> tracer to work:
>>
>>   local_irq_save/restore
>>   smp_processor_id
>>   preempt_enable/disable_notrace
>>   atomic_inc/dec
>>   
>
> In arch/x86/kvm/svm.c, function svm_vcpu_run(), everything between the 
> vmrun instruction and the call to load_host_msrs() is executed without 
> a live pda, so no smp_processor_id().  Could easily be fixed by 
> rearranging things.
>
>

Luis, please try the attached patch.


-- 
error compiling committee.c: too many arguments to function


--------------010305040409050707030300
Content-Type: text/plain;
 name="kvm-ftrace-peace.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kvm-ftrace-peace.patch"

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1452851..c10857d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -920,13 +920,6 @@ static int svm_get_irq(struct kvm_vcpu *vcpu)
 	return -1;
 }
 
-static void load_host_msrs(struct kvm_vcpu *vcpu)
-{
-#ifdef CONFIG_X86_64
-	wrmsrl(MSR_GS_BASE, to_svm(vcpu)->host_gs_base);
-#endif
-}
-
 static void save_host_msrs(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
@@ -1798,10 +1791,26 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"mov %%r14, %c[r14](%[svm]) \n\t"
 		"mov %%r15, %c[r15](%[svm]) \n\t"
 #endif
-		"pop %%"R"bp"
+		"pop %%"R"bp \n\t"
+		/* Reload PDA early so ftrace can work */
+		"mov %[fs], %%fs \n\t"
+		"mov %[gs], %%gs \n\t"
+#ifdef CONFIG_X86_64
+		"mov %c[gsbase](%[svm]), %%edi \n\t"
+		"mov %c[gsbase]+4(%[svm]), %%edx \n\t"
+		"mov %[msr_gs_base], %%ecx \n\t"
+		"xchg %%rax, %%rdi \n\t"
+		"wrmsr \n\t"
+		"xchg %%rax, %%rdi \n\t"
+#endif
 		:
 		: [svm]"a"(svm),
 		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
+		  [fs]"g"(fs_selector), [gs]"g"(gs_selector),
+#ifdef CONFIG_X86_64
+		  [gsbase]"i"(offsetof(struct vcpu_svm, host_gs_base)),
+		  [msr_gs_base]"i"(MSR_GS_BASE),
+#endif
 		  [rbx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RBX])),
 		  [rcx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RCX])),
 		  [rdx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RDX])),
@@ -1837,10 +1846,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	write_dr7(svm->host_dr7);
 	kvm_write_cr2(svm->host_cr2);
 
-	kvm_load_fs(fs_selector);
-	kvm_load_gs(gs_selector);
 	kvm_load_ldt(ldt_selector);
-	load_host_msrs(vcpu);
 
 	reload_tss(vcpu);
 

--------------010305040409050707030300--
