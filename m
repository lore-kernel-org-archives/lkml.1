Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbYDVELh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbYDVELh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 00:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbYDVEL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 00:11:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47794 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750783AbYDVEL0 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 00:11:26 -0400
Date: Tue, 22 Apr 2008 14:10:51 +1000
From: David Chinner <dgc@sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: use smaller int param in call to xfs_flush_pages
Message-ID: <20080422041051.GT103491721@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804220433.04030.vda.linux@googlemail.com> <200804220503.16888.vda.linux@googlemail.com> <200804220514.45191.vda.linux@googlemail.com> <480D5900.2000106@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480D5900.2000106@sandeen.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 10:18:24PM -0500, Eric Sandeen wrote:
> FWIW this one also seems to make no stack difference, at least on x86_64.
> 
> Not complaining; just checking it out. :)
> 
> If you can shink xfs_bmapi, let me know.  :)

FWIW, the path we care about is this path through ->writepage:

(submit_bio)
_xfs_buf_ioapply		32
xfs_buf_iorequest		0
xfs_buf_iostart			0
xfs_buf_read_flags		0
xfs_trans_read_buf		4
xfs_btree_read_bufs		16
xfs_alloc_lookup		56
xfs_alloc_lookup_eq		16
xfs_alloc_fixup_trees		20
xfs_alloc_ag_vextent_near	76
xfs_alloc_ag_vextent		0
xfs_alloc_vextent		48
xfs_bmap_btalloc		164
xfs_bmap_alloc			0
xfs_bmapi			228
xfs_iomap_write_allocate	116
xfs_iomap			20
xfs_map_blocks			16
xfs_page_state_convert		124
xfs_vm_writepage		12
-------------------------------------
checkstack total:		948

Realistically, the onyl thing we can trim anything off is xfs_bmapi,
xfs_bmap_btalloc, xfs_iomap_write_allocate, and xfs_page_state_convert.
It's going to take a lot of work to get any significant change into
those functions given the complexity of them....

FWIW, if we've come through a syscall, the rest of the trace looks
like:

__writepage				0
write_cache_pages			100
generic_writepages			0
xfs_vm_writepages			12
do_writepages				0
__writeback_single_inode		36
sync_sb_inodes				40
writeback_inodes			0
balance_dirty_pages_ratelimited_nr	76
generic_file_buffered_write		96
xfs_write				80
xfs_file_aio_write			12
do_sync_write				140
vfs_write				12
--------------------------------------------
total					604

So the normal case uses 604 bytes prior to entering ->writepage.

It's when we are already using >2k of the stack when we enter
->writepage that we get into trouble....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
