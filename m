Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbZJJNlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbZJJNlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 09:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759083AbZJJNk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 09:40:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:33871 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751971AbZJJNk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 09:40:57 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18gxZYJ9y8gZR6lSDHcbPlNMGnNNs9yY4UUBTmeKU
	lZ8omiCM+iAPrX
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch kvm-svm-fix-tsc-offset-adjustment-when-running-nested.patch added to 2.6.31-stable tree
Date: Sat, 10 Oct 2009 15:40:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-3.slh.1-sidux-amd64; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, joerg.roedel@amd.com, mtosatti@redhat.com,
       stable@kernel.org
References: <20091009223815.20569488DB@coco.kroah.org>
In-Reply-To: <20091009223815.20569488DB@coco.kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910101540.06686.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Saturday 10 October 2009, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: KVM: SVM: Fix tsc offset adjustment when running nested
> 
> to the 2.6.31-stable tree.  Its filename is
> 
>     kvm-svm-fix-tsc-offset-adjustment-when-running-nested.patch

This patch breaks compilation of 2.6.31.4-rc1 and 2.6.31.4-rc2, as it 
seems to depend on several prior optimisations to kvm's/ svm's nested 
behaviour:

[...]
  CC [M]  arch/x86/kvm/svm.o
arch/x86/kvm/svm.c: In function 'svm_vcpu_load':
arch/x86/kvm/svm.c:713: error: 'struct vcpu_svm' has no member named 'nested'
make[2]: *** [arch/x86/kvm/svm.o] Error 1
make[1]: *** [arch/x86/kvm] Error 2
make: *** [arch/x86] Error 2

Regards
	Stefan Lippers-Hollmann

-- 
> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From 77b1ab1732feb5e3dcbaf31d2f7547c5229f5f3a Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Wed, 16 Sep 2009 15:24:17 +0200
> Subject: KVM: SVM: Fix tsc offset adjustment when running nested
> 
> From: Joerg Roedel <joerg.roedel@amd.com>
> 
> commit 77b1ab1732feb5e3dcbaf31d2f7547c5229f5f3a upstream.
> 
> When svm_vcpu_load is called while the vcpu is running in
> guest mode the tsc adjustment made there is lost on the next
> emulated #vmexit. This causes the tsc running backwards in
> the guest. This patch fixes the issue by also adjusting the
> tsc_offset in the emulated hsave area so that it will not
> get lost.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/x86/kvm/svm.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -709,6 +709,8 @@ static void svm_vcpu_load(struct kvm_vcp
>  		rdtscll(tsc_this);
>  		delta = vcpu->arch.host_tsc - tsc_this;
>  		svm->vmcb->control.tsc_offset += delta;
> +		if (is_nested(svm))
> +			svm->nested.hsave->control.tsc_offset += delta;
>  		vcpu->cpu = cpu;
>  		kvm_migrate_timers(vcpu);
>  		svm->asid_generation = 0;
