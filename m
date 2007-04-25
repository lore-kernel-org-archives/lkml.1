Return-Path: <linux-kernel-owner+w=401wt.eu-S2992722AbXDYLg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992722AbXDYLg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992721AbXDYLg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:36:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35798 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992722AbXDYLgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:36:54 -0400
Date: Wed, 25 Apr 2007 13:35:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070425113530.GX9715@kernel.dk>
References: <20070424222105.883597089@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424222105.883597089@sgi.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24 2007, clameter@sgi.com wrote:
> V2->V3
> - More restructuring
> - It actually works!
> - Add XFS support
> - Fix up UP support
> - Work out the direct I/O issues
> - Add CONFIG_LARGE_BLOCKSIZE. Off by default which makes the inlines revert
>   back to constants. Disabled for 32bit and HIGHMEM configurations.
>   This also allows a gradual migration to the new page cache
>   inline functions. LARGE_BLOCKSIZE capabilities can be
>   added gradually and if there is a problem then we can disable
>   a subsystem.

I need this patch to actually boot the thing, or it bombs with a NULL
deref in page_cache_size().

It then boots, doing a little test with 8kb ext2 quickly dies though:

BUG: unable to handle kernel NULL pointer dereference at virtual address
000000ac
 printing eip:
d8149519
*pde = 00000000
Oops: 0002 [#1]
SMP 
Modules linked in: sunrpc button battery ac uhci_hcd ehci_hcd tg3 ide_cd
cdrom
CPU:    0
EIP:    0060:[<d8149519>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-rc7-g56a56164-dirty #131)
EIP is at 0xd8149519
eax: 000000ac   ebx: d81492a8   ecx: ddc4b804   edx: d837a940
esi: d81495b5   edi: d8149580   ebp: d814954c   esp: e9049d1c
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process fsck.ext2 (pid: 5604, ti=e9049000 task=f75c9030
task.ti=e9049000)
Stack: d81494e4 d8ebcac8 cd29113c 00000000 78337894 000241d0 7a33abd4
78337890 
       7813b751 00000044 78228db3 0000000f e9049d78 e9049e20 f75c9030
00000010 
       00000001 f7445680 79aa5540 00000003 7a33abd4 00000004 7813d35c
00000004 
Call Trace:
 [<7813b751>] __alloc_pages+0x5c/0x2a8
 [<78228db3>] sd_open+0x5e/0x106
 [<7813d35c>] __do_page_cache_readahead+0x109/0x123
 [<7813d48d>] blockable_page_cache_readahead+0x4a/0x9a
 [<7813d60f>] page_cache_readahead+0x8f/0x159
 [<78137d7b>] do_generic_mapping_read+0x17b/0x534
 [<781383d4>] generic_file_aio_read+0x19f/0x1c3
 [<78138134>] file_read_actor+0x0/0x101
 [<78151dee>] do_sync_read+0xbf/0xfc
 [<78127fbf>] autoremove_wake_function+0x0/0x33
 [<782a5bb5>] mutex_lock+0x13/0x22
 [<78151eb4>] vfs_read+0x89/0x104
 [<78152172>] sys_read+0x41/0x67
 [<78102548>] syscall_call+0x7/0xb
 [<782a0000>] bictcp_cong_avoid+0x110/0x3cd
 =======================
Code: b9 79 0d 00 00 00 00 02 00 00 00 1a ba d4 c0 aa 33 7a b4 b9 16 78
00 00 00 00 08 95 14 d8 08 95 14 d8 00 00 00 00 00 00 00 00 ac <00> 00
00 e4 94 14 d8 00 74 b9 79 0c 00 00 00 00 02 00 00 00 18 
EIP: [<d8149519>] 0xd8149519 SS:ESP 0068:e9049d1c

That's here:

        page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
                                zonelist, ALLOC_WMARK_LOW|ALLOC_CPUSET);
->     if (page)
                goto got_pg;

which doesn't look healthy. Note that this is a 32-bit machine, I
removed the 32-bit check (devices in this box are fine).

--- fs/libfs.c~	2007-04-25 13:30:50.000000000 +0200
+++ fs/libfs.c	2007-04-25 13:31:00.000000000 +0200
@@ -330,7 +330,7 @@
 int simple_prepare_write(struct file *file, struct page *page,
 			unsigned from, unsigned to)
 {
-	unsigned int page_size = page_cache_size(file->f_mapping);
+	unsigned int page_size = page_cache_size(page->mapping);
 
 	if (!PageUptodate(page)) {
 		if (to - from != page_size) {

-- 
Jens Axboe

