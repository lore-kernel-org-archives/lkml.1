Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXCANfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXCANfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965054AbXCANfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:35:14 -0500
Received: from lmv.inov.pt ([146.193.64.2]:41786 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965051AbXCANfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:35:12 -0500
Message-ID: <45E6D628.90800@inov.pt>
Date: Thu, 01 Mar 2007 13:33:28 +0000
From: Jose Goncalves <jose.goncalves@inov.pt>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
References: <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt> <20070221230503.GA28156@flint.arm.linux.org.uk> <45DDB096.2020807@inov.pt> <20070222170354.GB633@flint.arm.linux.org.uk>
In-Reply-To: <20070222170354.GB633@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Russel,

I'm back, after some more testing. Here goes my report.

I've switched to another SBC and the kernel still Oops, so is not a
one-off fault on the hardware.

I've also run memtest86+ on this board for the maximum period that I
reach an Oops with my application (24 H) and it not detected any fault
(in 21 passes).

As I've said earlier, our hardware as an extra serial controller
(TL16C554A). To isolate the problem, I've removed the board with this
extra controller and used only the SBC (Vortex86-6070 -
http://www.icop.com.tw/products_detail.asp?ProductID=70). Still, with
that setup and with my application using only ttyS1, I get kernel Oops,
and always in the same point:

<1>[43477.986867] Unable to handle kernel NULL pointer dereference at
virtual address 00000012
<1>[43477.995067]  printing eip:
<4>[43478.003087] c01bfa7a
<1>[43478.003116] *pde = 00000000
<0>[43478.011231] Oops: 0000 [#1]
<4>[43478.019188] Modules linked in:
<0>[43478.027308] CPU:    0
<4>[43478.027325] EIP:    0060:[<c01bfa7a>]    Not tainted VLI
<4>[43478.027341] EFLAGS: 00010202   (2.6.16.41-mtm6-debug1 #1)
<0>[43478.052490] EIP is at serial_in+0xa/0x4a
<0>[43478.061448] eax: 00000060   ebx: 00000000   ecx: 00000000   edx:
00000000
<0>[43478.070945] esi: 00000000   edi: 00000040   ebp: c7237e1c   esp:
c7237e18
<0>[43478.080720] ds: 007b   es: 007b   ss: 0068
<0>[43478.090470] Process gp_position (pid: 26205, threadinfo=c7236000
task=c775dab0)
<0>[43478.091319] Stack: <0>00000000 00000000 c01c0f88 00000000 00000000
c031fef0 00000005 00000202
<0>[43478.113464]        c717fa1c c031fef0 c124b510 c7237e60 c01bd97d
c031fef0 c124b510 c124b510
<0>[43478.126484]        00000000 c760c52c c7237e7c c01befe7 c124b510
00000000 ffffffed c760c52c
<0>[43478.139984] Call Trace:
<0>[43478.152627]  [<c0102a35>] show_stack_log_lvl+0xa5/0xad
<0>[43478.166200]  [<c0102b70>] show_registers+0x106/0x16f
<0>[43478.179852]  [<c0102d06>] die+0xb6/0x127
<0>[43478.193589]  [<c0109677>] do_page_fault+0x380/0x4b3
<0>[43478.207616]  [<c01026bf>] error_code+0x4f/0x60
<0>[43478.221803]  [<c01c0f88>] serial8250_startup+0x28f/0x2a9
<0>[43478.236340] Code: 38 43 78 75 02 b2 01 89 d0 eb 10 8b 41 70 39 43
70 0f 94 c0 0f b6 c0 eb 02 31 c0 5b 5d c3 90 90 90 55 89 e5 53 8b 5d 08
8b 55 0c <0f> b6 4b 12 0f b6 43 13 d3 e2 83 f8 02 74 1a 7f 05 48 74 09 eb
<4>[43478.322255]  BUG: gp_position/26205, lock held at task exit time!
<4>[43478.341721]  [c124b528] {uart_register_driver}
<4>[43478.359168] .. held by:       gp_position:26205 [c775dab0, 117]
<4>[43478.377112] ... acquired at:               uart_get+0x28/0xde

I've also done your suggestion and I've inserted "msleep(10);" just
before the "And clear the interrupt registers again for luck." and my
application is now running without problems fore more than 24H! So,
inserting a delay in this point definitely makes some difference (has
was with adding some extra printk() in several points of
serial8250_startup()).

This said, for me, this is definitely a software problem. The question
is were?
I would appreciate if you (or anyone) could give me any pointers on how
to detect the cause of my kernel Oops (perhaps activating extra kernel
debug?)

Thanks,
José Gonçalves


