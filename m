Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbXKFVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbXKFVrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXKFVrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:47:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbXKFVrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:47:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4730D713.7060406@l4x.org>
References: <4730D713.7060406@l4x.org> <472B9479.7040105@l4x.org> <15675.1193753820@redhat.com> <4726337B.1080608@l4x.org> <4725B553.4060502@l4x.org> <4220.1193663179@redhat.com> <15712.1193753924@redhat.com> <27945.1194278666@redhat.com>
To: Jan Dittmer <jdi@l4x.org>
Cc: dhowells@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Working frv toolchain?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 06 Nov 2007 21:47:15 +0000
Message-ID: <3834.1194385635@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Dittmer <jdi@l4x.org> wrote:

> > Can you try the attached patch?
> 
> Thanks, that fixes the error in question.

Excellent.  I'll post it on upstream.

> Are there any chances to get a patch for frv support against
> some upstream gcc 4.x version?

Do you mean a patch to gcc?  Apparently gcc 4.3 should be fine, but I haven't
been able to build a toolchain that includes it.  I'm currently stuck on
trying to get through the glibc build phase.


> Now I have only a couple of scary looking warnings (see below, sorry for the
> word-wrap).
> ...
> frv-linux-gnu-ld: Warning: size of symbol `sys_set_robust_list' changed from 8
> in kernel/sys_ni.o to 32 in kernel/futex.o

Yeah.  Dunno what to do about that.  I suspect I need to do something about
cond_syscall(), but I'm not sure what.

> WARNING: vmlinux.o(.text+0x40): Section mismatch: reference to
> .init.text:free_initmem (between 'init_post' and 'try_name')

It's entirely possible that free_initmem() should not itself be marked __init.

> WARNING: vmlinux.o(.text+0x54fc): Section mismatch: reference to
> .init.text:start_kernel (between 'debug_stub' and 'debug_stub_exit')
> WARNING: vmlinux.o(.text+0x5500): Section mismatch: reference to
> .init.text:start_kernel (between 'debug_stub' and 'debug_stub_exit')

debug_stub() needs to arrange for start_kernel() to be invoked on its first
entry, but can't itself be __init because it gets invoked on every debugging
event (single step, h/w breakpoints, break instruction, etc).  However, its
first call is right at the end of head.S, so it isn't actually a problem.

Note that it isn't possible to jump directly into the debugger.  You have to
take an debug-level exception to enter CPU debug mode - which is a level higher
than kernel mode.

> WARNING: vmlinux.o(.text+0xf7b48): Section mismatch: reference to
> .init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and
> 'pci_scan_bridge')

Hmmm... pci_scan_child_bus() is not __*init, but it calls pcibios_fixup_bus()
which is.  That smells a trifle fishy.

David
