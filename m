Return-Path: <linux-kernel-owner+w=401wt.eu-S1946544AbXBJABM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946544AbXBJABM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423372AbXBJABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:01:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423368AbXBJABK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:01:10 -0500
Date: Fri, 9 Feb 2007 16:00:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Russ Cox" <rsc@swtch.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix quadratic behavior of shrink_dcache_parent()
Message-Id: <20070209160055.bbd20c9f.akpm@linux-foundation.org>
In-Reply-To: <E1HFdnm-0006DB-00@dorka.pomaz.szeredi.hu>
References: <E1HFdnm-0006DB-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 23:01:06 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The time shrink_dcache_parent() takes, grows quadratically with the
> depth of the tree under 'parent'.  This starts to get noticable at
> about 10,000.
> 
> These kinds of depths don't occur normally, and filesystems which
> invoke shrink_dcache_parent() via d_invalidate() seem to have other
> depth dependent timings, so it's not even easy to expose this problem.
> 
> However with FUSE it's easy to create a deep tree and d_invalidate()
> will also get called.  This can make a syscall hang for a very long
> time.
> 
> This is the original discovery of the problem by Russ Cox:
> 
>   http://article.gmane.org/gmane.comp.file-systems.fuse.devel/3826

"The file system mounted on /tmp/z in the example contains 2^50
directories".   heh.

I do wonder how realistic this problem is in real life.

> The following patch fixes the quadratic behavior, by optionally
> allowing prune_dcache() to prune ancestors of a dentry in one go,
> instead of doing it one at a time.
> 
> Common code in dput() and prune_one_dentry() is extracted into a new
> helper function d_kill().
> 
> shrink_dcache_parent() as well as shrink_dcache_sb() are converted to
> use the ancestry-pruner option.  Only for shrink_dcache_memory() is
> this behavior not desirable, so it keeps using the old algorithm.
> 

I wonder if we should be setting shrink_parents=1 in
shrink_dcache_memory()?  Because we have this problem where the dentry
slabs suffer lots of internal fragmentation and we end up with whole slab
pages pinned by a single directory dentry.  I expect that if
shrink_dcache_memory() were aggressive about reaping newly-childless
directory dentries, some improvements might be realised there.

If so, we should change prune_dcache() to return the number pruned, so that
shrink_dcache_memory() can keep its arithmetic correct.  Would require some
careful testing and is out of scope for your work.


