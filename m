Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYGQHLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYGQHLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYGQHLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:11:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbYGQHLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:11:11 -0400
Date: Thu, 17 Jul 2008 00:09:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: benh@kernel.crashing.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       Nathan Lynch <ntl@pobox.com>
Subject: Re: [PATCH] elf loader support for auxvec base platform string
Message-Id: <20080717000951.5f8cab37.akpm@linux-foundation.org>
In-Reply-To: <1216276539.7740.309.camel@pasglop>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
	<1216166331-14810-2-git-send-email-ntl@pobox.com>
	<1216276539.7740.309.camel@pasglop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 16:35:39 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> Hi Linus, Andrew !
> 
> Should I seek somebody's ack before merging a patch like the one below ?

I think it's good to do so.

> I'm a bit reluctant to merge via the powerpc.git tree some changes to
> generic files without at least an ack from somebody else :-)

It tends to happen.  People often don't notice unless it a) crashes or
b) spits warnings or c) screws up my tree or d) all the above plus
more.

> There have been some debate on whether this AT_BASE_PLATFORM is the
> right approach, though I haven't seen them reach any useful conclusion
> and our toolchain people internally are screaming for it...
> 
> Cheers,
> Ben.
> 
> On Tue, 2008-07-15 at 18:58 -0500, Nathan Lynch wrote:
> > Some IBM POWER-based platforms have the ability to run in a
> > mode which mostly appears to the OS as a different processor from the
> > actual hardware.  For example, a Power6 system may appear to be a
> > Power5+, which makes the AT_PLATFORM value "power5+".  This means that
> > programs are restricted to the ISA supported by Power5+;
> > Power6-specific instructions are treated as illegal.
> > 
> > However, some applications (virtual machines, optimized libraries) can
> > benefit from knowledge of the underlying CPU model.  A new aux vector
> > entry, AT_BASE_PLATFORM, will denote the actual hardware.  For
> > example, on a Power6 system in Power5+ compatibility mode, AT_PLATFORM
> > will be "power5+" and AT_BASE_PLATFORM will be "power6".  The idea is
> > that AT_PLATFORM indicates the instruction set supported, while
> > AT_BASE_PLATFORM indicates the underlying microarchitecture.
> > 
> > If the architecture has defined ELF_BASE_PLATFORM, copy that value to
> > the user stack in the same manner as ELF_PLATFORM.
> > 
> > Signed-off-by: Nathan Lynch <ntl@pobox.com>
> > ---
> >  fs/binfmt_elf.c        |   23 +++++++++++++++++++++++
> >  include/linux/auxvec.h |    5 ++++-
> >  2 files changed, 27 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index d48ff5f..834c2c4 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -131,6 +131,10 @@ static int padzero(unsigned long elf_bss)
> >  #define STACK_ALLOC(sp, len) ({ sp -= len ; sp; })
> >  #endif
> >  
> > +#ifndef ELF_BASE_PLATFORM
> > +#define ELF_BASE_PLATFORM NULL
> > +#endif

Please add a comment which explains what this is.

Please also add a comment telling the world in which header file the
architecture *must* define this macro and then ensure that that header is
included into this file by reliable means.  asm/elf.h looks OK.

> >  static int
> >  create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
> >  		unsigned long load_addr, unsigned long interp_load_addr)
> > @@ -142,7 +146,9 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
> >  	elf_addr_t __user *envp;
> >  	elf_addr_t __user *sp;
> >  	elf_addr_t __user *u_platform;
> > +	elf_addr_t __user *u_base_platform;
> >  	const char *k_platform = ELF_PLATFORM;
> > +	const char *k_base_platform = ELF_BASE_PLATFORM;
> >  	int items;
> >  	elf_addr_t *elf_info;
> >  	int ei_index = 0;
> > @@ -172,6 +178,19 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
> >  			return -EFAULT;
> >  	}
> >  
> > +	/*
> > +	 * If this architecture has a "base" platform capability
> > +	 * string, copy it to userspace.
> > +	 */
> > +	u_base_platform = NULL;
> > +	if (k_base_platform) {
> > +		size_t len = strlen(k_base_platform) + 1;
> > +
> > +		u_base_platform = (elf_addr_t __user *)STACK_ALLOC(p, len);
> > +		if (__copy_to_user(u_base_platform, k_base_platform, len))
> > +			return -EFAULT;
> > +	}

>From my reading, this change will result in no additional code
generation on non-powerpc architectures.  This is good.  If poss, could
you please verify that theory and perhaps drop a note in the changelog
about that?


Apart from that - acked-by-me
