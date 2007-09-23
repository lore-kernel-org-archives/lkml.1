Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbXIWRtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbXIWRtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 13:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXIWRsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 13:48:52 -0400
Received: from lazybastard.de ([212.112.238.170]:35801 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbXIWRsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 13:48:51 -0400
Date: Sun, 23 Sep 2007 19:44:03 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Andrea Arcangeli <andrea@suse.de>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070923174402.GA15525@lazybastard.org>
References: <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <87tzpvy9cb.fsf@informatik.uni-tuebingen.de> <20070915223032.GA6708@v2.random> <20070916174657.GA2393@lazybastard.org> <alpine.LFD.0.999.0709161112410.16478@woody.linux-foundation.org> <20070916182136.GC2393@lazybastard.org> <alpine.LFD.0.999.0709161128350.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0709161128350.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 September 2007 11:44:09 -0700, Linus Torvalds wrote:
> On Sun, 16 Sep 2007, Jörn Engel wrote:
> > 
> > My approach is to have one for mount points and ramfs/tmpfs/sysfs/etc.
> > which are pinned for their entire lifetime and another for regular
> > files/inodes.  One could take a three-way approach and have
> > always-pinned, often-pinned and rarely-pinned.
> > 
> > We won't get never-pinned that way.
> 
> That sounds pretty good. The problem, of course, is that most of the time, 
> the actual dentry allocation itself is done before you really know which 
> case the dentry will be in, and the natural place for actually giving the 
> dentry lifetime hint is *not* at "d_alloc()", but when we "instantiate" 
> it with d_add() or d_instantiate().
> 
> [...]
> 
> And yes, you'd end up with the reallocation overhead quite often, but at 
> least it would now happen only when filling in a dentry, not in the 
> (*much* more critical) cached lookup path.

There may be another approach.  We could create a never-pinned cache,
without trying hard to keep it full.  Instead of moving a hot dentry at
dput() time, we move a cold one from the end of lru.  And if the lru
list is short, we just chicken out.

Our definition of "short lru list" can either be based on a ratio of
pinned to unpinned dentries or on a metric of cache hits vs. cache
misses.  I tend to dislike the cache hit metric, because updatedb would
cause tons of misses and result in the same mess we have right now.

With this double cache, we have a source of slabs to cheaply reap under
memory pressure, but still have a performance advantage (memcpy beats
disk io by orders of magnitude).

Jörn

-- 
The story so far:
In the beginning the Universe was created.  This has made a lot
of people very angry and been widely regarded as a bad move.
-- Douglas Adams
