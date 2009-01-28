Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbZA1BiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbZA1BiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 20:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZA1Bh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 20:37:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:55539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZA1Bh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 20:37:59 -0500
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 07:06:54 +0530
Message-Id: <1233106614.3256.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 14:57 -0800, Linus Torvalds wrote:

> 
> The thing is, the headers_check stuff is just wrong if it causes these 
> things, and I'd rather just turn it off.
> 

Basic idea of headers_check is:
1. clean header files so that they do not export useless things in userspace, like:
    usr/include/linux/elf-fdpic.h:62: extern's make no sense in userspace

2. provide sufficient stuff like:
   usr/include/asm/swab.h:7: found __[us]{8,16,32,64} type without #include <linux/types.h>

3. warns about exporting kernel space defines which are not valid in userspace and is always false for userspace
   usr/include/asm/swab.h:10: leaks CONFIG_X86 to userspace where it is not valid

And by headers_check tools we also able to find blunder mistakes which are very difficult to find by naked eye like:
   usr/include/asm-generic/fcntl.h:127: leaks CONFIG_64BIT to userspace where it is not valid 
for userspace this will be always false.
and some files was totally covered with ifdefs CONFIG_* and exported which are useless like:
  usr/include/linux/if_frad.h:29: leaks CONFIG_DLCI to userspace where it is not valid


> If those 
> 
> 	#ifdef CONFIG_XYZ
> 
> things result in problems, then we should just make the rule be that we 
> turn that kind of string into
> 
> 	#if 0
> 

This will looks ugly in userspace with so many #if 0 and make impossible
to read the code.

> automatically when exporting the kernel headers. IOW, just about 
> _anything_ that headers_check complains about automatically is something 
> that should just be _fixed_ automatically at header install time rather 
> than make the code harder to read.
> 
> So I think it makes our headers worse. Code like
> 
> 	> +#ifdef __KERNEL__
> 	> +# ifdef CONFIG_X86_BSWAP
> 	> +# define __X86_BSWAP  
> 	> +# endif /* CONFIG_X86_BSWAP */
> 	> +#endif /* __KERNEL__ */
> 
> just doesn't make sense. It doesn't make sense _inside_ the kernel, and it 
> doesn't make sense _outside_ it either.
> 

my earlier patch was like this:

diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
index 306d417..613be68 100644
--- a/arch/x86/include/asm/swab.h
+++ b/arch/x86/include/asm/swab.h
@@ -1,12 +1,15 @@
 #ifndef _ASM_X86_SWAB_H
 #define _ASM_X86_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
+#ifdef __KERNEL__
 #include <linux/compiler.h>
+#endif /* __KERNEL__ */
 
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 #ifdef __i386__
+#ifdef __KERNEL__
 # ifdef CONFIG_X86_BSWAP
        asm("bswap %0" : "=r" (val) : "0" (val));
 # else
@@ -16,7 +19,13 @@ static inline __attribute_const__ __u32
__arch_swab32(__u32 val)
            : "=q" (val)
            : "0" (val));
 # endif
-
+#else /* __KERNEL__ */
+       asm("xchgb %b0,%h0\n\t" /* swap lower bytes     */
+           "rorl $16,%0\n\t"   /* swap words           */
+           "xchgb %b0,%h0"     /* swap higher bytes    */
+           : "=q" (val)
+           : "0" (val));
+#endif /* __KERNEL__ */
 #else /* __i386__ */
        asm("bswapl %0"
            : "=r" (val)
@@ -37,6 +46,7 @@ static inline __attribute_const__ __u64
__arch_swab64(__u64 val)
                __u64 u;
        } v;
        v.u = val;
+#ifdef __KERNEL__
 # ifdef CONFIG_X86_BSWAP
        asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
            : "=r" (v.s.a), "=r" (v.s.b)
@@ -48,6 +58,13 @@ static inline __attribute_const__ __u64
__arch_swab64(__u64 val)
            : "=r" (v.s.a), "=r" (v.s.b)
            : "0" (v.s.a), "1" (v.s.b));
 # endif
+#else /* __KERNEL__ */
+       v.s.a = __arch_swab32(v.s.a);
+       v.s.b = __arch_swab32(v.s.b);
+       asm("xchgl %0,%1"
+           : "=r" (v.s.a), "=r" (v.s.b)
+           : "0" (v.s.a), "1" (v.s.b));
+#endif /* __KERNEL__ */
        return v.u;
 #else /* __i386__ */
        asm("bswapq %0"

to get rid of multiple blocks so I used above technique.

If we do not want to export __arch_swab32 and __arch_swab64 then we can
put whole block in #ifdef __KERNEL__ then we will get rid of above
solution.

--
JSR

