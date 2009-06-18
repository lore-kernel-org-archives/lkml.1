Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbZFRSP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbZFRSP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZFRSPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:15:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32862 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZFRSPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:15:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZkpV7QaekIx2QZ4BnQDoFQiowcEGwm8Dki0loHCeSIBkUhma73/kpJK2s7worThxo
	uTrjKAE4A6IkpIUNdiRgg==
Date: Thu, 18 Jun 2009 11:15:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michael Tokarev <mjt@tls.msk.ru>
cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel
 problem?
In-Reply-To: <4A3A7FDE.2050301@msgid.tls.msk.ru>
Message-ID: <alpine.DEB.2.00.0906181100340.7878@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <4A37FE48.6070306@msgid.tls.msk.ru> <4A38ACC0.3060501@msgid.tls.msk.ru> <alpine.DEB.2.00.0906170542170.3600@p34.internal.lan>
 <4A38C7CA.7040005@msgid.tls.msk.ru> <20090617185139.GF24040@fieldses.org> <4A395119.5060108@msgid.tls.msk.ru> <alpine.DEB.2.00.0906171335590.4786@chino.kir.corp.google.com> <4A3A00D9.8090504@msgid.tls.msk.ru> <alpine.DEB.2.00.0906180956560.2894@chino.kir.corp.google.com>
 <4A3A7FDE.2050301@msgid.tls.msk.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Michael Tokarev wrote:

> > If it's the exact same trace, then the page allocation failure is occurring
> > as the result of slab's growth of the skbuff_head_cache cache, not
> > buffer_head.
> 
> See http://lkml.org/lkml/2009/6/16/550 -- second message in this thread
> is mine, it shows exactly the same trace.
> 

This is skbuff_head_cache, although it's not exactly the same trace: 
Justin is using e1000, you're using RealTek.  The end result is indeed the 
same, however.

> > So it appears as though the issue you're raising is that buffer_head is
> > consuming far too much memory, which causes the system to be oom when
> > attempting a GFP_ATOMIC allocation for skbuff_head_cache and is otherwise
> > unseen with alloc_buffer_head() because it is allowed to invoke direct
> > reclaim:
> > 
> > 	$ grep -r alloc_buffer_head\( fs/*
> > 	fs/buffer.c:		bh = alloc_buffer_head(GFP_NOFS);
> > 	fs/buffer.c:struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
> > 	fs/gfs2/log.c:	bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
> > 	fs/jbd/journal.c:	new_bh =
> > alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
> > 	fs/jbd2/journal.c:	new_bh =
> > alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
> 
> Might be.
> 
> Here, I see the following scenario.  With freshly booted server, 1.9Gb RAM,
> slabtop shows about 11K entries in buffer_head slab, and about 1.7Gb free RAM.
> 
> When starting writing from another machine to this one over nfs, buffer_head
> slab grows quite rapidly up to about 450K entries (total size 48940K) and
> free memory drops to almost zero -- this happens in first 1..2 minutes
> (GigE network, writing from /dev/zero using dd).
> 
> The cache does not grow further -- just because there's no free memory for
> growing.  On a 4Gb machine it grows up to about 920K objects.
> 
> And from time to time during write the same warning occurs.  And slows
> down write from ~70Mb/sec (it is almost the actual speed of the target
> drive - it can do ~80Mb/sec) to almost zero for several seconds.
> 

This is the memory information printed with your page allocation failure:

Jun 13 17:06:42 gnome vmunix: Mem-Info:
Jun 13 17:06:42 gnome vmunix: DMA per-cpu:
Jun 13 17:06:42 gnome vmunix: CPU    0: hi:    0, btch:   1 usd:   0
Jun 13 17:06:42 gnome vmunix: DMA32 per-cpu:
Jun 13 17:06:42 gnome vmunix: CPU    0: hi:  186, btch:  31 usd: 170
Jun 13 17:06:42 gnome vmunix: Active_anon:4641 active_file:35865 inactive_anon:16138
Jun 13 17:06:42 gnome vmunix:  inactive_file:417340 unevictable:451 dirty:1330 writeback:13820 unstable:0
Jun 13 17:06:42 gnome vmunix:  free:2460 slab:16669 mapped:3659 pagetables:304 bounce:0
Jun 13 17:06:42 gnome vmunix: DMA free:7760kB min:24kB low:28kB high:36kB active_anon:0kB inactive_anon:84kB active_file:760kB inactive_file
Jun 13 17:06:42 gnome vmunix: lowmem_reserve[]: 0 1938 1938 1938

ZONE_DMA is inaccessible, just like Justin's machine:
7760K free < 24K min + (1938 pages * 4K/page).

Jun 13 17:06:42 gnome vmunix: DMA32 free:2080kB min:5620kB low:7024kB high:8428kB active_anon:18564kB inactive_anon:64468kB active_file:1427
Jun 13 17:06:42 gnome vmunix: lowmem_reserve[]: 0 0 0 0

And ZONE_DMA32 is far below its minimum watermark.  I mentioned in 
response to David Miller earlier that GFP_ATOMIC allocations can access 
beyond its minimum watermark; this is a good example of that.  For 
__GFP_HIGH allocations, the minimum watermark is halved, so this zone is 
oom because 2080K free < (5620K min / 2).

Notice that you have 13820 pages under writeback, however.  That's almost 
54M of memory being written back compared to 65M of slab total.

So this page allocation failure is only indicating that we're failing 
because it's GFP_ATOMIC and we can't do any direct reclaim.  All other 
memory allocations can block and can writeback pages to free memory, so 
while it is still stressing the VM, we don't get the same failure messages 
for such allocations.  The page allocator simply blocks and retries the 
allocation again; no oom killing occurs because reclaim makes progress 
each time, certainly because of the pages under writeback.

pdflush will do this in the background so all is not lost if subsequent 
__GFP_WAIT allocations do not trigger reclaim.  You may find it helpful to 
tune /proc/sys/vm/dirty_background_ratio to be lower to start background 
writeback sooner under such stress.  Details are in
Documentation/sysctl/vm.txt.

> > > As far as I can see, the warning itself, while harmless, indicates some
> > > deeper problem.  Namely, we shouldn't have an OOM condition - the system
> > > is doing nothing but NFS, there's only one NFS client which writes single
> > > large file, the system has 2GB (or 4Gb on another machine) RAM.  It should
> > > not OOM to start with.
> > 
> > Thanks to the page allocation failure that Justin posted earlier, which
> > shows the state of the available system memory, it shows that the machine
> > truly is oom.  You seem to have isolated that to an enormous amount of
> > buffer_head slab, which is a good start.
> 
> It's not really slabs it seems.  In my case the total amount of buffer_heads
> is about 49Mb which is very small compared with the amount of memory on the
> system.  But as far as I can *guess* buffer_head is just that - head, a
> pointer to some other place...  Unwritten or cached data?
> 

While 49M may seem rather small compared to your 2G system, it represents 
75% of slab allocations as shown in your page allocation failure.
