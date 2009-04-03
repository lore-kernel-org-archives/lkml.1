Return-Path: <linux-kernel-owner+w=401wt.eu-S1763121AbZDCAjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763121AbZDCAjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762352AbZDCAip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:38:45 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:19547 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761924AbZDCAin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=P4hxfjXgfnkOMKDGkWgGpfyKE6rV8sphXHwBrqEuvMuArMNh9zaqcOHz9qMZV6wm7j
         nW7Rf+F8J3dZtDXPZ1l7Kk/th17cBTrUoWBVobKaGSH/b9VUk82GGydk8KDRSkD6Koj/
         Jr7CPpm/dP4JjWThvT5De+ii9TMeMb9mTEcyw=
Message-ID: <49D55ABA.3030502@gmail.com>
Date: Fri, 03 Apr 2009 09:39:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] percpu: convert SNMP mibs to new infra
References: <49D32212.80607@cosmosbay.com> <49D32DC2.9010003@goop.org> <49D33E80.70802@cosmosbay.com> <20090401161218.GB3859@elte.hu> <49D3A0C2.9000403@cosmosbay.com> <49D3B61F.8010507@cosmosbay.com> <49D40323.2020406@gmail.com> <20090402040537.GB30442@elte.hu> <49D4724C.7010200@cosmosbay.com>
In-Reply-To: <49D4724C.7010200@cosmosbay.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
...
>  #define percpu_read(var)	percpu_from_op("mov", per_cpu__##var)
>  #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
>  #define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
> +#define percpu_ptr_add(var, val)	percpu_to_op("add", *(var), val)
> +#define percpu_ptr_inc(var)       percpu_ptr_add(var, 1)
> +#define percpu_ptr_dec(var)       percpu_ptr_add(var, -1)
>  #define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
>  #define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
>  #define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)

x86 part looks fine to me.

> diff --git a/include/net/snmp.h b/include/net/snmp.h
> index 57c9362..1ba584b 100644
> --- a/include/net/snmp.h
> +++ b/include/net/snmp.h
> @@ -123,15 +123,31 @@ struct linux_xfrm_mib {
>  };
>  
>  /* 
> - * FIXME: On x86 and some other CPUs the split into user and softirq parts
> + * On x86 and some other CPUs the split into user and softirq parts
>   * is not needed because addl $1,memory is atomic against interrupts (but 
> - * atomic_inc would be overkill because of the lock cycles). Wants new 
> - * nonlocked_atomic_inc() primitives -AK
> + * atomic_inc would be overkill because of the lock cycles).
>   */ 
> +#ifdef CONFIG_X86
> +# define SNMP_ARRAY_SZ 1
> +#else
> +# define SNMP_ARRAY_SZ 2
> +#endif

This is quite hacky but, well, for the time being...

Thanks.

-- 
tejun
