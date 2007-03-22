Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXCVIBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXCVIBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030230AbXCVIBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:01:00 -0400
Received: from ozlabs.org ([203.10.76.45]:40736 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030224AbXCVIBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:01:00 -0400
Subject: Re: [PATCH] Cleanup: rationalize paravirt wrappers
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <46023096.8060809@qumranet.com>
References: <1174531311.2713.86.camel@localhost.localdomain>
	 <46023096.8060809@qumranet.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 19:00:42 +1100
Message-Id: <1174550442.2713.128.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 09:30 +0200, Avi Kivity wrote:
> Rusty Russell wrote:
> > +static inline unsigned long long native_read_msr(unsigned int msr, int *err)
> > +{
> > +	unsigned long long val;
> > +
> > +	asm volatile("2: rdmsr ; xorl %0,%0\n"
> > +		     "1:\n\t"
> > +		     ".section .fixup,\"ax\"\n\t"
> > +		     "3:  movl %3,%0 ; jmp 1b\n\t"
> > +		     ".previous\n\t"
> > + 		     ".section __ex_table,\"a\"\n"
> > +		     "   .align 4\n\t"
> > +		     "   .long 	2b,3b\n\t"
> > +		     ".previous"
> > +		     : "=r" (*err), "=A" (val)
> > +		     : "c" (msr), "i" (-EFAULT));
> > +
> > +	return val;
> > +}
> >   
> 
> 
> > +#define rdmsr(msr,val1,val2)						\
> > +	do {								\
> > +		int __err;						\
> > +		unsigned long long __val = native_read_msr(msr, &__err);	\
> > +		val1 = __val;						\
> > +		val2 = __val >> 32;					\
> > +	} while(0)
> > +
> >   
> 
> You're silently changing the behavior (as well as the prototype) here,  
> rdmsr() used to fail loudly, now it fails silently, with no way for the 
> caller to check.

Hi Avi!

	Not sure what you're saying about the prototype: the old macro was:

-#define rdmsr(msr,val1,val2) \
-	__asm__ __volatile__("rdmsr" \
-			  : "=a" (val1), "=d" (val2) \
-			  : "c" (msr))
-

Which doesn't seem to be a great difference to me.

The behaviour change (don't oops when an invalid rdmsr is used) was
there with CONFIG_PARAVIRT=y, the cleanup just made !CONFIG_PARAVIRT the
same.  Is it important?

Thanks,
Rusty.

