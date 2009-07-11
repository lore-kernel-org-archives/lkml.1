Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZGKJlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZGKJlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 05:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZGKJle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 05:41:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:36093 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751559AbZGKJld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 05:41:33 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/fnmY5MSrfJlMi/ZTWPp/sZS3naCO0OZVf2gvh+s
	WwM1xLO8g2CfuG
Message-ID: <4A585E42.4000401@fisher-privat.net>
Date: Sat, 11 Jul 2009 11:41:22 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090616)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard A. Holden III" <aciddeath@gmail.com>
Subject: Re: Intel BIOS - Corrupted low memory at ffff880000004200
References: <4A5210A2.2080301@fisher-privat.net> <4A52254F.8080103@fisher-privat.net> <20090708113949.GA8960@srcf.ucam.org> <20090710115238.GA8812@elte.hu> <4A575735.9050208@zytor.com>
In-Reply-To: <4A575735.9050208@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin schrieb:
> Ingo Molnar wrote:
>> So i'd really like to know what is happening there, instead of just 
>> zapping support for 64K of RAM on the majority of Linux systems.
>>
>> We might end up doing the same thing in the end (i.e. disable that 
>> 64k of RAM) - but it should be an informed decision, not a wild stab 
>> in the dark.
>>
> 
> Speaking as a boot loader author, I can let you know that these kinds of
> problems are in no wise limited to suspend/resume.
> 
> Pretty much any time you're executing BIOS code you're going to have
> *some* platform which has severe memory corruption somewhere.  This is
> particularly painful for boot loaders, obviously, because the BIOS
> corrupts the boot loader as it is running.  In most cases, there simply
> isn't any way to prevent the corruption, and it's simply dumb luck that
> you will boot most of the time.
> 
> And no, I don't think EFI is going to magically solve anything.  EFI
> will just spread the same class of corruption problems over the entire
> memory map.  It will reduce the density of such bugs -- in particular it
> will eliminiate the "right offset, wrong segment" as well as "idiot
> coding assembly" class of problems -- but it will not confine the ones
> that can and will happen; it's still fundamentally a super-privileged
> flat memory space.
> 
> The root cause seems to be a lack of verification practices in the BIOS
> industry in the post-DOS era.  Back when DOS was still a commercially
> significant system, the BIOS didn't just support the running OS, it also
> directly supported running applications.  That put a relatively high bar
> on how broken your BIOS could be and still have a viable platform.
> These days, it doesn't look like neither the BIOS vendors nor the OEMs
> necessarily even know how to QA, and since the BIOS industry is
> relatively small and highly consolidated, if there isn't sufficient OEM
> pressure it simply won't happen since there is no money in it.
> 
> The HDMI case is a good example -- that probably involved SMI being
> triggered and the SMI code then clobbering a wild pointer.
> 
> 	-hpa
> 

I did a memorydump of Windows Vista SP2 (with win32dd.exe -t 1 -r ) 
before and after suspend. It has same changes/corruption on 
ffff880000004200 like linux do. So this issue is not OS relevant. More 
over Windows show some more changes in this area, some of them are 
changes in the VBIOS space:

this is diff of the windows dump:
linux has no changes at his place ... it looks like some artifacts from 
windows bootmanager.
===================================================================
513,514c513,514
< 0002000: e931 0300 0200 0000 00c0 d0ff 0050 1504  .1...........P..
< 0002010: f498 3980 0000 0000 0000 0000 0000 0000  ..9.............
---
 > 0002000: e931 0300 0300 0000 00c0 d0ff 00d0 1404  .1..............
 > 0002010: 6c84 d380 0000 0000 0000 0000 0000 0000  l...............
523,526c523,526
< 00020a0: 0000 0000 3000 0000 2000 0000 2000 0000  ....0... ... ...
< 00020b0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
< 00020c0: 0000 0000 0000 0000 0000 0000 b004 b381  ................
< 00020d0: 0800 0000 8200 2000 f8ff 928a 1000 0000  ...... .........
---
 > 00020a0: 0000 0000 3000 0000 2300 0000 2300 0000  ....0...#...#...
 > 00020b0: 0000 0000 4020 b581 e04c 1385 0ca0 a281  ....@ ...L......
 > 00020c0: 6820 b581 e04c 1385 84cc 3e80 cdf5 a281  h ...L....>.....
 > 00020d0: 0800 0000 8200 0000 58cc 3e80 1000 0000  ........X.>.....
559c559
< 00022e0: 3b00 0080 0000 0000 0020 1200 6006 0000  ;........ ..`...
---
 > 00022e0: 3100 0180 bc89 3500 0020 1200 f906 0000  1.....5.. ......
561,562c561,562
< 0002300: 0000 0000 0000 0000 0000 ff03 d0b5 918a  ................
< 0002310: 0000 ff07 d0b9 918a 2800 0000 0000 0000  ........(.......
---
 > 0002300: f00f ffff 0004 0000 0000 ff03 d085 3d80  ..............=.
 > 0002310: 0000 ff07 d089 3d80 2800 0000 0000 0000  ......=.(.......
1057c1057
====================================================================

This issue same on windows and linux
====================================================================
< 0004200: 0000 0000 0000 0000 0000 0000 0000 0000  ................
---
 > 0004200: 0104 4200 0000 0000 0000 0000 0000 0000  ..B.............
53286c53286
====================================================================

This is part of VBIOS. On linux this is unchanged and it is located on a 
different address space.
====================================================================
< 00d0250: ffff ffff ffff ffff ffff ffff ffff ffff  ................
---
 > 00d0250: ffff ffff dfff ffff ffff ffff ffff ffff  ................
53643c53643
< 00d18a0: ffff ffff ffff ffff ffff ffff ffff ffff  ................
---
 > 00d18a0: ffff ffff ffff ffff ffdf ffff ffff ffff  ................
54271c54271
< 00d3fe0: ffff ffff ffff ffff ffff ffff ffff ffff  ................
---
 > 00d3fe0: ffff ffff 7fff ffff ffff ffff ffff ffff  ................
74497,74510c74497,74510
====================================================================

