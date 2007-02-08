Return-Path: <linux-kernel-owner+w=401wt.eu-S1423195AbXBHJse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423195AbXBHJse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 04:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423208AbXBHJse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 04:48:34 -0500
Received: from web26908.mail.ukl.yahoo.com ([217.146.176.97]:40749 "HELO
	web26908.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423195AbXBHJsd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cPr7/lSIo4+QUtXkuiZGqxprqU1cKP2vklScPP4fxiE/x1BgPqSow0+SrbFopf+DZ8i/Ki/QSCqlZkSM6lbk6atZUka24CTOH93Hp2IKs4EXCZiyyWLc0+mMa+SJeYcT9qxysJQQti/vwb6aDjBRXjOJ8zFyWAQ52R+1lvh+GKg=  ;
Message-ID: <20070208094831.56920.qmail@web26908.mail.ukl.yahoo.com>
X-YMail-OSG: dD.6NJgVM1k5HP3bIJ3SWWn9ff.HwXJxhedA7I_RBpHfBJ3eK7T9szMbdDH9LwA6kGYfn0AfY9lzv4SKN5O3PLjusO6uIv2rx9OlwFtXL1R5JiGolgoMkGWX.IAwX_BMICs4BzW6F6wq6t.lqW1geB_GfRBlk87IeEOM4vlIEcBxrs68YcmJLg--
X-Mailer: YahooMailRC/368.7 YahooMailWebService/0.6.132.7
Date: Thu, 8 Feb 2007 09:48:31 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: vgoyal@in.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> > Etienne Lorrain wrote:
> >  Yes, any PT_LOAD below 64 Kbytes can only be real mode, and real-mode
> > cannot be loaded higher, and cannot be bigger than 640 Kbytes, anything
> > different (like with virtual address at 0xC0000000) is Linux protected mode.
> > Considering the linker used it is always the 4th program header, before there
> > were only 3 program header,third one stay the NOTE one.
>
> Well this is all a lot of speculation. This is not standard way of retrieving
> information from ELF. Number of program headers finally created keep on
> changing. Previously it was left to the linker and now people have changed
> it to 3 by specifically using PHDR directive.

  Well, the standard way is:
1 - the code program header, to be write protected if possible
2 - the (initialised) data program header, to be able to restart the program by just reload/re-entry,
    and after that (memsiz - filesz) of BSS
 Anything after is non standard. The number of program header is written in the ELF header,
but anything over 2 probably need a special loader for the extra treatment.
 That isn't usual to have something near zero, because it is better not to map
any memory there to catch null pointer dereference (in virtual memory system).

 I assume you care about this ELF header because you are also a user of
the ELF file vmlinux, aren't you?
  
> >  Just I did not completely understand why you need relocation (and the announce
> > was when I was in holidays far away). I know a simple kernel is needed to do
> > some debugging when the main kernel has crashed, this kernel is better loaded
> > at for instance 16 Mbytes. You probably do not want the same kernel as the main
> > one because it may crash the same way, and you start a loop - and even then
> > if you have exactly the same kernel it is easier to use the same write-protected
> > block of memory with different data sections.
> >  But I probably do not understand the problem so do not know what to write.
> 
> As long as one can make sure that test kernel boots (commonly the case with
> distros), same kernel can be used as capture kernel too. So the idea here
> is to be able to use same kernel binary as production kernel and capture
> kernel hence distros don't have to ship an additional kernel binary compiled
> for a different physical addr just for dump capturing purposes.

 And you do not want to write protect the kernel code (if the CPU write protection
is not working, the hardware is not working so debug will be difficult, and a simple
CRC32 can tell kernel memory failure) and use twice the same code memory
(with different data area or saving kernel data elsewhere before reload).
 Is that related to module loading or instruction set detection/patch or multiprocessor?

> Currently relocation information is extracted from vmlinux and packed in
> final bzImage after some processing. After execution of real mode code
> and once the image is decompressed, all the relocations are performed and
> then control is transferred to kernel.

  So here you are not really using the initial ELF program header of vmlinux,
but more the section header and my PT_LOAD section bother you, I better
understand. You cannot really claim you are only doing standard/usual
ELF treatment.

 Thanks,
 Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
