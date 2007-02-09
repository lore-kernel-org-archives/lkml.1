Return-Path: <linux-kernel-owner+w=401wt.eu-S1946435AbXBINE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946435AbXBINE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946444AbXBINE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:04:27 -0500
Received: from web26912.mail.ukl.yahoo.com ([217.146.177.79]:24441 "HELO
	web26912.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946435AbXBINE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:04:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xxAdW6WqPukZ4RVKYYd3q0ryRDjrcxXwFRM3hPgK+yj39py/whcg8vMDm2QkXA7bLws1sf/5e+Evwt90su2MzDN1TgBx1F2NxO9qx6umT3JJ/eXT5DqvTzizUXXjv+efaHZFh89olw+6W8EQUnz/FwPoEfvFYFsB8daytoIrDSE=  ;
Message-ID: <20070209130425.63252.qmail@web26912.mail.ukl.yahoo.com>
X-YMail-OSG: yK7I8iQVM1mf8UkIoqqwvazQYrJh9tmHejYy07VsUIIBlfsTecOZhuKPGuxqv1F4SDZosBvgbGdHxZ_eDnq8z6T5l4kclJsHz0bGWpJzLORnyJ1Jnxjaz8aqjkuaqdiWwMgu41w2xw0V6fRY9S8kWn7BgAcE2MChbdzJlEmO1aqugUBWJhgy9w--
Date: Fri, 9 Feb 2007 14:04:25 +0100 (CET)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: vgoyal@in.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070209055941.GA26262@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Vivek Goyal <vgoyal@in.ibm.com> wrote:
> No, as of today, kexec does not relocate vmlinux. At compilation time,
> vmlinux is compiled for a fixed address and vmlinux is loaded at that
> address. This compile address can be controlled with CONFIG_PHYSICAL_START,
> as you already mentioned in your patchset.
> 
> So in the case of kdump, if one wishes to use vmlinux instead of a relocatable
> bzImage, he will re-compile the kernel for a different address and then use
> that vmlinux.
> 
> OTOH, boot loader can possibly relocate vmlinux because all the relocation
> information is retained in vmlinux (Using ld option --emit-relocs). But
> probably self relocating image should be a better option as all the
> boot-loaders out there don't have to be modifed.

  Well, a self relocating image cannot be an ELF file because the code
 to relocate the ELF cannot be executed at the wrong place.
 If relocation is needed, I would better like not to link vmlinux at a
 fixed address first. In fact I wonder if we are talking of the same
 kind of relocation: you seem to talk about "ld --pic-executable" while
 I am thinking of "ld -r" to "locate" it at the bootloader loading time.
  The main problem I see is that I do not have the code for that, and
 I am going deeper/earlier into the generation of vmlinux, while comments
 are "already you are too early, loading an ELF file is too complex for
 a bootloader". The solution I have already is working.

> > If you cannot get a PT_LOAD
> > section, maybe we can put a simple system in NOTE, or just create a
> > PT_LOAD16 if the linker accepts other values.
> 
> My guess is that PT_LOAD16 is not an acceptable value. Putting information
> in PT_NOTE seems interesting (As Eric already mentioned).

 In fact, thinking more about that, I am going back to my implementation
 of it, because on ia32 the interrupt vectors are at address zero and it is
 obviouly an invalid address to load an ELF for this architecture.
 But for the linker, it is the right address to link it (being an offset
 into a non-null segment in real mode), and because the entry point has
 to be zero (I cannot use the ELF entry value) the program header base
 address has to be zero.
 Anyway, your loader in (probably) written in C, so a test against zero
 is a simple thing to do, and should be done anyway to check for an
 incorrect ELF program header. I wonder if this NOTE program header is
 not simply designed as an "end" marker, it does not seem to contain
 anything, so me defining the realmode after that program header may
 be a good idea.

> We already do checksum verification to make sure newly loaded kernel has
> not been corrupted before we jump to it. What's the point in doing the
> verification existing kernel text. Because even that is intact, and you
> reload your data section, that data section will have to be reloaded at
> the same place where previous data section was. Now after you re-loaded 
> the data section, some DMA might corrupt it now (Because we never stopped
> DMAs). So loading a fresh copy of text and data section at a reserved 
> memory location seems safer.

 If you really are tring to catch an erroneous DMA into the kernel,
 is it better to keep an exact copy of the kernel you are using somewhere
 else to do a bit-to-bit comparisson after the crash, and so no relocate.
 Anyway if the DMA crash has crashed the exception handling area the system
 is dead anyway.

> Interesting question, How does a boot loader/user decide where to load
> the relocatable image? I think it depends on the new interesting usages
> of the relocatable kernel. As of today, kexec knows where is reserved
> memory region (Read from /proc/iomem) and it loads the image at the
> start of that reserved region (Meeting alignment restrictions, if any). So
> in this case boot loader takes the decision. May be a user option also
> can be created, something like --load-address=0xXYZ and then people
> can have fun loading same image at various addresses.

 I think that you are asking too much for the bootloader user, and that
is a decision he has to take *before* the crash; even me, I would select
one address like 16 Mbytes and stick with it...
 If the running Linux kernel do not erase Gujin from memory, it could
also go back to real mode and do a "longjmp()" to return to the
Gujin interface - but most of the times the system had a reason to
crash (for instance a ventilator stopped working) and you can plan
whatever you want in software...

  Thanks,
  Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
