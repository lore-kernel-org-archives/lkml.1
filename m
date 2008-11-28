Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbYK1Xpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbYK1Xpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 18:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYK1Xpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 18:45:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46064 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYK1Xpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 18:45:38 -0500
Subject: Re: [PATCH -v3 8/8] dnotify: reimplement dnotify using fsnotify
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, hch@infradead.org, a.p.zijlstra@chello.nl
In-Reply-To: <20081128062505.GK28946@ZenIV.linux.org.uk>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172133.17115.96807.stgit@paris.rdu.redhat.com>
	 <20081128062505.GK28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 28 Nov 2008 18:44:44 -0500
Message-Id: <1227915884.3393.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 06:25 +0000, Al Viro wrote:
> On Tue, Nov 25, 2008 at 12:21:33PM -0500, Eric Paris wrote:
> > -	inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
> > -	dn->dn_next = inode->i_dnotify;
> > -	inode->i_dnotify = dn;
> > -	spin_unlock(&inode->i_lock);
> > -
> > -	if (filp->f_op && filp->f_op->dir_notify)
> > -		return filp->f_op->dir_notify(filp, arg);
> > +	dn->dn_next = entry->private;
> > +	entry->private = dn;
> > +	dnotify_recalc_inode_mask(entry);
> > +	spin_unlock(&inode->i_fsnotify_lock);
> > +	fsnotify_mark_put(entry);
> > +	fsnotify_put_group(dnotify_group);
> 
> Now, that is interesting - you've just taken out the fscked-in-head
> ->dir_notify().  The action is quite laudable, but it deserves being
> announced properly:
> 
> * Remove the hopelessly misguided ->dir_notify().  The only instance (cifs)
> has been broken by design from the very beginning; the objects it creates
> are never destroyed, keep references to struct file they can outlive, nothing
> that could possibly evict them exists on close(2) path *and* no locking
> whatsoever is done to prevent races with close(), should the previous, er,
> deficiencies someday be dealt with.
> 
> While we are at it, removing the only call of that method is obviously
> only a half of the job...

crap, I actually meant to move that out to the actual do_fcntl() call to
get it out of my way.  I did see that it is useless since we don't
handle responses in any way and obviously this has nothing to do with
dnotify.....

I'll poke the cifs people to see if they are ok with dropping it
altogether properly....

