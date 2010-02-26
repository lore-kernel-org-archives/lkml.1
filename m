Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907Ab0BZKdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:33:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933791Ab0BZKd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:33:29 -0500
Message-ID: <4B87A373.9000808@redhat.com>
Date: Fri, 26 Feb 2010 12:33:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: SVM: Add correct handling of nested iopm
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com> <1267118149-15737-5-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267118149-15737-5-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2010 07:15 PM, Joerg Roedel wrote:
> This patch adds the correct handling of the nested io
> permission bitmap. Old behavior was to not lookup the port
> in the iopm but only reinject an io intercept to the guest.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/svm.c |   25 +++++++++++++++++++++++++
>   1 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index bb75a44..3859e2c 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -78,6 +78,7 @@ struct nested_state {
>
>   	/* gpa pointers to the real vectors */
>   	u64 vmcb_msrpm;
> +	u64 vmcb_iopm;
>
>   	/* A VMEXIT is required but not yet emulated */
>   	bool exit_required;
> @@ -1603,6 +1604,26 @@ static void nested_svm_unmap(struct page *page)
>   	kvm_release_page_dirty(page);
>   }
>
> +static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
> +{
> +	unsigned port;
> +	u8 val, bit;
> +	u64 gpa;
> +
> +	if (!(svm->nested.intercept&  (1ULL<<  INTERCEPT_IOIO_PROT)))
> +		return NESTED_EXIT_HOST;
> +
> +	port = svm->vmcb->control.exit_info_1>>  16;
> +	gpa  = svm->nested.vmcb_iopm + (port / 8);
> +	bit  = port % 8;
> +	val  = 0;
> +
> +	if (kvm_read_guest(svm->vcpu.kvm, gpa,&val, 1))
> +		val&= (1<<  bit);
> +
> +	return val ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
> +}
> +
>    

A kvm_{test,set,clear}_guest_bit() would be useful, we have several 
users already (not a requirement for this patchset).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

