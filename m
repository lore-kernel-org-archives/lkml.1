Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZCZAXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZCZAXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZCZAW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:22:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:35462 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZCZAW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:22:57 -0400
Date: Thu, 26 Mar 2009 01:22:53 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090326002253.GC11024@duck.suse.cz>
References: <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <alpine.LFD.2.00.0903251649450.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903251649450.3032@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 25-03-09 16:57:21, Linus Torvalds wrote:
> 
> 
> On Wed, 25 Mar 2009, Linus Torvalds wrote:
> > 
> > Yes, yes, it may need to allocate backing store (a page that was dirtied 
> > by mmap), and I'm sure that's the reason for it all,
> 
> Hmm. Thinking about that, I'm not so sure. Shouldn't that backing store 
> allocation happen when the page is actually dirtied on ext3?
  We don't do it currently. We could do it (it would also solve the problem
that we currently silently discard users data when he reaches his quota or
filesystem gets ENOSPC) but there are problems with it as well:
 1) We have to writeout blocks full of zeros on allocation so that we don't
expose unallocated data => slight slowdown
 2) When blocksize < pagesize we must play nasty tricks for this to work
(think about i_size = 1024, set_page_dirty(), truncate(f, 8192),
writepage() -> uhuh, not enough space allocated)
 3) We'll do allocation in the order in which pages are dirtied. Generally,
I'd suspect this order to be less linear than the order in which writepages
submit IO and thus it will result in the larger fragmentation of the file.
  So it's not a clear win IMHO.

> I _suspect_ that goes back to the fact that ext3 is older than the 
> "aops->set_page_dirty()" callback, and nobody taught ext3 to do the bmap's 
> at dirty time, so now it does it at writeout time.
> 
> Anyway, there we are. Old filesystems do the wrong thing (block allocation 
> while doing writeout because they don't do it when dirtying), and newer 
> filesystems do the wrong thing (block allocations during writeout, because 
> they want to do delayed allocation to do the inode dirtying after doing 
> writeback).
> 
> And in either case, the VM is screwed, and can't ask for writeout, because 
> it will be randomly throttled by the filesystem. So we do lots of async 
> bdflush threads, which then causes IO ordering problems because now the 
> writeout is all in random order.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
