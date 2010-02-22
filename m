Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab0BVK3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:29:21 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:41106 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0BVK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:29:19 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dN936eMab9bhzz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY8NSM-02-5LM-02
X-M-MSG: 
Date: Mon, 22 Feb 2010 11:29:09 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 02/11] KVM: SVM: Fix wrong interrupt injection in
 enable_irq_windows
Message-ID: <20100222102909.GB4210@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
 <1266592990-8911-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1266592990-8911-3-git-send-email-joerg.roedel@amd.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Feb 2010 10:29:10.0665 (UTC) FILETIME=[DF0F5790:01CAB3A9]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

forgot this one? I did not find it in your tree.

Joerg

On Fri, Feb 19, 2010 at 04:23:01PM +0100, Joerg Roedel wrote:
> The nested_svm_intr() function does not execute the vmexit
> anymore. Therefore we may still be in the nested state after
> that function ran. This patch changes the nested_svm_intr()
> function to return wether the irq window could be enabled.
> 
> Cc: stable@kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/svm.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 63ecd4d..f87fc98 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1389,16 +1389,17 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>  	return nested_svm_exit_handled(svm);
>  }
>  
> -static inline int nested_svm_intr(struct vcpu_svm *svm)
> +/* This function returns true if it is save to enable the irq window */
> +static inline bool nested_svm_intr(struct vcpu_svm *svm)
>  {
>  	if (!is_nested(svm))
> -		return 0;
> +		return true;
>  
>  	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
> -		return 0;
> +		return true;
>  
>  	if (!(svm->vcpu.arch.hflags & HF_HIF_MASK))
> -		return 0;
> +		return false;
>  
>  	svm->vmcb->control.exit_code = SVM_EXIT_INTR;
>  
> @@ -1411,10 +1412,10 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
>  		 */
>  		svm->nested.exit_required = true;
>  		trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
> -		return 1;
> +		return false;
>  	}
>  
> -	return 0;
> +	return true;
>  }
>  
>  static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, struct page **_page)
> @@ -2563,13 +2564,11 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	nested_svm_intr(svm);
> -
>  	/* In case GIF=0 we can't rely on the CPU to tell us when
>  	 * GIF becomes 1, because that's a separate STGI/VMRUN intercept.
>  	 * The next time we get that intercept, this function will be
>  	 * called again though and we'll get the vintr intercept. */
> -	if (gif_set(svm)) {
> +	if (gif_set(svm) && nested_svm_intr(svm)) {
>  		svm_set_vintr(svm);
>  		svm_inject_irq(svm, 0x0);
>  	}
> -- 
> 1.6.6
> 

