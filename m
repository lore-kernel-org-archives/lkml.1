Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbYCFFyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbYCFFyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 00:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYCFFyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 00:54:39 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40271 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751851AbYCFFyj (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 00:54:39 -0500
Date: Thu, 6 Mar 2008 16:54:16 +1100
From: David Chinner <dgc@sgi.com>
To: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][BUGFIX][RFC] fix soft lock up at NFS mount by making limitation of dentry_unused
Message-ID: <20080306055416.GF155407@sgi.com>
References: <47CF75F9.1050406@np.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF75F9.1050406@np.css.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 01:41:29PM +0900, Kentaro Makita wrote:
> [Summary]
>   Make a limitation of dentry_unused to avoid soft lock up at NFS mounts
>  and remounting any filesystem.
> 
> [Descriptions]
> - background
>  dentry_unused is a list of dentries which is not in use. This works
>  as a cache against not-exisiting files. dentry_unused grows up when
>  directories or files are removed. This list can be *verrry* long
>  if there is no memory  pressure, because there is no limit.
> 
> - what's problem
>  When prune_dcache() is called, it scans *all* dentry_unused linearly
>  under spin_lock(). This scan costs very much if there are many entries.
>  For example, prune_dcache() is called at mounting NFS.
>  In our test, when there are 100,000,000 of unused dentries, mounting
>  NFS took 1 minutes and almost all user programs hang during it.
> 
>   100,000,000 is possible number on large systems.
> 
>  This problem already happend on our system.
>  Therefore, we need a limitation of dentry_unused.

No, we need a smarter free list structure. There have been several attempts
at this in the past. Two that I can recall off the top of my head:

	- per node unused LRUs
	- per superblock unusued LRUs

I guess we need to revisit this again, because limiting the size of
the cache like this is not an option.

>  I feel we need more tests to determine resonable value to any system.
>  So, please test.
.....
> Tested on Intel Itanium 2 9050 (dualcore) x12 MEM 24GB , kernel-2.6.25-rc4
> I found no peformance regression in my tests.

Try something that relies on leaving the working set on the unused
list, like NFS server benchmarks that have a working set of tens of
million of files....

> Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
> ---
>  fs/dcache.c |    7 +++++++
>  1 files changed, 7 insertions(+)
> diff -rupN -X linux-2.6.25-rc4/Documentation/dontdiff linux-2.6.25-rc4/fs/dcache.c linux-2.6.25-rc4mod/fs/dcache.c
> --- linux-2.6.25-rc4/fs/dcache.c	2008-03-05 13:33:54.000000000 +0900
> +++ linux-2.6.25-rc4mod/fs/dcache.c	2008-03-05 16:47:18.000000000 +0900
> @@ -42,6 +42,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOC
> 
>  EXPORT_SYMBOL(dcache_lock);
> 
> +/* threshold to limit dentry_unused */
> +unsigned int dentry_unused_ratio = 10000;
>  static struct kmem_cache *dentry_cache __read_mostly;
> 
>  #define DNAME_INLINE_LEN (sizeof(struct dentry)-offsetof(struct dentry,d_iname))
> @@ -61,6 +63,7 @@ static unsigned int d_hash_mask __read_m
>  static unsigned int d_hash_shift __read_mostly;
>  static struct hlist_head *dentry_hashtable __read_mostly;
>  static LIST_HEAD(dentry_unused);
> +static void prune_dcache(int count, struct super_block *sb);
> 
>  /* Statistics gathering. */
>  struct dentry_stat_t dentry_stat = {
> @@ -214,6 +217,10 @@ repeat:
>    	}
>   	spin_unlock(&dentry->d_lock);
>  	spin_unlock(&dcache_lock);
> +	/* Prune unused dentry over threshold level */
> +	int nr_in_use = (dentry_stat.nr_dentry - dentry_stat.nr_unused);
> +	if (dentry_stat.nr_dentry > nr_in_use * dentry_unused_ratio / 100)
> +		prune_dcache(dentry_stat.nr_unused * 5 / 100 , NULL);

nr_in_use is going to overflow 32 bits with this calculation.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
