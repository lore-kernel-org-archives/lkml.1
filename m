Return-Path: <linux-kernel-owner+w=401wt.eu-S2992776AbXBITm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992776AbXBITm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992779AbXBITm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:42:56 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34789 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992776AbXBITmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:42:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <20070209130425.63252.qmail@web26912.mail.ukl.yahoo.com>
Date: Fri, 09 Feb 2007 12:42:46 -0700
In-Reply-To: <20070209130425.63252.qmail@web26912.mail.ukl.yahoo.com> (Etienne
	Lorrain's message of "Fri, 9 Feb 2007 14:04:25 +0100 (CET)")
Message-ID: <m1ps8j3yo9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:

>   Well, a self relocating image cannot be an ELF file because the code
>  to relocate the ELF cannot be executed at the wrong place.
>  If relocation is needed, I would better like not to link vmlinux at a
>  fixed address first. In fact I wonder if we are talking of the same
>  kind of relocation: you seem to talk about "ld --pic-executable" while
>  I am thinking of "ld -r" to "locate" it at the bootloader loading time.
>   The main problem I see is that I do not have the code for that, and
>  I am going deeper/earlier into the generation of vmlinux, while comments
>  are "already you are too early, loading an ELF file is too complex for
>  a bootloader". The solution I have already is working.

Being very clear.  ld --pic-executable or ld -shared is essentially
what we are talking when we are discussing building a relocatable
kernel.  Something with the properties of an ELF ET_DYN executable
that does not use an interpreter.  ld.so is the only common executable
of this type in linux.

Loading an ELF executable is very much:
- Walk through the program headers and for each PT_LOAD segment load
  it at the address it requests.
- Jump to e_entry from the ELF header.

If you are working with a relocatable ELF object the rules become:
- Walk through the program header once to find the size and alignment
  of the chunk of memory that the linux kernel needs.
- Find a hole in the memory map that meets those requirements.
- Compute the offset 
- Walk through the program headers and for each PT_LOAD segment
  add offset to the addresses and load the segment like normal.
- Jump to offset + e_entry.

This is within the scope of what a bootloader can reasonably do, and
I have implemented it in etherboot as well as /sbin/kexec. 

>> > If you cannot get a PT_LOAD
>> > section, maybe we can put a simple system in NOTE, or just create a
>> > PT_LOAD16 if the linker accepts other values.
>> 
>> My guess is that PT_LOAD16 is not an acceptable value. Putting information
>> in PT_NOTE seems interesting (As Eric already mentioned).
>
>  In fact, thinking more about that, I am going back to my implementation
>  of it, because on ia32 the interrupt vectors are at address zero and it is
>  obviouly an invalid address to load an ELF for this architecture.

No special games no special rules with the well defined ELF components
either add a note that you can define all of the semantics yourself
or don't do it.  That is what the notes are there for.

>  But for the linker, it is the right address to link it (being an offset
>  into a non-null segment in real mode), and because the entry point has
>  to be zero (I cannot use the ELF entry value) the program header base
>  address has to be zero.

Agreed. When the object file is linked using offset 0, and letting the
real mode segments do have different bases to do your relocation is fine.

>  Anyway, your loader in (probably) written in C, so a test against zero
>  is a simple thing to do, and should be done anyway to check for an
>  incorrect ELF program header. I wonder if this NOTE program header is
>  not simply designed as an "end" marker, it does not seem to contain
>  anything, so me defining the realmode after that program header may
>  be a good idea.

We have been very sparse on the usage of ELF notes but yes they exist
and yes people do look at them.  Please dig up a copy of the ELF spec
and read up on them or look at etherboot for an example.

>  If you really are tring to catch an erroneous DMA into the kernel,
>  is it better to keep an exact copy of the kernel you are using somewhere
>  else to do a bit-to-bit comparisson after the crash, and so no relocate.
>  Anyway if the DMA crash has crashed the exception handling area the system
>  is dead anyway.

No.  We are not trying to catch a erroneous DMA in that sense.  We
do not shutdown any drivers when switching to the new kernel from
panic(), because we don't know what is broken.   Any single bit
of kernel code of could cause problems not just the exception table.
Running in an area that we have never used for DMA and is completely
reserved gives us freedom to not worry about it.  I.e. This is not
error detection but future error prevention and it works.

Before starting the new kernel we do a sha256 checksum test on the
new kernel and on our code that is running the checksum.  All of which
comes from /sbin/kexec.  Not compiled into the running kernel.  The
policy is in user space.

>> Interesting question, How does a boot loader/user decide where to load
>> the relocatable image? I think it depends on the new interesting usages
>> of the relocatable kernel. As of today, kexec knows where is reserved
>> memory region (Read from /proc/iomem) and it loads the image at the
>> start of that reserved region (Meeting alignment restrictions, if any). So
>> in this case boot loader takes the decision. May be a user option also
>> can be created, something like --load-address=0xXYZ and then people
>> can have fun loading same image at various addresses.
>
>  I think that you are asking too much for the bootloader user, and that
> is a decision he has to take *before* the crash; even me, I would select
> one address like 16 Mbytes and stick with it.

Yes.  Unfortunately there is no one value that works on all machines,
which is why we are moving to a relocatable kernel.

Currently we specify crashkernel=size@location on the kernel command
line to reserve the memory.  Hopefully we can reduce this to just
crashkernel=size and have the kernel find a reasonable whole in
the memory map to reserve.  Where that hole is, is exported to
userspace so /sbin/kexec just puts the kernel in that hole.

>  If the running Linux kernel do not erase Gujin from memory, it could
> also go back to real mode and do a "longjmp()" to return to the
> Gujin interface - but most of the times the system had a reason to
> crash (for instance a ventilator stopped working) and you can plan
> whatever you want in software...

True, and no solution is perfect.   The target is to catch the maximum
number of situations that can be caught.

Going back to real mode generally doesn't work because the BIOS get's
confused with the changes in hardware state from linux running.  Some
systems it does work on though.  Going back to real mode especially
don't work well when the kernel doesn't do a clean shutdown.

In a normal context there are two practical advantages to a bootloader
speaking ELF.
1) The load address is no longer fixed at 1MB.  So if (for example) we
   want to get the performance advantages of 4MB pages all we have to
   do is tweak the  alignment and the load address to be at 4MB.
2) Being able to choose somewhere else in the memory map that works.
   If we have a big (32MB uncompressed) kernel with all of the modules
   compiled in and there is a memory hole at 15MB-16MB.  The normal
   load address won't work so the bootloader can pick another address.
   Similarly problems appear when people place acpi tables at lower
   addresses.

For a 64bit kernel I have thought placing the kernel above 4GB has
several interesting advantages for making more memory available for
DMA accesses without needed an IOMMU.

Then we get into the cases like Xen, which have no real mode to go
through so need completely different bootloaders.

Eric
