Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYKUSoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYKUSoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYKUSoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:44:05 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42187 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYKUSoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:44:03 -0500
Date: Fri, 21 Nov 2008 11:43:45 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, cl@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       efault@gmx.de, a.p.zijlstra@chello.nl,
       Linux Netdev List <netdev@vger.kernel.org>, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: pipe/sockets/anon dentries should have themselves as parent
Message-ID: <20081121184344.GC5707@parisc-linux.org>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121153626.GA9281@infradead.org> <4926F6C5.9030108@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4926F6C5.9030108@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 06:58:29PM +0100, Eric Dumazet wrote:
> +/**
> + * d_alloc_unhashed - allocate unhashed dentry
> + * @inode: inode to allocate the dentry for
> + * @name: dentry name

It's normal to list the parameters in the order they're passed to the
function.  Not sure if we have a tool that checks for this or not --
Randy?

> + *
> + * Allocate an unhashed dentry for the inode given. The inode is
> + * instantiated and returned. %NULL is returned if there is insufficient
> + * memory. Unhashed dentries have themselves as a parent.
> + */
> + 
> +struct dentry * d_alloc_unhashed(const char *name, struct inode *inode)
> +{
> +	struct qstr q = { .name = name, .len = strlen(name) };
> +	struct dentry *res;
> +
> +	res = d_alloc(NULL, &q);
> +	if (res) {
> +		res->d_sb = inode->i_sb;
> +		res->d_parent = res;
> +		/*
> +		 * We dont want to push this dentry into global dentry hash table.
> +		 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
> +		 * This permits a working /proc/$pid/fd/XXX on sockets,pipes,anon
> +		 */

Line length ... as checkpatch would have warned you ;-)

And there are several other grammatical nitpicks with this comment.  Try
this:

		/*
		 * We don't want to put this dentry in the global dentry
		 * hash table, so we pretend the dentry is already hashed
		 * by unsetting DCACHE_UNHASHED.  This permits 
		 * /proc/$pid/fd/XXX t work for sockets, pipes and
		 * anonymous files (signalfd, timerfd, etc).
		 */

> +		res->d_flags &= ~DCACHE_UNHASHED;
> +		res->d_flags |= DCACHE_DISCONNECTED;

Is this really better than:

		res->d_flags = res->d_flags & ~DCACHE_UNHASHED |
						DCACHE_DISCONNECTED;

Anyway, nice cleanup.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
