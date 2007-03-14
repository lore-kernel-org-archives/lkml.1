Return-Path: <linux-kernel-owner+w=401wt.eu-S1030484AbXCNGcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484AbXCNGcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 02:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030493AbXCNGcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 02:32:15 -0400
Received: from ozlabs.org ([203.10.76.45]:51206 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030484AbXCNGcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 02:32:15 -0400
Subject: Re: [PATCH] Introduce load_TLS to the "for" loop.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070313135000.GA92373@muc.de>
References: <1173767976.10618.50.camel@localhost.localdomain>
	 <20070313135000.GA92373@muc.de>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 17:31:57 +1100
Message-Id: <1173853917.19022.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 14:50 +0100, Andi Kleen wrote:
> On Tue, Mar 13, 2007 at 05:39:36PM +1100, Rusty Russell wrote:
> > GCC (4.1 at least) unrolls it anyway, but I can't believe this code
> 
> Are you sure? Normally it doesn't unroll without -funroll-loops which
> the kernel does normally not set. Especially not with -Os builds.

Yep, checked again:

$ gcc --version
gcc (GCC) 4.1.2 20060928 (prerelease) (Ubuntu 4.1.1-13ubuntu5)
...
...
  gcc -Wp,-MD,arch/x86_64/kernel/.process.o.d  -nostdinc
-isystem /usr/lib/gcc/i486-linux-gnu/4.1.2/include -D__KERNEL__
-Iinclude  -include include/linux/autoconf.h -Wall -Wundef
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -O2
-mtune=generic -m64 -mno-red-zone -mcmodel=kernel -pipe
-fno-reorder-blocks -Wno-sign-compare -fno-asynchronous-unwind-tables
-funit-at-a-time -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
-maccumulate-outgoing-args   -fno-omit-frame-pointer
-fno-optimize-sibling-calls -g  -fno-stack-protector
-Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(process)"
-D"KBUILD_MODNAME=KBUILD_STR(process)" -c -o
arch/x86_64/kernel/process.o arch/x86_64/kernel/process.c
...
$ objdump -Dr arch/x86_64/kernel/process.o | less
...
     6be:       48 8b 94 00 00 00 00    mov    0x0(%rax,%rax,1),%rdx
     6c5:       00 
                        6c2: R_X86_64_32S       cpu_gdt_descr+0x2
     6c6:       48 8b 83 98 02 00 00    mov    0x298(%rbx),%rax
     6cd:       48 83 c2 60             add    $0x60,%rdx
     6d1:       48 89 02                mov    %rax,(%rdx)
     6d4:       48 8b 83 a0 02 00 00    mov    0x2a0(%rbx),%rax
     6db:       48 89 42 08             mov    %rax,0x8(%rdx)
     6df:       48 8b 83 a8 02 00 00    mov    0x2a8(%rbx),%rax
     6e6:       48 89 42 10             mov    %rax,0x10(%rdx)

If I turn on CONFIG_OPTIMIZE_FOR_SIZE, it's still unrolled,
interestingly.

Cheers,
Rusty.

