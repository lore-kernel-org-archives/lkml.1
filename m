Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZA0F6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZA0F6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZA0F57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:57:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:38024 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZA0F56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:57:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JoYlM3VnEVSkGyl+kky7n0RaOvoI7Es87Iddd39voJMDN3wPNxoKICnd6qO2Av1pXx
         Uc/VRxva1Fwfi3olbzcrAgqTb6SAcSgTJ6+G0OWm4UklD1lGdc+uYcstlHyiPO0EbJCt
         2joWofrFWUUoE3ZkdkMSRO10UI4i8xbSxXRys=
MIME-Version: 1.0
In-Reply-To: <497E5F76.10301@goop.org>
References: <497E5F76.10301@goop.org>
Date: Tue, 27 Jan 2009 00:57:57 -0500
Message-ID: <73c1f2160901262157g3d281e62nb3ebafe01ab1dfe4@mail.gmail.com>
Subject: Re: unified percpu stuff
From: Brian Gerst <brgerst@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 8:12 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> I'm really pleased to see the unified percpu stuff in the kernel, but
> unfortunately its breaking Xen at the moment.
> It looks like this is just a matter of initializing %gs properly in
> xen_start_kernel.  Is there any problem with me doing a load_gs_base(0)
> somewhere early in xen_start_kernel (arch/x86/xen/enlighten.c)?

Some of the changes I did made the assumption that the percpu state is
set up early in head_xx.S, which apparently is skipped for xen.  Is
there documentation anywhere for the xen bootstrap process?

Try this patch (untested):

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bef941f..b90d061 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1647,6 +1647,8 @@ asmlinkage void __init xen_start_kernel(void)
 	have_vcpu_info_placement = 0;
 #endif

+	switch_to_new_gdt();
+
 	xen_smp_init();

 	/* Get mfn list */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 7735e3d..00d9265 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -235,6 +235,8 @@ cpu_initialize_context(unsigned int cpu, struct
task_struct *idle)
 	ctxt->user_regs.ss = __KERNEL_DS;
 #ifdef CONFIG_X86_32
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
+#else
+	ctxt->gs_base_kernel = per_cpu_offset(cpu);
 #endif
 	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
 	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */

--
Brian Gerst
