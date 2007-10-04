Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXJDWyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXJDWyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbXJDWyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:54:12 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:57163 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbXJDWyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:54:12 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, jakub.bogusz@gemius.pl
In-reply-to: <20071004154348.71535f47.akpm@linux-foundation.org> (message from
	Andrew Morton on Thu, 4 Oct 2007 15:43:48 -0700)
Subject: Re: [patch 02/12] fuse: fix race between getattr and write
References: <20071002155026.650555479@szeredi.hu>
	<20071002155213.312599553@szeredi.hu> <20071004154348.71535f47.akpm@linux-foundation.org>
Message-Id: <E1IdZZp-0002Xp-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Oct 2007 00:53:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -228,6 +243,7 @@ static struct dentry *fuse_lookup(struct
> >  	struct fuse_conn *fc = get_fuse_conn(dir);
> >  	struct fuse_req *req;
> >  	struct fuse_req *forget_req;
> > +	u64 attr_version;
> >  
> >  	if (entry->d_name.len > FUSE_NAME_MAX)
> >  		return ERR_PTR(-ENAMETOOLONG);
> > @@ -242,6 +258,10 @@ static struct dentry *fuse_lookup(struct
> >  		return ERR_PTR(PTR_ERR(forget_req));
> >  	}
> >  
> > +	spin_lock(&fc->lock);
> > +	attr_version = fc->attr_version;
> > +	spin_unlock(&fc->lock);
> 
> You might want to do this (oft-repeated) operation in a little helper
> function.
> 
> Because I suspect that the lock isn't needed if CONFIG_64BIT=y.

You're perfectly right, although fuse is not yet at the stage, where
I'd bother too much with scalability optimizations like that ;)

But it's a good cleanup, and I'll do an incremental patch on top of
this if that's OK.

Miklos
