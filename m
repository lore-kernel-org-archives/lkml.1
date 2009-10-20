Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZJTUAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZJTUAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZJTUAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:00:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59317 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZJTUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:00:22 -0400
Subject: Re: [Jfs-discussion] [PATCH] jfs: lockdep fix
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net
In-Reply-To: <4ade05f0af05a2.00981454@wp.pl>
References: <4ade05f0af05a2.00981454@wp.pl>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 15:00:23 -0500
Message-Id: <1256068823.3708.30.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 20:48 +0200, Krzysztof Helt wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> Release rdwrlock semaphore during memory allocation.
> This fixes the locked already reported here:
> 
> http://www.mail-archive.com/jfs-discussion@lists.sourceforge.net/msg01389.html
> 
> The problem here is that memory allocation is done with rdwrlock 
> semaphore taken and the VM can get into the jfs layer taking the 
> rdwrlock again.
> 
> Also, the patch fixes the lockdep below. This problem is created because 
> the rdwrlock semaphore acquires the commit_mutex and it is called with 
> interrupts enabled. The interrupt may hit with the commit_mutex taken 
> and take the rdwrlock (again) inside the interrupt context.

The rdwrlock should never be taken in interrupt context.

> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.32-rc3 #99
> ---------------------------------------------------------
> kswapd0/180 just changed the state of lock:
>  (&jfs_ip->rdwrlock#2){++++-.}, at: [<c02e2207>] jfs_get_block+0x47/0x280
> but this lock took another, RECLAIM_FS-unsafe lock in the past:
>  (&jfs_ip->commit_mutex){+.+.+.}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 
> other info that might help us debug this:
> no locks held by kswapd0/180.
> 
> the shortest dependencies between 2nd lock and 1st lock:
>  -> (&jfs_ip->commit_mutex){+.+.+.} ops: 7937 {
>     HARDIRQ-ON-W at:

<snip>

> ---
> 
> I am not sure if this is the right fix to the problem. The heavy use of 
> the jfs volume can lock up a machine (e.g. hit me in Ubuntu 9.04).

I don't think we can just drop the mutex, since it protects the inode's
xtree from being modified while another thread is either reading or
writing it.

I proposed another fix here:
http://bugzilla.kernel.org/show_bug.cgi?id=13613

It seems I haven't followed up and submitted it to the vfs maintainer.
Could you please give that patch a try and see if it fixes the problem
for you?

Thanks,
Shaggy

> diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
> index b2ae190..de18324 100644
> --- a/fs/jfs/inode.c
> +++ b/fs/jfs/inode.c
> @@ -244,9 +244,22 @@ int jfs_get_block(struct inode *ip, sector_t lblock,
>  #ifdef _JFS_4K
>  	if ((rc = extHint(ip, lblock64 << ip->i_sb->s_blocksize_bits, &xad)))
>  		goto unlock;
> +
> +	/* release lock to avoid lockdep with jfs_ip->commit_mutex */
> +	if (create)
> +		IWRITE_UNLOCK(ip);
> +	else
> +		IREAD_UNLOCK(ip);
> +
>  	rc = extAlloc(ip, xlen, lblock64, &xad, false);
> +
>  	if (rc)
> -		goto unlock;
> +		return rc;
> +
> +	if (create)
> +		IWRITE_LOCK(ip, RDWRLOCK_NORMAL);
> +	else
> +		IREAD_LOCK(ip, RDWRLOCK_NORMAL);
>  
>  	set_buffer_new(bh_result);
>  	map_bh(bh_result, ip->i_sb, addressXAD(&xad));

-- 
David Kleikamp
IBM Linux Technology Center

