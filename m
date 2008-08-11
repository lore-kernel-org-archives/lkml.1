Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbYHKJlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbYHKJlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYHKJlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:41:37 -0400
Received: from il.qumranet.com ([212.179.150.194]:15308 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbYHKJlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:41:36 -0400
Message-ID: <48A0094E.8020203@qumranet.com>
Date: Mon, 11 Aug 2008 12:41:34 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: kvm-devel <kvm@vger.kernel.org>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] reduce stack usage in kvm_vcpu_ioctl()
References: <1217874693-28398-1-git-send-email-dave@linux.vnet.ibm.com> <1217874695-28430-1-git-send-email-dave@linux.vnet.ibm.com>
In-Reply-To: <1217874695-28430-1-git-send-email-dave@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> Same as the last one, but this time we use kmalloc()
> for all of the uses.
>
> Note that the kfree()s take advantage of the fact that
> kfree() is OK on NULL.
>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
>  virt/kvm/kvm_main.c |   48 ++++++++++++++++++++++++++++++------------------
>  1 files changed, 30 insertions(+), 18 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7dd9b0b..70bf180 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1118,6 +1118,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  	struct kvm_vcpu *vcpu = filp->private_data;
>  	void __user *argp = (void __user *)arg;
>  	int r;
> +	struct kvm_fpu *fpu = NULL;
> +	struct kvm_sregs *kvm_sregs = NULL;
> +
>   

Spurious blank line.

>  
>  	if (vcpu->kvm->mm != current->mm)
>  		return -EIO;
> @@ -1165,25 +1168,29 @@ out_free2:
>  		break;
>  	}
>  	case KVM_GET_SREGS: {
> -		struct kvm_sregs kvm_sregs;
> -
> -		memset(&kvm_sregs, 0, sizeof kvm_sregs);
> -		r = kvm_arch_vcpu_ioctl_get_sregs(vcpu, &kvm_sregs);
> +		kvm_sregs = kzalloc(sizeof(struct kvm_sregs), GFP_KERNEL);
> +		r = -ENOMEM;
> +		if (!kvm_sregs)
> +			goto out;
> +		memset(kvm_sregs, 0, sizeof(struct kvm_sregs));
>   

memset unneeded after kzalloc.


btw, this is a generic problem, and could be handled generically:

struct ioctl_handler_entry {
    u32 ioctl;
    union {
        long (*handler_parg)(void *arg);
        long (*handler_larg)(long arg);
    };
};

void process_ioctl(struct ioctl_handler_entry *ioctls)
{
     search for correct entry;
     allocate memory (get size from ioctl number);
     copy from user (if _IOW);
     call handler;
     copy to user (if _IOR, and no error);
     free memory;
}

I imagine this can be used to simplify many ioctls.

-- 
error compiling committee.c: too many arguments to function

