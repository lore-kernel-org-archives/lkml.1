Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZCKMXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZCKMXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZCKMW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:22:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbZCKMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:22:56 -0400
Date: Wed, 11 Mar 2009 13:22:52 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>, stable@kernel.org
Subject: Re: [patch] fs: avoid I_NEW inodes
Message-ID: <20090311122251.GA24590@duck.suse.cz>
References: <20090305064554.GA11916@wotan.suse.de> <20090305100000.GA29177@duck.suse.cz> <20090305101637.GB17815@wotan.suse.de> <20090305111226.GB29531@duck.suse.cz> <20090310134106.GA15977@wotan.suse.de> <20090310160321.GB1190@duck.suse.cz> <20090311023429.GC16561@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311023429.GC16561@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-03-09 03:34:30, Nick Piggin wrote:
> On Tue, Mar 10, 2009 at 05:03:21PM +0100, Jan Kara wrote:
> > > Index: linux-2.6/fs/drop_caches.c
> > > ===================================================================
> > > --- linux-2.6.orig/fs/drop_caches.c
> > > +++ linux-2.6/fs/drop_caches.c
> > > @@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
> > >  
> > >  	spin_lock(&inode_lock);
> > >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > > -		if (inode->i_state & (I_FREEING|I_WILL_FREE))
> > > +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> > >  			continue;
> > >  		if (inode->i_mapping->nrpages == 0)
> > >  			continue;
> > > Index: linux-2.6/fs/inode.c
> > > ===================================================================
> > > --- linux-2.6.orig/fs/inode.c
> > > +++ linux-2.6/fs/inode.c
> > > @@ -356,6 +356,8 @@ static int invalidate_list(struct list_h
> > >  		if (tmp == head)
> > >  			break;
> > >  		inode = list_entry(tmp, struct inode, i_sb_list);
> > > +		if (inode->i_state & I_NEW)
> > > +			continue;
> >   If somebody is setting up inodes at this point, we are in serious
> > trouble I think. So WARN_ON would be more appropriate I think.
> 
> Really? Hmm, this is also called via flush_disk which seems like it
> can operate under a mounted filesystem?
  Ah, I was not following calls far enough. You're right.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
