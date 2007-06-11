Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXFKXev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXFKXev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbXFKXeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:34:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbXFKXeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:34:44 -0400
Date: Mon, 11 Jun 2007 16:34:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: splice: move balance_dirty_pages_ratelimited() outside of
 splice actor
Message-Id: <20070611163433.dbc541ec.akpm@linux-foundation.org>
In-Reply-To: <200706112159.l5BLxF5x004043@hera.kernel.org>
References: <200706112159.l5BLxF5x004043@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007 21:59:15 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=20d698db67059a63d217030dfd02872cb5f88dfb
> Commit:     20d698db67059a63d217030dfd02872cb5f88dfb
> Parent:     17374ff1aa9ce2a0597416a16729474b538af443
> Author:     Jens Axboe <jens.axboe@oracle.com>
> AuthorDate: Tue Jun 5 11:05:11 2007 +0200
> Committer:  Jens Axboe <jens.axboe@oracle.com>
> CommitDate: Fri Jun 8 08:33:59 2007 +0200
> 
>     splice: move balance_dirty_pages_ratelimited() outside of splice actor
>     
>     I've seen inode related deadlocks, so move this call outside of the
>     actor itself, which may hold the inode lock.
>     

eh?  If the pipe_to_file() caller holds inode_lock, our problems are large.

I doubt if that's true, so what problem is this patch really fixing??

> ---
>  fs/splice.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index b78a7f0..6349d31 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -652,7 +652,6 @@ find_page:
>  	 * accessed, we are now done!
>  	 */
>  	mark_page_accessed(page);
> -	balance_dirty_pages_ratelimited(mapping);
>  out:
>  	page_cache_release(page);
>  	unlock_page(page);
> @@ -823,6 +822,7 @@ generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
>  			if (err)
>  				ret = err;
>  		}
> +		balance_dirty_pages_ratelimited(mapping);
>  	}
>  
>  	return ret;
> @@ -876,6 +876,7 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
>  			if (err)
>  				ret = err;
>  		}
> +		balance_dirty_pages_ratelimited(mapping);
>  	}
>  

balance_dirty_pages_ratelimited() is supposed to be called
once-per-dirtied-page.  This caller can dirty an arbitrarily large amount
of memory and hence should use balance_dirty_pages_ratelimited_nr().

As things stand, a large splice() could potentially cause the dirty limits
to be exceeded.

btw, can we please arrange to get patches reviewed prior to them being
merged?

