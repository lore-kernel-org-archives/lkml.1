Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbXEaSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbXEaSGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbXEaSGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:06:08 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42243 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730AbXEaSGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:06:05 -0400
Subject: Re: [PATCH resend] introduce I_SYNC
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070531142535.GA25236@lazybastard.org>
References: <20070516170110.GC8113@lazybastard.org>
	 <20070516101535.94e44b3b.akpm@linux-foundation.org>
	 <20070531142535.GA25236@lazybastard.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 31 May 2007 13:06:03 -0500
Message-Id: <1180634763.13932.28.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-31 at 16:25 +0200, Jörn Engel wrote:
> --- linux-2.6.21logfs/fs/jfs/jfs_txnmgr.c~I_LOCK        2007-05-07
> 10:28:55.000000000 +0200
> +++ linux-2.6.21logfs/fs/jfs/jfs_txnmgr.c       2007-05-29
> 13:10:32.000000000 +0200
> @@ -1286,7 +1286,14 @@ int txCommit(tid_t tid,          /*
> transaction 
>                  * commit the transaction synchronously, so the last
> iput
>                  * will be done by the calling thread (or later)
>                  */
> -               if (tblk->u.ip->i_state & I_LOCK)
> +               /*
> +                * I believe this code is no longer needed.  Splitting
> I_LOCK
> +                * into two bits, I_LOCK and I_SYNC should prevent
> this
> +                * deadlock as well.  But since I don't have a JFS
> testload
> +                * to verify this, only a trivial s/I_LOCK/I_SYNC/ was
> done.
> +                * Joern
> +                */
> +               if (tblk->u.ip->i_state & I_SYNC)
>                         tblk->xflag &= ~COMMIT_LAZY;
>         }

I think the code is still needed, and I think this change is correct.
The deadlock that this code is avoiding is caused by clear_inode()
calling wait_on_inode().  Since clear_inode() now calls
inode_sync_wait(inode), we want to avoid the lazily committing this
transaction when the I_SYNC flag is set.

Unfortunately, recreating the deadlock is hard, and I haven't been able
to recreate it with this code commented out.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

