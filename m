Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbXEJWtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbXEJWtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbXEJWtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:49:15 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbXEJWtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:49:14 -0400
Message-ID: <4643A128.30302@zytor.com>
Date: Thu, 10 May 2007 15:48:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com> <1178806235.18785.1189115515@webmail.messagingengine.com> <46435F8A.1040203@zytor.com> <20070510220406.GA21110@mailshack.com>
In-Reply-To: <20070510220406.GA21110@mailshack.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> On Thu, May 10, 2007 at 11:08:10AM -0700, H. Peter Anvin wrote:
>> As far as I could tell, "scan" simply caused the nonstandard video
>> driver scan modules (unsafe probes) to be invoked.  Since those modules
>> are no longer present, there appeared to be no need for them.  The VGA
>> and VESA probes are safe.
> 
> It doesn't probe the hardware in dangerous ways. (Search for mode_scan
> in video.S) It works by trying to set a mode via the normal
> AH=0/AL=mode/int 0x10 method for all possible values of mode. It then
> checks if the bios reports the new mode as being set and reads a few
> standard vga registers to determine if it is a text mode. It's
> completely independent of the CONFIG_VIDEO_SVGA stuff.

It's dangerous, all right (which is why it doesn't do it by default),
since you have no guarantee that the BIOS doesn't totally vomit on these
calls -- or, like my laptop, take about a minute before giving up
finding nothing.

Anyway, I re-implemented scanning and pushed it out to the git tree;
please try it out as it does absolutely nothing on any of my machines.

> That makes me wonder: (from arch/i386/boot/pmjump.S)
> 
> 37         movw    $__BOOT_DS, %cx
> 38 
> 39         movl    %cr0, %edx
> 40         orb     $1, %dl                 # Protected mode (PE) bit
> 41         movl    %edx, %cr0
> 42
> 43         movw    %cx, %ds
> 44         movw    %cx, %es
> 45         movw    %cx, %fs
> 46         movw    %cx, %gs
> 47         movw    %cx, %ss
> 48
> 49         # Jump to the 32-bit entrypoint
> 50         .byte   0x66, 0xea              # ljmpl opcode
> 51 2:      .long   0                       # offset
> 52         .word   __BOOT_CS               # segment
> 
> I thought the 32-bit jump was required to come before the segment loads.
> Does this code load values from the gdt, or are they just loaded as real
> mode segments? As long as it does not crash it does not matter, because
> head.S reloads them again.

Once CR0.PE is set, segments are loaded from the GDT.

	-hpa
