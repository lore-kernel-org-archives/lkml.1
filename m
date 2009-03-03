Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZCCPC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZCCPC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZCCPCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:02:20 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42600 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZCCPCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:02:19 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jan sonnek <ha2nny@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
	 <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 03 Mar 2009 15:01:20 +0000
Message-Id: <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2009 15:01:32.0485 (UTC) FILETIME=[F07C2F50:01C99C10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 10:41 +0000, Catalin Marinas wrote:
> On Mon, 2009-03-02 at 12:11 -0800, Andrew Morton wrote:
> > > Mar  1 00:06:51 localhost kernel: [   74.008165] unreferenced object 0xf6c4daf0 (size 52):
> > > Mar  1 00:06:51 localhost kernel: [   74.008170]   comm "swapper", pid 1, jiffies 4294893427
> > > Mar  1 00:06:51 localhost kernel: [   74.008175]   backtrace:
> > > Mar  1 00:06:51 localhost kernel: [   74.008179]     [<c018978c>] kmemleak_alloc+0x17e/0x28e
> > > Mar  1 00:06:51 localhost kernel: [   74.008185]     [<c0186b86>] kmem_cache_alloc+0xdc/0xe7
> > > Mar  1 00:06:51 localhost kernel: [   74.008190]     [<c01a53bd>] alloc_buffer_head+0x16/0x71
> > > Mar  1 00:06:51 localhost kernel: [   74.008196]     [<c01a5b91>] alloc_page_buffers+0x23/0xad
> > > Mar  1 00:06:51 localhost kernel: [   74.008200]     [<c01a5fd4>] __getblk+0x192/0x26b
> > > Mar  1 00:06:51 localhost kernel: [   74.008205]     [<c01d91f4>] jread+0x105/0x1de
> > > Mar  1 00:06:51 localhost kernel: [   74.008209]     [<c01d932b>] do_one_pass+0x5e/0x38c
> > > Mar  1 00:06:51 localhost kernel: [   74.008213]     [<c01d96f8>] journal_recover+0x41/0x9d
> > > Mar  1 00:06:51 localhost kernel: [   74.008218]     [<c01db8d4>] journal_load+0x47/0x7b
> > > Mar  1 00:06:51 localhost kernel: [   74.008221]     [<c01d43d1>] ext3_fill_super+0xe9d/0x144c
> > > Mar  1 00:06:51 localhost kernel: [   74.008225]     [<c018d721>] get_sb_bdev+0xfa/0x140
> > > Mar  1 00:06:51 localhost kernel: [   74.008231]     [<c01d2070>] ext3_get_sb+0x18/0x1a
> > > Mar  1 00:06:51 localhost kernel: [   74.008235]     [<c018c71f>] vfs_kern_mount+0x41/0x7c
> > > Mar  1 00:06:51 localhost kernel: [   74.008241]     [<c018c7a8>] do_kern_mount+0x37/0xbe
> > > Mar  1 00:06:51 localhost kernel: [   74.008247]     [<c019f0bf>] do_mount+0x5f7/0x630
> > > Mar  1 00:06:51 localhost kernel: [   74.008253]     [<c019f167>] sys_mount+0x6f/0xac
> > 
> > I suspect kmemleak has gone nuts here.
> 
> It seems that the buffer_head structure allocated above is stored in
> page->private. However, the page structures are no longer scanned in
> newer versions of kmemleak. That's the hunk that was removed after
> comments about the contiguity of a node's memory:
> 
> +     /* mem_map scanning */
> +     for_each_online_node(i) {
> +             struct page *page, *end;
> +
> +             page = NODE_MEM_MAP(i);
> +             end  = page + NODE_DATA(i)->node_spanned_pages;
> +
> +             scan_block(page, end, NULL);
> +     }
> 
> The alternative is to inform kmemleak about the page structures returned
> from __alloc_pages_internal() but there would be problems with recursive
> calls into kmemleak when it allocates its own data structures.
> 
> I'll look at re-adding the hunk above, maybe with some extra checks like
> pfn_valid().

Looking again at this, the node_mem_map is always contiguous and the
code above only scans the node_mem_map, not the memory represented by
the node (which may not be contiguous). So I think it is a valid code
sequence.

If the above gets too deep into the nodes structure, an alternative
would be:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 09b6fd7..0f17e62 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3552,6 +3552,11 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 		map = alloc_remap(pgdat->node_id, size);
 		if (!map)
 			map = alloc_bootmem_node(pgdat, size);
+		/*
+		 * Inform kmemleak to scan the node_mem_map arrays as the page
+		 * structure may contain pointers to other objects.
+		 */
+		kmemleak_alloc(map, size, 1, GFP_ATOMIC);
 		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
 	}
 #ifndef CONFIG_NEED_MULTIPLE_NODES

-- 
Catalin

