Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676Ab0A2WBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0A2WBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581Ab0A2WBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:01:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37579 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0A2WBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:01:09 -0500
Date: Fri, 29 Jan 2010 22:00:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: dentries: dentry defragmentation
Message-ID: <20100129220044.GA31305@ZenIV.linux.org.uk>
References: <20100129204931.789743493@quilx.com>
 <20100129205007.832823807@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129205007.832823807@quilx.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 02:49:48PM -0600, Christoph Lameter wrote:
> +		if ((d_unhashed(dentry) && list_empty(&dentry->d_lru)) ||
> +		   (!d_unhashed(dentry) && hlist_unhashed(&dentry->d_hash)) ||
> +		   (dentry->d_inode &&
> +		   !mapping_cap_writeback_dirty(dentry->d_inode->i_mapping)))
> +			/* Ignore this dentry */
> +			v[i] = NULL;
> +		else
> +			/* dget_locked will remove the dentry from the LRU */
> +			dget_locked(dentry);
> +	}
> +	spin_unlock(&dcache_lock);
> +	return NULL;
> +}

No.  As the matter of fact - fuck, no.  For one thing, it's going to race
with umount.  For another, kicking busy dentry out of hash is worse than
useless - you are just asking to get more and more copies of that sucker
in dcache.  This is fundamentally bogus, especially since there is a 100%
safe time for killing dentry - when dput() drives the refcount to 0 and
you *are* doing dput() on the references you've acquired.  If anything, I'd
suggest setting a flag that would trigger immediate freeing on the final
dput().

And that does not cover the umount races.  You *can't* go around grabbing
dentries without making sure that superblock won't be shut down under
you.  And no, I don't know how to deal with that cleanly - simply bumping
superblock ->s_count under sb_lock is enough to make sure it's not freed
under you, but what you want is more than that.  An active reference would
be enough, except that you'd get sudden "oh, sorry, now there's no way
to make sure that superblock is shut down at umount(2), no matter what kind
of setup you have".  So you really need to get ->s_umount held shared,
which is, not particulary locking-order-friendly, to put it mildly.
