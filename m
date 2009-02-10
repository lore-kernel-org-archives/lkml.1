Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbZBJOUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbZBJOUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZBJOUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:20:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZBJOUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:20:39 -0500
Date: Tue, 10 Feb 2009 15:20:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
Message-ID: <20090210142026.GD16147@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <20090209135557.GB14785@elte.hu> <20090209141209.GA24323@elte.hu> <499186FB.4070506@kernel.org> <49918C3C.8030208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49918C3C.8030208@kernel.org>
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

> Tejun Heo wrote:
> > Ingo Molnar wrote:
> >> * Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >>> [...] I might not get around testing it today and pushing it out into tip:master, 
> >>> but i pushed out the core/percpu bits, should you queue up further changes.
> >> ok, activated it for -tip testing, and there's a 64-bit build failure caused by 
> >> it:
> >>
> >> arch/x86/kernel/head64.o: In function `x86_64_start_reservations':
> >> head64.c:(.init.text+0x26): undefined reference to `__stack_chk_guard'
> >> head64.c:(.init.text+0xc2): undefined reference to `__stack_chk_guard'
> >> arch/x86/kernel/head64.o: In function `x86_64_start_kernel':
> >> head64.c:(.init.text+0x104): undefined reference to `__stack_chk_guard'
> >> head64.c:(.init.text+0x1cd): undefined reference to `__stack_chk_guard'
> >> arch/x86/kernel/head.o: In function `reserve_ebda_region':
> >> head.c:(.init.text+0xb): undefined reference to `__stack_chk_guard'
> >> arch/x86/kernel/head.o:head.c:(.init.text+0x87): more undefined references to 
> >> `__stack_chk_guard' follow
> > 
> > Call to __stack_chk_guard is probably generated automatically.
> > Strangely, my gcc only generates calls to __stack_chk_fail.
> > 
> >  > gcc --version
> >  gcc (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291]
> >  Copyright (C) 2008 Free Software Foundation, Inc.
> >  This is free software; see the source for copying conditions.  There is NO
> >  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> >  > nm build/vmlinux|grep __stack_chk_
> >  00000000f0fdf6cb A __crc___stack_chk_fail
> >  ffffffff80d53e50 r __kcrctab___stack_chk_fail
> >  ffffffff80d5ff81 r __kstrtab___stack_chk_fail
> >  ffffffff80d3d140 r __ksymtab___stack_chk_fail
> >  ffffffff80248619 T __stack_chk_fail
> > 
> > I'll try other compilers but which version are you using?  The
> > difference is that before the patchset, -fno-stack-protector was
> > always added whether stackprotector was enabled or not so this problem
> > wasn't visible (at the cost of bogus stackprotector of course).  We'll
> > probably need to add __stack_chk_guard or disable if gcc generates
> > such symbol.  I'll play with different gccs.
> 
> Can't reproduce with gcc-4.1 or 4.2.  Any chance you're using distcc
> w/ a build machine w/ glibc < 2.4?  __stack_chk_guard is the symbol
> gcc fetches stack canary from if TLS is not supported, so somehow gcc
> thought that TLS wasn't available while building head64.

yeah - i also used distcc. Maybe the nostackp makefile magic gets confused
about that?

	Ingo
