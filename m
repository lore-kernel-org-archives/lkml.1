Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZGUUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZGUUsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbZGUUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:48:19 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:43283 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbZGUUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:48:18 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 16:48:17 EDT
Date: Tue, 21 Jul 2009 22:42:14 +0200
From: Bastian Blank <waldi@debian.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Kiko Piris <kernel@pirispons.net>, Damien Wyart <damien.wyart@free.fr>,
       Greg KH <gregkh@suse.de>, Wolfgang Walter <wolfgang.walter@stwm.de>,
       hpa@zytor.com, 537862@bugs.debian.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090721204214.GA27015@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Kiko Piris <kernel@pirispons.net>,
	Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
	Wolfgang Walter <wolfgang.walter@stwm.de>, hpa@zytor.com,
	537862@bugs.debian.org
References: <20090720040813.GC11940@kroah.com> <200907201613.22483.wolfgang.walter@stwm.de> <20090720150916.GB10015@suse.de> <20090720180333.GA2905@brouette> <20090720192933.GA22641@superlopez.pirispons.net> <alpine.LFD.2.01.0907201241490.19335@localhost.localdomain> <20090720211908.GA31814@superlopez.pirispons.net> <alpine.LFD.2.01.0907201458000.19335@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907201458000.19335@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 03:02:36PM -0700, Linus Torvalds wrote:
> On Mon, 20 Jul 2009, Kiko Piris wrote:
> > Yes, as Marcel Beister pointed, it resulted some binutils bug.
> > Downgrading the package produced a perfectly bootable 2.6.30.2.
> Ok, so it's been narrowed down to binutils. Good.

Okay, I did some work and now got one working and one not working
kernel. The setup code it, except the payload size and the version
string, identical. Now to vmlinux.

First difference (1-vmlinux is the broken, 2-vmlinux is the working
version):
| 2-vmlinux:     file format elf32-i386
| 2-vmlinux
| architecture: i386, flags 0x00000113:
| HAS_RELOC, EXEC_P, HAS_SYMS, D_PAGED
vs.
| 1-vmlinux:     file format elf32-i386
| 1-vmlinux
| architecture: i386, flags 0x00000013:
| HAS_RELOC, EXEC_P, HAS_SYMS
The file lost its D_PAGED flag.

Next:
|  16 .init.rodata  00000394  c05057e0  005057e0  004067e0  2**4
|                   CONTENTS, ALLOC, LOAD, RELOC, DATA
|  17 .data.page_aligned 00000800  c0506000  00506000  00407000  2**5
|                   CONTENTS, ALLOC, LOAD, DATA
vs.
|  16 .init.rodata  00000394  c0506000  00506000  00407000  2**4
|                   CONTENTS, ALLOC, LOAD, RELOC, DATA
|  17 .data_nosave  00000c6c  c0506394  00506394  00407394  2**0
|                   ALLOC
|  18 .data.page_aligned 00000800  c0507000  00506394  00407394  2**5
|                   CONTENTS, ALLOC, LOAD, DATA
So suddenly there apears a .data_nosave with some content, but it is
marked the same then a bss section and not even properly aligned
according to the linker script.

The same sections of another working kernel, built with the new
binutils:
|  18 .init.rodata  000003bd  c040f4c0  0040f4c0  003104c0  2**2
|                   CONTENTS, ALLOC, LOAD, RELOC, DATA
|  19 .data_nosave  00001000  c0410000  00410000  00311000  2**2
|                   CONTENTS, ALLOC, LOAD, DATA
|  20 .data.page_aligned 00000800  c0411000  00411000  00312000  2**2
|                   CONTENTS, ALLOC, LOAD, DATA
The .data_nosave section is a real one here.

I would say, such holes won't survive the objcopy to create a binary and
all code is at the wrong location.

Bastian

-- 
Punishment becomes ineffective after a certain point.  Men become insensitive.
		-- Eneg, "Patterns of Force", stardate 2534.7
