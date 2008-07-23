Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbYGWB1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbYGWB1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 21:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYGWB1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 21:27:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:41688 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYGWB1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 21:27:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,234,1215414000"; 
   d="scan'208";a="318094306"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH retry] arch/ia64/kvm/kvm-ia64.c: Add local_irq_restore in error handling code
Date: Wed, 23 Jul 2008 09:26:12 +0800
Message-ID: <42DFA526FC41B1429CE7279EF83C6BDC01689A73@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0807222137350.2670@ask.diku.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH retry] arch/ia64/kvm/kvm-ia64.c: Add local_irq_restore in error handling code
Thread-Index: AcjsMoHRLatB/Ik2TcGJJxZj7KBQ3wAL8z6Q
References: <Pine.LNX.4.64.0807222137350.2670@ask.diku.dk>
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: "Julia Lawall" <julia@diku.dk>, <avi@qumranet.com>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
X-OriginalArrivalTime: 23 Jul 2008 01:26:17.0684 (UTC) FILETIME=[1ADFA140:01C8EC63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> There is a call to local_irq_restore in the normal exit case, so it
> would 
> seem that there should be one on an error return as well.
> 
> The semantic patch that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)

Good catch!  Excellent patch to find such issues!
Xiantao

> 
> // <smpl>
> @@
> expression l;
> expression E,E1,E2;
> @@
> 
> local_irq_save(l);
> ... when != local_irq_restore(l)
>     when != spin_unlock_irqrestore(E,l)
>     when any
>     when strict
> (
> if (...) { ... when != local_irq_restore(l)
>                when != spin_unlock_irqrestore(E1,l)
> +   local_irq_restore(l);
>     return ...;
> }
>> 
> if (...)
> +   {local_irq_restore(l);
>     return ...;
> +   }
>> 
> spin_unlock_irqrestore(E2,l);
>> 
> local_irq_restore(l);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  .../julia/linuxcopy}/arch/ia64/kvm/kvm-ia64.c      |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/home/julia/linux-2.6/arch/ia64/kvm/kvm-ia64.c
> b/var/julia/linuxcopy/arch/ia64/kvm/kvm-ia64.c index 2672f4d..7a37d06
> 100644 --- a/home/julia/linux-2.6/arch/ia64/kvm/kvm-ia64.c
> +++ b/var/julia/linuxcopy/arch/ia64/kvm/kvm-ia64.c
> @@ -125,9 +125,9 @@ void kvm_arch_hardware_enable(void *garbage)
>  				PAGE_KERNEL));
>  	local_irq_save(saved_psr);
>  	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
> +	local_irq_restore(saved_psr);
>  	if (slot < 0)
>  		return;
> -	local_irq_restore(saved_psr);
> 
>  	spin_lock(&vp_lock);
>  	status = ia64_pal_vp_init_env(kvm_vsa_base ?
> @@ -160,9 +160,9 @@ void kvm_arch_hardware_disable(void *garbage)
> 
>  	local_irq_save(saved_psr);
>  	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
> +	local_irq_restore(saved_psr);
>  	if (slot < 0)
>  		return;
> -	local_irq_restore(saved_psr);
> 
>  	status = ia64_pal_vp_exit_env(host_iva);
>  	if (status)
> @@ -1253,6 +1253,7 @@ static int vti_vcpu_setup(struct kvm_vcpu
>  *vcpu, int id) uninit:
>  	kvm_vcpu_uninit(vcpu);
>  fail:
> +	local_irq_restore(psr);
>  	return r;
>  }

