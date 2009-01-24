Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbZAXR22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbZAXR22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 12:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZAXR2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 12:28:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54242 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZAXR2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 12:28:19 -0500
Date: Sat, 24 Jan 2009 18:27:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       LLVM Developers Mailing List <llvmdev@cs.uiuc.edu>
Subject: Re: inline asm semantics: output constraint width smaller than
	input
Message-ID: <20090124172758.GA31699@elte.hu>
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu> <497A0C0A.7080207@gmail.com> <497B408C.20802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <497B408C.20802@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> On 2009-01-23 20:27, Török Edwin wrote:
> >>>    
> >>>       
> >> i'd not mind it at all if the kernel could be built with other open-source 
> >> compilers too.
> >>
> >> Now in this case the patch you suggest might end up hurting the end result 
> >> so it's not an unconditional 'yes'. But ... how much it actually matters 
> >> depends on the circumstances.
> >>
> >> So could you please send a sample patch for some of most common inline 
> >> assembly statements that are affected by this, so that we can see:
> >>
> >>    1) how ugly the LLVM workarounds are
> >>   
> >>     
> >
> > Ok, I will prepare a patch for both cases.
> >
> >   
> >>    2) how they affect the generated kernel image in practice
> >>
> >> My gut feeling is that it's going to be acceptable with a bit of thinking 
> >> (we might even do some wrappers to do this cleanly) - but i'd really like 
> >> to see it before giving you that judgement.
> >>     
> 
> The below patch is to build the kernel for x86_64, with the attached
> .config,
> using llvm-gcc (trunk, with patch from
> http://llvm.org/bugs/show_bug.cgi?id=2989#c2).
> 
> The .config has KVM turned off, because I didn't know how to change
> x86_emulate.c so that LLVM builds it
> (http://llvm.org/bugs/show_bug.cgi?id=3373#c10)
> For 32-bit some more changes are required.
> 
> The resulting kernel image are of the same size
> $ ls -l vmlinux.patched
> -rwxr-xr-x 1 edwin edwin 11277206 2009-01-24 17:58 vmlinux.patched
> $ ls -l vmlinux
> -rwxr-xr-x 1 edwin edwin 11277206 2009-01-24 18:01 vmlinux
> 
> They aren't identical though, a disassembly shows that the address of
> most of functions changed,
> also some register assignments changed (r14 instead of r15, and so on).
> 
> Are these changes correct, and are they acceptable?
> 
> Best regards,
> --Edwin
> 
> ---
>  arch/x86/include/asm/uaccess.h |   10 ++++++----
>  arch/x86/lib/delay.c           |    2 +-
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> index 69d2757..28280de 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -154,7 +154,7 @@ extern int __get_user_bad(void);
>  
>  #define get_user(x, ptr)                        \
>  ({                                    \
> -    int __ret_gu;                            \
> +    unsigned long __ret_gu;                        \
>      unsigned long __val_gu;                        \
>      __chk_user_ptr(ptr);                        \
>      might_fault();                            \
> @@ -176,7 +176,7 @@ extern int __get_user_bad(void);
>          break;                            \
>      }                                \
>      (x) = (__typeof__(*(ptr)))__val_gu;                \
> -    __ret_gu;                            \
> +    (int)__ret_gu;                            \
>  })
>  
>  #define __put_user_x(size, x, ptr, __ret_pu)            \
> @@ -239,11 +239,13 @@ extern void __put_user_8(void);
>   */
>  #define put_user(x, ptr)                    \
>  ({                                \
> -    int __ret_pu;                        \
> +    __typeof__(*(ptr)) __ret_pu;                \

This does not look right. We can sometimes have put_user() of non-integer 
types (say structures). How does the (int)__ret_pu cast work in that case? 
We'll fall into this branch in that case:

        default:                                                \
                __put_user_x(X, __pu_val, ptr, __ret_pu);       \
                break;                                          \

and __ret_pu has a nonsensical type in that case.

>      __typeof__(*(ptr)) __pu_val;                \
>      __chk_user_ptr(ptr);                    \
>      might_fault();                        \
>      __pu_val = x;                        \
> +       /* return value is 0 or -EFAULT, both fit in 1 byte, and \
> +    * are sign-extendable to int */                \
>      switch (sizeof(*(ptr))) {                \
>      case 1:                            \
>          __put_user_x(1, __pu_val, ptr, __ret_pu);    \
> @@ -261,7 +263,7 @@ extern void __put_user_8(void);
>          __put_user_x(X, __pu_val, ptr, __ret_pu);    \
>          break;                        \
>      }                            \
> -    __ret_pu;                        \
> +    (int)__ret_pu;                        \
>  })
>  
>  #define __put_user_size(x, ptr, size, retval, errret)            \
> diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
> index f456860..12d27f8 100644
> --- a/arch/x86/lib/delay.c
> +++ b/arch/x86/lib/delay.c
> @@ -112,7 +112,7 @@ EXPORT_SYMBOL(__delay);
>  
>  inline void __const_udelay(unsigned long xloops)
>  {
> -    int d0;
> +    unsigned long d0;
>  
>      xloops *= 4;
>      asm("mull %%edx"

Is this all that you need (plus the 16-bit setup code tweaks) to get LLVM 
to successfully build a 64-bit kernel image?

If yes then this doesnt look all that bad or invasive at first sight (if 
the put_user() workaround can be expressed in a cleaner way), but in any 
case it would be nice to hear an LLVM person's opinion about roughly when 
this is going to be solved in LLVM itself.

	Ingo
