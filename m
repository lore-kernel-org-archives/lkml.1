Return-Path: <linux-kernel-owner+w=401wt.eu-S1762324AbXHONqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324AbXHONqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbXHONqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:46:01 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34314 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245AbXHONqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:46:00 -0400
Date: Wed, 15 Aug 2007 15:45:55 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: Satyam Sharma <satyam@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations
	already do.
Message-ID: <20070815134555.GA29761@Chamillionaire.breakpoint.cc>
References: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au> <alpine.LFD.0.999.0708151809420.16414@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708151809420.16414@enigma.security.iitk.ac.in>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Satyam Sharma | 2007-08-15 18:32:10 [+0530]:

>On Wed, 15 Aug 2007, Herbert Xu wrote:
>
>> Andi Kleen <ak@suse.de> wrote:
>> >> My config with march=pentium-m and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
>> >>   text    data     bss     dec     hex filename
>> >> 3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
>> >> 3435308  249176  176128 3860612  3ae884 atomic_inlineasm/vmlinux
>> > 
>> > What is the difference between atomic_normal and atomic_inlineasm? 
>> 
>> The inline asm stops certain optimisations from occuring.
>
>Yup, the "__volatile__" after "__asm__" shouldn't be required. The
>previous definitions allowed the compiler to optimize certain atomic
>ops away, and considering we haven't seen any bugs due to the past
>behaviour anyway, changing it like this sounds unnecessary.
>
>The second behavioral change that comes about here is the force-
>constraining of v->counter to memory in the extended asm's constraint
>sets. But that's required to give "volatility"-like behaviour, which
>I suspect is the goal of this patch.
exactly.

>Sebastian, could you look at the kernel images in detail and see why,
>how and what in the text expanded by 1158 bytes with these changes?
Wow, easy. "normal" is Linus' git. It has no volatile or anything. I
suspect the compiler to "optimize" some of the reads and sets away
(which remain after my patch is applied).
Anyway, I tried to find out the source of this and it is not that easy.
If the text is getting bigger, all references to the data section are
changed and I can't simply diff. Than I searched for two "equal" .o
files which differ in size. This was not better because gcc reorganized
the whole .o file and the functions that were at the beginning in the
first file, were at a different position in the second one.
For those who have plenty of time in their hands, I posted the four
kernels [1] and my four O= folders [2]. 
Once I have some time, I try to diff the specific function within the .o
file which used the atomic_{read|set} operation.

>> I'm still unconvinced why we need this because nobody has
>> brought up any examples of kernel code that legitimately
>> need this.
>
>Me too, but I do find these more palatable than the variants using
>"volatile", I admit.
Yes. The inline asm is even smaller than the volatile ones, what sounds
like better optimization by the gcc (and it does exactly what volatile
was used for).

[1] http://download.breakpoint.cc/kernel_builds_vmlinux.tbz2 8.3 MiB
[2] http://download.breakpoint.cc/kernel_builds.tbz2 117 MiB
>
>Satyam

Sebastian
