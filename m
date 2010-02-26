Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab0BZK2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:28:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933446Ab0BZK2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:28:31 -0500
Message-ID: <4B87A248.1050300@redhat.com>
Date: Fri, 26 Feb 2010 12:28:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com> <1267118149-15737-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267118149-15737-3-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2010 07:15 PM, Joerg Roedel wrote:
> This patch optimizes the way the msrpm of the host and the
> guest are merged. The old code merged the 2 msrpm pages
> completly. This code needed to touch 24kb of memory for that
> operation. The optimized variant this patch introduces
> merges only the parts where the host msrpm may contain zero
> bits. This reduces the amount of memory which is touched to
> 48 bytes.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/svm.c |   67 +++++++++++++++++++++++++++++++++++++++++++++-------
>   1 files changed, 58 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d8d4e35..d15e0ea 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -92,6 +92,9 @@ struct nested_state {
>
>   };
>
> +#define MSRPM_OFFSETS	16
> +static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> +
>   struct vcpu_svm {
>   	struct kvm_vcpu vcpu;
>   	struct vmcb *vmcb;
> @@ -436,6 +439,34 @@ err_1:
>
>   }
>
> +static void add_msr_offset(u32 offset)
> +{
> +	u32 old;
> +	int i;
> +
> +again:
> +	for (i = 0; i<  MSRPM_OFFSETS; ++i) {
> +		old = msrpm_offsets[i];
> +
> +		if (old == offset)
> +			return;
> +
> +		if (old != MSR_INVALID)
> +			continue;
> +
> +		if (cmpxchg(&msrpm_offsets[i], old, offset) != old)
> +			goto again;
> +
> +		return;
> +	}
> +
> +	/*
> +	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
> +	 * increase MSRPM_OFFSETS in this case.
> +	 */
> +	BUG();
> +}
>    

Why all this atomic cleverness?  The possible offsets are all determined 
statically.  Even if you do them dynamically (makes sense when 
considering pmu passthrough), it's per-vcpu and therefore single 
threaded (just move msrpm_offsets into vcpu context).

> @@ -1846,20 +1882,33 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
>
>   static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>   {
> -	u32 *nested_msrpm;
> -	struct page *page;
> +	/*
> +	 * This function merges the msr permission bitmaps of kvm and the
> +	 * nested vmcb. It is omptimized in that it only merges the parts where
> +	 * the kvm msr permission bitmap may contain zero bits
> +	 */
>    

A comment that describes the entire function can be moved above the 
function, freeing a whole tab stop for contents.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

