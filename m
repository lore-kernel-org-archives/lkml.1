Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbXEJWF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbXEJWF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXEJWFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:05:19 -0400
Received: from m-relay.rz.uni-saarland.de ([134.96.7.3]:20133 "EHLO
	m-relay.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759358AbXEJWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:05:16 -0400
Date: Fri, 11 May 2007 00:04:06 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
Message-ID: <20070510220406.GA21110@mailshack.com>
References: <464158E9.2000207@zytor.com> <1178806235.18785.1189115515@webmail.messagingengine.com> <46435F8A.1040203@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46435F8A.1040203@zytor.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.5.1 (m-relay.rz.uni-saarland.de [134.96.7.3]); Fri, 11 May 2007 00:05:03 +0200 (CEST)
X-AntiVirus: checked by AntiVir Milter (version: 1.1.3-1; AVE: 7.3.1.53; VDF: 6.38.1.19; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:08:10AM -0700, H. Peter Anvin wrote:
> As far as I could tell, "scan" simply caused the nonstandard video
> driver scan modules (unsafe probes) to be invoked.  Since those modules
> are no longer present, there appeared to be no need for them.  The VGA
> and VESA probes are safe.

It doesn't probe the hardware in dangerous ways. (Search for mode_scan
in video.S) It works by trying to set a mode via the normal
AH=0/AL=mode/int 0x10 method for all possible values of mode. It then
checks if the bios reports the new mode as being set and reads a few
standard vga registers to determine if it is a text mode. It's
completely independent of the CONFIG_VIDEO_SVGA stuff.

> > Would it make sense to just compile everything independent of config
> > options and determine what should be done at run-time? And/or separate
> > the bootcode related config-options and put them under EMBEDDED/TINY?
> 
> It doesn't, because e.g. Voyager needs special A20 code, etc.  I guess
> we could dynamically detect Voyager and then do that, but that would
> require testing.

Yeah, Voyager and Elan should be detected at runtime in that case. But
if one ever wants to do that, this would be a good time... This rewrite
needs thorough testing anyhow. ;)

> > If space is not that much of an issue, could you imagine putting
> > the decompression/relocation/misc.c code in setup too? This would
> > make it easier to start thinking of a new kernel image format without
> > breaking bootloaders that use a bzImage in the intended way.
> 
> I don't think that's either desirable or practical.  That code really
> wants ready addressability of the whole image.

Heh. I don't know about desirable, but it is not really impractical. The
Relocatable patches already introduced a small bit of 32-bit code in
setup (git-show 968de4f0 arch/i386/boot/setup.S). This has disappeared
in your rewrite, however.

That makes me wonder: (from arch/i386/boot/pmjump.S)

37         movw    $__BOOT_DS, %cx
38 
39         movl    %cr0, %edx
40         orb     $1, %dl                 # Protected mode (PE) bit
41         movl    %edx, %cr0
42
43         movw    %cx, %ds
44         movw    %cx, %es
45         movw    %cx, %fs
46         movw    %cx, %gs
47         movw    %cx, %ss
48
49         # Jump to the 32-bit entrypoint
50         .byte   0x66, 0xea              # ljmpl opcode
51 2:      .long   0                       # offset
52         .word   __BOOT_CS               # segment

I thought the 32-bit jump was required to come before the segment loads.
Does this code load values from the gdt, or are they just loaded as real
mode segments? As long as it does not crash it does not matter, because
head.S reloads them again.

Thanks,
Greetings,
	Alexander
