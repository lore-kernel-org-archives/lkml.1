Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZGALvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZGALvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZGALvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:51:42 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:34935 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZGALvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:51:41 -0400
Message-ID: <4A4B4DCE.8050209@monstr.eu>
Date: Wed, 01 Jul 2009 13:51:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: monstr@monstr.eu, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [microblaze-uclinux] [PATCH 10/11] microblaze: use generic system.h
References: <cover.1245345894.git.arnd@arndb.de> <4372408b2a754e861984bf803d8b1ade651eb827.1245347640.git.arnd@arndb.de> <4A4B4659.5030008@monstr.eu> <200907011339.56171.arnd@arndb.de>
In-Reply-To: <200907011339.56171.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann wrote:
> On Wednesday 01 July 2009, Michal Simek wrote:
>> this patch can't be applied because generic implementation expect pointer to task struct
>> but microblaze low level code expect thread_info. I have one patch for MMU kernel which fixed it
>> but I don't have it for noMMU kernel.
> 
> Ok, just leave it out for now then, it's not important because it does not impact the ABI.
> 
> Maybe I should allow overriding switch_to() in the generic file?

I thought about too. Some archs use task pointer some of them thread pointer.

Michal

> 
> 	Arnd <><
> ---
> asm-generic: make parts of system.h optional
> 
> The asm-generic/system.h file was originally meant as an example, but by
> letting the architecture override some of its contents, it immediately
> becomes much more useful.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> --- a/include/asm-generic/system.h
> +++ b/include/asm-generic/system.h
> @@ -24,6 +24,7 @@
>  
>  struct task_struct;
>  
> +#ifndef switch_to
>  /* context switching is now performed out-of-line in switch_to.S */
>  extern struct task_struct *__switch_to(struct task_struct *,
>  		struct task_struct *);
> @@ -31,10 +32,15 @@ extern struct task_struct *__switch_to(struct task_struct *,
>  	do {								\
>  		((last) = __switch_to((prev), (next)));			\
>  	} while (0)
> +#endif
>  
> +#ifndef arch_align_stack
>  #define arch_align_stack(x) (x)
> +#endif
>  
> +#ifndef nop
>  #define nop() asm volatile ("nop")
> +#define nop
>  
>  #endif /* !__ASSEMBLY__ */
>  
> @@ -46,9 +52,11 @@ extern struct task_struct *__switch_to(struct task_struct *,
>   * This implementation only contains a compiler barrier.
>   */
>  
> +#ifndef mb()
>  #define mb()	asm volatile ("": : :"memory")
>  #define rmb()	mb()
>  #define wmb()	asm volatile ("": : :"memory")
> +#endif
>  
>  #ifdef CONFIG_SMP
>  #define smp_mb()	mb()
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page : http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive : http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 
> 

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
