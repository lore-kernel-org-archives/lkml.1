Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbXE0CZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbXE0CZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 22:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXE0CZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 22:25:08 -0400
Received: from mail.fieldses.org ([66.93.2.214]:37480 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbXE0CZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 22:25:07 -0400
Date: Sat, 26 May 2007 22:25:02 -0400
To: David Howells <dhowells@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
Message-ID: <20070527022502.GB10867@fieldses.org>
References: <20070526022342.GA20905@fieldses.org> <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com> <7436.1180223730@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7436.1180223730@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 12:55:30AM +0100, David Howells wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> > > +	if (!afs_lock_manager) {
> > > +		afs_lock_manager = create_singlethread_workqueue("kafs_lockd");
> > > +		if (!afs_lock_manager)
> > > +			return -ENOMEM;
> > > +	}
> > > +	return 0;
> > 
> > Doesn't this need some locking?
> 
> Oops.  Yes.  It used to be inside the lock_kernel() section, but has since
> escaped.

The BKL wouldn't help, since create_singlethread_workqueue() can sleep.
Or am I missing something?

> > Do you allow upgrades and downgrades?  (Just curious.)
> 
> AFS does not, as far as I know.

So if I request a write lock while holding a read lock, my request will
be denied?

> > > +		/* if we've already got a readlock on the server and no waiting
> > > +		 * writelocks, then we might be able to instantly grant another
> > 
> > Is that comment correct?  (You don't really test for "waiting
> > writelocks", do you?)
> 
> Locally, yes.  'if (list_empty(&vnode->pending_locks))' covers it quite
> handily.

Oops, right, I was overlooking that check.

This is a little strange, though--if there's somebody waiting for a
write lock on an inode (because somebody else already holds a read lock
on it), that shouldn't block requests for read locks.

--b.
