Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZKBMSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZKBMSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZKBMSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:18:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZKBMSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:18:51 -0500
Message-ID: <4AEECE2E.2050609@redhat.com>
Date: Mon, 02 Nov 2009 14:18:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] Add shared memory hypercall to PV Linux guest.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-2-git-send-email-gleb@redhat.com>
In-Reply-To: <1257076590-29559-2-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 01:56 PM, Gleb Natapov wrote:
> Add hypercall that allows guest and host to setup per cpu shared
> memory.
>
>    

Better to set this up as an MSR (with bit zero enabling, bits 1-5 
features, and 64-byte alignment).  This allows auto-reset on INIT and 
live migration using the existing MSR save/restore infrastructure.

>   arch/x86/include/asm/kvm_host.h |    3 +
>   arch/x86/include/asm/kvm_para.h |   11 +++++
>   arch/x86/kernel/kvm.c           |   82 +++++++++++++++++++++++++++++++++++++++
>   arch/x86/kernel/setup.c         |    1 +
>   arch/x86/kernel/smpboot.c       |    3 +
>   arch/x86/kvm/x86.c              |   70 +++++++++++++++++++++++++++++++++
>   include/linux/kvm.h             |    1 +
>   include/linux/kvm_para.h        |    4 ++
>   8 files changed, 175 insertions(+), 0 deletions(-)
>    

Please separate into guest and host patches.

> +#define KVM_PV_SHM_VERSION 1
>    

versions = bad, feature bits = good

> +
> +#define KVM_PV_SHM_FEATURES_ASYNC_PF		(1<<  0)
> +
> +struct kvm_vcpu_pv_shm {
> +	__u64 features;
> +	__u64 reason;
> +	__u64 param;
> +};
> +
>    

Some documentation for this?

Also, the name should reflect the pv pagefault use.  For other uses we 
can register other areas.

>   #define MMU_QUEUE_SIZE 1024
>
> @@ -37,6 +41,7 @@ struct kvm_para_state {
>   };
>
>   static DEFINE_PER_CPU(struct kvm_para_state, para_state);
> +static DEFINE_PER_CPU(struct kvm_vcpu_pv_shm *, kvm_vcpu_pv_shm);
>    

Easier to put the entire structure here, not a pointer.

> +
> +static int kvm_pv_reboot_notify(struct notifier_block *nb,
> +				unsigned long code, void *unused)
> +{
> +	if (code == SYS_RESTART)
> +		on_each_cpu(kvm_pv_unregister_shm, NULL, 1);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block kvm_pv_reboot_nb = {
> +        .notifier_call = kvm_pv_reboot_notify,
> +};
>    

Is this called on kexec, or do we need another hook?

> +static int kvm_pv_setup_shm(struct kvm_vcpu *vcpu, unsigned long gpa,
> +			    unsigned long size, unsigned long version,
> +			    unsigned long *ret)
> +{
> +	addr = gfn_to_hva(vcpu->kvm, gfn);
> +	if (kvm_is_error_hva(addr))
> +		return -EFAULT;
> +
> +	/* pin page with pv shared memory */
> +	down_read(&mm->mmap_sem);
> +	r = get_user_pages(current, mm, addr, 1, 1, 0,&vcpu->arch.pv_shm_page,
> +			   NULL);
> +	up_read(&mm->mmap_sem);
>    

This fails if the memory area straddles a page boundary.  Aligning would 
solve this.  I prefer using put_user() though than a permanent 
get_user_pages().


-- 
error compiling committee.c: too many arguments to function

