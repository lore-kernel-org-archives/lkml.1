Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbXJPHUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbXJPHUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 03:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933034AbXJPHUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 03:20:24 -0400
Received: from mail2.racsa.co.cr ([196.40.31.26]:43292 "EHLO
	barracuda1.racsa.co.cr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000AbXJPHUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 03:20:21 -0400
X-ASG-Debug-ID: 1192518453-7118005d0000-xx1T2L
X-Barracuda-URL: http://172.16.1.10:8000/cgi-bin/mark.cgi
Date: Tue, 16 Oct 2007 01:07:31 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Old version of lilo fails to boot 2.6.23
Subject: Old version of lilo fails to boot 2.6.23
Message-id: <Pine.LNX.4.64.0710151600090.15578@bruno>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Barracuda-Connect: UNKNOWN[172.16.7.11]
X-Barracuda-Start-Time: 1192518453
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at racsa.co.cr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Greetings:

I upgraded to version 2.6.23 and had a fun time figuring out the source of
this boot failure message on my x86 system:

   This kernel requires an i<random integer>86 CPU, but only detected an
   i<smaller random integer>86 CPU.

It turns out that my version of lilo (lilo -V gives version 21) doesn't set
up the stack and data segment registers in a compatible manner before
entering the new 16-bit real mode kernel loader code.  This problem is new
to the 2.6.23 series.

Parts of the 16-bit real mode loader code are now being compiled as C code
with gcc in 32 bit mode passing the .code16gcc directive to the assembler to
correct the stack frames to 16 bit.  This kludge won't work unless all the
16-bit segment registers are set to the same value.  Gcc only manipulates
the offset of the address and doesn't know anything about segment registers
or segment override prefixes.  My lilo was setting SS=0x8000, DS=0x9000, and
SP=0xB000 before entering the kernel loader.  This makes stack automatics
unreachable from the data segment without segment override prefixes.

I was tempted to patch the kernel code, but instead decided to try
"upgrading" lilo to grub-0.97 and found that grub works just fine.  This
also has the significant advantage that we won't need those nasty as86 and
ld86 things any more since lilo was the last package on our systems that
used them.

However, it would probably be a good idea to modify the kernel loader to
lock out interrupts and explicitly set up the stack in its assembly startup
code to insure that the stack is located correctly above the code in the
same segment, rather than relying on the boot loader to do the right thing. 
The existing setup code already insures that the other segment registers are
equal but omits the stack segment register.  Also, because lilo (and
others?) loads the data/code segment at 0X90000, the stack pointer would
have to be set no higher than 0XA000 to avoid potential overwrites of the
EBDA.  But I believe from my look at the code that the data/code sits below
0X8000 in the segment, so this should be fine.

If others think this is a good thing, I will test and submit a patch.

Please CC me directly as I am no longer subscribed to the list.


Best regards,

Joseph
