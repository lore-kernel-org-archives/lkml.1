Return-Path: <linux-kernel-owner+w=401wt.eu-S1161526AbXBHEp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161526AbXBHEp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 23:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161531AbXBHEp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 23:45:29 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43219 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161526AbXBHEp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 23:45:28 -0500
Date: Thu, 8 Feb 2007 10:15:25 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Re : Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
Message-ID: <20070208044525.GA5997@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <848486.58910.qm@web26907.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <848486.58910.qm@web26907.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 02:55:39PM +0000, Etienne Lorrain wrote:
> Vivek Goyal wrote:
> >How do I know which program header is real mode code and the boot loader
> > is not supposed to load it? May be PT_LOAD header with physical addr 0?
> > What happens if changes happen and down the line we start compiling 
> > real mode code for non-zero address?
> 
>  Yes, any PT_LOAD below 64 Kbytes can only be real mode, and real-mode
> cannot be loaded higher, and cannot be bigger than 640 Kbytes, anything
> different (like with virtual address at 0xC0000000) is Linux protected mode.
> Considering the linker used it is always the 4th program header, before there
> were only 3 program header,third one stay the NOTE one.
> 

Well this is all a lot of speculation. This is not standard way of retrieving
information from ELF. Number of program headers finally created keep on
changing. Previously it was left to the linker and now people have changed
it to 3 by specifically using PHDR directive.
  
> > Hence I think keeping real mode code out of vmlinux might prove to be a good idea.
> 
>  Well, ELF is a format made to describe what to load, at which addres, and I assume
> everyone recognise that some ELF section shall not be loaded, like the debug information.
> Gujin accepts having the real-mode treated like a program text and so in the program header,
> or like extra memory block with content like the symbol table used by a debugger, I do not
> know what is best so have implemented the two.
> 
> > Secondly, if you compile real mode code with vmlinux, what would be the
> > entry point for this ELF file? Real mode entry? Then I have not way to
> > find out from ELF headers where is the protected mode entry point and
> > I can not do use this vmlinux with kexec/kdump.
> 
>  I did not touch the kernel entry point, the real mode entry point is at offset zero
> in the real-mode program header/section table.
> 
> > OTOH, now bzImage is relocatable. Is this image going to be relocatable?
> > How do we take care of that?
> 
>  Just I did not completely understand why you need relocation (and the announce
> was when I was in holidays far away). I know a simple kernel is needed to do
> some debugging when the main kernel has crashed, this kernel is better loaded
> at for instance 16 Mbytes. You probably do not want the same kernel as the main
> one because it may crash the same way, and you start a loop - and even then
> if you have exactly the same kernel it is easier to use the same write-protected
> block of memory with different data sections.
>  But I probably do not understand the problem so do not know what to write.
> 

As long as one can make sure that test kernel boots (commonly the case with
distros), same kernel can be used as capture kernel too. So the idea here
is to be able to use same kernel binary as production kernel and capture
kernel hence distros don't have to ship an additional kernel binary compiled
for a different physical addr just for dump capturing purposes.

Currently relocation information is extracted from vmlinux and packed in
final bzImage after some processing. After execution of real mode code
and once the image is decompressed, all the relocations are performed and
then control is transferred to kernel.

Thanks
Vivek
