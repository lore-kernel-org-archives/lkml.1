Return-Path: <linux-kernel-owner+w=401wt.eu-S1422986AbXBHNLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422986AbXBHNLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 08:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422970AbXBHNLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 08:11:05 -0500
Received: from web26903.mail.ukl.yahoo.com ([217.146.176.92]:32624 "HELO
	web26903.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422985AbXBHNLD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 08:11:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=UoUb9bwlpZAO/PAaEsI3Qa1nDuHvwLD2IV2LbJYqr3zBf6DxplS5+B+9L631XbF+t3H07UVZxtnNYBU+mM7qBLXXdweN9vGT13VI9+sEMsdfkqpqeFl2QWRBotIr8hbeLJqOD+lSzCdyaOMRYrU6Quub/e9dFDA0flb+Ig9oTzM=;
X-YMail-OSG: qRB82l8VM1l.Yy.TxBN2zO52FN5jepb5p3gdz_uN3VRtdEWykKCiHigz_Yl6nRj6Cv0ueThJkp1TpmQ0RExBAUEmkOjsO2z4P2tBHNA2ZJloncEPzpW6VoF03TaW3kcz.gSZfCnDa1zY
X-Mailer: YahooMailRC/368.7 YahooMailWebService/0.6.132.7
Date: Thu, 8 Feb 2007 13:10:58 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
To: vgoyal@in.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <737880.23190.qm@web26903.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >  I assume you care about this ELF header because you are also a user of
> > the ELF file vmlinux, aren't you?
>
> Yes I am. I use kexec boot loader which has capability to load ELF kernel
> images (vmlinux). That's why I am concerned about linking real mode code
> in vmlinux as for kdump case I shall have to be aware that kernel vmlinux
> might contain a special PT_LOAD type program header which will contain
> real mode code and it does not have to be loaded. Then I will run into
> guessing business which one is that real mode PT_LOAD  program header and
> my assumption might very well break in next few kernel release.

 So is kexec able to relocate this vmlinux? If kexec and Gujin do approximately
the same thing they should do it the same way. If you cannot get a PT_LOAD
section, maybe we can put a simple system in NOTE, or just create a
PT_LOAD16 if the linker accepts other values.
 I do not really like to relocate after vmlinux has been linked at a fixed address,
because I am not sure you can guess each address to relocate or not:
you can define permanent address in the linker file by simply "symbol = address"
and those should never be relocated. For instance the very high addresses
on ia32 may point to registers or FPU instead of memory, so may or may not
have to be relocated. I also would better like you not to relocate the real-mode
addresses.
 
> >  And you do not want to write protect the kernel code (if the CPU write protection
> > is not working, the hardware is not working so debug will be difficult, and a simple
> > CRC32 can tell kernel memory failure) and use twice the same code memory
> > (with different data area or saving kernel data elsewhere before reload).
> >  Is that related to module loading or instruction set detection/patch or multiprocessor?
>
> If I understand it right, you seem to be suggesting that I don't have to 
> reload the kernel text and I can only reload the data for second kernel?
> 
> We run the whole of the kernel from a mutually execlusive location from
> first kernel to mitigate the concerns that first kernel's ongoing DMA might
> corrupt second kernel. That's why first kernel's text can't be reused.

  So in some exception handler, you detect something is wrong and then
 jump to a new kernel. Maybe this class of bug (DMA or hardware bit flipped)
 should be detected even without this double kernel environment, by running a
 CRC32 on the kernel text section in this exception handler, displayed that in
 the crash dump.

> Secondly, it gives flexibility to user that either he can choose to use 
> the production kernel as capture kernel or an entirely different custom
> kernel can be used as capture kernel.

  IHMO if it is just capturing the memory, I would have a kernel without
 any modules (usb-storage drivers linked-in) and save to USB key the
 core. Automatically loading modules after the crash may be a problem.

> If real mode code is linked with vmlinux, then kdump will be broken.

 I do not want to break anything for fun. I need either a reason or a bug.

> bzImage is relocatable. If a new kernel image format is introduced
> (compressed ELF), then I will prefer it to be a relocatable one
> (if possible).

 It may be possible to do some kind of "ld -r -o vmlinux", but delaying
the decision where to run the kernel is just delaying: someone has to
decide, and even if Gujin do not decide It will ask the user who most
of the time will have no clue... and on which basis do you want the
bootloader to decide... maybe this SDRAM is faulty and usually the
SDRAM are 512 Mbytes so run the kernel at 512 + 16 Mbytes, but
only if there is more than 1024 Mbytes of SDRAM?

  Thanks,
  Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
