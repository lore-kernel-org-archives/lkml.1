Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbXFLLXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbXFLLXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXFLLXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:23:17 -0400
Received: from brick.kernel.dk ([80.160.20.94]:25242 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbXFLLXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:23:16 -0400
Date: Tue, 12 Jun 2007 13:20:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: splice: move balance_dirty_pages_ratelimited() outside of  splice actor
Message-ID: <20070612112059.GY18832@kernel.dk>
References: <200706112159.l5BLxF5x004043@hera.kernel.org> <20070611163433.dbc541ec.akpm@linux-foundation.org> <20070612063510.GO18832@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612063510.GO18832@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12 2007, Jens Axboe wrote:
> On Mon, Jun 11 2007, Andrew Morton wrote:
> > On Mon, 11 Jun 2007 21:59:15 GMT
> > Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> > 
> > > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=20d698db67059a63d217030dfd02872cb5f88dfb
> > > Commit:     20d698db67059a63d217030dfd02872cb5f88dfb
> > > Parent:     17374ff1aa9ce2a0597416a16729474b538af443
> > > Author:     Jens Axboe <jens.axboe@oracle.com>
> > > AuthorDate: Tue Jun 5 11:05:11 2007 +0200
> > > Committer:  Jens Axboe <jens.axboe@oracle.com>
> > > CommitDate: Fri Jun 8 08:33:59 2007 +0200
> > > 
> > >     splice: move balance_dirty_pages_ratelimited() outside of splice actor
> > >     
> > >     I've seen inode related deadlocks, so move this call outside of the
> > >     actor itself, which may hold the inode lock.
> > >     
> > 
> > eh?  If the pipe_to_file() caller holds inode_lock, our problems are large.
> > 
> > I doubt if that's true, so what problem is this patch really fixing??
> 
> I can repeatedly lock up balance_dirty_pages() if it's called inside the
> double lock of splice_from_pipe(). I'll fire up the test box and
> reproduce, then post the backtraces.

OK, here it is. Running

$ ./splice-fromnet 9999 | ./splice-out xxx

on one box (receive from network port 9999, store in file xxx) and a
simple

$ cat SUSE-Linux-10.1-GM-DVD-i386.iso | netcat centera 9999

on another box. After ~180mb has been transferred, splice-out gets
stuck. With the balancing moved outside of the splice actor, everything
works perfectly regardless of memory pressure.

splice-fromne S 00000000     0  9829   9778 (NOTLB)
   efe63d4c 00000046 f524cb20 00000000 efe63cfc c0144ae3 00000000 f524cb20
   c03c33fa f1b9ee0c 00000009 f524cb20 02ad51ce 00000024 00002406 f524cc30
   c1cf3980 00000001 efe63d44 00000246 f6692040 00000282 efe63d54 f2f83600
Call Trace:
 [<c01809bd>] pipe_wait+0x6d/0x90
 [<c0198006>] splice_to_pipe+0x196/0x240
 [<c035eb4d>] skb_splice_bits+0xcd/0xe0
 [<c038157b>] tcp_splice_data_recv+0x2b/0x40
 [<c0381501>] tcp_read_sock+0x131/0x180
 [<c0381f55>] tcp_splice_read+0x85/0x1e0
 [<c03572f5>] sock_splice_read+0x25/0x30
 [<c019743e>] do_splice_to+0x5e/0x80
 [<c0198beb>] sys_splice+0x1eb/0x200
 [<c010511e>] sysenter_past_esp+0x5f/0x99
 =======================
splice-out    D EF423C98     0  9830   9778 (NOTLB)
   ef423cac 00000046 00000002 ef423c98 ef423c94 00000000 00000046 f760ba98
   f760ba98 f760b9a0 00000006 f7cba0f0 02ca49b4 00000024 001cf7e6 f7cba200
   c1cf3980 00000001 c0144c73 c1cdaf78 f55c64c0 00000046 c1cdaf78 fffd5d5b
Call Trace:
 [<c03c272d>] io_schedule+0x1d/0x30
 [<c0154979>] sync_page+0x39/0x50
 [<c03c2d20>] __wait_on_bit_lock+0x40/0x70
 [<c0154929>] __lock_page+0x69/0x70
 [<c015a9c5>] write_cache_pages+0x105/0x2f0
 [<c015abd3>] generic_writepages+0x23/0x30
 [<c015ac29>] do_writepages+0x49/0x50
 [<c01960a4>] __writeback_single_inode+0x94/0x370
 [<c0196783>] sync_sb_inodes+0x1b3/0x270
 [<c0196aa8>] writeback_inodes+0xb8/0xf0
 [<c015afed>] balance_dirty_pages_ratelimited_nr+0x9d/0x1b0
 [<c01978b3>] pipe_to_file+0x163/0x260
 [<c0197a0f>] __splice_from_pipe+0x5f/0x250
 [<c0197d18>] splice_from_pipe+0x58/0x80
 [<c0197dc4>] generic_file_splice_write+0x54/0x100
 [<c01974bf>] do_splice_from+0x5f/0x80
 [<c0198bce>] sys_splice+0x1ce/0x200
 [<c010511e>] sysenter_past_esp+0x5f/0x99

There are two pdflushes, doing nothing:

 =======================
pdflush       S F7D8FF90     0   171      2 (L-TLB)
   f7d8ffa4 00000046 00000002 f7d8ff90 f7d8ff8c 00000000 f7c50b60 c055ebac
   f7c51090 00000001 0000000a f7c50b60 6fc07726 00000026 0002552e f7c50c70
   c1ce9980 00000000 c015b750 f7d8ff98 f71d8b80 c0498c8c 00000001 fffd86d8
Call Trace:
 [<c015b7ec>] pdflush+0x9c/0x1c0
 [<c013aa42>] kthread+0x42/0x70
 [<c0105e0b>] kernel_thread_helper+0x7/0x1c
 =======================
pdflush       S F7D91F90     0   172      2 (L-TLB)
   f7d91fa4 00000046 00000002 f7d91f90 f7d91f8c 00000000 f7ca6aa0 c055ebac
   f7ca6fd0 00000001 00000009 f7ca6aa0 01d76a76 00000024 003c4c0a f7ca6bb0
   c1ce9980 00000000 c015b750 f7d91f98 f7255dc0 c0498c8c 00000001 fffd5df9
Call Trace:
 [<c015b7ec>] pdflush+0x9c/0x1c0
 [<c013aa42>] kthread+0x42/0x70
 [<c0105e0b>] kernel_thread_helper+0x7/0x1c

-- 
Jens Axboe

