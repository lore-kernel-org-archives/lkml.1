Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZCMKp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZCMKp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZCMKps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:45:48 -0400
Received: from cmpxchg.org ([85.214.51.133]:44069 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZCMKpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:45:47 -0400
Date: Fri, 13 Mar 2009 11:44:42 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Message-ID: <20090313104442.GB2119@cmpxchg.org>
References: <20090313105618.43DF.A69D9226@jp.fujitsu.com> <1236931036.5188.80.camel@laptop> <20090313170058.6840.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313170058.6840.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 05:15:44PM +0900, KOSAKI Motohiro wrote:
> > > > > 	The ramfs stuff is rather icky in that it adds the pages to the aging
> > > > > 	list, marks them dirty, but does not provide a writeout method. 
> > > > > 
> > > > > 	This will make the paging code scan over them (continuously) trying to
> > > > > 	clean them, failing that (lack of writeout method) and putting them back
> > > > > 	on the list.
> > > > > 
> > > > > Not requiring the pages to be added to the LRU would be a really good idea.
> > > > > They are not discardable, be it in MMU or NOMMU mode, except when the inode
> > > > > itself is discarded.
> > > > 
> > > > Yep, these pages shouldn't be on the LRU at all.  I guess that will
> > > > require some tweaks to core filemap.c code.
> > > 
> > > IMHO, UNEVICTABLE_LRU already does lru isolation.
> > > only rest prblem is, getting rid of "depends on MMU" line in mm/Kconfig.
> > > 
> > > Am I missing anything?
> > 
> > Yes, the need to take something off that shouldn't be there to begin
> > with.
> 
> In past unevictable lru discussion, we discuss the same thing.
> at that time, we found two reason of unevictable lru is better than 
> completely taking off.
> 
> (1) page migration code depend on the page stay on lru.
> (2) "taking off at reclaim time" can avoid adding lock to fastpath.
>     anyway, complely removing from lru need something lock.
>     we disliked it at that time.

Agreed with (1).  NOMMU can't support migration, though.  But keeping
them off the LRU on NOMMU needs adjustment of the page cache
read/write code in mm/filemap.c.

I'm not quite sure I understand (2).  But never adding these pages on
the LRU means we never have to remove them anywhere, no?

	Hannes
