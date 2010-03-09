Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0CITXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:23:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0CITXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:23:02 -0500
Date: Tue, 9 Mar 2010 14:22:38 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jblunck@suse.de, viro@zeniv.linux.org.uk, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] union-mount: Drive the union cache via dcache
Message-ID: <20100309192237.GA10605@shell>
References: <1267567889-4637-1-git-send-email-vaurora@redhat.com> <1267567889-4637-2-git-send-email-vaurora@redhat.com> <1267567889-4637-3-git-send-email-vaurora@redhat.com> <E1NmsUF-0003u0-19@pomaz-ex.szeredi.hu> <20100303214952.GD19689@shell> <E1NnE05-00069x-VI@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NnE05-00069x-VI@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 05:34:13PM +0100, Miklos Szeredi wrote:
> On Wed, 3 Mar 2010, Valerie Aurora wrote:
> > On Wed, Mar 03, 2010 at 06:35:55PM +0100, Miklos Szeredi wrote:
> > > On Tue,  2 Mar 2010, Valerie Aurora wrote:
> > > > +/*
> > > > + * This must be called after __d_drop_unions() without holding any locks.
> > > > + * Note: The dentry might still be reachable via a lookup but at that time it
> > > > + * already a negative dentry. Otherwise it would be unhashed. The union_mount
> > > > + * structure itself is still reachable through mnt->mnt_unions (which we
> > > > + * protect against with union_lock).
> > > > + *
> > > > + * We were worried about a recursive dput() call through:
> > > > + *
> > > > + * dput()->d_kill()->shrink_d_unions()->union_put()->dput()
> > > > + *
> > > > + * But this path can only be reached if the dentry is unhashed when we
> > > > + * enter the first dput(), and it can only be unhashed if it was
> > > > + * rmdir()'d, and d_delete() calls shrink_d_unions() for us.
> > > > + */
> > > > +void shrink_d_unions(struct dentry *dentry)
> > > > +{
> > > > +	struct union_mount *this, *next;
> > > > +
> > > > +repeat:
> > > > +	spin_lock(&union_lock);
> > > > +	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
> > > > +		BUG_ON(!hlist_unhashed(&this->u_hash));
> > > > +		BUG_ON(!hlist_unhashed(&this->u_rhash));
> > > > +		list_del(&this->u_unions);
> > > > +		this->u_next.dentry->d_unionized--;
> > > > +		spin_unlock(&union_lock);
> > > > +		union_put(this);
> > > > +		goto repeat;
> > > 
> > > This loop is weird.  That list_for_each_entry_safe is just used to
> > > initialize "this", since it unconditionally restarts from the
> > > beginning.
> > 
> > This loop is definitely weird, but the alternative is so simple
> > (replace the goto with a spin_lock()) that I suspect Jan had a reason
> > to write it this way.  Jan, do you recall?
> 
> Something like the following is equivalent but more readable:
> 
> 	struct list_head *head = &dentry->d_unions;
> 
> 	spin_lock(&union_lock);
> 	while (!list_empty(head) {
> 		this = list_entry(head->next, struct union_mount, u_unions);
> 		...
> 		spin_unlock(&union_lock);
> 		union_put(this);
> 		spin_lock(&union_lock);
> 	}
> 	spin_unlock(&union_lock);

Okay, I will rewrite it along those lines.  Thanks,

-VAL
