Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXF2Oys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXF2Oys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXF2Oyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:54:40 -0400
Received: from gw.goop.org ([64.81.55.164]:53381 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbXF2Oyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:54:39 -0400
Message-ID: <46851CF3.2070608@goop.org>
Date: Fri, 29 Jun 2007 10:53:39 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] cross-architecture ELF clean up
References: <20070620230854.246399397@goop.org> <20070620230902.387008536@goop.org> <Pine.LNX.4.64.0706251531110.4386@scrub.home> <468168FD.1080200@goop.org> <Pine.LNX.4.64.0706280027100.4890@scrub.home> <4683D78E.6080309@goop.org> <Pine.LNX.4.64.0706282319350.1817@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0706282319350.1817@scrub.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
> The problem I have is that you want to separate _all_ constants, which 
> doesn't really make sense to me, because many of them are useless without 
> the correspending structures.
>   

It seems cleanest to just put all the constants in one place rather than 
scatter them around based on how they happen to be used.


>>> module.h does indeed pull in way too much, but instead of hacking headers
>>> into little pieces, IMO it would be better to solve the real problem.
>>>   
>>>       
>> No, that's not the real problem; its a side-effect of the real problem.  The
>> real problem is that linux/elf.h ends up bringing in too much.
>>     
>
> Please define the problem more specific. :)
>   

I want to be able to include a header to get just the ELF type and 
constant definitions with no other crud.  Both arch-independent ELF 
definitions, and the ones parameterised by ELF_CLASS.

I want this for three reasons:

   1. one is the general cleanup that allows people to use
      forward-declared ELF types in general kernel headers without
      needing to pull in the full set of ELF headers
   2. and to be able to pull full ELF declarations into code which can't
      deal with Linux headers, such as bootloader code which doesn't
      compile in the same universe as the rest of the kernel
   3. a way of getting arch-dependent but broadly common ELF parameters
      in a consistent way

This is complicated by the fact that each architecture needs to define 
some arch-dependent ELF structures which will end up having wider 
dependencies.  The classic example is the ELF note for core files which 
contains register and other process state, and that will naturally pull 
in a bunch of other headers to implement that.  Unfortunately, the 
current structure of the ELF headers mean that any user with the 
slightest interest in ELF structures will end up pulling in half the 
kernel headers via the asm/elf.h includes.

So my solution was to factor the ELF definitions into useful groups that 
allow the various users to pull in what they need.  The breakdown is:

    * arch-independent ELF forward declarations: linux/elf-decl.h
    * arch-independent constants: linux/elf-const.h
    * arch-independent ELF structure definitions: linux/elf-defn.h
    * arch-parameterised ELF declarations: asm/elf-defines.h

and because more or less all the architectures do the same thing for 
their parameterised ELF types (albeit inconsistently), I pulled the 
implementation into asm-generic/elf{32,64}-defines.h, and the typical 
asm/elf-defines.h ends up being a single line to include the appropriate 
one.

I'd agree that linux/elf-const.h and linux/elf-decl.h could probably be 
folded together.

>>  arch/powerpc,
>> for example, has its own stripped down copy of elf.h for bootloader stuff in
>> order to avoid this extra crud.  The fix is to make it possible to get just
>> the appropriate ELF definitions without getting everything else.
>>     
>
> The bootloader is no kernel code and thus the elf header pull in a lot 
> less:
>
> $ gcc -c foo.c -Iusr/include --trace-includes
> . usr/include/linux/elf.h
> .. usr/include/linux/types.h
> ... usr/include/linux/posix_types.h
> .... usr/include/linux/stddef.h
> .... usr/include/asm/posix_types.h
> ... usr/include/asm/types.h
> .. usr/include/linux/auxvec.h
> ... usr/include/asm/auxvec.h
> .. usr/include/linux/elf-em.h
> .. usr/include/asm/elf.h
> ... usr/include/asm/ptrace.h
> .... usr/include/asm/ptrace-abi.h
> ... usr/include/asm/user.h
> .... usr/include/asm/page.h
>
> One could remove ptrace.h but otherwise the result looks quite reasonable.
>   

Which architecture?  The variation of other includes in the various 
asm-*/elf.h headers is very broad.

On i386, it ends up being dependent on the mach-* subarch mess, which 
doesn't work in the boot code.  Since there's nothing about the ELF 
definitions which is subarch-dependent, so that's clearly a bogus 
dependency.

>> There's the secondary problem that lots of ELF stuff is copy'n'paste
>> duplicated across all the architectures, but all they really care about is one
>> of two sets of parallel definitions (32 or 64 ELF structures).  That was the
>> secondary
>>     
>
> Some of it you could put into linux/elf, e.g.:
>
> #if ELF_CLASS == ELFCLASS32
>
> typedef Elf32_Ehdr     Elf_Ehdr;
> typedef Elf32_Phdr     Elf_Phdr;
> typedef Elf32_Shdr     Elf_Shdr;
> typedef Elf32_Sym      Elf_Sym;
> typedef Elf32_Dyn      Elf_Dyn;
> typedef Elf32_Rel      Elf_Rel;
> typedef Elf32_Rela     Elf_Rela;
>
> typedef Elf32_Addr     Elf_Addr;
>
> #elif ELF_CLASS == ELFCLASS64
>
> typedef Elf64_Ehdr     Elf_Ehdr;
> typedef Elf64_Phdr     Elf_Phdr;
> typedef Elf64_Shdr     Elf_Shdr;
> typedef Elf64_Sym      Elf_Sym;
> typedef Elf64_Dyn      Elf_Dyn;
> typedef Elf64_Rel      Elf_Rel;
> typedef Elf64_Rela     Elf_Rela;
>
> typedef Elf64_Addr     Elf_Addr;
>
> #else
> #error
> #endif
>   

Yes, but it does get a bit subtle.  x86-64 does strange things with 
redefining the ELF class to compile a 32-bit binfmt_elf, and I think 
other architectures play similar games.   Rearranging these headers is 
pretty fragile, and I think my approach is a bit less likely to 
(possibly) break things.  But I haven't cross-compiled all the 
architectures, so I may have broken stuff anyway.

> The patch does help you quite a bit, you don't have to cleanup elf.h so 
> it's usable by the whole kernel. Only few parts now really need it and 
> depend on it, which makes the extensive splitup unnecessary only to 
> reduce header dependencies.
>   

Yes, but only for the module.h case.  My concerns are wider.

    J
