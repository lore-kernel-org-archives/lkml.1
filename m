Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbXELLIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbXELLIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXELLIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:08:32 -0400
Received: from 1wt.eu ([62.212.114.60]:2590 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbXELLIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:08:31 -0400
Date: Sat, 12 May 2007 13:08:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Zbigniew Baniewski <zb@ispid.com.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "modularized" 2.4.34.4  ->  ide-core "unresolved symbols"
Message-ID: <20070512110827.GA21596@1wt.eu>
References: <20070505194922.GA13176@localhost.localdomain> <20070506043645.GF943@1wt.eu> <20070508202334.GA16185@localhost.localdomain> <20070508211646.GA3129@1wt.eu> <20070508221425.GA18244@localhost.localdomain> <20070508223922.GB31591@1wt.eu> <20070509220544.GA14957@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509220544.GA14957@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zbigniew,

On Thu, May 10, 2007 at 12:05:44AM +0200, Zbigniew Baniewski wrote:
> So, I changed the config (below) and made another compilation - still the
> same:
> ------------------------
> ...ordinary boot messages, ending with "hda:... sectors... w/Cache..."
> hda: attached ide-disk driver
> hda:<1>Unable to handle kernel paging request at virtual address ffffff00 
> printing eip:
> 
> ...a lot of interesting stuff...              
> 
> <0>Kernel panic: Attempted to kill the idle task!
> In idle task - not syncing.
> -----------------------
> 
> I'm afraid, kernel 2.4.34.4 is just broken.

Well, in fact it's not just that easy.

I've tried your image and could reproduce the same panic here.
However, it is not the same problem at all, because it appears
unrelated to IDE, and it crashes about 1 second after init has
been forked. I noticed this because I had a hard time trying
to get access to a shell, then I finally decided to put sash
on the FS and rebuild it. I booted with init=sash and got the
sash prompt, then the panic one second after it, while no
module could be loaded.

I decoded the panic dump :

VFS: Mounted root (cramfs filesystem) readonly.
Freeing unused kernel memory: 116k freed
Unable to handle kernel paging request at virtual address ffffff00
 printing eip:
c0113a80
Oops: 0002
CPU:    0
EIP:    0010:[<c0113a80>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010286
eax: ffffff00   ebx: 00000001   ecx: ffffffff   edx: c0300000
esi: 00049800   edi: c0270800   ebp: 0003e000   esp: c0301fc4
ds: 0018   es: 0018   ss: 0018
Process swapper (pid: 0, stackpage=c0301000)
Stack: c012016c 00000001 00049800 c0270800 c011e2a0 c0108166 c0270f60 00007dfd 
       00007dfd 00007dfd 00007dfd c0303340 c011e1ba 00000000 00000000 
Call Trace:    [<c012016c>] [<c011e2a0>] [<c0108166>] [<c011e1ba>]
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 

>>EIP; c0113a80 <init_idle+0/94>   <=====
Trace; c012016c <cpu_idle+8/54>
Trace; c011e2a0 <rest_init+50/54>
Trace; c0108166 <start_kernel+172/178>
Trace; c011e1ba <L6+0/2>
Code;  c0113a80 <init_idle+0/94>
00000000 <_EIP>:

 <0>Kernel panic: Attempted to kill the idle task!


It crashes in init_idle(), itself called by cpu_idle(). I retried with
plain 2.4.34, and this one works perfectly.

Then I dowloaded grsec as I've noticed your kernel is called -grsec. I
applied the patch to plain 2.4.34, and kaboom ! The same panic as above.
Unfortunately, grsec does not seem to modify the functions above, so
it's trickier than it looks.

The fact that it is inside an initrd makes it amazingly difficult to
debug. It took me 3 hours this morning to succesfully get a shell
with no modules loaded.

Then I tried to hard-link the IDEDISK module, and it works even with
grsec. So right now, all I can say is :
  - 2.4.34 + IDEDISK=y  works
  - 2.4.34 + IDEDISK=m  works
  - 2.4.34 + grsec + IDEDISK=y  works
  - 2.4.34 + grsec + IDEDISK=m  breaks

I do not have enough knowledge of the IDE DISK driver nor of grsec to
guess what goes wrong. If other people on the list could enlighten me,
I would appreciate it. In the mean time, I suggest that you avoid
grsec+IDEDISK=m. So maybe using IDEDISK=y would be acceptable, even
if we agree that we're hiding the bug instead of fixing it ?

Regards,
Willy

