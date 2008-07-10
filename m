Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYGJEzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYGJEzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 00:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbYGJEzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 00:55:06 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:5872 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891AbYGJEzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 00:55:03 -0400
From: Frans Pop <elendil@planet.nl>
To: Ian Campbell <ijc@hellion.org.uk>
Subject: [regression?] 2.6.26 floppy boot failure with kernel packed using 'upx'
Date: Thu, 10 Jul 2008 06:54:59 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807100655.00857.elendil@planet.nl>
X-OriginalArrivalTime: 10 Jul 2008 04:55:01.0780 (UTC) FILETIME=[1C724540:01C8E249]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the Debian installer we've been tracing a problem with our installation
boot floppy. If booted with 'expert' at the syslinux prompt, it only shows:
<snip>
SYSLINUX 3.70 <etc.>
boot:expert
Loading linux......................
Loading initrd.gz....ready.
Probing EDD (edd=off to disable)... ok
</snip>

And then the emulator crashes (both VirtualBox and qemu), or on real
hardware the system reboots. The qemu crash is included at the bottom
of this mail.

The problem was initially seen with the 2.6.25 Debian kernel and traced
to a set of Xen-related patches backported from upstream 2.6.26. Floppies
using Debian 2.6.24 or pristine 2.6.24/2.6.25 don't show the problem.

Bisection has shown the culprit to be this very early 2.6.26 commit:
$ git bisect bad
099e1377269a47ed30a00ee131001988e5bcaa9c is first bad commit
commit 099e1377269a47ed30a00ee131001988e5bcaa9c
Author: Ian Campbell <ijc@hellion.org.uk>
Date:   Wed Feb 13 20:54:58 2008 +0000

    x86: use ELF format in compressed images.

Important factor here is that we "pack" the kernel using upx [1] (in order
to fit everything on a floppy). The original (unpacked) kernel after this
commit boots fine, only a packed version fails.
We have tried upx versions 2.01, 3.01 and 3.03, all with same result.

Both "good" (before commit) and "bad" (after commit) images are available
at: http://people.debian.org/~fjp/tmp/d-i/floppy/upx/
Included are the boot floppy image, the raw kernel and the packed kernel.

The issue can also be reproduced using qemu without booting the floppy
itself. For the "bad" image:
# Boots correctly (but fails when mounting root fs):
$ qemu -kernel vmlinuz -hda /dev/zero
# Fails:
$ qemu -kernel vmlinuz.upx -hda /dev/zero

So, the primairy question here is:
- is this a kernel regression because whatever changed is no longer valid
  conform "kernel format specs", or
- is this a latent issue in upx that somehow creates an invalid image, or
- does this change effectively create a new "type" of image that upx
  just doesn't yet know how to handle correctly?

And a follow-up question in the last two cases: how likely is it that this
change could/will cause similar issues in other comparable scenarios?

Note that we've been using this same compression technique for ages in
the Debian installer without any problems.

Cheers,
FJP

[1] http://upx.sourceforge.net/


upx command used for compression and output
-------------------------------------------
$ upx -f -9 vmlinuz
                       Ultimate Packer for eXecutables
  Copyright (C) 1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007
UPX 3.01        Markus Oberhumer, Laszlo Molnar & John Reiser   Jul 31st 2007

        File size         Ratio      Format      Name
   --------------------   ------   -----------   -----------
   1312304 ->   1245723   94.93%  bvmlinuz/386   vmlinuz

qemu crash output
-----------------
$ qemu -fda boot.img
qemu: fatal: triple fault
EAX=00000018 EBX=00000000 ECX=00000000 EDX=003646f6
ESI=000333a1 EDI=00000000 EBP=ffffffb0 ESP=0003c367
EIP=00101015 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 00000000 00000000
CS =0010 00000000 ffffffff 00cf9b00
SS =0018 00000000 ffffffff 00cf9300
DS =0000 00000000 00000000 00000000
FS =0018 00000000 ffffffff 00cf9300
GS =0018 00000000 ffffffff 00cf9300
LDT=0000 00000000 00000000 00008000
TR =0020 00001000 00000067 00008900
GDT=     656e6900 0000646e
IDT=     00000000 00000000
CR0=60000011 CR2=00000000 CR3=00000000 CR4=00000000
CCS=ffeb7200 CCD=00000000 CCO=LOGICB
FCW=037f FSW=4000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000
Aborted
