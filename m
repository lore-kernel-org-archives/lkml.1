Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbZHaK0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbZHaK0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZHaK0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:26:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54727 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZHaK0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:26:44 -0400
Date: Mon, 31 Aug 2009 19:26:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: page allocator regression on nommu
Message-ID: <20090831102642.GA30264@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
	Christoph Lameter <cl@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20090831074842.GA28091@linux-sh.org> <84144f020908310308i48790f78g5a7d73a60ea854f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908310308i48790f78g5a7d73a60ea854f8@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 01:08:19PM +0300, Pekka Enberg wrote:
> On Mon, Aug 31, 2009 at 10:48 AM, Paul Mundt<lethal@linux-sh.org> wrote:
> > modprobe: page allocation failure. order:7, mode:0xd0
> 
> OK, so we have order 7 page allocation here...
> 
[snip]
> > Active_anon:0 active_file:0 inactive_anon:0
> > ?inactive_file:0 unevictable:323 dirty:0 writeback:0 unstable:0
> > ?free:2967 slab:0 mapped:0 pagetables:0 bounce:0
> > Normal free:11868kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:1292kB present:16256kB pages_scanned:0 all_unreclaimable? no
> > lowmem_reserve[]: 0 0
> > Normal: 267*4kB 268*8kB 251*16kB 145*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB = 11868kB
> 
> ...but we seem to be all out of order > 3 pages. I'm not sure why
> commit 49255c619fbd482d704289b5eb2795f8e3b7ff2e changes any of this,
> though.
> 
Nor am I, but it does. With it reverted, all of the order-7 allocations
succeed just fine. With some debugging printks added:

usbcore: registered new device driver usb
alloc order 7 for 49000: pages 0c21c000
alloc order 7 for 49000: pages 0c21c000
...

While with it applied:

alloc order 7 for 49000:
modprobe: page allocation failure. order:7, mode:0xd0
...
Mem-Info:
Normal per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Active_anon:0 active_file:0 inactive_anon:0
 inactive_file:0 unevictable:323 dirty:0 writeback:0 unstable:0
 free:2911 slab:0 mapped:0 pagetables:0 bounce:0
Normal free:11644kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:1292kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
Normal: 259*4kB 264*8kB 247*16kB 142*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB = 11644kB
323 total pagecache pages
4096 pages RAM
662 pages reserved
226 pages shared
288 pages non-shared
0 pages in pagetable cache
-ENOMEM
Allocation of length 299008 from process 50 (modprobe) failed
Normal per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Active_anon:0 active_file:0 inactive_anon:0
 inactive_file:0 unevictable:323 dirty:0 writeback:0 unstable:0
 free:2911 slab:0 mapped:0 pagetables:0 bounce:0
Normal free:11644kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:1292kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
Normal: 259*4kB 264*8kB 247*16kB 142*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB = 11644kB
323 total pagecache pages

the -ENOMEM printk() I've placed in the alloc_pages() error path.

> > ------------[ cut here ]------------
> > kernel BUG at mm/nommu.c:598!
> > Kernel BUG: 003e [#1]
> > Modules linked in:
> >
> > Pid : 51, Comm: ? ? ? ? ? ? ? ? modprobe
> > CPU : 0 ? ? ? ? ? ? ? ? Not tainted ?(2.6.31-rc7 #2835)
> >
> > PC is at __put_nommu_region+0xe/0xb0
> > PR is at do_mmap_pgoff+0x8dc/0xa68
> 
> This looks to be a bug in nommu do_mmap_pgoff() error handling. I
> guess we shouldn't call __put_nommu_region() if add_nommu_region()
> hasn't been called?
> 
Yeah, that looks a bit suspect. __put_nommu_region() is safe to be called
without a call to add_nommu_region(), but we happen to trip over the BUG_ON()
in this case because we've never made a single addition to the region tree.

We probably ought to just up_write() and return if nommu_region_tree == RB_ROOT,
which is what I'll do unless David objects.
