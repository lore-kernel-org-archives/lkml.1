Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbXCVHUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbXCVHUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXCVHUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:20:36 -0400
Received: from mtaout4.012.net.il ([84.95.2.10]:24925 "EHLO mtaout4.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbXCVHUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:20:35 -0400
Date: Thu, 22 Mar 2007 09:20:32 +0200
From: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] make KVM conform to sucky rdmsr interface
In-reply-to: <1174531917.2713.91.camel@localhost.localdomain>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Message-id: <46022E40.8080300@qumranet.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Thu,
 22 Mar 2007 09:20:32 +0200 (IST)
References: <1174531917.2713.91.camel@localhost.localdomain>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Grrr.... Andi refused to take my "rdmsr64" patch which moved to a
> function-like interface for MSRs, dismissing it as pointless churn.
>
> paravirt_ops cleanups changed a macro to an inline and spotted this
> kvm bug.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff -r 47c6ee74a5c5 drivers/kvm/vmx.c
> --- a/drivers/kvm/vmx.c	Thu Mar 22 12:57:44 2007 +1100
> +++ b/drivers/kvm/vmx.c	Thu Mar 22 13:38:24 2007 +1100
> @@ -1127,7 +1127,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
>  		u64 data;
>  		int j = vcpu->nmsrs;
>  
> -		if (rdmsr_safe(index, &data_low, &data_high) < 0)
> +		if (rdmsr_safe(index, data_low, data_high) < 0)
>  			continue;
>  		if (wrmsr_safe(index, data_low, data_high) < 0)
>  			continue;
>
>
>   

My rdmsr_safe (x86_64, i386 is similar/same) is

#define rdmsr_safe(msr,a,b) \
        ({ int ret__;                                           \
          asm volatile ("1:       rdmsr\n"                      \
                      "2:\n"                                    \
                      ".section .fixup,\"ax\"\n"                \
                      "3:       movl %4,%0\n"                   \
                      " jmp 2b\n"                               \
                      ".previous\n"                             \
                      ".section __ex_table,\"a\"\n"             \
                      " .align 8\n"                             \
                      " .quad 1b,3b\n"                          \
                      ".previous":"=&bDS" (ret__), "=a"(*(a)), "=d"(*(b))\
                      :"c"(msr), "i"(-EIO), "0"(0));            \
          ret__; })


Which seems quite happy to accept pointers to the values. The one in 
asm/i386/paravirt.h has a similar calling convention.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

