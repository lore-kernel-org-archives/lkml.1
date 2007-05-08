Return-Path: <linux-kernel-owner+w=401wt.eu-S966902AbXEHSMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966902AbXEHSMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966035AbXEHSMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:12:52 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965995AbXEHSMv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:12:51 -0400
Date: Tue, 8 May 2007 11:12:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
Message-Id: <20070508111243.13e7a7f7.akpm@linux-foundation.org>
In-Reply-To: <46405E0C.3020909@zytor.com>
References: <20070505104452.GA30944@mailshack.com>
	<20070508032817.e4734798.akpm@linux-foundation.org>
	<46405E0C.3020909@zytor.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 04:25:00 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> Andrew Morton wrote:
> 
> >>  
> >>  	# Normalize the start address
> >> -	jmpl	$BOOTSEG, $start2
> >> +	jmpw	$BOOTSEG, $start2
> > 
> > Sigh, another blow struck in the ongoing struggle between my Vaio and the
> > rest of the world.
> > 
> > Stone-cold black-screen lockup immediately upon boot.
> > 
> > Stock FC5 install, config at
> > http://userweb.kernel.org/~akpm/config-sony.txt
> 
> Andrew, I'm seriously starting to think there is something fundamentally
> wrong with that test setup.

heh.  All the other bugs have been real oh-yeah-youre-right bugs.  This is
the only mystery bug which I recall.

> The bootsect code in question is never executed.  AT ALL.  The only
> raison d'être for it at all is to print an error message if someone
> writes the kernel to a raw floppy disk.  Nor does it change the
> alignment of the header or anything else to that effect -- the assembly
> code downstream has an explicit ".org" directive.  For what it's worth,
> just to make sure I'm not crazy, I just re-tested both booting the
> kernel and booting the raw disk image, in simulation and on real
> hardware, and it doesn't change anything.  I used your configuration
> file (yes '' | make oldconfig) minus Bluetooth (which is broken in
> current top of Linus) against top of tree Linus + the jmpw patch.  I
> obviously don't have your Vaio, but I do have my own share of quirky
> hardware.  FWIW, I netbooted the hardware using pxelinux 3.50-pre7 as
> the bootloader.[*]
> 
> I'm not writing this to give you a hard time, far from it.  I'm
> suggesting that there might be something wrong with that rig that's
> giving you false testing failures.  I don't particularly care about the
> patch itself -- all it does is save 3 bytes which are currently unused
> anyway, (although it might help Vivek's work.)  However, I'm very
> concerned that you might be getting false failures, for obvious reasons.
> 

I just retested bare 2.6.21 with that patch.  Same hang.

Maybe the assembler or linker screwed something up.

Without patch:

(gdb)  x/20i _start
0x0 <_start>:   ljmpw  $0x0,$0x8
0x6 <_start+6>: rolb   $0x8c,(%edi)
0x9 <start2+1>: enter  $0xd88e,$0x8e
0xd <start2+5>: rorb   $0xfb,0x7c00bcd0(%esi)
0x14 <start2+12>:       cld    
0x15 <start2+13>:       mov    $0x20ac0031,%esi
0x1a <msg_loop+2>:      (bad)  
0x1b <msg_loop+3>:      je     0x26 <die>
0x1d <msg_loop+5>:      mov    $0xe,%ah
0x1f <msg_loop+7>:      mov    $0x10cd0007,%ebx
0x24 <msg_loop+12>:     jmp    0x18 <msg_loop>
0x26 <die>:     xor    %eax,%eax
0x28 <die+2>:   int    $0x16

With patch:

(gdb) x/20i _start
0x0 <_start>:   ljmp   $0xc88c,$0x7c00005
0x7 <start2+2>: mov    %eax,%ds
0x9 <start2+4>: mov    %eax,%es
0xb <start2+6>: mov    %eax,%ss
0xd <start2+8>: mov    $0xfcfb7c00,%esp
0x12 <start2+13>:       mov    $0x20ac002e,%esi
0x17 <msg_loop+2>:      (bad)  
0x18 <msg_loop+3>:      je     0x23 <die>
0x1a <msg_loop+5>:      mov    $0xe,%ah
0x1c <msg_loop+7>:      mov    $0x10cd0007,%ebx
0x21 <msg_loop+12>:     jmp    0x15 <msg_loop>

not sure what's going on there.  We seem to have confused gdb.
