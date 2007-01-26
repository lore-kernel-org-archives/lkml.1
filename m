Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbXAZW71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbXAZW71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 17:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXAZW71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 17:59:27 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbXAZW7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 17:59:25 -0500
Date: Fri, 26 Jan 2007 14:59:09 -0800
From: Andrew Morton <akpm@osdl.org>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       joerg@hydrops.han.de
Subject: Re: [Bugme-new] [Bug 7891] New: vdso page is no longer mapped for
 a.out binaries in kernel 2.6.18
Message-Id: <20070126145909.4f7d1cda.akpm@osdl.org>
In-Reply-To: <200701262240.l0QMe9aG019624@fire-2.osdl.org>
References: <200701262240.l0QMe9aG019624@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(Please respond via reply-to-all, not via the bugzilla web interface)

On Fri, 26 Jan 2007 14:40:09 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7891
> 
>            Summary: vdso page is no longer mapped for a.out binaries in
>                     kernel 2.6.18
>     Kernel Version: 2.6.18 and later
>             Status: NEW
>           Severity: normal
>              Owner: process_other@kernel-bugs.osdl.org
>          Submitter: joerg@hydrops.han.de
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.17.14
> Distribution: vanilla kernel
> Hardware Environment: x86-32
> Software Environment: gentoo
> Problem Description: this is a 2.6.18 regression bug.
> 
> In kernel 2.6.18 the vdso page is no longer mapped for a.out binaries.
> For instance a program using sleep will sigsegv on delivery of SIGALRM (to be
> precise: on return from signal handling). I tested this using a static a.out
> binary. This program does work in 2.6.17 . 
> 
> cat /proc/pid/smaps does show that vdso is not mapped in 2.6.18 for an a.out
> binary. I had a look at fs/binfmt_elf.c and found that the vdso pages is mapped
> using arch_setup_additional_pages from arch/i386/kernel/sysenter.c for elf.
> 
> I did a test calling arch_setup_additional_pages from fs/binfmt_aout.c with
> positive result. 
> 
> As arch_setup_additional_pages is defined in arch/i368-asm/elf.h only, I see no
> clean way to provide a patch for fs/binfmt_aout.c. 
> 
> Steps to reproduce:
> Compile a simple program using sleep() to a.out binary and execute it. It will
> sigsegv on delivery of SIGALRM.
> 

OK, who was it this time?  Andi?

If a.out indeed needs to call arch_setup_additional_pages() then the
correct way to fix this is to rip the festering dungpile which we have now
and:

- Give i386, x86_64, powerpc and sh a new
  CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES

- Create a new include/linux/interp.h which has:

	struct linux_binprm;
	#ifdef CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES
	extern int arch_setup_additional_pages(struct linux_binprm *bprm,
                                       int executable_stack);
	#else
	static inline int arch_setup_additional_pages(struct linux_binprm *bprm,
                                       int executable_stack)
	{
		return 0;
	}
	#endif

- include <linux/interp.h> from binfmt_elf.c and binfmt_aout.c and from
  all the files which implement arch_setup_additional_pages().  

- Remove the #ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES from binfmt_elf.c

- Add the call to arch_setup_additional_pages() in binfmt_aout.h.


