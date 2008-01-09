Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYAIBLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYAIBLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYAIBK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:10:58 -0500
Received: from gw.goop.org ([64.81.55.164]:44273 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbYAIBK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:10:57 -0500
Message-ID: <47841EB1.1020304@goop.org>
Date: Tue, 08 Jan 2008 17:09:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <20080108224244.GA3768@elte.hu> <20080108231226.GA10744@elte.hu> <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <20080109004329.GA6603@elte.hu>
In-Reply-To: <20080109004329.GA6603@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>     
>>>>>>>  #define __PAGE_KERNEL_EXEC						\
>>>>>>> -	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
>>>>>>> +	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
>>>>>>>     
>>>>>>>               
>>>>> This shouldn't be necessary.  The old 64-bit code defined everything 
>>>>> without _PAGE_GLOBAL, but then used a MAKE_GLOBAL() macro to OR it 
>>>>> in later.  This seemed a bit roundabout to me, so I just put it in 
>>>>> from the outset.
>>>>>           
>>> actually, this is wrong.
>>>
>>> a couple of places use __PAGE_* values, which you've now changed to 
>>> include the _PAGE_GLOBAL flag.
>>>       
>> yep, fixing this resolves the crash.
>>     
>
> but then it crashes init:
>
>  init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp 
>  7fff81bedda8 error5printk: 7740690 messages suppressed.
>
> because you changed __PAGE_KERNEL_VSYSCALL as well, from:
>
>  #define __PAGE_KERNEL_VSYSCALL \
>          (_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
>
> to:
>
>  #define __PAGE_KERNEL_VSYSCALL          (__PAGE_KERNEL_RO | _PAGE_USER)
>
> but __PAGE_KERNEL_RO is an NX one, so the vsyscall cannot execute 
> instructions.
>
> so this wants to be:
>
>  #define __PAGE_KERNEL_VSYSCALL          (__PAGE_KERNEL_RX | _PAGE_USER)
>
> this was the last bug and the resulting kernel boots fine. 3 nasty bugs 
> in one patch :-/
>
> 	Ingo
>
> ---------------->
> Subject: x86: move all asm/pgtable constants into one place, fix
> From: Ingo Molnar <mingo@elte.hu>
>
> fix.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/asm-x86/pgtable.h |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> Index: linux-x86.q/include/asm-x86/pgtable.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/pgtable.h
> +++ linux-x86.q/include/asm-x86/pgtable.h
> @@ -68,27 +68,27 @@ extern unsigned long long __PAGE_KERNEL,
>  #endif	/* __ASSEMBLER__ */
>  #else
>  #define __PAGE_KERNEL_EXEC						\
> -	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
> +	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
>  #define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
>  #endif
>  
>  #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
>  #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
>  #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
> -#define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RO | _PAGE_USER)
> +#define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
>  #define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
>  #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
>  #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
>  
> -#define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
> -#define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
> -#define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
> -#define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
> -#define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
> -#define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE)
> -#define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
> -#define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
> -#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
> +#define PAGE_KERNEL			__pgprot(__PAGE_KERNEL | _PAGE_GLOBAL)
> +#define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO | _PAGE_GLOBAL)
> +#define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC | _PAGE_GLOBAL)
> +#define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX | _PAGE_GLOBAL)
> +#define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE | _PAGE_GLOBAL)
> +#define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE | _PAGE_GLOBAL)
> +#define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC | _PAGE_GLOBAL)
> +#define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL | _PAGE_GLOBAL)
> +#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE | _PAGE_GLOBAL)
>   

This isn't correct, because it will set _PAGE_GLOBAL on 32-bit 
unconditionally.  It needs to be something like:

diff -r a6d5e9e1a81d include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h	Tue Jan 08 13:59:42 2008 -0800
+++ b/include/asm-x86/pgtable.h	Tue Jan 08 16:37:19 2008 -0800
@@ -68,7 +68,7 @@ extern unsigned long long __PAGE_KERNEL,
 #endif	/* __ASSEMBLER__ */
 #else
 #define __PAGE_KERNEL_EXEC						\
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
 #endif
 
@@ -80,15 +80,17 @@ extern unsigned long long __PAGE_KERNEL,
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
-#define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
-#define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
-#define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
-#define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
-#define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
-#define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
-#define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+#define GLOBAL_PGPROT(prot)	__pgprot(prot | _PAGE_GLOBAL)
+
+#define PAGE_KERNEL			GLOBAL_PGPROT(__PAGE_KERNEL)
+#define PAGE_KERNEL_RO			GLOBAL_PGPROT(__PAGE_KERNEL_RO)
+#define PAGE_KERNEL_EXEC		GLOBAL_PGPROT(__PAGE_KERNEL_EXEC)
+#define PAGE_KERNEL_RX			GLOBAL_PGPROT(__PAGE_KERNEL_RX)
+#define PAGE_KERNEL_NOCACHE		GLOBAL_PGPROT(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_LARGE		GLOBAL_PGPROT(__PAGE_KERNEL_LARGE)
+#define PAGE_KERNEL_LARGE_EXEC		GLOBAL_PGPROT(__PAGE_KERNEL_LARGE_EXEC)
+#define PAGE_KERNEL_VSYSCALL		GLOBAL_PGPROT(__PAGE_KERNEL_VSYSCALL)
+#define PAGE_KERNEL_VSYSCALL_NOCACHE	GLOBAL_PGPROT(__PAGE_KERNEL_VSYSCALL_NOCACHE)
 
 /*         xwr */
 #define __P000	PAGE_NONE


