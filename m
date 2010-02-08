Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab0BHHdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:33:37 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59079 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0BHHdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:33:35 -0500
Date: Mon, 8 Feb 2010 08:33:34 +0100
From: Andreas Mohr <andi@lisas.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100208073334.GB7171@rhlx01.hs-esslingen.de>
References: <20100129185434.GH19501@one-eyed-alien.net> <1265045354.25750.52.camel@pc1117.cambridge.arm.com> <20100208065519.GE1290@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208065519.GE1290@ucw.cz>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 08, 2010 at 07:55:19AM +0100, Pavel Machek wrote:
> Plus it does unneccessary flushes on x86, etc...

Noticed that as well, there should be an arch-obeying helper for this.


On my MIPSEL, I had urb->transfer_buffer NULL ptr crashes
(I think that was expected in case of a certain DMA setup, Alan said).

However, even with NULL check added I still had:

hub 2-1.1:1.0: state 7 ports 7 chg 0000 evt 0010
Unhandled kernel unaligned access[#1]:
Cpu 0
$ 0   : 00000000 fffffffd 803b0000 00010000
$ 4   : 08002042 8143bfe0 0043bfe0 0000000d
$ 8   : 00000001 3b9aca00 c4653600 00000000
$12   : 00000049 3b9aca00 81dbc868 00000000
$16   : a1e00000 803b0000 8037f840 81dfaa80
$20   : 00000000 81dd5080 80000000 00000000
$24   : 00000000 80015a64
$28   : 8033a000 8033bc10 a1dd83cc 801da5e4
Hi    : 00000000
Lo    : 00000000
epc   : 800171e8 __flush_dcache_page+0x38/0x120
    Not tainted
ra    : 801da5e4 ehci_urb_done+0x180/0x1e4
Status: 10009002    KERNEL EXL
Cause : 00800010
BadVA : 08002056
PrId  : 00029029 (Broadcom BCM3302)
Modules linked in:
Process swapper (pid: 0, threadinfo=8033a000, task=8033c000, tls=00000000)
Stack : 00000000 00000000 81e04980 801c80ac a1dd9060 a1dd8394 ffffff6a ffffff6a
        81dfaa80 a1dd83cc a1dd8380 801db3a4 803a6a28 80068e9c 000003f8 00003fc0
        a1dd81cc 801dea58 00000001 00000000 a1dd9360 81dd5080 a1dd8380 10009001
        a1dd83cc 81dd5158 00000000 80318d44 81dd5158 00000001 00010031 801de8f4
        81dd5158 8033bce0 803a76a0 803a0000 8033d860 8004f924 00000219 00000043
        ...
Call Trace:
[<800171e8>] __flush_dcache_page+0x38/0x120
[<801da5e4>] ehci_urb_done+0x180/0x1e4
[<801db3a4>] qh_completions+0x484/0x554
[<801de8f4>] ehci_work+0x1ec/0xb68
[<801e2598>] ehci_irq+0x360/0x3a4
[<801c7cf8>] usb_hcd_irq+0x64/0x15c
[<80066d58>] handle_IRQ_event+0x90/0x280
[<80068e80>] handle_percpu_irq+0x48/0x9c
[<8000e228>] plat_irq_dispatch+0x15c/0x178
[<80001444>] ret_from_irq+0x0/0x4
[<80001680>] r4k_wait+0x20/0x40
[<8000fe34>] cpu_idle+0x30/0x60
[<80354a34>] start_kernel+0x338/0x350


Code: 00000000  10800029  3c02803b <8c820014> 14400026  3c02803b  8c83001c  2482001c  14620021
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Fatal exception in interrupt



Seems like BadVA : 08002056 really isn't as aligned (offset 0x6) as it should be.

I've given up on this now BTW, I'll wait until the dust has settled (i.e. some nice improvements
have found their way to the kernel) and retry in some months with a much newer kernel version
(currently patched-up 2.6.31.9) whether something remains to be fixed.
I'll work on more productive things such as submitting some waiting patches.

Andreas Mohr
