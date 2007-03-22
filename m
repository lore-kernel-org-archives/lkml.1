Return-Path: <linux-kernel-owner+w=401wt.eu-S1030576AbXCVVbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576AbXCVVbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965414AbXCVVbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:31:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52448 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965405AbXCVVa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:30:59 -0400
Date: Thu, 22 Mar 2007 14:30:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@qumranet.com>, Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] make KVM conform to sucky rdmsr interface
Message-Id: <20070322143011.0cf83370.akpm@linux-foundation.org>
In-Reply-To: <1174549770.2713.121.camel@localhost.localdomain>
References: <1174531917.2713.91.camel@localhost.localdomain>
	<46022E40.8080300@qumranet.com>
	<1174549770.2713.121.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 18:49:30 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> rdmsr_safe() takes pointers.  rdmsr() modifies its arguments.  What a
> mess.
> 
> Fix rdmsr_safe() with !CONFIG_PARAVIRT.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r a7f78e8eacc8 include/asm-i386/msr.h
> --- a/include/asm-i386/msr.h	Thu Mar 22 12:38:35 2007 +1100
> +++ b/include/asm-i386/msr.h	Thu Mar 22 18:40:35 2007 +1100
> @@ -96,12 +96,12 @@ static inline void wrmsrl (unsigned long
>  	(native_write_msr(msr, ((unsigned long long)val2 << 32) | val1))
>  
>  /* rdmsr with exception handling */
> -#define rdmsr_safe(msr,val1,val2)						\
> +#define rdmsr_safe(msr,p1,p2)						\
>  	({								\
>  		int __err;						\
> -		unsigned long long __val = native_read_msr(msr, &__err);	\
> -		val1 = __val;						\
> -		val2 = __val >> 32;					\
> +		unsigned long long __val = native_read_msr(msr, &__err);\
> +		(*p1) = __val;						\
> +		(*p2) = __val >> 32;					\
>  		__err;							\
>  	})


Linus's tree has

/* rdmsr with exception handling */
#define rdmsr_safe(msr,a,b) ({ int ret__;						\
	asm volatile("2: rdmsr ; xorl %0,%0\n"						\
		     "1:\n\t"								\
		     ".section .fixup,\"ax\"\n\t"					\
		     "3:  movl %4,%0 ; jmp 1b\n\t"					\
		     ".previous\n\t"							\
 		     ".section __ex_table,\"a\"\n"					\
		     "   .align 4\n\t"							\
		     "   .long 	2b,3b\n\t"						\
		     ".previous"							\
		     : "=r" (ret__), "=a" (*(a)), "=d" (*(b))				\
		     : "c" (msr), "i" (-EFAULT));\
	ret__; })

(secret decoder ring: resize your xterm to 100 cols to read the above.  Sigh).

Which tree are you patching??
