Return-Path: <linux-kernel-owner+w=401wt.eu-S1764964AbYEVW4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764964AbYEVW4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbYEVW4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:56:34 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52324 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756470AbYEVW4b (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:56:31 -0400
Date: Fri, 23 May 2008 08:56:08 +1000
From: David Chinner <dgc@sgi.com>
To: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, dgc@sgi.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH][RFC]fix soft lock up at NFS mount by per-SB LRU-list of unused dentries
Message-ID: <20080522225608.GZ173056135@sgi.com>
References: <4834D8DA.30907@np.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834D8DA.30907@np.css.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 11:22:18AM +0900, Kentaro Makita wrote:
> +/*
> + * Shrink the dentry LRU on a given superblock.
> + * @sb   : superblock to shrink dentry LRU.
> + * @count: If count is NULL, we prune all dentries on superblock.
> + * @flags: If flags is non-zero, we need to do special processing based on
> + * which flags are set. This means we don't need to maintain multiple
> + * similar copies of this loop.
> + */
> +static void __shrink_dcache_sb(struct super_block *sb, int *count, int flags)
> +{
> +	LIST_HEAD(referenced);
> +	LIST_HEAD(tmp);
> +	struct dentry *dentry;
> +	int cnt = 0;
> +
> +	BUG_ON(!sb);
> +	BUG_ON((flags & DCACHE_REFERENCED) && count == NULL);
> +	spin_lock(&dcache_lock);
> +	if (count != NULL)
> +		/* called from prune_dcache() and shrink_dcache_parent() */
> +		cnt = *count;

I'd convert all the 'if (count == NULL)' to 'if (!count)' and same
for 'if (count != NULL)' to 'if (count)'....

> +restart:
> +	if (count == NULL)
> +		list_splice_init(&sb->s_dentry_lru, &tmp);
> +	else {

Probably should add {} to the first branch here as well.

> +		while (!list_empty(&sb->s_dentry_lru)) {
> +			dentry = list_entry(sb->s_dentry_lru.prev,
> +					struct dentry, d_lru);
> +			BUG_ON(dentry->d_sb != sb);
> +
> +			spin_lock(&dentry->d_lock);
> +		/*
> +		 * If we are honouring the DCACHE_REFERENCED flag and the
> +		 * dentry has this flag set, don't free it. Clear the flag
> +		 * and put it back on the LRU
> +		 */
> +			if ((flags & DCACHE_REFERENCED)
> +				&& (dentry->d_flags & DCACHE_REFERENCED)) {

Indentation of the second line of the if is the same as the block of
code underneath it. Probably should read:

			if ((flags & DCACHE_REFERENCED) &&
			    (dentry->d_flags & DCACHE_REFERENCED)) {
> +				dentry->d_flags &= ~DCACHE_REFERENCED;
> +				list_move_tail(&dentry->d_lru, &referenced);
> +				spin_unlock(&dentry->d_lock);
> +			} else {
> +				list_move_tail(&dentry->d_lru, &tmp);
> +				spin_unlock(&dentry->d_lock);
> +				cnt--;
> +				if (!cnt)
> +					break;
				if (--cnt == 0)
					break;
> +			}
> +		}
> +	}

I'm wondering if this loop is an excessively long time to be holding the
dcache_lock. I guess the hol dtime is limited by the size of *count being
passed in. I think we could also do a:

		cond_resched_lock(&dcache_lock);
	
in the loop here to prevent this from occurring....

> +	while (!list_empty(&tmp)) {
> +		dentry = list_entry(tmp.prev, struct dentry, d_lru);
> +		dentry_lru_del_init(dentry);
> +		spin_lock(&dentry->d_lock);
> +		/*
> +		 * We found an inuse dentry which was not removed from
> +		 * the LRU because of laziness during lookup.  Do not free
> +		 * it - just keep it off the LRU list.
> +		 */
> +		if (atomic_read(&dentry->d_count)) {
> +			spin_unlock(&dentry->d_lock);
> +			continue;
> +		}
> +		prune_one_dentry(dentry);
> +		/* dentry->d_lock is dropped in prune_one_dentry() */
> +		cond_resched_lock(&dcache_lock);
> +	}
> +	if ((count == NULL) && (!list_empty(&sb->s_dentry_lru)))
> +		goto restart;
> +	if (count != NULL)
> +		*count = cnt;

	if (count)
		*count = cnt;
	else if (!list_empty(&sb->s_dentry_lru))
		goto restart;

> +	if (!list_empty(&referenced))
> +		list_splice(&referenced, &sb->s_dentry_lru);
> +	spin_unlock(&dcache_lock);
> +}
> +
>  /**
>   * prune_dcache - shrink the dcache
>   * @count: number of entries to try and free
> - * @sb: if given, ignore dentries for other superblocks
> - *         which are being unmounted.
>   *
>   * Shrink the dcache. This is done when we need
>   * more memory, or simply when we need to unmount
> @@ -425,111 +526,75 @@ static void prune_one_dentry(struct dent
>   * all the dentries are in use.
>   */
> 
> -static void prune_dcache(int count, struct super_block *sb)
> +static void prune_dcache(int count)
>  {
> -	spin_lock(&dcache_lock);
> -	for (; count ; count--) {
> -		struct dentry *dentry;
> -		struct list_head *tmp;
> -		struct rw_semaphore *s_umount;
> +	struct super_block *sb;
> +	int w_count;
> +	int unused = dentry_stat.nr_unused;
> +	int prune_ratio;
> +	int pruned;
> 
> -		cond_resched_lock(&dcache_lock);
> -
> -		tmp = dentry_unused.prev;
> -		if (sb) {
> -			/* Try to find a dentry for this sb, but don't try
> -			 * too hard, if they aren't near the tail they will
> -			 * be moved down again soon
> -			 */
> -			int skip = count;
> -			while (skip && tmp != &dentry_unused &&
> -			    list_entry(tmp, struct dentry, d_lru)->d_sb != sb) {
> -				skip--;
> -				tmp = tmp->prev;
> -			}
> -		}
> -		if (tmp == &dentry_unused)
> -			break;
> -		list_del_init(tmp);
> -		prefetch(dentry_unused.prev);
> - 		dentry_stat.nr_unused--;
> -		dentry = list_entry(tmp, struct dentry, d_lru);
> -
> - 		spin_lock(&dentry->d_lock);
> -		/*
> -		 * We found an inuse dentry which was not removed from
> -		 * dentry_unused because of laziness during lookup.  Do not free
> -		 * it - just keep it off the dentry_unused list.
> -		 */
> - 		if (atomic_read(&dentry->d_count)) {
> - 			spin_unlock(&dentry->d_lock);
> -			continue;
> -		}
> -		/* If the dentry was recently referenced, don't free it. */
> -		if (dentry->d_flags & DCACHE_REFERENCED) {
> -			dentry->d_flags &= ~DCACHE_REFERENCED;
> - 			list_add(&dentry->d_lru, &dentry_unused);
> - 			dentry_stat.nr_unused++;
> - 			spin_unlock(&dentry->d_lock);
> +	if (unused == 0 || count == 0)
> +		return;
> +	spin_lock(&dcache_lock);
> +restart:
> +	if (count >= unused)
> +		prune_ratio = 1;
> +	else
> +		prune_ratio = unused / count;

unused = 100,000, count = 128 => prune_ratio = 781.

if we have 3 filesystems with 70,000, 25,000 and 5,000 dentries a piece,
that gives us:

> +	spin_lock(&sb_lock);
> +	list_for_each_entry(sb, &super_blocks, s_list) {

Question on lock ordering of sb_lock vs dcache_lock - which is the inner
lock? Are the two of them held together anywhere else? (/me doesn't
have time to searchthe code right now).

> +		if (sb->s_nr_dentry_unused == 0)
>  			continue;
> -		}
> -		/*
> -		 * If the dentry is not DCACHED_REFERENCED, it is time
> -		 * to remove it from the dcache, provided the super block is
> -		 * NULL (which means we are trying to reclaim memory)
> -		 * or this dentry belongs to the same super block that
> -		 * we want to shrink.
> +		sb->s_count++;
> +		/* Now, we reclaim unused dentrins with fairness.
> +		 * we reclaim them same percentage on each superblocks.
> +		 * we calculate number of dentries to scan on this sb
> +		 * based on following way, but impelementation is arranged
> +		 * to avoid overflow.
> +		 * number of dentries to scan on this sb =
> +		 * count * (number of dentries on this sb /
> +		 * number of dentries in the machine)
>  		 */
> +		spin_unlock(&sb_lock);
> +		if (prune_ratio != 1)
> +			w_count = (sb->s_nr_dentry_unused / prune_ratio) + 1;
> +		else
> +			w_count = sb->s_nr_dentry_unused;
> +		pruned = w_count;

70,000 -> 90
25,000 -> 33
 5,000 -> 7

Total = 130. So we will prune a small number more than is asked for. I guess
this isn't a big problem because we exit the loop if count <= 0.

Otherwise it's looking good.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
