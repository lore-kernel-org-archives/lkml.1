Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZBJOTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZBJOTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZBJOTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:19:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34182 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZBJOTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:19:30 -0500
Date: Tue, 10 Feb 2009 15:19:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
Message-ID: <20090210141917.GC16147@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <20090209135557.GB14785@elte.hu> <20090209141209.GA24323@elte.hu> <499186FB.4070506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499186FB.4070506@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >> [...] I might not get around testing it today and pushing it out into tip:master, 
> >> but i pushed out the core/percpu bits, should you queue up further changes.
> > 
> > ok, activated it for -tip testing, and there's a 64-bit build failure caused by 
> > it:
> > 
> > arch/x86/kernel/head64.o: In function `x86_64_start_reservations':
> > head64.c:(.init.text+0x26): undefined reference to `__stack_chk_guard'
> > head64.c:(.init.text+0xc2): undefined reference to `__stack_chk_guard'
> > arch/x86/kernel/head64.o: In function `x86_64_start_kernel':
> > head64.c:(.init.text+0x104): undefined reference to `__stack_chk_guard'
> > head64.c:(.init.text+0x1cd): undefined reference to `__stack_chk_guard'
> > arch/x86/kernel/head.o: In function `reserve_ebda_region':
> > head.c:(.init.text+0xb): undefined reference to `__stack_chk_guard'
> > arch/x86/kernel/head.o:head.c:(.init.text+0x87): more undefined references to 
> > `__stack_chk_guard' follow
> 
> Call to __stack_chk_guard is probably generated automatically.
> Strangely, my gcc only generates calls to __stack_chk_fail.
> 
>  > gcc --version
>  gcc (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291]
>  Copyright (C) 2008 Free Software Foundation, Inc.
>  This is free software; see the source for copying conditions.  There is NO
>  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>  > nm build/vmlinux|grep __stack_chk_
>  00000000f0fdf6cb A __crc___stack_chk_fail
>  ffffffff80d53e50 r __kcrctab___stack_chk_fail
>  ffffffff80d5ff81 r __kstrtab___stack_chk_fail
>  ffffffff80d3d140 r __ksymtab___stack_chk_fail
>  ffffffff80248619 T __stack_chk_fail
> 
> I'll try other compilers but which version are you using?  The
> difference is that before the patchset, -fno-stack-protector was
> always added whether stackprotector was enabled or not so this problem
> wasn't visible (at the cost of bogus stackprotector of course).  We'll
> probably need to add __stack_chk_guard or disable if gcc generates
> such symbol.  I'll play with different gccs.

that was with a crosscompiler:

aldebaran:~> /opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-gcc -v
Using built-in specs.
Target: x86_64-unknown-linux-gnu
Configured with: 
/home/mingo/s/crosstool-0.43/build/x86_64-unknown-linux-gnu/gcc-4.2.3-glibc-2.3.6/gcc-4.2.3/configure 
--target=x86_64-unknown-linux-gnu --host=i686-host_pc-linux-gnu 
--prefix=/opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu 
--disable-multilib 
--with-sysroot=/opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/x86_64-unknown-linux-gnu/sys-root 
--with-local-prefix=/opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/x86_64-unknown-linux-gnu/sys-root 
--disable-nls --enable-threads=posix --enable-symvers=gnu --enable-__cxa_atexit 
--enable-languages=c --enable-shared --enable-c99 --enable-long-long
Thread model: posix
gcc version 4.2.3

The problem is i think GCC's brain-dead stackprotector support - having different 
models for user-space and kernel-space stackprotector. So this compiler is not 
_able_ to actually build a stackprotector kernel - but we should auto-discover that.

	Ingo
