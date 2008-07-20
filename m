Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYGTK5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYGTK5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 06:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbYGTK5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 06:57:40 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:36285 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015AbYGTK5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 06:57:37 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net
Subject: [bug] sparc64: kmalloc-64 padding and redzone overwritten
Date: Sun, 20 Jul 2008 12:57:30 +0200
User-Agent: KMail/1.9.9
Cc: kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807201257.30954.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	I'm getting these on sparc64 while running LTP on latest
Linus 2.6.26-03465-g5b664cb-dirty. It's dirty because of one-line pagemap
fix but that should't matter. The box is ultra 60 (sparc64).

=============================================================================
BUG kmalloc-64: Padding overwritten. 0xfffff800b601dfe0-0xfffff800b601dfff
-----------------------------------------------------------------------------

INFO: Slab 0x0000000201f484d0 objects=60 used=0 fp=0xfffff800b601d3a8 flags=0x00c3
Call Trace:
 [00000000004bd6ac] slab_err+0x54/0x60
 [00000000004bdc94] slab_pad_check+0x11c/0x160
 [00000000004bdd98] check_slab+0xc0/0xe0
 [00000000004bf080] __slab_alloc+0xc8/0x7a0
 [00000000004bfb38] kmem_cache_alloc+0xc0/0xe0
 [0000000000518210] ext3_init_block_alloc_info+0x18/0x60
 [000000000051c2e8] ext3_get_blocks_handle+0xa30/0xd20
 [000000000051c878] ext3_get_block+0x80/0xe0
 [00000000004ed384] __block_prepare_write+0x26c/0x520
 [00000000004ed6c0] block_write_begin+0x48/0xe0
 [000000000051e22c] ext3_write_begin+0xb4/0x1e0
 [00000000004988a8] generic_file_buffered_write+0xf0/0x6c0
 [0000000000499088] __generic_file_aio_write_nolock+0x210/0x3a0
 [0000000000499258] generic_file_aio_write+0x40/0xe0
 [0000000000518efc] ext3_file_write+0x24/0xe0
 [00000000004c40f0] do_sync_write+0x98/0xe0
 Padding 0xfffff800b601dfe0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 Padding 0xfffff800b601dff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
FIX kmalloc-64: Restoring 0xfffff800b601c000-0xfffff800b601dfff=0x5a

=============================================================================
BUG kmalloc-64: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xfffff800b601d3e8-0xfffff800b601d3ef. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522578455317 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522578455317 cpu=1515870810 pid=1515870810
INFO: Slab 0x0000000201f484d0 objects=60 used=0 fp=0xfffff800b601d3a8 flags=0x00c3
INFO: Object 0xfffff800b601d3a8 @offset=5032 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xfffff800b601d398:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xfffff800b601d3a8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xfffff800b601d3b8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xfffff800b601d3c8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xfffff800b601d3d8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Redzone 0xfffff800b601d3e8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xfffff800b601d428:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Call Trace:
 [00000000004bd7b4] print_trailer+0xfc/0x180
 [00000000004bde68] check_bytes_and_report+0xb0/0xe0
 [00000000004bdee8] check_object+0x50/0x2a0
 [00000000004bf5d0] __slab_alloc+0x618/0x7a0
 [00000000004bfb38] kmem_cache_alloc+0xc0/0xe0
 [0000000000518210] ext3_init_block_alloc_info+0x18/0x60
 [000000000051c2e8] ext3_get_blocks_handle+0xa30/0xd20
 [000000000051c878] ext3_get_block+0x80/0xe0
 [00000000004ed384] __block_prepare_write+0x26c/0x520
 [00000000004ed6c0] block_write_begin+0x48/0xe0
 [000000000051e22c] ext3_write_begin+0xb4/0x1e0
 [00000000004988a8] generic_file_buffered_write+0xf0/0x6c0
 [0000000000499088] __generic_file_aio_write_nolock+0x210/0x3a0
 [0000000000499258] generic_file_aio_write+0x40/0xe0
 [0000000000518efc] ext3_file_write+0x24/0xe0
 [00000000004c40f0] do_sync_write+0x98/0xe0
FIX kmalloc-64: Restoring 0xfffff800b601d3e8-0xfffff800b601d3ef=0xbb

FIX kmalloc-64: Marking all objects used

	Mariusz
