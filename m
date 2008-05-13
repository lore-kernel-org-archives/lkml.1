Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbYEMVdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbYEMVdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759074AbYEMVcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:32:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54334 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757750AbYEMVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:32:40 -0400
Date: Tue, 13 May 2008 16:32:39 -0500
From: Russ Anderson <rja@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 0/3] ia64: Migrate data off physical pages with correctable errors v3
Message-ID: <20080513213238.GA13951@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080509150937.GA16523@sgi.com> <alpine.LFD.1.10.0805090817280.3142@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805090817280.3142@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 08:21:32AM -0700, Linus Torvalds wrote:
> On Fri, 9 May 2008, Russ Anderson wrote:
> > 
> >   [2/3] page.discard.v2: Avoid putting a bad page back on the LRU.
> > 
> > 	page.discard are the arch independent changes.  It adds a new
> > 	page flag (PG_memerror) to mark the page as bad and prevent it
> > 	from being put back on the LRU.  PG_memerror is only defined
> > 	on 64 bit architectures. 
> 
> So I haven't looked at this a lot, but it strikes me that it look to be 
> much simple if you were to just increment the page count instead of 
> playing games in mm/page_alloc.c.

Looking closer at the code, it is possible to increment the page count
and avoid playing games in mm/page_alloc.c.  The page count cannot
be directly incremented, due to the way the migration code works, but,
as Christoph pointed out, the migration code increments the page count.
Preventing the bad pages from being returned to the LRU prevents
the reference counts from going to zero.  The net effect is as you
suggest.
 
> That will make sure that it never goes back on any free lists, and 
> requires no changes to the allocator. Hmm?

All the pages on the bad page list have a reference count of 1.

> I'm also not really seeing why this triggers on lru_cache_add(), since 
> that should only happen to new pages anyway. Who does lru_cache_add() on 
> old pages?

The change to lru_cache_add() is being removed.  I'll post the
updated patches shortly.

> 			Linus

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
