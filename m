Return-Path: <linux-kernel-owner+w=401wt.eu-S1763065AbXGWKqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763065AbXGWKqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbXGWKqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:46:34 -0400
Received: from il.qumranet.com ([82.166.9.18]:42929 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbXGWKqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:46:34 -0400
Message-ID: <46A48713.9080404@qumranet.com>
Date: Mon, 23 Jul 2007 13:46:43 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 1/8]KVM: fix bugs in kvm sched integration patch
References: <1185173492.2645.65.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185173492.2645.65.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> fix some bugs in kvm-sch patch.
>   

There is now a 'preempt-hooks' branch on kvm.git with the preempt-hooks 
work.  I'll continually update and rebase it against master.

> 1. vmcs_readl/vmcs_writel are called with preempt enabled
>   

Why is that bad?

> 2. preempt_count check doesn't make sense with preempt disabled
>   

That is already fixed in the branch.

> 3. vmx_cpu_run doesn't handle error correctly and kvm_mmu_reload might
> sleep with mutex changes, so I move it above.
>   

Yes.

> @@ -2001,6 +1997,10 @@ preempted:
>  		kvm_guest_debug_pre(vcpu);
>  
>  again:
> +	r = kvm_mmu_reload(vcpu);
> +	if (unlikely(r))
> +		goto out;
> +
>  	preempt_disable();
>  
>  	if (!vcpu->mmio_read_completed)
> @@ -2009,10 +2009,6 @@ again:
>  	vmx_save_host_state(vcpu);
>  	kvm_load_guest_fpu(vcpu);
>  
> -	r = kvm_mmu_reload(vcpu);
> -	if (unlikely(r))
> -		goto out;
> -
>  	/*
>  	 * Loading guest fpu may have cleared host cr0.ts
>  	 */
>   

I'll add this (and the spinlock->mutex conversion) to the branch.

-- 
error compiling committee.c: too many arguments to function

