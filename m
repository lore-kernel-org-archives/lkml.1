Return-Path: <linux-kernel-owner+w=401wt.eu-S1763140AbXHWOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763140AbXHWOiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbXHWOiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:38:15 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51903 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761522AbXHWOiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:38:14 -0400
Date: Thu, 23 Aug 2007 09:37:45 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: moriai.satoshi@lab.ntt.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       ecryptfs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Ecryptfs-devel] [PATCH] eCryptfs: fix possible fault in ecryptfs_sync_page
Message-ID: <20070823143745.GM22689@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <200708230742.AA00247@paprika.lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708230742.AA00247@paprika.lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 04:42:59PM +0900, Ryusuke Konishi wrote:
> This will avoid a possible fault in ecryptfs_sync_page().

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

Note that there are other outstanding issues with eCryptfs on NFS. For
instance, prepare_write()/commit_write() have gone away in -mm,
leading to an oops when eCryptfs tries to call them directly, which is
well deserved, since eCryptfs really should not be doing that. Unionfs
has just two places where it calls vfs_read() and vfs_write()
respectively; eCryptfs is a bit more complex, with multiple write
paths that end up writing encrypted data and updating metadata in the
header. I am currently trying to find a way to convert everything over
to vfs_read() and vfs_write() in eCryptfs, in a way that does not
ultimately result in a kernel hang.

> In the function, eCryptfs calls sync_page() method of a lower 
> filesystem without checking its existence.  However, there 
> are many filesystems that don't have this method including
> network filesystems such as NFS, AFS, and so forth.
> They may fail when an eCryptfs page is waiting for lock.
> 
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  fs/ecryptfs/mmap.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index e4ab7bc..fd3f94d 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -834,7 +834,8 @@ static void ecryptfs_sync_page(struct page *page)
>  		ecryptfs_printk(KERN_DEBUG, "find_lock_page failed\n");
>  		return;
>  	}
> -	lower_page->mapping->a_ops->sync_page(lower_page);
> +	if (lower_page->mapping->a_ops->sync_page)
> +		lower_page->mapping->a_ops->sync_page(lower_page);
>  	ecryptfs_printk(KERN_DEBUG, "Unlocking page with index = [0x%.16x]\n",
>  			lower_page->index);
>  	unlock_page(lower_page);
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> eCryptfs-devel mailing list
> eCryptfs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ecryptfs-devel
