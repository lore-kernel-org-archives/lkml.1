Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968Ab0ATXgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0ATXgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538Ab0ATXgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:36:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab0ATXgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:36:39 -0500
Date: Wed, 20 Jan 2010 18:31:02 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/41] VFS: Introduce dput() variant that maintains a kill-list
Message-ID: <20100120233102.GA16090@shell>
References: <1256152779-10054-7-git-send-email-vaurora@redhat.com> <200911300228.nAU2Se3A007387@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300228.nAU2Se3A007387@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 09:28:40PM -0500, Erez Zadok wrote:
> In message <1256152779-10054-7-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > This patch introduces a new variant of dput(). This becomes necessary to
> > prevent a recursive call to dput() from the union mount code.
> > 
> >   void __dput(struct dentry *dentry, struct list_head *list, int greedy);
> >   struct dentry *__d_kill(struct dentry *dentry, struct list_head *list,
> >   	 		  int greedy);
> > 
> > __dput() works mostly like the original dput() did. The main difference is
> > that if it the greedy argument is zero it will put the parent on a special
> > list instead of trying to get rid of it directly.
> > 
> > Therefore the union mount code can safely call __dput() when it wants to get
> > rid of underlying dentry references during a dput(). After calling __dput()
> > or __d_kill() the caller must make sure that __d_kill_final() is called on all
> > dentries on the kill list. __d_kill_final() is actually doing the
> > dentry_iput() and is also dereferencing the parent.
> 
> From the description above, there is something somewhat unclean about all
> the special things that now have to happen: a special flags to affect how a
> function behaves, an extra requirement on the caller of __d_kill, etc.  I
> wonder if there is a clear way to achieve this.

I looked into this some more, and looks like this patch might be
unnecessary with the current code base.

We were worried about a recursive dput() call through:

dput()->d_kill()->shrink_d_unions()->union_put()->dput()

But this path can only be reached if the dentry is unhashed when we
enter the first dput(), and it can only be unhashed if it was
rmdir()'d, and that means we called d_delete(), and d_delete() calls
shrink_d_unions() for us.  So if we do call d_kill() from dput(), the
unions are already gone and there is no danger of calling dput()
again.

Jan, does this make sense?  If not, do you have a test case that
triggers a recursive dput()?

Thanks,

-VAL

> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  fs/dcache.c |  115 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 files changed, 105 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 38bf982..3415e9e 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -157,14 +157,19 @@ static void dentry_lru_del_init(struct dentry *dentry)
> >  }
> >  
> >  /**
> > - * d_kill - kill dentry and return parent
> > + * __d_kill - kill dentry and return parent
> >   * @dentry: dentry to kill
> > + * @list: kill list
> > + * @greedy: return parent instead of putting it on the kill list
> >   *
> >   * The dentry must already be unhashed and removed from the LRU.
> >   *
> > - * If this is the root of the dentry tree, return NULL.
> > + * If this is the root of the dentry tree, return NULL. If greedy is zero, we
> > + * put the parent of this dentry on the kill list instead. The callers must
> > + * make sure that __d_kill_final() is called on all dentries on the kill list.
> >   */
> > -static struct dentry *d_kill(struct dentry *dentry)
> > +static struct dentry *__d_kill(struct dentry *dentry, struct list_head *list,
> > +			       int greedy)
> 
> If you're keeping 'greedy' then perhaps make it a bool instead of 'int';
> that way you don't have to pass an unclear '0' or '1' in the rest of the
> code.
> 
> > +void __dput(struct dentry *, struct list_head *, int);
> 
> Can you move the __dput() code here and avoid the forward function
> declaration?
> 
> Can __dput() be made static, or you need to call it from elsewhere.  I
> didn't see an extern for it in this patch.  If there's an extern in another
> patch, then it should be moved here.
> 
> > +static void __d_kill_final(struct dentry *dentry, struct list_head *list)
> > +{
> 
> Your patch header says that the caller of __dput or _-d_kill must called
> __d_kill_final.  So shouldn't this be a non-static extern'ed function?
> 
> Either way, I suggest documenting in a comment above __d_kill_final() who
> should call it and under what circumstances.
> 
> 
> > +			iput(inode);
> > +	}
> > +
> > +	if (IS_ROOT(dentry))
> > +		parent = NULL;
> > +	else
> > +		parent = dentry->d_parent;
> > +	d_free(dentry);
> > +	__dput(parent, list, 1);
> > +}
> > +
> > +/**
> > + * d_kill - kill dentry and return parent
> > + * @dentry: dentry to kill
> > + *
> > + * The dentry must already be unhashed and removed from the LRU.
> > + *
> > + * If this is the root of the dentry tree, return NULL.
> > + */
> > +static struct dentry *d_kill(struct dentry *dentry)
> > +{
> > +	LIST_HEAD(mortuary);
> > +	struct dentry *parent;
> > +
> > +	parent = __d_kill(dentry, &mortuary, 1);
> > +	while (!list_empty(&mortuary)) {
> > +		dentry = list_entry(mortuary.next, struct dentry, d_lru);
> > +		list_del(&dentry->d_lru);
> > +		__d_kill_final(dentry, &mortuary);
> > +	}
> > +
> > +	return parent;
> > +}
> > +
> >  /* 
> >   * This is dput
> >   *
> > @@ -199,19 +266,24 @@ static struct dentry *d_kill(struct dentry *dentry)
> >   * Real recursion would eat up our stack space.
> >   */
> >  
> > -/*
> > - * dput - release a dentry
> > - * @dentry: dentry to release 
> > +/**
> > + * __dput - release a dentry
> > + * @dentry: dentry to release
> > + * @list: kill list argument for __d_kill()
> > + * @greedy: greedy argument for __d_kill()
> >   *
> >   * Release a dentry. This will drop the usage count and if appropriate
> >   * call the dentry unlink method as well as removing it from the queues and
> >   * releasing its resources. If the parent dentries were scheduled for release
> > - * they too may now get deleted.
> > + * they too may now get deleted if @greedy is not zero. Otherwise parent is
> > + * added to the kill list. The callers must make sure that __d_kill_final() is
> > + * called on all dentries on the kill list.
> > + *
> > + * You probably want to use dput() instead.
> >   *
> >   * no dcache lock, please.
> >   */
> > -
> > -void dput(struct dentry *dentry)
> > +void __dput(struct dentry *dentry, struct list_head *list, int greedy)
> >  {
> 
> I wonder now if the "__" prefix in __dput is appropriate: usually it's
> reserved for "hidden" internal functions that are not supposed to be called
> by other users, right?  I try to avoid naming things FOO and __FOO because
> the name alone doesn't help me understand what each one might be doing.  So
> maybe rename __dput() to something more descriptive?
> 
> Erez.
