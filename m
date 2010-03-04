Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab0CDQel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:34:41 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42519 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab0CDQef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:34:35 -0500
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, jblunck@suse.de, viro@zeniv.linux.org.uk,
       hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20100303214952.GD19689@shell> (message from Valerie Aurora on
	Wed, 3 Mar 2010 16:49:52 -0500)
Subject: Re: [PATCH 2/6] union-mount: Drive the union cache via dcache
References: <1267567889-4637-1-git-send-email-vaurora@redhat.com> <1267567889-4637-2-git-send-email-vaurora@redhat.com> <1267567889-4637-3-git-send-email-vaurora@redhat.com> <E1NmsUF-0003u0-19@pomaz-ex.szeredi.hu> <20100303214952.GD19689@shell>
Message-Id: <E1NnE05-00069x-VI@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Mar 2010 17:34:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Valerie Aurora wrote:
> On Wed, Mar 03, 2010 at 06:35:55PM +0100, Miklos Szeredi wrote:
> > On Tue,  2 Mar 2010, Valerie Aurora wrote:
> > > +/*
> > > + * This must be called after __d_drop_unions() without holding any locks.
> > > + * Note: The dentry might still be reachable via a lookup but at that time it
> > > + * already a negative dentry. Otherwise it would be unhashed. The union_mount
> > > + * structure itself is still reachable through mnt->mnt_unions (which we
> > > + * protect against with union_lock).
> > > + *
> > > + * We were worried about a recursive dput() call through:
> > > + *
> > > + * dput()->d_kill()->shrink_d_unions()->union_put()->dput()
> > > + *
> > > + * But this path can only be reached if the dentry is unhashed when we
> > > + * enter the first dput(), and it can only be unhashed if it was
> > > + * rmdir()'d, and d_delete() calls shrink_d_unions() for us.
> > > + */
> > > +void shrink_d_unions(struct dentry *dentry)
> > > +{
> > > +	struct union_mount *this, *next;
> > > +
> > > +repeat:
> > > +	spin_lock(&union_lock);
> > > +	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
> > > +		BUG_ON(!hlist_unhashed(&this->u_hash));
> > > +		BUG_ON(!hlist_unhashed(&this->u_rhash));
> > > +		list_del(&this->u_unions);
> > > +		this->u_next.dentry->d_unionized--;
> > > +		spin_unlock(&union_lock);
> > > +		union_put(this);
> > > +		goto repeat;
> > 
> > This loop is weird.  That list_for_each_entry_safe is just used to
> > initialize "this", since it unconditionally restarts from the
> > beginning.
> 
> This loop is definitely weird, but the alternative is so simple
> (replace the goto with a spin_lock()) that I suspect Jan had a reason
> to write it this way.  Jan, do you recall?

Something like the following is equivalent but more readable:

	struct list_head *head = &dentry->d_unions;

	spin_lock(&union_lock);
	while (!list_empty(head) {
		this = list_entry(head->next, struct union_mount, u_unions);
		...
		spin_unlock(&union_lock);
		union_put(this);
		spin_lock(&union_lock);
	}
	spin_unlock(&union_lock);

Thanks,
Miklos
