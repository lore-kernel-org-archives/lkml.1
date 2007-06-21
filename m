Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbXFUJcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbXFUJcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 05:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbXFUJcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 05:32:03 -0400
Received: from mail.atmel.fr ([81.80.104.162]:60740 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbXFUJcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 05:32:00 -0400
Message-ID: <467A4532.40301@rfo.atmel.com>
Date: Thu, 21 Jun 2007 11:30:26 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Oops in a driver while using SLUB as a SLAB allocator
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While debugging a Linux driver on my ARM platform 
(AT91), I switched on the 2.6.22-rc5 kernel. While 
reconfiguring it I selected CONFIG_SLUB as a SLAB allocator.

The sd/mmc driver I tried to run is vanilla driver 
which never, until now, produces Oops (at91_mci.c).

The oops seems to occur after a page unmapping using 
dma_unmap_page() followed by a flush_dcache_page() (in 
at91mci_post_dma_read()).

Here is the oops (driver verbose output included to show 
pages used for dma sg list) :

Starting kernel ...

Linux version 2.6.22-rc5 (user@location) (gcc version 3.4.2) #8 Thu Jun 21 11:05:18 CEST 2007
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
Machine: Atmel AT91SAM9263-EK
[..]
Memory: 64MB = 64MB total
Memory: 62012KB available (2492K code, 246K data, 116K init)
SLUB: Genslabs=23, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[..]
Probe MCI devices
pre dma read
Using transfer index 0
sg = c3d0be68
dma address = 23C54968, length = 8
Nothing left to transfer (index = 1)
pre dma read done
setting ier to 00000040
MCI irq: status = 0000C0ED, C07F0040, 00000040
Receive has ended
post dma read
finishing index 0
Unmapping page 23C54968
buffer = c3c54968, length = 8
post dma read done
[^ this transfert is ok]
[..]
pre dma read
Using transfer index 0
sg = c3d0be68
dma address = 203AFBC0, length = 64
Nothing left to transfer (index = 1)
pre dma read done
setting ier to 00000040
MCI irq: status = 0000C0ED, C07F0040, 00000040
Receive has ended
post dma read
finishing index 0
Unmapping page 203AFBC0
buffer = c03afbc0, length = 64
Unable to handle kernel NULL pointer dereference at virtual address 0000000d
pgd = c0004000
[0000000d] *pgd=00000000
Internal error: Oops: 1 [#1]
Modules linked in:
CPU: 0
PC is at get_index+0x1c/0x50
LR is at prio_tree_next+0x60/0x194
pc : [<c01098ac>]    lr : [<c0109fc4>]    Not tainted
sp : c3d0bca8  ip : ffffffdd  fp : c3d0bcb4
r10: 00000040  r9 : c3d0be78  r8 : c3d0bcc4
r7 : c3d0bcc0  r6 : 00000000  r5 : c029635c  r4 : c3d0bcfc
r3 : c3d0bcc0  r2 : c3d0bcc4  r1 : 00000001  r0 : c3d0bcc0
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  Segment kernel
Control: 5317F
Table: 20004000  DAC: 00000017
Process kmmcd (pid: 761, stack limit = 0xc3d0a258)
Stack: (0xc3d0bca8 to 0xc3d0c000)
bca0:                   c3d0bce8 c3d0bcb8 c0109fc4 c01098a0 c003efc0 c003ed50
bcc0: c3d0bcec c3d0bcd0 00000000 00000000 c0298594 c3d0be68 c3d649e0 c3d0bcf8
bce0: c3d0bcec c0067734 c0109f74 c3d0bd30 c3d0bcfc c002bd0c c0067728 00000000
bd00: 00000000 00000000 00000000 c029635c 00000000 00000000 c3d0a000 c3d0be68
bd20: 00000000 c3d0bd64 c3d0bd34 c017df00 c002bc14 ffffffff c005068c c3d6ce60
bd40: 00000000 00000000 0000000b 0000002c c3d0bea4 c3d0be78 c3d0bd84 c3d0bd68
bd60: c005a99c c017dd00 c029c4bc 0000000b c02c5f38 00000000 c3d0bd9c c3d0bd88
bd80: c005bd04 c005a968 0000000b c029c4bc c3d0bdbc c3d0bda0 c0025048 c005bc68
bda0: ffffffff fefff000 0000000b 00000001 c3d0be14 c3d0bdc0 c0025a84 c0025010
bdc0: 0000001b 00000001 c4880000 c07f0040 c3d0bed0 c3d64800 00000000 00000001
bde0: 0000002c c3d0bea4 c3d0be78 c3d0be14 c029ae50 c3d0be08 c029ae50 c017db6c
be00: 60000013 ffffffff c3d0be24 c3d0be18 c017dba0 c017db28 c3d0be40 c3d0be28
be20: c0179890 c017db90 00000000 c3d0be44 00000000 c3d0be64 c3d0be44 c01798f0
be40: c01797a8 00000000 c3d0be48 c3d0be48 00000000 c3c54800 c3d0bf0c c3d0be68
be60: c017c744 c01798c8 c02da5e0 00000bc0 203afbc0 00000040 05f5e100 00000000
be80: 00000040 00000001 00000000 00000200 00000040 00000000 c3d0bed0 00000001
bea0: c3d0be68 00000006 00fffff1 00000000 00000000 00000000 00000000 00000035
bec0: 00000000 00000000 c3d0be78 c3d0bed0 c3d0bea4 c3d0be78 00000000 c3d0be44
bee0: c01798a0 c03afbc0 c3c54800 c3c54958 c3d64800 c3c54948 00000000 00000000
bf00: c3d0bf58 c3d0bf10 c017be4c c017c61c c03afbc0 00000000 00000000 02250000
bf20: 00000000 03534453 44303147 8030b855 ff006ad3 c3d0bf5c c3d6496c c3d64800
bf40: 00000000 00000000 00000000 c3d0bf7c c3d0bf5c c017a080 c017b908 00ff8000
bf60: c3d6cde0 c0179f34 c3c4f280 c3d6cde0 c3d0bf94 c3d0bf80 c00499c0 c0179f44
bf80: c3d6cde8 c3d0bfac c3d0bfdc c3d0bf98 c0049b24 c0049918 00000000 c3c4f280
bfa0: c004d938 c3d0bfb8 c3d0bfb8 00000000 c3c4f280 c004d938 c3d0bfb8 c3d0bfb8
bfc0: fffffffc c0049a54 00000000 00000000 c3d0bff4 c3d0bfe0 c004d444 c0049a64
bfe0: 00000000 00000000 00000000 c3d0bff8 c003c3f4 c004d400 00000000 00000000
Backtrace:
[<c0109890>] (get_index+0x0/0x50) from [<c0109fc4>] (prio_tree_next+0x60/0x194)
[<c0109f64>] (prio_tree_next+0x0/0x194) from [<c0067734>] (vma_prio_tree_next+0x1c/0x88)
 r8:c3d649e0 r7:c3d0be68 r6:c0298594 r5:00000000 r4:00000000
[<c0067718>] (vma_prio_tree_next+0x0/0x88) from [<c002bd0c>] (flush_dcache_page+0x108/0x124)
[<c002bc04>] (flush_dcache_page+0x0/0x124) from [<c017df00>] (at91_mci_irq+0x210/0x45c)
 r6:00000000 r5:c3d0be68 r4:c3d0a000
[<c017dcf0>] (at91_mci_irq+0x0/0x45c) from [<c005a99c>] (handle_IRQ_event+0x44/0x80)
[<c005a958>] (handle_IRQ_event+0x0/0x80) from [<c005bd04>] (handle_level_irq+0xac/0x104)
 r7:00000000 r6:c02c5f38 r5:0000000b r4:c029c4bc
[<c005bc58>] (handle_level_irq+0x0/0x104) from [<c0025048>] (asm_do_IRQ+0x48/0x78)
 r5:c029c4bc r4:0000000b
[<c0025000>] (asm_do_IRQ+0x0/0x78) from [<c0025a84>] (__irq_svc+0x24/0x60)
Exception stack(0xc3d0bdc0 to 0xc3d0be08)
bdc0: 0000001b 00000001 c4880000 c07f0040 c3d0bed0 c3d64800 00000000 00000001
bde0: 0000002c c3d0bea4 c3d0be78 c3d0be14 c029ae50 c3d0be08 c029ae50 c017db6c
be00: 60000013 ffffffff
 r7:00000001 r6:0000000b r5:fefff000 r4:ffffffff
[<c017db18>] (at91mci_process_next+0x0/0x68) from [<c017dba0>] (at91_mci_request+0x20/0x24)
[<c017db80>] (at91_mci_request+0x0/0x24) from [<c0179890>] (mmc_start_request+0xf8/0x108)
[<c0179798>] (mmc_start_request+0x0/0x108) from [<c01798f0>] (mmc_wait_for_req+0x38/0x50)
 r6:00000000 r5:c3d0be44 r4:00000000
[<c01798b8>] (mmc_wait_for_req+0x0/0x50) from [<c017c744>] (mmc_sd_switch+0x138/0x160)
 r5:c3c54800 r4:00000000
[<c017c60c>] (mmc_sd_switch+0x0/0x160) from [<c017be4c>] (mmc_attach_sd+0x554/0x7e4)
[<c017b8f8>] (mmc_attach_sd+0x0/0x7e4) from [<c017a080>] (mmc_rescan+0x14c/0x20c)
[<c0179f34>] (mmc_rescan+0x0/0x20c) from [<c00499c0>] (run_workqueue+0xb8/0x14c)
 r7:c3d6cde0 r6:c3c4f280 r5:c0179f34 r4:c3d6cde0
[<c0049908>] (run_workqueue+0x0/0x14c) from [<c0049b24>] (worker_thread+0xd0/0xe4)
 r5:c3d0bfac r4:c3d6cde8
[<c0049a54>] (worker_thread+0x0/0xe4) from [<c004d444>] (kthread+0x54/0x7c)
 r7:00000000 r6:00000000 r5:c0049a54 r4:fffffffc
[<c004d3f0>] (kthread+0x0/0x7c) from [<c003c3f4>] (do_exit+0x0/0x75c)
 r5:00000000 r4:00000000
Code: e1d000b6 e241c024 e3500000 e1a00003 (0591300c)
Kernel panic - not syncing: Aiee, killing interrupt handler!


Note that when using CONFIG_SLAB the dma mapping adresses are :

dma address = 0x23D8AB68, length = 8
dma address = 0x23D453A0, length = 64
dma address = 0x23D30000, length = 4096
for instance.

and the driver behaves OK (like it behaves until now).

Do you find a reason why I cannot use SLUB ? Did I missed 
something or do I use a bad dma_xx or cache flush call in 
the driver ?

Thanks, regards,
-- 
Nicolas Ferre


