Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbZAWSRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbZAWSRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZAWSRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:17:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53917 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZAWSRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:17:30 -0500
Date: Fri, 23 Jan 2009 19:17:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inline asm semantics: output constraint width smaller than
	input
Message-ID: <20090123181721.GA32545@elte.hu>
References: <497A0500.3080706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <497A0500.3080706@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0059]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> Hi,
> 
> I am trying to build the kernel with LLVM 2.5 prerelease (using 
> llvm-gcc-4.2 frontend), however I am running into some inline asm 
> semantics issues, and after some discussion on LLVM bugzilla I would 
> like to know if you would be accepting patches for this: 
> http://llvm.org/bugs/show_bug.cgi?id=3373
> 
> The problem is when "a" output constraint is used with a variable of 
> smaller width than the "0" input constraint.
> 
> Here are 2 examples:
> 
> int __ret_pu; unsigned long __pu_val;
> return   ({asm volatile("call __put_user_" "8" : "=a" (__ret_pu) :"0"
>                           (__pu_val), "c"(addr) : "ebx"); __ret_pu;});
> 
> 
> unsigned char return_code;      /* %al */         
> unsigned long address;          /* %ebx */ 
> unsigned long length;           /* %ecx */
> unsigned long entry;            /* %edx */
> unsigned long flags;
> __asm__("lcall *(%%edi); cld"
>                 : "=a" (return_code),
>                   "=b" (address),
>                   "=c" (length),
>                   "=d" (entry)
>                 : "0" (service),
>                   "1" (0),
>                   "D" (&bios32_indirect));
> 
> There are 2 cases:
> 1. output is wider than input
> 2. output is narrower than input
> 
> Case 2 seems to occur lots of times on 64-bit (due to sizeof(int) != 
> sizeof(unsigned long)), and a few times on 32-bit as well.
> 
> Would you accept patches that increase the portability of the inline asm 
> statements? (essentially by adding casts for case 1, and introducing a 
> temporary of correct width for case 2).

i'd not mind it at all if the kernel could be built with other open-source 
compilers too.

Now in this case the patch you suggest might end up hurting the end result 
so it's not an unconditional 'yes'. But ... how much it actually matters 
depends on the circumstances.

So could you please send a sample patch for some of most common inline 
assembly statements that are affected by this, so that we can see:

   1) how ugly the LLVM workarounds are
   2) how they affect the generated kernel image in practice

My gut feeling is that it's going to be acceptable with a bit of thinking 
(we might even do some wrappers to do this cleanly) - but i'd really like 
to see it before giving you that judgement.

Another question: does LLVM always warn about such input/output aliased 
constraint width mismatch problems if they occur, or does it silently 
corrupt the resulting instruction sequence?

	Ingo
