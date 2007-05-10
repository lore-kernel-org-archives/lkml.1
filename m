Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbXEJXbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbXEJXbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbXEJXbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:31:15 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:53912 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbXEJXbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:31:14 -0400
Subject: Re: [PATCH] locks: fix F_GETLK regression (failure to find
	conflicts)
From: Doug Chapman <doug.chapman@hp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       Marc Eshel <eshel@almaden.ibm.com>, Trond Myklebust <trond@netapp.com>
In-Reply-To: <20070510223843.GB13719@fieldses.org>
References: <1178823375.7247.11.camel@dchapman.boston.redhat.com>
	 <20070510193050.GQ13719@fieldses.org> <20070510223843.GB13719@fieldses.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 19:30:56 -0400
Message-Id: <1178839856.21710.0.camel@phobos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 18:38 -0400, J. Bruce Fields wrote:
> In 9d6a8c5c213e34c475e72b245a8eb709258e968c we changed posix_test_lock
> to modify its single file_lock argument instead of taking separate input
> and output arguments.  This makes it no longer safe to set the output
> lock's fl_type to F_UNLCK before looking for a conflict, since that
> means searching for a conflict against a lock with type F_UNLCK.
> 
> This fixes a regression which causes F_GETLK to incorrectly report no
> conflict on most filesystems (including any filesystem that doesn't do
> its own locking).
> 
> Also fix posix_lock_to_flock() to copy the lock type.  This isn't
> strictly necessary, since the caller already does this; but it seems
> less likely to cause confusion in the future.
> 
> Thanks to Doug Chapman for the bug report.
> 
> Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
> ---
>  fs/locks.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 671a034..8ec16ab 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -669,7 +669,6 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
>  {
>  	struct file_lock *cfl;
>  
> -	fl->fl_type = F_UNLCK;
>  	lock_kernel();
>  	for (cfl = filp->f_path.dentry->d_inode->i_flock; cfl; cfl = cfl->fl_next) {
>  		if (!IS_POSIX(cfl))
> @@ -681,7 +680,8 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
>  		__locks_copy_lock(fl, cfl);
>  		unlock_kernel();
>  		return 1;
> -	}
> +	} else
> +		fl->fl_type = F_UNLCK;
>  	unlock_kernel();
>  	return 0;
>  }
> @@ -1632,6 +1632,7 @@ static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
>  	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
>  		fl->fl_end - fl->fl_start + 1;
>  	flock->l_whence = 0;
> +	flock->l_type = fl->fl_type;
>  	return 0;
>  }
>  

I tested this both with my little hacked up test program as well as with
the LTP tests.  Looks good.  Nice job on the quick turnaround on this
Bruce.

- Doug


