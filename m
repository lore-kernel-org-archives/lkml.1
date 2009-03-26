Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbZCZBmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbZCZBmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbZCZBmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:42:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbZCZBmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:42:10 -0400
Date: Wed, 25 Mar 2009 18:34:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090326002253.GC11024@duck.suse.cz>
Message-ID: <alpine.LFD.2.00.0903251826390.3032@localhost.localdomain>
References: <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu>
 <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <alpine.LFD.2.00.0903251649450.3032@localhost.localdomain> <20090326002253.GC11024@duck.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Jan Kara wrote:
>
>  1) We have to writeout blocks full of zeros on allocation so that we don't
> expose unallocated data => slight slowdown

Why? 

This is in _no_ way different from a regular "write()" system call. And 
there, we just attach the buffers to the page. If something crashes before 
the page actually gets written out, then we'll have hopefully never 
written out the metadata (that's what "data=ordered" means).

>  2) When blocksize < pagesize we must play nasty tricks for this to work
> (think about i_size = 1024, set_page_dirty(), truncate(f, 8192),
> writepage() -> uhuh, not enough space allocated)

Good point. I suspect not enough people have played around with 
"set_page_dirty()" to find these kinds of things. The VFS layer probably 
doesn't help sufficiently with the half-dirty pages, although the FS can 
obviously always look up the previously last page and do things manually 
if it wants to.

But yes, this is nasty.

>  3) We'll do allocation in the order in which pages are dirtied. Generally,
> I'd suspect this order to be less linear than the order in which writepages
> submit IO and thus it will result in the larger fragmentation of the file.
>   So it's not a clear win IMHO.

Yes, that may be the case.

Of course, the approach of just checking whether the buffer heads already 
exists and are mapped (before bothering with anything else) probably works 
fine in practice. In most loads, pages will have been dirtied by regular 
"write()" system calls, and then we will have the buffers pre-allocated 
regardless. 

			Linus
