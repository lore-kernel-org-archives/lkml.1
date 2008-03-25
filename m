Return-Path: <linux-kernel-owner+w=401wt.eu-S1761247AbYCYWCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247AbYCYWCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbYCYWC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:02:29 -0400
Received: from pat.uio.no ([129.240.10.15]:56588 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbYCYWC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:02:27 -0400
Subject: Re: [PATCH] vfs: Fix lock inversion in drop_pagecache_sb()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, dgc@sgi.com, wfg@mail.ustc.edu.cn,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080325125354.5f2da108.akpm@linux-foundation.org>
References: <20080325181227.GE5125@duck.suse.cz>
	 <20080325125354.5f2da108.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 18:01:44 -0400
Message-Id: <1206482504.20428.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 06B419DCDAA81CF3461F018BF14CD17CC85DAB4E
X-UiO-SR-test: FF18A1171845F7EEBCDA9E2D57D203314CA9A5AC
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 27 total 7518466 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-25 at 12:53 -0700, Andrew Morton wrote:
> On Tue, 25 Mar 2008 19:12:27 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > Fix longstanding lock inversion in drop_pagecache_sb by dropping inode_lock
> > before calling __invalidate_mapping_pages(). We just have to make sure
> > inode won't go away from under us by keeping reference to it and putting
> > the reference only after we have safely resumed the scan of the inode
> > list. A bit tricky but not too bad...
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > CC: Fengguang Wu <wfg@mail.ustc.edu.cn>
> > CC: David Chinner <dgc@sgi.com>
> > 
> > ---
> >  fs/drop_caches.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> > index 59375ef..f5aae26 100644
> > --- a/fs/drop_caches.c
> > +++ b/fs/drop_caches.c
> > @@ -14,15 +14,21 @@ int sysctl_drop_caches;
> >  
> >  static void drop_pagecache_sb(struct super_block *sb)
> >  {
> > -	struct inode *inode;
> > +	struct inode *inode, *toput_inode = NULL;
> >  
> >  	spin_lock(&inode_lock);
> >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> >  		if (inode->i_state & (I_FREEING|I_WILL_FREE))
> >  			continue;
> 
> OT: it might be worth having an `if (mapping->nrpages==0) continue' here.
> 
> > +		__iget(inode);
> > +		spin_unlock(&inode_lock);
> >  		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
> > +		iput(toput_inode);
> > +		toput_inode = inode;
> > +		spin_lock(&inode_lock);
> >  	}
> >  	spin_unlock(&inode_lock);
> > +	iput(toput_inode);
> >  }
> >  
> >  void drop_pagecache(void)
> 
> hrm.  So we have a random ref on an inode without holding inode_lock.  If
> we race with invalidate_list() we end up with an inode stuck on s_inodes
> and "Self-destruct in 5 seconds.  Have a nice day...", don't we?

Calling drop_pagecache_sb() without having a reference to 'sb'? Surely
not...

Trond

