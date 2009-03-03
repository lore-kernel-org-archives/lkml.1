Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbZCCQ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbZCCQ5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZCCQ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:57:12 -0500
Received: from relay1.sgi.com ([192.48.179.29]:48563 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753614AbZCCQ5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:57:11 -0500
Cc: Christoph Hellwig <hch@infradead.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Message-Id: <A277CB1C-4258-42EC-B1D9-F5CAAB962B42@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <49AD5401.30803@sandeen.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: next-20090220: XFS: inconsistent lock state
Date: Tue, 3 Mar 2009 10:57:07 -0600
References: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com> <20090224200740.GA9266@infradead.org> <49AD5401.30803@sandeen.net>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 3, 2009, at 10:00 AM, Eric Sandeen wrote:

> Christoph Hellwig wrote:
>> On Fri, Feb 20, 2009 at 08:52:59PM +0300, Alexander Beregalov wrote:
>>> Hi
>>>
>>> [ INFO: inconsistent lock state ]
>>> 2.6.29-rc5-next-20090220 #2
>>> ---------------------------------
>>> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
>>> kswapd0/324 [HC0[0]:SC0[0]:HE1:SE1] takes:
>>> (&(&ip->i_lock)->mr_lock){+++++?}, at: [<ffffffff803ca60a>]
>>> xfs_ilock+0xaa/0x120
>>> {RECLAIM_FS-ON-W} state was registered at:
>>
>> That's a false positive.  While the ilock can be taken in reclaim the
>> allocation here is done before the inode is added to the inode cache.
>>
>> The patch below should help avoiding the warning:
>
> Seems ok to me.  I hate to see the BUG() added but I guess in this  
> case
> something truly bizarre would have to happen for the ilock to fail on
> this inode.
>
> on irc you sugggested ASSERT(0); instead of BUG();

That would mean that instead of bombing out here, we do it
in xfs debug kernels only, which is a good thing. However,
do we just silently ignore it in non debug kernels, and
later try to unlock without locking first?
Maybe the following be better:

	if (lock_flags) {
		if (!xfs_ilock_nowait(ip, lock_flags)) {
			ASSERT(0);
			error = EAGAIN;
			goto out_destroy;
		}
	}
				
Or just keep the BUG(); , as it shouldn't happen (we hope).

Reviewed-by: Felix Blyakher <felixb@sgi.com>


> I might prefer that
> but either way:
>
> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
>
>>
>> Index: xfs/fs/xfs/xfs_iget.c
>> ===================================================================
>> --- xfs.orig/fs/xfs/xfs_iget.c	2009-02-24 20:56:00.716027739 +0100
>> +++ xfs/fs/xfs/xfs_iget.c	2009-02-24 20:56:46.089031360 +0100
>> @@ -246,9 +246,6 @@ xfs_iget_cache_miss(
>> 		goto out_destroy;
>> 	}
>>
>> -	if (lock_flags)
>> -		xfs_ilock(ip, lock_flags);
>> -
>> 	/*
>> 	 * Preload the radix tree so we can insert safely under the
>> 	 * write spinlock. Note that we cannot sleep inside the preload
>> @@ -259,6 +256,15 @@ xfs_iget_cache_miss(
>> 		goto out_unlock;
>> 	}
>>
>> +	/*
>> +	 * Because the inode hasn't been added to the radix-tree yet it  
>> can't
>> +	 * be found by another thread, so we can do the non-sleeping lock  
>> here.
>> +	 */
>> +	if (lock_flags) {
>> +		if (!xfs_ilock_nowait(ip, lock_flags))
>> +			BUG();
>> +	}
>> +
>> 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) -  
>> 1);
>> 	first_index = agino & mask;
>> 	write_lock(&pag->pag_ici_lock);
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

