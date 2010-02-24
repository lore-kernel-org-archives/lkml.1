Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab0BXT1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:27:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652Ab0BXT1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:27:53 -0500
Subject: Re: [PATCH 11/11] KVM: SVM: Optimize nested svm msrpm merging
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1267034360-5907-12-git-send-email-joerg.roedel@amd.com>
Date: Wed, 24 Feb 2010 20:27:50 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <402BABD5-304A-47EA-B35C-D0E3948BB27E@suse.de>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com> <1267034360-5907-12-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24.02.2010, at 18:59, Joerg Roedel wrote:

> This patch optimizes the way the msrpm of the host and the
> guest are merged. The old code merged the 2 msrpm pages
> completly. This code needed to touch 24kb of memory for that
> operation. The optimized variant this patch introduces
> merges only the parts where the host msrpm may contain zero
> bits. This reduces the amount of memory which is touched to
> 48 bytes.

Nice catch!

> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
> arch/x86/kvm/svm.c |   45 ++++++++++++++++++++++++++++++++++++---------
> 1 files changed, 36 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ae2f211..eb25fea 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -754,6 +754,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
> 	svm->nested.hsave = page_address(hsave_page);
> 
> 	svm->nested.msrpm = page_address(nested_msrpm_pages);
> +	svm_vcpu_init_msrpm(svm->nested.msrpm);
> 
> 	svm->vmcb = page_address(page);
> 	clear_page(svm->vmcb);
> @@ -1824,20 +1825,46 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
> 
> static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
> {
> -	u32 *nested_msrpm;
> -	struct page *page;
> +	/*
> +	 * This function merges the msr permission bitmaps of kvm and the
> +	 * nested vmcb. It is omptimized in that it only merges the parts where
> +	 * the kvm msr permission bitmap may contain zero bits
> +	 */
> +	static const u32 msrpm_offsets[] = {
> +		0x0000002c, /* SYSENTER_CS */
> +
> +		0x00000038, /* LASTBRANCHFROMIP
> +			       LASTBRANCHTOIP
> +			       LASTINTFROMIP
> +			       LASTINTTOIP */
> +
> +		0x00000820, /* STAR
> +			       LSTAR
> +			       CSTAR
> +			       SYSCALL_MASK */
> +
> +		0x00000840, /* FS_BASE
> +			       GS_BASE
> +			       KERNEL_GS_BASE */
> +
> +		0xffffffff, /* End of List */

Isn't there such a list around somewhere already? We really should only keep this list once throughout the whole code. If necessary, just create the list on the fly when bits get set in the msrpm.

Alex

