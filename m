Return-Path: <linux-kernel-owner+w=401wt.eu-S1751664AbZLDOcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbZLDOcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZLDOcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:32:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:55716 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZLDOcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:32:18 -0500
In-Reply-To: <20091204092119.GA9707@laptop>
References: <20091204092119.GA9707@laptop>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8B1FEF0C-5D71-4D64-ADC3-1EE60F50779F@kernel.crashing.org>
Cc: x86@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: x86: Is 'volatile' necessary for readb/writeb and friends?
Date: Fri, 4 Dec 2009 15:39:06 +0100
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> x86 memory-mapped IO register accessors cast the memory mapped address
> parameter to a one with the 'volatile' type qualifier. For example,  
> here
> is readb() after cpp processing
>
> --> arch/x86/include/asm/io.h:
>
> static inline unsigned char readb(const volatile void __iomem *addr) {

This "volatile" is meaningless.

> 	unsigned char ret;
> 	asm volatile("movb %1, %0"

This "volatile" is required; without it, if "ret" isn't used (or can
be optimised away), the asm() could be optimised away.

> 		     :"=q" (ret)
> 		     :"m" (*(volatile unsigned char __force *)addr)

This "volatile" has no effect, since the asm has a "memory" clobber.
Without that clobber, this "volatile" would prevent moving the asm
over other memory accesses.

If you want to get all language-lawyery, if the object pointed to by
"addr" is volatile, the volatile here _is_ needed: accessing volatile
objects via a not volatile-qualified lvalue is undefined.  But since
this is GCC-specific code anyway, do you care?  :-)

> 		     :"memory");
>         return ret;
> }


Segher

