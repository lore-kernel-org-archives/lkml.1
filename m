Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbYK1GZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbYK1GZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 01:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYK1GZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 01:25:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47775 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYK1GZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 01:25:08 -0500
Date: Fri, 28 Nov 2008 06:25:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v3 8/8] dnotify: reimplement dnotify using fsnotify
Message-ID: <20081128062505.GK28946@ZenIV.linux.org.uk>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com> <20081125172133.17115.96807.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125172133.17115.96807.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:21:33PM -0500, Eric Paris wrote:
> -	inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
> -	dn->dn_next = inode->i_dnotify;
> -	inode->i_dnotify = dn;
> -	spin_unlock(&inode->i_lock);
> -
> -	if (filp->f_op && filp->f_op->dir_notify)
> -		return filp->f_op->dir_notify(filp, arg);
> +	dn->dn_next = entry->private;
> +	entry->private = dn;
> +	dnotify_recalc_inode_mask(entry);
> +	spin_unlock(&inode->i_fsnotify_lock);
> +	fsnotify_mark_put(entry);
> +	fsnotify_put_group(dnotify_group);

Now, that is interesting - you've just taken out the fscked-in-head
->dir_notify().  The action is quite laudable, but it deserves being
announced properly:

* Remove the hopelessly misguided ->dir_notify().  The only instance (cifs)
has been broken by design from the very beginning; the objects it creates
are never destroyed, keep references to struct file they can outlive, nothing
that could possibly evict them exists on close(2) path *and* no locking
whatsoever is done to prevent races with close(), should the previous, er,
deficiencies someday be dealt with.

While we are at it, removing the only call of that method is obviously
only a half of the job...
