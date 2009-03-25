Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbZCZAEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbZCZAEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbZCZAEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:04:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756821AbZCZAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:04:30 -0400
Date: Wed, 25 Mar 2009 16:57:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903251649450.3032@localhost.localdomain>
References: <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz>
 <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu>
 <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Linus Torvalds wrote:
> 
> Yes, yes, it may need to allocate backing store (a page that was dirtied 
> by mmap), and I'm sure that's the reason for it all,

Hmm. Thinking about that, I'm not so sure. Shouldn't that backing store 
allocation happen when the page is actually dirtied on ext3?

I _suspect_ that goes back to the fact that ext3 is older than the 
"aops->set_page_dirty()" callback, and nobody taught ext3 to do the bmap's 
at dirty time, so now it does it at writeout time.

Anyway, there we are. Old filesystems do the wrong thing (block allocation 
while doing writeout because they don't do it when dirtying), and newer 
filesystems do the wrong thing (block allocations during writeout, because 
they want to do delayed allocation to do the inode dirtying after doing 
writeback).

And in either case, the VM is screwed, and can't ask for writeout, because 
it will be randomly throttled by the filesystem. So we do lots of async 
bdflush threads, which then causes IO ordering problems because now the 
writeout is all in random order.

			Linus
