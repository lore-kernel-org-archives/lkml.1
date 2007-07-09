Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbXGIIy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbXGIIy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 04:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXGIIyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 04:54:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:48591 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXGIIyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 04:54:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,516,1175497200"; 
   d="scan'208";a="265988864"
Subject: Re: [PATCH][RFC] kvm-scheduler integration
From: Shaohua Li <shaohua.li@intel.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <11838994974161-git-send-email-avi@qumranet.com>
References: <11838994974161-git-send-email-avi@qumranet.com>
Content-Type: multipart/mixed; boundary="=-OB3sD6oCE0XIy2uSl6NI"
Date: Mon, 09 Jul 2007 16:50:01 +0800
Message-Id: <1183971001.4254.3.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OB3sD6oCE0XIy2uSl6NI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2007-07-08 at 20:58 +0800, Avi Kivity wrote:
> The only fly in the ointment is that it crashes quite soon.  Haven't
> figured
> out why yet, but comments on the general direction would be welcome.
Attached patch seems help in my test. prepare_task_switch is called with
irq disabled.


> -static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
> +static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>         u64 phys_addr = __pa(vcpu->vmcs);
> -       int cpu;
>         u64 tsc_this, delta;
> 
> -       cpu = get_cpu();
> -
> +       WARN_ON(!preempt_count());
This and below change will break preempt disabled case. better remove
them.

>         if (vcpu->cpu != cpu)
>                 vcpu_clear(vcpu);
> 
> @@ -426,9 +432,9 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
> 
>  static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
>  {
> +       WARN_ON(!preempt_count());
>         vmx_load_host_state(vcpu);
>         kvm_put_guest_fpu(vcpu);
> -       put_cpu();
>  }


--=-OB3sD6oCE0XIy2uSl6NI
Content-Disposition: attachment; filename=dbg.patch
Content-Type: text/x-patch; name=dbg.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -347,6 +347,7 @@ static void vmx_save_host_state(struct k
 static void vmx_load_host_state(struct kvm_vcpu *vcpu)
 {
 	struct vmx_host_state *hs = &vcpu->vmx_host_state;
+	unsigned long flags;
 
 	if (!hs->loaded)
 		return;
@@ -359,12 +360,12 @@ static void vmx_load_host_state(struct k
 		 * If we have to reload gs, we must take care to
 		 * preserve our gs base.
 		 */
-		local_irq_disable();
+		local_irq_save(flags);
 		load_gs(hs->gs_sel);
 #ifdef CONFIG_X86_64
 		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
 #endif
-		local_irq_enable();
+		local_irq_restore(flags);
 
 		reload_tss();
 	}

--=-OB3sD6oCE0XIy2uSl6NI--
