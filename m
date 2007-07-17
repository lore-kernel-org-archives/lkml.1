Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbXGQIND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbXGQIND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbXGQIMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:12:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:43916 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbXGQIMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:12:46 -0400
Message-ID: <469C7A05.2070205@qumranet.com>
Date: Tue, 17 Jul 2007 11:12:53 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       KVM devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/3] KVM - Add missing kvm_run initializations
References: <20070716192446.GA16243@c2.user-mode-linux.org>
In-Reply-To: <20070716192446.GA16243@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> There are a bunch of missing initializations of run->exit_reason and
> associated data.
>
> kvm_hypercall wasn't setting exit_reason at all.
>
> When exit_reason is KVM_EXIT_MMIO, the mmio data isn't initialized.  I
> don't know what it should be, so I just stuck a FIXME in there.
>
> There were some missing initializations of hardware_exit_reason with
> KVM_EXIT_UNKNOWN, so I added those.  One case had exit_reason = 0,
> which I changed to KVM_EXIT_UNKNOWN.
>
> I did a pass over all of the return 0 paths in the exit handler
> callbacks, so this should cover everything.
>
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  drivers/kvm/kvm_main.c |    3 +++
>  drivers/kvm/svm.c      |    3 +++
>  drivers/kvm/vmx.c      |    4 +++-
>  3 files changed, 9 insertions(+), 1 deletion(-)
>
> Index: kvm/drivers/kvm/kvm_main.c
> ===================================================================
> --- kvm.orig/drivers/kvm/kvm_main.c
> +++ kvm/drivers/kvm/kvm_main.c
> @@ -1370,6 +1370,7 @@ int kvm_hypercall(struct kvm_vcpu *vcpu,
>  		run->hypercall.ret = ret;
>  		run->hypercall.longmode = is_long_mode(vcpu);
>  		kvm_arch_ops->decache_regs(vcpu);
> +		run->exit_reason = KVM_EXIT_HYPERCALL;
>  		return 0;
>  	}
>   

Aye. (And: aiiieee)

>  	vcpu->regs[VCPU_REGS_RAX] = ret;
> @@ -1928,6 +1929,8 @@ static int kvm_vcpu_ioctl_run(struct kvm
>  		if (r == EMULATE_DO_MMIO) {
>  			/*
>  			 * Read-modify-write.  Back to userspace.
> +			 *
> +			 * FIXME - kvm_run->mmio not initialized
>  			 */
>  			kvm_run->exit_reason = KVM_EXIT_MMIO;
>  			r = 0;
>   

I believe that emulate_instruction will set run->mmio if it returns 
EMULATE_DO_MMIO.

> Index: kvm/drivers/kvm/svm.c
> ===================================================================
> --- kvm.orig/drivers/kvm/svm.c
> +++ kvm/drivers/kvm/svm.c
> @@ -929,6 +929,7 @@ static int pf_interception(struct kvm_vc
>  		return 1;
>  	case EMULATE_DO_MMIO:
>  		++vcpu->stat.mmio_exits;
> +		/* FIXME - kvm_run->mmio not initialized */
>  		kvm_run->exit_reason = KVM_EXIT_MMIO;
>   

Ditto.

The rest are all good.

-- 
error compiling committee.c: too many arguments to function

