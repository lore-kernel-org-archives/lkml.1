Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbZJMVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbZJMVMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761343AbZJMVMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:12:19 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59458 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760812AbZJMVMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:12:16 -0400
Date: Tue, 13 Oct 2009 21:11:37 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] v3: allow userspace to adjust kvmclock offset
Message-ID: <20091013211137.GB31282@gambetta>
References: <1255467305-14748-1-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255467305-14748-1-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:55:05PM -0400, Glauber Costa wrote:
> +	case KVM_SET_CLOCK: {
> +		struct timespec now;
> +		struct kvm_clock_data user_ns;
> +		u64 now_ns;
> +		long delta;
		^^^^
Should'nt that read s64? I guess such a large value won't happen in
practice, but the 32bits case would truncate the value differently in
the substraction below.

Regards,
Frederik
> +
> +		r =  -EFAULT;
> +		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
> +			goto out;
> +
> +		r = 0;
> +		ktime_get_ts(&now);
> +		now_ns = timespec_to_ns(&now);
> +		delta = user_ns.clock - now_ns;
> +		kvm->arch.kvmclock_offset = delta;
> +		break;	
> +	}
> +	case KVM_GET_CLOCK: {
> +		struct timespec now;
> +		struct kvm_clock_data user_ns;
> +		u64 now_ns;
> +
> +		ktime_get_ts(&now);
> +		now_ns = timespec_to_ns(&now);
> +		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
> +
> +		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
> +			r =  -EFAULT;
> +
> +		break;	
> +	}
> +
>  	default:
>  		;
>  	}
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index f8f8900..ad0ecbc 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -497,6 +497,11 @@ struct kvm_irqfd {
>  	__u8  pad[20];
>  };
>  
> +struct kvm_clock_data {
> +	__u64 clock;
> +	__u64 pad[2];
> +};
> +
>  /*
>   * ioctls for VM fds
>   */
> @@ -546,6 +551,8 @@ struct kvm_irqfd {
>  #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
>  #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
>  #define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioeventfd)
> +#define KVM_SET_CLOCK		  _IOW(KVMIO, 0x7a, struct kvm_clock_data)
> +#define KVM_GET_CLOCK		  _IOW(KVMIO, 0x7b, struct kvm_clock_data)
>  
>  /*
>   * ioctls for vcpu fds
> -- 
> 1.6.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
