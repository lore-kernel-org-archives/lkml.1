Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbXF1Vsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbXF1Vsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761166AbXF1VsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:48:23 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4049 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762154AbXF1VsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:48:21 -0400
Date: Thu, 28 Jun 2007 23:48:28 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] cross-architecture ELF clean up
In-Reply-To: <4683D78E.6080309@goop.org>
Message-ID: <Pine.LNX.4.64.0706282319350.1817@scrub.home>
References: <20070620230854.246399397@goop.org> <20070620230902.387008536@goop.org>
 <Pine.LNX.4.64.0706251531110.4386@scrub.home> <468168FD.1080200@goop.org>
 <Pine.LNX.4.64.0706280027100.4890@scrub.home> <4683D78E.6080309@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 28 Jun 2007, Jeremy Fitzhardinge wrote:

> Roman Zippel wrote:
> > This could be avoided by reordering things within elf.h, but is it really
> > necessary since there is no user of this right now?
> >   
> 
> Well, yes, I don't have much need to include ELF headers in asm now, but I
> still think its worth separating the arch-specific definitions from asm/elf.h
> and all the other stuff they pull in.  Specifically, the structure forward
> declarations and constants have very few external dependencies, but the
> structure definitions - particularly the arch-specific ones - have very wide
> dependencies, which is what I'm trying to solve.  Very few pieces of code care
> about the arch-specific structures.

The problem I have is that you want to separate _all_ constants, which 
doesn't really make sense to me, because many of them are useless without 
the correspending structures.

> > module.h does indeed pull in way too much, but instead of hacking headers
> > into little pieces, IMO it would be better to solve the real problem.
> >   
> 
> No, that's not the real problem; its a side-effect of the real problem.  The
> real problem is that linux/elf.h ends up bringing in too much.

Please define the problem more specific. :)

>  arch/powerpc,
> for example, has its own stripped down copy of elf.h for bootloader stuff in
> order to avoid this extra crud.  The fix is to make it possible to get just
> the appropriate ELF definitions without getting everything else.

The bootloader is no kernel code and thus the elf header pull in a lot 
less:

$ gcc -c foo.c -Iusr/include --trace-includes
. usr/include/linux/elf.h
.. usr/include/linux/types.h
... usr/include/linux/posix_types.h
.... usr/include/linux/stddef.h
.... usr/include/asm/posix_types.h
... usr/include/asm/types.h
.. usr/include/linux/auxvec.h
... usr/include/asm/auxvec.h
.. usr/include/linux/elf-em.h
.. usr/include/asm/elf.h
... usr/include/asm/ptrace.h
.... usr/include/asm/ptrace-abi.h
... usr/include/asm/user.h
.... usr/include/asm/page.h

One could remove ptrace.h but otherwise the result looks quite reasonable.

> There's the secondary problem that lots of ELF stuff is copy'n'paste
> duplicated across all the architectures, but all they really care about is one
> of two sets of parallel definitions (32 or 64 ELF structures).  That was the
> secondary

Some of it you could put into linux/elf, e.g.:

#if ELF_CLASS == ELFCLASS32

typedef Elf32_Ehdr     Elf_Ehdr;
typedef Elf32_Phdr     Elf_Phdr;
typedef Elf32_Shdr     Elf_Shdr;
typedef Elf32_Sym      Elf_Sym;
typedef Elf32_Dyn      Elf_Dyn;
typedef Elf32_Rel      Elf_Rel;
typedef Elf32_Rela     Elf_Rela;

typedef Elf32_Addr     Elf_Addr;

#elif ELF_CLASS == ELFCLASS64

typedef Elf64_Ehdr     Elf_Ehdr;
typedef Elf64_Phdr     Elf_Phdr;
typedef Elf64_Shdr     Elf_Shdr;
typedef Elf64_Sym      Elf_Sym;
typedef Elf64_Dyn      Elf_Dyn;
typedef Elf64_Rel      Elf_Rel;
typedef Elf64_Rela     Elf_Rela;

typedef Elf64_Addr     Elf_Addr;

#else
#error
#endif

> > I played with it a little and the patch below moves a lot stuff out of
> > module.h, so this would drastically reduce the header dependencies.
> > Unless there are major objections, I can test the patch a little more and
> > convert the other archs.
> >   
> 
> Well, it seems like a large fiddly patch which only solves part of the problem
> I want to solve; actually it doesn't help me at all, but it achieves one of
> the side-effects of my patch. The arch changes make it look pretty awkward to
> merge.

The patch does help you quite a bit, you don't have to cleanup elf.h so 
it's usable by the whole kernel. Only few parts now really need it and 
depend on it, which makes the extensive splitup unnecessary only to 
reduce header dependencies.

bye, Roman
