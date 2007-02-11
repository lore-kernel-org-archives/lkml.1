Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXBKUuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXBKUuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 15:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932118AbXBKUuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 15:50:15 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43895 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbXBKUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 15:50:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: RE : Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <415752.45429.qm@web26901.mail.ukl.yahoo.com>
Date: Sun, 11 Feb 2007 13:49:57 -0700
In-Reply-To: <415752.45429.qm@web26901.mail.ukl.yahoo.com> (Etienne Lorrain's
	message of "Sun, 11 Feb 2007 14:23:55 +0100 (CET)")
Message-ID: <m1odo0zafe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:

> Eric W. Biederman wrote:
>> Etienne Lorrain writes:
>> >   Well, a self relocating image cannot be an ELF file because the code
>> >  to relocate the ELF cannot be executed at the wrong place.
>> >  If relocation is needed, I would better like not to link vmlinux at a
>> >  fixed address first. In fact I wonder if we are talking of the same
>> >  kind of relocation: you seem to talk about "ld --pic-executable" while
>> >  I am thinking of "ld -r" to "locate" it at the bootloader loading time.
>> >   The main problem I see is that I do not have the code for that, and
>> >  I am going deeper/earlier into the generation of vmlinux, while comments
>> >  are "already you are too early, loading an ELF file is too complex for
>> >  a bootloader". The solution I have already is working.
>> 
>> Being very clear.  ld --pic-executable or ld -shared is essentially
>> what we are talking when we are discussing building a relocatable
>> kernel.  Something with the properties of an ELF ET_DYN executable
>> that does not use an interpreter.  ld.so is the only common executable
>> of this type in linux.
>
>  So we are talking of two different things.
>  You want to _compile_ the totality of the kernel as code and data
> relocatable - right now only modules are compiled that way.
>  On IA32 architecture, there is no problem having the code relocatable,
> because most/all calls and jumps are PC relative, so very few instructions
> need to be different.
>  The problem is having the data relocatable, then every access to memory
> has to be relative to a register, and so the register EBX is reserved
> for that by the compiler.
>  The IA32 processor does not have enough registers already, removing one
> of them makes the assembly seriously worse - mostly when dealing with
> 64 bits "long long" - you can only get two of them in register and a
> simple addition produces long and slow code.
>  Having the data relocatable could be done by using the base address of
> IA32 segments, but this does not seem to be the preferred method because
> segments use seems to slow down the processor a lot more.

There are two more options in addition to segments:
- Running at a fixed virtual address.
- Processing relocation entries to modify the initial code/data to
  live where we want.  We don't have the that shared libraries do of wanting
  to share text/data pages loaded at different addresses.

>  What I was talking of was "loading" a non relocatable kernel (compiled
> as usual without -fPIC/-shared) at any address, so not inducing slow
> down whatever the base address used. I said that it is possible, maybe
> quite easy to do so, but I do not have the code for it - and people
> say right now that an ELF bootloader is not what they want to.

The thing to pick up on is that we really don't want the gcc flag
-fPIC but if ld wasn't an idiot we would want the linker flag -shared.
Anyway we have working code merged that processes all of the
relocation entries and modifies the kernel to run properly where we
load it at.  This has all been done and merged at this point.  It's
only available to a bzImage loader but it is all there.  Currently the
only overhead is something like 5 or 10 percent overhead to hold the
relocation entries.

The only thing currently compiled with -fPIC is the kernel gzip
decompressor and it is carefully coded so it doesn't generate any
relocation entries that need processing.  It is just throw away code
so we don't much care about it's efficiency.

>  Now, if people wants to switch to a completely relocatable kernel,
> because they do not mind the slow down (that I am not really able
> to quantify) - and because anyway most of their kernel is modules,
> then Gujin can relocate that without _any_ problem; in fact it
> does already load in intermediate (HIMEM malloc'ed) memory under
> DOS to relocate it later (called 'late relocation' in Gujin code,
> done every times the code is not at the right address in memory,
> interrupt disabled and in protected mode).

Yes.  That is roughly what we are saying.  We want that at least
as a well defined option.

>  Loading and executing at whatever address is not a problem,
> and should be doable already in the real-mode function of the
> kernel called by Gujin, by modifying few elements of the
> structure passed in parameter of this real-mode function:
> it should be done after loading the E820 memory map for the
> BIOS parameter page.
> I am reading right now Gujin source and note that you may want
> to access array elf_reloc[] and variable nb_elf_reloc in this
> Linux function - will be added in next Gujin version.
>  You already can access type LOADER_str parameter "loader"
> where you can get runadr which can overwrite the ELF entry
> point address. The old ELF header is at loader.load_address
> if it is needed.
>
>  The main problem Gujin has, is to decide where to load a
> relocatable kernel, so this policy is left to the kernel and
> not to the user. For instance and as you made me think of, if you
> do not want for security reasons that the kernel memory could
> be modified by an attacker by using the legacy DMA, then you
> want to load it at an address which cannot be modified this way,
> i.e. over 16 Mbytes. Note that some chipset had an extension I/O
> address to extend this legacy DMA to 32 bits addresses, but it
> has not been documented and probably not implemented widely.
>
>  I do not know how many people are like me, but I am currently
> typing on a monolitic kernel because I find it a _lot_ simpler
> to do a ".config" once and make it slowly evolve with new kernel
> versions (answering No to most of the questions), than managing
> hundreds of module files each time I regenerate/remove a kernel.
>  The kernel I am working on is not relocatable because - well
> I do not have crash to debug...

Yes.   In this sense I'm a tool builder.  I build general capabilities
that can be used to solve specific problems.  A relocatable kernel
is a general capability and the only interesting problem to date
has been taking crash dumps.  To reduce the maintenance overhead I
try and remove the cases where you need an extra config option for
the new functionality.  If there is not overhead a config option just
makes things harder to test.

>  So I think that from the Gujin point of view, everything you need
> is done and working (but the access to elf_reloc)- please explain what
> you want more if not. If you want a solution to load now, you can
> use patch linux-2.6.20-rc5 in sourceforge, which uses an intermediate
> binary dump of the ELF file, and can be relocated the non ELF way.

This requires a more detailed examination.  The previous conversation
indicated that if we could replace setup.S, video.S and edd.S with
C versions it would be very interesting.  If we happen to change the
link so they are available in an ELF executable so much the better.

If we wind up adding two versions of the real mode code one written
in assembly and one written in C accessible by different means
by different bootloaders that is not interesting.

>  So, why do I want an ELF file loaded by a bootloader?

>  The main reason is to be able to use all the usual ELF tools to do
> all sort of things, like showing segments size and base address with
> "objdump" and "readelf", adding and extracting sections with "strip"
> and "objcopy", and dumping section content with either "objdump -m i8086"
> or "objdump" alone to display the assembly instructions after link,
> for real-mode or protected-mode, with symbols.
>  For all that, I need a 100% compatible ELF file structure - that is
> what I have already.

Yes.  That is nice. 

>  I know that to load this ELF kernel file the user will need a different
> loader like Gujin or your kexec. I know that I am asking you not to treat
> an impossible action (loading a section at address 0 over the interrupt
> table), and I say please.

It is my belief that we can solve this without hacks, and still have
a useable structure.

[snip]
>  So technically - and if I understand you correctly (feel free to correct
>  me) - you ask me to put the real mode code into the NOTE section, by
>  adding a few words header and concatening the code.
>
>  There is two way to do so, the first being simply to replace in
> vmlinux.lds.S (in the patch I sent) the lines:
>   .realmode 0 : AT (ADDR(.bss) + SIZEOF(.bss) - LOAD_OFFSET) {
>   ..... *(.init.text16) ...
>   } :text16 = 0x9090
> by something like:
>   .realmode 0 : AT (ADDR(.bss) + SIZEOF(.bss) - LOAD_OFFSET) {
>   LONG(8)
>   LONG(SIZEOF (.realmode))
>   LONG(1)
>   BYTE('R') BYTE('E') BYTE('A') BYTE('L')
>   BYTE('M') BYTE('O') BYTE('D') BYTE('E')
>   ..... *(.init.text16) ...
>   } :note = 0x9090

That would certainly get the job done.

>  The other way to do is to produce an independant link for the real-mode
> program (linked at base address 0), convert it to binary and include
> the resulting block into the NOTE segment. First that is a lot more
> complex (it can be done but is more complex), and two I loose all
> the debuging information I wanted in the ELF file.
>  I can still see the real-mode assembly by forcing objdump to interpret
> the NOTE section as real-mode code, but the offset calculated for
> assembly calls and jumps is wrong, I lost all symbols, in short it
> goes against what I wanted initially.

So I really don't care if we move whole real mode section into a note
or if we just put a pointer to it into a note.  What is important is
that we use a note to find it.

Which means that we could do something goofy in the linker script
like we do with the current vdso.  So we could give it a virtual
address of 0 and a physical address in the init code section.
Allowing us to load it normally and then just drop it later.  Not
perfect but something that would not need special treatment by
a bootloader unless it wanted to copy the data from there into
some location in low memory and execute it.

For me the objective is not so much reusing the existing tools
(although that is a plus) but more to be able to build a unified
binary that can be used for everything, and will give us the freedom
to do interesting things with the kernel in the future, and hopefully
something that is more or less usable by portable bootloaders.  Having
a different file format and different rules for different
architectures is a pain.

Eric
