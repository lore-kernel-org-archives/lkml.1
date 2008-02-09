Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYBIUqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYBIUqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 15:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYBIUqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 15:46:43 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:46503 "EHLO smpt.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753858AbYBIUql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 15:46:41 -0500
Message-ID: <47AE1123.40402@gandalf.sssup.it>
Date: Sat, 09 Feb 2008 21:46:27 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dwmw2@infradead.org
Subject: jffs2 summary buffer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The summary is allocated using the vmalloc
 
c->summary->sum_buf = vmalloc(c->sector_size);

The same buffer is using and passed to the under layer in the 
jffs2_sum_write_data:

  vecs[0].iov_base = &isum;
        vecs[0].iov_len = sizeof(isum);
        vecs[1].iov_base = c->summary->sum_buf;
        vecs[1].iov_len = datasize;

        sum_ofs = jeb->offset + c->sector_size - jeb->free_size;

        dbg_summary("JFFS2: writing out data to flash to pos : 0x%08x\n",
                    sum_ofs);

        ret = jffs2_flash_writev(c, vecs, 2, sum_ofs, &retlen, 0);

So maybe it can't be directly mapped using a dma_map_sync.

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1]
Modules linked in:
CPU: 0    Not tainted  (2.6.23.14 #26)
PC is at consistent_sync+0x60/0xe4
LR is at 0xc0221be4
pc : [<c0027540>]    lr : [<c0221be4>]    psr: 60000013
sp : c1b29bb8  ip : c0221be4  fp : c1b29bd0
r10: 00000000  r9 : c024c5f8  r8 : 00000001
r7 : c024c610  r6 : 00000001  r5 : c286f4d0  r4 : c286f0b0
r3 : 00000000  r2 : 00000001  r1 : 00000001  r0 : 00000028
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: 21cf0000  DAC: 00000017
Process pdflush (pid: 64, stack limit = 0xc1b28258)
Stack: (0xc1b29bb8 to 0xc1b2a000)
9ba0:                                                       2286f0b0 
c2860000
9bc0: c02f9500 c1b29bfc c1b29bd4 c01078c4 c00274f0 0000efc0 c1cff440 
00000420
9be0: 00000000 00002100 00000000 c141a680 c1b29c0c c1b29c00 c0129e38 
c01077d0
9c00: c1b29c5c c1b29c10 c012a38c c0129df4 00000004 c286f0b0 00000420 
c0329800
9c20: 00000420 00001df8 c286f0b0 00000000 c0329800 00000000 00557700 
00000000
9c40: 00557700 00000000 00000000 00002100 c1b29c80 c1b29c60 c0124e9c 
c012a1e4
9c60: c1b29cb4 c286f0b0 00002100 000041b0 c1a81e00 c1b29ce0 c1b29c84 
c00cfde8
9c80: c0124e04 c1b29cb4 c286f0b0 00000002 c1b29d18 c1a81f18 000020d0 
00557700
9ca0: 00000002 c286f0b0 c1b29d28 00000020 00555630 00000000 00555630 
c2870b93
9cc0: 00000000 c1a81e00 c1ae90a8 000041b0 00000615 c1b29d54 c1b29ce8 
c00d11e8
9ce0: c00cfb74 00555630 00000000 c1b29d28 00000000 000041d0 20061985 
000041d0
9d00: a909c0d4 000002f3 00000000 00000000 ed429247 6b7f8525 c1b29cf8 
00000020
9d20: c286d000 000041b0 c1a81e00 000000c4 c1ae90a8 c1a81e00 000043f8 
0000083c
9d40: c1b29dc0 000000c4 c1b29d88 c1b29d58 c00c5634 c00d0ed8 c1a81e00 
c1ae9110
9d60: 000000c4 c1a81e00 0000083c c1b29dc0 00000001 c02db440 c1fb952c 
c1b29da8
9d80: c1b29d8c c00c593c c00c55c4 c1fb952c 0000083c c02ee458 c1a81e00 
c1b29df0
9da0: c1b29dac c00ca054 c00c5918 c1b29dd4 c1b29dbc 00000001 c00e7ddc 
00000000
9dc0: 000000c4 00000001 c1fb952c 00002000 c02ee458 c1a48398 00000001 
c032f544
9de0: 00002000 c1b29ec8 c1b29df4 c00ca8ac c00ca008 c1b29e80 c009e47c 
00000018
9e00: 00000400 c02acc60 00004f00 00000018 c1a81e00 c1ae9214 00000000 
00003000
9e20: c02c38f0 c032f530 00000001 c1b29e58 c1b29e3c c0033c38 0000004a 
00000001
9e40: c032f55c c1b29e64 c1b29e54 c0088f90 c0088db4 0000004a c1b29e94 
c1b29e68
9e60: c0089bf8 c0088f84 c0043ff0 0000004a 00000001 c1bf7000 c1ae9214 
c1a81e2c
9e80: 00000000 00000000 c1b29ec8 c1b29e98 c00cd258 c008a4fc c1b29ebc 
c1b29ea8
9ea0: c1fb952c c032f530 c1a81e00 c1ae9214 c1a81e2c 00000000 00000000 
c1b29f08
9ec0: c1b29ecc c00cbbac c00ca504 00100100 00200200 c1a81e00 c1a81e2c 
c1b28000
9ee0: c0222874 c1a81e00 c1a81e2c 00555600 c0222874 00000000 00000000 
c1b29f28
9f00: c1b29f0c c00d012c c00cb560 c1a81e00 00000000 c1b28000 c0222874 
c1b29f40
9f20: c1b29f2c c00cce34 c00d0078 c1bf7000 c1bf703c c1b29f58 c1b29f44 
c0078014
9f40: c00cce00 c1b29fb0 c02267ec c1b29fa0 c1b29f5c c006000c c0077fb0 
00000000
9f60: 00000000 c1b29f88 00000000 00000000 00000000 00000000 00000000 
00000000
9f80: 00000025 00000000 c0222874 c1b29fb0 c02267ec c1b29fd8 c1b29fa4 
c0060da4
9fa0: c005ffcc c02c38a0 c005ffbc 00000000 c1b29fb0 c1b29fb0 ffffb421 
c1b28000
9fc0: 00000000 c0060c90 00000000 c1b29ff4 c1b29fdc c004ad70 c0060ca0 
00000000
9fe0: 00000000 00000000 00000000 c1b29ff8 c0039d24 c004ad24 e664d744 
3f62122c
Backtrace:
[<c00274e0>] (consistent_sync+0x0/0xe4) from [<c01078c4>] 
(spi_transfer+0x104/0x1c0)
 r6:c02f9500 r5:c2860000 r4:2286f0b0
[<c01077c0>] (spi_transfer+0x0/0x1c0) from [<c0129e38>] 
(do_spi_transfer+0x54/0x5c)
[<c0129de4>] (do_spi_transfer+0x0/0x5c) from [<c012a38c>] 
(at91_dataflash_write+0x1b8/0x2a0)
[<c012a1d4>] (at91_dataflash_write+0x0/0x2a0) from [<c0124e9c>] 
(part_write+0xa8/0xb0)
[<c0124df4>] (part_write+0x0/0xb0) from [<c00cfde8>] 
(jffs2_flash_writev+0x288/0x448)
 r6:c1a81e00 r5:000041b0 r4:00002100
[<c00cfb64>] (jffs2_flash_writev+0x4/0x448) from [<c00d11e8>] 
(jffs2_sum_write_sumnode+0x320/0x3e0)
[<c00d0ec8>] (jffs2_sum_write_sumnode+0x0/0x3e0) from [<c00c5634>] 
(jffs2_do_reserve_space+0x80/0x354)
[<c00c55b4>] (jffs2_do_reserve_space+0x0/0x354) from [<c00c593c>] 
(jffs2_reserve_space_gc+0x34/0x58)
[<c00c5908>] (jffs2_reserve_space_gc+0x0/0x58) from [<c00ca054>] 
(jffs2_garbage_collect_pristine+0x5c/0x38c)
 r7:c1a81e00 r6:c02ee458 r5:0000083c r4:c1fb952c
[<c00c9ff8>] (jffs2_garbage_collect_pristine+0x0/0x38c) from 
[<c00ca8ac>] (jffs2_garbage_collect_live+0x3b8/0x105c)
[<c00ca4f4>] (jffs2_garbage_collect_live+0x0/0x105c) from [<c00cbbac>] 
(jffs2_garbage_collect_pass+0x65c/0x714)
[<c00cb550>] (jffs2_garbage_collect_pass+0x0/0x714) from [<c00d012c>] 
(jffs2_flush_wbuf_gc+0xc4/0x198)
[<c00d0068>] (jffs2_flush_wbuf_gc+0x0/0x198) from [<c00cce34>] 
(jffs2_write_super+0x44/0x48)
 r7:c0222874 r6:c1b28000 r5:00000000 r4:c1a81e00
[<c00ccdf0>] (jffs2_write_super+0x0/0x48) from [<c0078014>] 
(sync_supers+0x74/0xac)
 r5:c1bf703c r4:c1bf7000
[<c0077fa0>] (sync_supers+0x0/0xac) from [<c006000c>] 
(wb_kupdate+0x50/0x140)
 r5:c02267ec r4:c1b29fb0
[<c005ffbc>] (wb_kupdate+0x0/0x140) from [<c0060da4>] (pdflush+0x114/0x1d8)
 r5:c02267ec r4:c1b29fb0
[<c0060c90>] (pdflush+0x0/0x1d8) from [<c004ad70>] (kthread+0x5c/0x90)
 r7:00000000 r6:c0060c90 r5:00000000 r4:c1b28000
[<c004ad14>] (kthread+0x0/0x90) from [<c0039d24>] (do_exit+0x0/0x744)
 r6:00000000 r5:00000000 r4:00000000
Code: e59f0084 e1a01005 eb004440 e3a03000 (e5833000)
WARNING: at kernel/exit.c:892 do_exit()
[<c0026740>] (dump_stack+0x0/0x14) from [<c0039d68>] (do_exit+0x44/0x744)
[<c0039d24>] (do_exit+0x0/0x744) from [<c0026d30>] (die+0x2a0/0x2fc)
[<c0026a90>] (die+0x0/0x2fc) from [<c0027ee0>] (__do_kernel_fault+0x6c/0x7c)
[<c0027e74>] (__do_kernel_fault+0x0/0x7c) from [<c0028154>] 
(do_page_fault+0x1f8/0x214)
 r7:c1b29b70 r6:c02c38a0 r5:c022013c r4:ffffffff
[<c0027f5c>] (do_page_fault+0x0/0x214) from [<c00221e0>] 
(do_DataAbort+0x3c/0xa0)
[<c00221a4>] (do_DataAbort+0x0/0xa0) from [<c0022a00>] 
(__dabt_svc+0x40/0x60)
Exception stack(0xc1b29b70 to 0xc1b29bb8)
9b60:                                     00000028 00000001 00000001 
00000000
9b80: c286f0b0 c286f4d0 00000001 c024c610 00000001 c024c5f8 00000000 
c1b29bd0
9ba0: c0221be4 c1b29bb8 c0221be4 c0027540 60000013 
ffffffff                  
 r8:00000001 r7:c024c610 r6:00000001 r5:c1b29ba4 r4:ffffffff
[<c00274e0>] (consistent_sync+0x0/0xe4) from [<c01078c4>] 
(spi_transfer+0x104/0x1c0)
 r6:c02f9500 r5:c2860000 r4:2286f0b0
[<c01077c0>] (spi_transfer+0x0/0x1c0) from [<c0129e38>] 
(do_spi_transfer+0x54/0x5c)
[<c0129de4>] (do_spi_transfer+0x0/0x5c) from [<c012a38c>] 
(at91_dataflash_write+0x1b8/0x2a0)
[<c012a1d4>] (at91_dataflash_write+0x0/0x2a0) from [<c0124e9c>] 
(part_write+0xa8/0xb0)
[<c0124df4>] (part_write+0x0/0xb0) from [<c00cfde8>] 
(jffs2_flash_writev+0x288/0x448)
 r6:c1a81e00 r5:000041b0 r4:00002100
[<c00cfb64>] (jffs2_flash_writev+0x4/0x448) from [<c00d11e8>] 
(jffs2_sum_write_sumnode+0x320/0x3e0)
[<c00d0ec8>] (jffs2_sum_write_sumnode+0x0/0x3e0) from [<c00c5634>] 
(jffs2_do_reserve_space+0x80/0x354)
[<c00c55b4>] (jffs2_do_reserve_space+0x0/0x354) from [<c00c593c>] 
(jffs2_reserve_space_gc+0x34/0x58)
[<c00c5908>] (jffs2_reserve_space_gc+0x0/0x58) from [<c00ca054>] 
(jffs2_garbage_collect_pristine+0x5c/0x38c)
 r7:c1a81e00 r6:c02ee458 r5:0000083c r4:c1fb952c
[<c00c9ff8>] (jffs2_garbage_collect_pristine+0x0/0x38c) from 
[<c00ca8ac>] (jffs2_garbage_collect_live+0x3b8/0x105c)
[<c00ca4f4>] (jffs2_garbage_collect_live+0x0/0x105c) from [<c00cbbac>] 
(jffs2_garbage_collect_pass+0x65c/0x714)
[<c00cb550>] (jffs2_garbage_collect_pass+0x0/0x714) from [<c00d012c>] 
(jffs2_flush_wbuf_gc+0xc4/0x198)
[<c00d0068>] (jffs2_flush_wbuf_gc+0x0/0x198) from [<c00cce34>] 
(jffs2_write_super+0x44/0x48)
 r7:c0222874 r6:c1b28000 r5:00000000 r4:c1a81e00
[<c00ccdf0>] (jffs2_write_super+0x0/0x48) from [<c0078014>] 
(sync_supers+0x74/0xac)
 r5:c1bf703c r4:c1bf7000
[<c0077fa0>] (sync_supers+0x0/0xac) from [<c006000c>] 
(wb_kupdate+0x50/0x140)
 r5:c02267ec r4:c1b29fb0
[<c005ffbc>] (wb_kupdate+0x0/0x140) from [<c0060da4>] (pdflush+0x114/0x1d8)
 r5:c02267ec r4:c1b29fb0
[<c0060c90>] (pdflush+0x0/0x1d8) from [<c004ad70>] (kthread+0x5c/0x90)
 r7:00000000 r6:c0060c90 r5:00000000 r4:c1b28000
[<c004ad14>] (kthread+0x0/0x90) from [<c0039d24>] (do_exit+0x0/0x744)
 r6:00000000 r5:00000000 r4:00000000

The solution was to copy in a safely buffer. Can be this affect others 
drivers?

Regards Michael


