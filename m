Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZCCQpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZCCQpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZCCQpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:45:34 -0500
Received: from relay1.sgi.com ([192.48.179.29]:47360 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751295AbZCCQpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:45:33 -0500
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Message-Id: <B793B976-694B-423B-AAF2-9A622696CC88@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20090224200740.GA9266@infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: next-20090220: XFS: inconsistent lock state
Date: Tue, 3 Mar 2009 10:45:28 -0600
References: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com> <20090224200740.GA9266@infradead.org>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 24, 2009, at 2:07 PM, Christoph Hellwig wrote:

> On Fri, Feb 20, 2009 at 08:52:59PM +0300, Alexander Beregalov wrote:
>> Hi
>>
>> [ INFO: inconsistent lock state ]
>> 2.6.29-rc5-next-20090220 #2
>> ---------------------------------
>> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
>> kswapd0/324 [HC0[0]:SC0[0]:HE1:SE1] takes:
>> (&(&ip->i_lock)->mr_lock){+++++?}, at: [<ffffffff803ca60a>]
>> xfs_ilock+0xaa/0x120
>> {RECLAIM_FS-ON-W} state was registered at:
>
> That's a false positive.  While the ilock can be taken in reclaim the
> allocation here is done before the inode is added to the inode cache.
>
> The patch below should help avoiding the warning:
>
>
> Index: xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iget.c	2009-02-24 20:56:00.716027739 +0100
> +++ xfs/fs/xfs/xfs_iget.c	2009-02-24 20:56:46.089031360 +0100
> @@ -246,9 +246,6 @@ xfs_iget_cache_miss(
> 		goto out_destroy;
>  	}
>
> -	if (lock_flags)
> -		xfs_ilock(ip, lock_flags);
> -
>  	/*
>  	 * Preload the radix tree so we can insert safely under the
>  	 * write spinlock. Note that we cannot sleep inside the preload
> @@ -259,6 +256,15 @@ xfs_iget_cache_miss(
>  		goto out_unlock;

Since we removed call to xfs_ilock() above, this should change
to 'goto out_destroy;'
Otherwise, seems goot to me.

Reviewed-by: Felix Blyakher <felixb@sgi.com>


>
> 	}
>
> +	/*
> +	 * Because the inode hasn't been added to the radix-tree yet it  
> can't
> +	 * be found by another thread, so we can do the non-sleeping lock  
> here.
> +	 */
> +	if (lock_flags) {
> +		if (!xfs_ilock_nowait(ip, lock_flags))
> +			BUG();

>
> +	}
> +
> 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
> 	first_index = agino & mask;
> 	write_lock(&pag->pag_ici_lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

