Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZDAAxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZDAAxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZDAAx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:53:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:31322 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZDAAx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:53:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,304,1235980800"; 
   d="scan'208";a="126372487"
Date: Wed, 1 Apr 2009 08:53:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "stable@kernel.org" <stable@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jack@suse.cz" <jack@suse.cz>,
       "m.mizuma@jp.fujitsu.com" <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: [PATCH][RESEND for 2.6.29-rc8-mm1] skip I_CLEAR state inodes
Message-ID: <20090401005309.GA5628@localhost>
References: <20090318170237.8F6C.61FB500B@jp.fujitsu.com> <20090323103846.GA16577@localhost> <20090324155655.2684.61FB500B@jp.fujitsu.com> <20090324074457.GA7745@localhost> <20090324120502.GC23439@duck.suse.cz> <20090324124001.GA25326@localhost> <20090330071824.GA9260@localhost> <20090331164332.7093ac94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331164332.7093ac94.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 07:43:32AM +0800, Andrew Morton wrote:
> On Mon, 30 Mar 2009 15:18:24 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
>
> > clear_inode() will switch inode state from I_FREEING to I_CLEAR,
> > and do so _outside_ of inode_lock. So any I_FREEING testing is
> > incomplete without a coupled testing of I_CLEAR.
> >
> > So add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
> > add_dquot_ref().
> >
> > Masayoshi MIZUMA discovered the bug in drop_pagecache_sb() and Jan Kara
> > reminds fixing the other two cases.
>
> ok...
>
> But what is the user-visible consequence of this?  You cc'ed
> stable@kernel.org so I assume it's serious.  People will want to know
> what problem we're fixing!

Sorry, the changelog could be expanded with the following paragraph:

Fix real kernel panics.  Masayoshi MIZUMA has a nice panic flow:
----------------------------------------------------------------------
            [process A]               |        [process B]
 |                                    |
 |    prune_icache()                  | drop_pagecache()
 |      spin_lock(&inode_lock)        |   drop_pagecache_sb()
 |      inode->i_state |= I_FREEING;  |       |
 |      spin_unlock(&inode_lock)      |       V
 |          |                         |     spin_lock(&inode_lock)
 |          V                         |         |
 |      dispose_list()                |         |
 |        list_del()                  |         |
 |        clear_inode()               |         |
 |          inode->i_state = I_CLEAR  |         |
 |            |                       |         V
 |            |                       |      if (inode->i_state & (I_FREEING|I_WILL_FREE))
 |            |                       |              continue;           <==== NOT MATCH
 |            |                       |
 |            |                       | (DANGER from here on! Accessing disposing inode!)
 |            |                       |
 |            |                       |      __iget()
 |            |                       |        list_move() <===== PANIC on poisoned list !!
 V            V                       |
(time)
----------------------------------------------------------------------

Thanks,
Fengguang

> >
> > --- mm.orig/fs/drop_caches.c
> > +++ mm/fs/drop_caches.c
> > @@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
> >
> >  	spin_lock(&inode_lock);
> >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> > +		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
> >  			continue;
> >  		if (inode->i_mapping->nrpages == 0)
> >  			continue;
> > --- mm.orig/fs/fs-writeback.c
> > +++ mm/fs/fs-writeback.c
> > @@ -538,7 +538,8 @@ void generic_sync_sb_inodes(struct super
> >  		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> >  			struct address_space *mapping;
> >
> > -			if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> > +			if (inode->i_state &
> > +					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
> >  				continue;
> >  			mapping = inode->i_mapping;
> >  			if (mapping->nrpages == 0)
> > --- mm.orig/fs/quota/dquot.c
> > +++ mm/fs/quota/dquot.c
> > @@ -823,7 +823,7 @@ static void add_dquot_ref(struct super_b
> >
> >  	spin_lock(&inode_lock);
> >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> > +		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
> >  			continue;
> >  		if (!atomic_read(&inode->i_writecount))
> >  			continue;
