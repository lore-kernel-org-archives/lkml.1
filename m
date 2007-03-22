Return-Path: <linux-kernel-owner+w=401wt.eu-S965853AbXCVHae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965853AbXCVHae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965851AbXCVHae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:30:34 -0400
Received: from mtaout5.012.net.il ([84.95.2.13]:16203 "EHLO mtaout5.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965855AbXCVHac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:30:32 -0400
Date: Thu, 22 Mar 2007 09:30:30 +0200
From: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Cleanup: rationalize paravirt wrappers
In-reply-to: <1174531311.2713.86.camel@localhost.localdomain>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
Message-id: <46023096.8060809@qumranet.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Thu,
 22 Mar 2007 09:30:30 +0200 (IST)
References: <1174531311.2713.86.camel@localhost.localdomain>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> +static inline unsigned long long native_read_msr(unsigned int msr, int *err)
> +{
> +	unsigned long long val;
> +
> +	asm volatile("2: rdmsr ; xorl %0,%0\n"
> +		     "1:\n\t"
> +		     ".section .fixup,\"ax\"\n\t"
> +		     "3:  movl %3,%0 ; jmp 1b\n\t"
> +		     ".previous\n\t"
> + 		     ".section __ex_table,\"a\"\n"
> +		     "   .align 4\n\t"
> +		     "   .long 	2b,3b\n\t"
> +		     ".previous"
> +		     : "=r" (*err), "=A" (val)
> +		     : "c" (msr), "i" (-EFAULT));
> +
> +	return val;
> +}
>   


> +#define rdmsr(msr,val1,val2)						\
> +	do {								\
> +		int __err;						\
> +		unsigned long long __val = native_read_msr(msr, &__err);	\
> +		val1 = __val;						\
> +		val2 = __val >> 32;					\
> +	} while(0)
> +
>   

You're silently changing the behavior (as well as the prototype) here,  
rdmsr() used to fail loudly, now it fails silently, with no way for the 
caller to check.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

