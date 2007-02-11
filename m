Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXBKNX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXBKNX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 08:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932821AbXBKNX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 08:23:58 -0500
Received: from web26901.mail.ukl.yahoo.com ([217.146.176.90]:44226 "HELO
	web26901.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932078AbXBKNX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 08:23:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=f5Cp63RL0DST3ZOL3tj2fYXC7idLe6z1SoxLOam7FwpIHabY4Qi26bpy6ynJgsl0d5N0GbJ0Jn4tAvXeQrMM7FVFHOjU1C9n49yd2Qq8GC4cDFWvbKuTrOj84QiwpZJP9D/kdkqHCNjLj1C1PHFtSkIkp89m7etZrb3wtTAQX6U=;
X-YMail-OSG: uHKLc3gVM1n4O21qiaMrtBU2NKs5voMlhPKzBpaT1d43PaUwW3A672WKHFHXO7W0cE4fjHZrHFyK31V38B8JkYSWKzPL6_iP5Bv869GHU87yW3sFNN5csEmWRZgaEhCL0pLw_AdqVwj_1sXqUi4EzzKJ2gwZZ3bZiv_F1gEUYzbI19nC6ZQO2w--
Date: Sun, 11 Feb 2007 14:23:55 +0100 (CET)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: RE : Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1ps8j3yo9.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <415752.45429.qm@web26901.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Etienne Lorrain writes:
> >   Well, a self relocating image cannot be an ELF file because the code
> >  to relocate the ELF cannot be executed at the wrong place.
> >  If relocation is needed, I would better like not to link vmlinux at a
> >  fixed address first. In fact I wonder if we are talking of the same
> >  kind of relocation: you seem to talk about "ld --pic-executable" while
> >  I am thinking of "ld -r" to "locate" it at the bootloader loading time.
> >   The main problem I see is that I do not have the code for that, and
> >  I am going deeper/earlier into the generation of vmlinux, while comments
> >  are "already you are too early, loading an ELF file is too complex for
> >  a bootloader". The solution I have already is working.
> 
> Being very clear.  ld --pic-executable or ld -shared is essentially
> what we are talking when we are discussing building a relocatable
> kernel.  Something with the properties of an ELF ET_DYN executable
> that does not use an interpreter.  ld.so is the only common executable
> of this type in linux.

 So we are talking of two different things.
 You want to _compile_ the totality of the kernel as code and data
relocatable - right now only modules are compiled that way.
 On IA32 architecture, there is no problem having the code relocatable,
because most/all calls and jumps are PC relative, so very few instructions
need to be different.
 The problem is having the data relocatable, then every access to memory
has to be relative to a register, and so the register EBX is reserved
for that by the compiler.
 The IA32 processor does not have enough registers already, removing one
of them makes the assembly seriously worse - mostly when dealing with
64 bits "long long" - you can only get two of them in register and a
simple addition produces long and slow code.
 Having the data relocatable could be done by using the base address of
IA32 segments, but this does not seem to be the preferred method because
segments use seems to slow down the processor a lot more.

 What I was talking of was "loading" a non relocatable kernel (compiled
as usual without -fPIC/-shared) at any address, so not inducing slow
down whatever the base address used. I said that it is possible, maybe
quite easy to do so, but I do not have the code for it - and people
say right now that an ELF bootloader is not what they want to.

 Now, if people wants to switch to a completely relocatable kernel,
because they do not mind the slow down (that I am not really able
to quantify) - and because anyway most of their kernel is modules,
then Gujin can relocate that without _any_ problem; in fact it
does already load in intermediate (HIMEM malloc'ed) memory under
DOS to relocate it later (called 'late relocation' in Gujin code,
done every times the code is not at the right address in memory,
interrupt disabled and in protected mode).
 Loading and executing at whatever address is not a problem,
and should be doable already in the real-mode function of the
kernel called by Gujin, by modifying few elements of the
structure passed in parameter of this real-mode function:
it should be done after loading the E820 memory map for the
BIOS parameter page.
I am reading right now Gujin source and note that you may want
to access array elf_reloc[] and variable nb_elf_reloc in this
Linux function - will be added in next Gujin version.
 You already can access type LOADER_str parameter "loader"
where you can get runadr which can overwrite the ELF entry
point address. The old ELF header is at loader.load_address
if it is needed.

 The main problem Gujin has, is to decide where to load a
relocatable kernel, so this policy is left to the kernel and
not to the user. For instance and as you made me think of, if you
do not want for security reasons that the kernel memory could
be modified by an attacker by using the legacy DMA, then you
want to load it at an address which cannot be modified this way,
i.e. over 16 Mbytes. Note that some chipset had an extension I/O
address to extend this legacy DMA to 32 bits addresses, but it
has not been documented and probably not implemented widely.

 I do not know how many people are like me, but I am currently
typing on a monolitic kernel because I find it a _lot_ simpler
to do a ".config" once and make it slowly evolve with new kernel
versions (answering No to most of the questions), than managing
hundreds of module files each time I regenerate/remove a kernel.
 The kernel I am working on is not relocatable because - well
I do not have crash to debug...

 So I think that from the Gujin point of view, everything you need
is done and working (but the access to elf_reloc)- please explain what
you want more if not. If you want a solution to load now, you can
use patch linux-2.6.20-rc5 in sourceforge, which uses an intermediate
binary dump of the ELF file, and can be relocated the non ELF way.

> >  In fact, thinking more about that, I am going back to my implementation
> >  of it, because on ia32 the interrupt vectors are at address zero and it is
> >  obviouly an invalid address to load an ELF for this architecture.
> 
> No special games no special rules with the well defined ELF components
> either add a note that you can define all of the semantics yourself
> or don't do it.  That is what the notes are there for.

 So, why do I want an ELF file loaded by a bootloader?
 The main reason is to be able to use all the usual ELF tools to do
all sort of things, like showing segments size and base address with
"objdump" and "readelf", adding and extracting sections with "strip"
and "objcopy", and dumping section content with either "objdump -m i8086"
or "objdump" alone to display the assembly instructions after link,
for real-mode or protected-mode, with symbols.
 For all that, I need a 100% compatible ELF file structure - that is
what I have already.
 I do _not_ need to use the Linux loader at the prompt of a Xterm for
this file, if I try I have this very informative error message:
[etienne@localhost linux-2.6.20]$ ./vmlinux.elf 
Killed
[etienne@localhost linux-2.6.20]$ 
 I know that to load this ELF kernel file the user will need a different
loader like Gujin or your kexec. I know that I am asking you not to treat
an impossible action (loading a section at address 0 over the interrupt
table), and I say please.

> >  But for the linker, it is the right address to link it (being an offset
> >  into a non-null segment in real mode), and because the entry point has
> >  to be zero (I cannot use the ELF entry value) the program header base
> >  address has to be zero.
> 
> Agreed. When the object file is linked using offset 0, and letting the
> real mode segments do have different bases to do your relocation is fine.

 Nice to agree.

> We have been very sparse on the usage of ELF notes but yes they exist
> and yes people do look at them.  Please dig up a copy of the ELF spec
> and read up on them or look at etherboot for an example.

 I've read it again from cover to cover, version 1.2, pretty boring
 stuff, isn't it?
 So technically - and if I understand you correctly (feel free to correct
 me) - you ask me to put the real mode code into the NOTE section, by
 adding a few words header and concatening the code.

 There is two way to do so, the first being simply to replace in
vmlinux.lds.S (in the patch I sent) the lines:
  .realmode 0 : AT (ADDR(.bss) + SIZEOF(.bss) - LOAD_OFFSET) {
  ..... *(.init.text16) ...
  } :text16 = 0x9090
by something like:
  .realmode 0 : AT (ADDR(.bss) + SIZEOF(.bss) - LOAD_OFFSET) {
  LONG(8)
  LONG(SIZEOF (.realmode))
  LONG(1)
  BYTE('R') BYTE('E') BYTE('A') BYTE('L')
  BYTE('M') BYTE('O') BYTE('D') BYTE('E')
  ..... *(.init.text16) ...
  } :note = 0x9090
That has the main advantage to keep producing a single link, but the
major disadvantage that this code is no more linked at 0 but offseted
by the header of 5 longs, the call to the function has to be offseted,
and it may not work nicely when another developper comes in few years
and add another few Kbytes note - everything will work if his note
is added after mine but break badly if it is added before mine.
 The order it is processed is under the linker control, and anybody
could add a note in C by declaring a structure in the .note section.
 You will probably agree with me that it is not an acceptable solution.

 The other way to do is to produce an independant link for the real-mode
program (linked at base address 0), convert it to binary and include
the resulting block into the NOTE segment. First that is a lot more
complex (it can be done but is more complex), and two I loose all
the debuging information I wanted in the ELF file.
 I can still see the real-mode assembly by forcing objdump to interpret
the NOTE section as real-mode code, but the offset calculated for
assembly calls and jumps is wrong, I lost all symbols, in short it
goes against what I wanted initially.

  Thanks,
  Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
