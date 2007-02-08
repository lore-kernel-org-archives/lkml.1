Return-Path: <linux-kernel-owner+w=401wt.eu-S1422932AbXBHLhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422932AbXBHLhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422935AbXBHLhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:37:12 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59949 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422932AbXBHLhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:37:10 -0500
Date: Thu, 8 Feb 2007 17:07:06 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
Message-ID: <20070208113706.GB14039@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070208094831.56920.qmail@web26908.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208094831.56920.qmail@web26908.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 09:48:31AM +0000, Etienne Lorrain wrote:
> Vivek Goyal wrote:
> > > Etienne Lorrain wrote:
> > >  Yes, any PT_LOAD below 64 Kbytes can only be real mode, and real-mode
> > > cannot be loaded higher, and cannot be bigger than 640 Kbytes, anything
> > > different (like with virtual address at 0xC0000000) is Linux protected mode.
> > > Considering the linker used it is always the 4th program header, before there
> > > were only 3 program header,third one stay the NOTE one.
> >
> > Well this is all a lot of speculation. This is not standard way of retrieving
> > information from ELF. Number of program headers finally created keep on
> > changing. Previously it was left to the linker and now people have changed
> > it to 3 by specifically using PHDR directive.
> 
>   Well, the standard way is:
> 1 - the code program header, to be write protected if possible
> 2 - the (initialised) data program header, to be able to restart the program by just reload/re-entry,
>     and after that (memsiz - filesz) of BSS
>  Anything after is non standard. The number of program header is written in the ELF header,
> but anything over 2 probably need a special loader for the extra treatment.
>  That isn't usual to have something near zero, because it is better not to map
> any memory there to catch null pointer dereference (in virtual memory system).
> 

May be that's the ideal scenario. But if you leave it to linker to decide the
number of progaram headers to linker then linker sometimes optimizes and
creates more program headers if it finds empty space between various sections.
Sometime one or two page space gets created between sections because of
alignment restrictions. So effectively, number of program headers were not
fixed, till recently.

>  I assume you care about this ELF header because you are also a user of
> the ELF file vmlinux, aren't you?
>   

Yes I am. I use kexec boot loader which has capability to load ELF kernel
images (vmlinux). That's why I am concerned about linking real mode code
in vmlinux as for kdump case I shall have to be aware that kernel vmlinux
might contain a special PT_LOAD type program header which will contain
real mode code and it does not have to be loaded. Then I will run into
guessing business which one is that real mode PT_LOAD  program header and
my assumption might very well break in next few kernel release.
 

> > >  Just I did not completely understand why you need relocation (and the announce
> > > was when I was in holidays far away). I know a simple kernel is needed to do
> > > some debugging when the main kernel has crashed, this kernel is better loaded
> > > at for instance 16 Mbytes. You probably do not want the same kernel as the main
> > > one because it may crash the same way, and you start a loop - and even then
> > > if you have exactly the same kernel it is easier to use the same write-protected
> > > block of memory with different data sections.
> > >  But I probably do not understand the problem so do not know what to write.
> > 
> > As long as one can make sure that test kernel boots (commonly the case with
> > distros), same kernel can be used as capture kernel too. So the idea here
> > is to be able to use same kernel binary as production kernel and capture
> > kernel hence distros don't have to ship an additional kernel binary compiled
> > for a different physical addr just for dump capturing purposes.
> 
>  And you do not want to write protect the kernel code (if the CPU write protection
> is not working, the hardware is not working so debug will be difficult, and a simple
> CRC32 can tell kernel memory failure) and use twice the same code memory
> (with different data area or saving kernel data elsewhere before reload).
>  Is that related to module loading or instruction set detection/patch or multiprocessor?
> 

If I understand it right, you seem to be suggesting that I don't have to 
reload the kernel text and I can only reload the data for second kernel?

We run the whole of the kernel from a mutually execlusive location from
first kernel to mitigate the concerns that first kernel's ongoing DMA might
corrupt second kernel. That's why first kernel's text can't be reused.
Secondly, it gives flexibility to user that either he can choose to use 
the production kernel as capture kernel or an entirely different custom
kernel can be used as capture kernel.
 
> > Currently relocation information is extracted from vmlinux and packed in
> > final bzImage after some processing. After execution of real mode code
> > and once the image is decompressed, all the relocations are performed and
> > then control is transferred to kernel.
> 
>   So here you are not really using the initial ELF program header of vmlinux,
> but more the section header and my PT_LOAD section bother you, I better
> understand. You cannot really claim you are only doing standard/usual
> ELF treatment.
> 

Kexec as a boot loader allows to load both ELF vmlinux file or bzImage.
Hence for kdump, a user got the flexibility to either use vmlinux or 
bzImage for dump captruing purposes. Hence I am concerned about both. 

If real mode code is linked with vmlinux, then kdump will be broken.

bzImage is relocatable. If a new kernel image format is introduced
(compressed ELF), then I will prefer it to be a relocatable one
(if possible).

Thanks
Vivek
