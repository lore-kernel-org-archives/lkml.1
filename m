Return-Path: <linux-kernel-owner+w=401wt.eu-S1946134AbXBIF74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946134AbXBIF74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 00:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946137AbXBIF74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 00:59:56 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44245 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946134AbXBIF7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 00:59:55 -0500
Date: Fri, 9 Feb 2007 11:29:41 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
Message-ID: <20070209055941.GA26262@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <737880.23190.qm@web26903.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <737880.23190.qm@web26903.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 01:10:58PM +0000, Etienne Lorrain wrote:
> > >  I assume you care about this ELF header because you are also a user of
> > > the ELF file vmlinux, aren't you?
> >
> > Yes I am. I use kexec boot loader which has capability to load ELF kernel
> > images (vmlinux). That's why I am concerned about linking real mode code
> > in vmlinux as for kdump case I shall have to be aware that kernel vmlinux
> > might contain a special PT_LOAD type program header which will contain
> > real mode code and it does not have to be loaded. Then I will run into
> > guessing business which one is that real mode PT_LOAD  program header and
> > my assumption might very well break in next few kernel release.
> 
>  So is kexec able to relocate this vmlinux? If kexec and Gujin do approximately
> the same thing they should do it the same way.

No, as of today, kexec does not relocate vmlinux. At compilation time,
vmlinux is compiled for a fixed address and vmlinux is loaded at that
address. This compile address can be controlled with CONFIG_PHYSICAL_START,
as you already mentioned in your patchset.

So in the case of kdump, if one wishes to use vmlinux instead of a relocatable
bzImage, he will re-compile the kernel for a different address and then use
that vmlinux.

OTOH, boot loader can possibly relocate vmlinux because all the relocation
information is retained in vmlinux (Using ld option --emit-relocs). But
probably self relocating image should be a better option as all the
boot-loaders out there don't have to be modifed.

> If you cannot get a PT_LOAD
> section, maybe we can put a simple system in NOTE, or just create a
> PT_LOAD16 if the linker accepts other values.

My guess is that PT_LOAD16 is not an acceptable value. Putting information
in PT_NOTE seems interesting (As Eric already mentioned).

>  I do not really like to relocate after vmlinux has been linked at a fixed address,
> because I am not sure you can guess each address to relocate or not:
> you can define permanent address in the linker file by simply "symbol = address"
> and those should never be relocated. For instance the very high addresses
> on ia32 may point to registers or FPU instead of memory, so may or may not
> have to be relocated. I also would better like you not to relocate the real-mode
> addresses.
>  

I think there will have to be an upper limit on the address where you can
relocate your image to. Anyway, given i386 virtual memory address space
constraint, I think you can not load kernel image in high memory (896MB).
It has to run anywhere below that.

I think you are referring to defining absolute symbols. Already there are
some absolute symbols generated when kernel is compiled and these are
not relocated while image is being loaded at a non-compiled address. So if
a boot loader decides to relocate a vmlinux image, it will have to skip
relocations present w.r.t absolute symbols. (Unfortunately, ld does generate
relocation entries even for absolute symbols).
 
> > >  And you do not want to write protect the kernel code (if the CPU write protection
> > > is not working, the hardware is not working so debug will be difficult, and a simple
> > > CRC32 can tell kernel memory failure) and use twice the same code memory
> > > (with different data area or saving kernel data elsewhere before reload).
> > >  Is that related to module loading or instruction set detection/patch or multiprocessor?
> >
> > If I understand it right, you seem to be suggesting that I don't have to 
> > reload the kernel text and I can only reload the data for second kernel?
> > 
> > We run the whole of the kernel from a mutually execlusive location from
> > first kernel to mitigate the concerns that first kernel's ongoing DMA might
> > corrupt second kernel. That's why first kernel's text can't be reused.
> 
>   So in some exception handler, you detect something is wrong and then
>  jump to a new kernel.

In a nutshell, Yes.

>  Maybe this class of bug (DMA or hardware bit flipped)
>  should be detected even without this double kernel environment, by running a
>  CRC32 on the kernel text section in this exception handler, displayed that in
>  the crash dump.

We already do checksum verification to make sure newly loaded kernel has
not been corrupted before we jump to it. What's the point in doing the
verification existing kernel text. Because even that is intact, and you
reload your data section, that data section will have to be reloaded at
the same place where previous data section was. Now after you re-loaded 
the data section, some DMA might corrupt it now (Because we never stopped
DMAs). So loading a fresh copy of text and data section at a reserved 
memory location seems safer. 

> 
> > Secondly, it gives flexibility to user that either he can choose to use 
> > the production kernel as capture kernel or an entirely different custom
> > kernel can be used as capture kernel.
> 
>   IHMO if it is just capturing the memory, I would have a kernel without
>  any modules (usb-storage drivers linked-in) and save to USB key the
>  core. Automatically loading modules after the crash may be a problem.

As a user you can very well do it. Distros are also doing something 
similar. They just insert 1-2 modules from initrd (custom initrd created
based on choice of dump saving destination) and capture the dump either
to a local storage or over network and then system is booted back to
production kernel.

> 
> > If real mode code is linked with vmlinux, then kdump will be broken.
> 
>  I do not want to break anything for fun. I need either a reason or a bug.
> 
> > bzImage is relocatable. If a new kernel image format is introduced
> > (compressed ELF), then I will prefer it to be a relocatable one
> > (if possible).
> 
>  It may be possible to do some kind of "ld -r -o vmlinux", but delaying
> the decision where to run the kernel is just delaying: someone has to
> decide, and even if Gujin do not decide It will ask the user who most
> of the time will have no clue... and on which basis do you want the
> bootloader to decide... maybe this SDRAM is faulty and usually the
> SDRAM are 512 Mbytes so run the kernel at 512 + 16 Mbytes, but
> only if there is more than 1024 Mbytes of SDRAM?
> 

Interesting question, How does a boot loader/user decide where to load
the relocatable image? I think it depends on the new interesting usages
of the relocatable kernel. As of today, kexec knows where is reserved
memory region (Read from /proc/iomem) and it loads the image at the
start of that reserved region (Meeting alignment restrictions, if any). So
in this case boot loader takes the decision. May be a user option also
can be created, something like --load-address=0xXYZ and then people
can have fun loading same image at various addresses.

I think this is interesting usage if boot loader can somehow decide
that first few MB is faulty and load kernel at a memory address higher
than that. If first whole 1G is faulty then you can't do much on i386,
but on 64bit arches like x86_64, this should not be an issue. 

Thanks
Vivek
