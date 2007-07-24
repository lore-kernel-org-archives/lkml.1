Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbYLLCMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbYLLCMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 21:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbYLLCMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 21:12:19 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:39145 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756986AbYLLCMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 21:12:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GIQln+qZ2TmRD26ZugNA/xm3qMSIJTXR9G2RTyedbfZEcrQibXZUOP/dW0XFE05g0Dosdn4K7wgVoRQcKay/bEGBHYk35RvPYJlx2D/lUDj+15La4tM401VqbZEByC74guMnMtXNehu1QqZ0n8MCbeNDlJCZvrl7eg8XU1G3ndk=  ;
X-YMail-OSG: FKxlFMsVM1nMsrMhMKUazldHXpg26EG61RxCSjb55krMzJb22gAmbY.h7dzmdtwZi0tbJYHowOxnw8VS3z9OahDOKshe9cdWxfJV2R0Ch5i3vfb2UQ3NUE10GfzirdVgbVoF5U_i0lEb6px7etn7T51KDC_RfSSr6Axbtj3564rJLpG_Q3wyo3G.u_eS
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH v3 3/7] fs: Introduce a per_cpu last_ino allocator
Date: Tue, 24 Jul 2007 11:34:41 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <493100B0.6090104@cosmosbay.com> <49419696.9080509@cosmosbay.com>
In-Reply-To: <49419696.9080509@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241134.42512.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 09:39, Eric Dumazet wrote:
> new_inode() dirties a contended cache line to get increasing
> inode numbers.
>
> Solve this problem by providing to each cpu a per_cpu variable,
> feeded by the shared last_ino, but once every 1024 allocations.
>
> This reduce contention on the shared last_ino, and give same
> spreading ino numbers than before.
> (same wraparound after 2^32 allocations)

I don't suppose this would cause any filesystems to do silly
things?

Seems like a good idea, if you could just add a #define instead
of 1024.

>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
>  fs/inode.c |   35 ++++++++++++++++++++++++++++++++---
>  1 files changed, 32 insertions(+), 3 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index f94f889..dc8e72a 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -556,6 +556,36 @@ repeat:
>  	return node ? inode : NULL;
>  }
>
> +#ifdef CONFIG_SMP
> +/*
> + * Each cpu owns a range of 1024 numbers.
> + * 'shared_last_ino' is dirtied only once out of 1024 allocations,
> + * to renew the exhausted range.
> + */
> +static DEFINE_PER_CPU(int, last_ino);
> +
> +static int last_ino_get(void)
> +{
> +	static atomic_t shared_last_ino;
> +	int *p = &get_cpu_var(last_ino);
> +	int res = *p;
> +
> +	if (unlikely((res & 1023) == 0))
> +		res = atomic_add_return(1024, &shared_last_ino) - 1024;
> +
> +	*p = ++res;
> +	put_cpu_var(last_ino);
> +	return res;
> +}
> +#else
> +static int last_ino_get(void)
> +{
> +	static int last_ino;
> +
> +	return ++last_ino;
> +}
> +#endif
> +
>  /**
>   *	new_inode 	- obtain an inode
>   *	@sb: superblock
> @@ -575,7 +605,6 @@ struct inode *new_inode(struct super_block *sb)
>  	 * error if st_ino won't fit in target struct field. Use 32bit counter
>  	 * here to attempt to avoid that.
>  	 */
> -	static unsigned int last_ino;
>  	struct inode * inode;
>
>  	spin_lock_prefetch(&inode_lock);
> @@ -583,11 +612,11 @@ struct inode *new_inode(struct super_block *sb)
>  	inode = alloc_inode(sb);
>  	if (inode) {
>  		percpu_counter_inc(&nr_inodes);
> +		inode->i_state = 0;
> +		inode->i_ino = last_ino_get();
>  		spin_lock(&inode_lock);
>  		list_add(&inode->i_list, &inode_in_use);
>  		list_add(&inode->i_sb_list, &sb->s_inodes);
> -		inode->i_ino = ++last_ino;
> -		inode->i_state = 0;
>  		spin_unlock(&inode_lock);
>  	}
>  	return inode;
