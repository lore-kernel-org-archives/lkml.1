Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZGOOX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZGOOX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZGOOXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:23:25 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:44489 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754719AbZGOOXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:23:24 -0400
X-Trace: 230091258/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.119.106/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.119.106
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYEACSDXUpPRXdq/2dsb2JhbACBUc96gjaBUwU
X-IronPort-AV: E=Sophos;i="4.42,404,1243810800"; 
   d="scan'208";a="230091258"
Date: Wed, 15 Jul 2009 15:22:46 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] shmem: call set_page_dirty() with locked page
In-Reply-To: <20090715140447.GA15177@localhost>
Message-ID: <Pine.LNX.4.64.0907151520050.27929@sister.anvils>
References: <20090714092926.GA23969@localhost> <Pine.LNX.4.64.0907141918380.10805@sister.anvils>
 <20090715111012.GA1403@localhost> <Pine.LNX.4.64.0907151405020.23573@sister.anvils>
 <20090715140447.GA15177@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Wu Fengguang wrote:
> shmem: call set_page_dirty() with locked page
> 
> The dirtying of page and set_page_dirty() can be moved into the page lock.
> 
> - In shmem_write_end(), the page was dirtied while the page lock was held,
>   but it's being marked dirty just after dropping the page lock.
> - In shmem_symlink(), both dirtying and marking can be moved into page lock.
> 
> It's valuable for the hwpoison code to know whether one bad page can be dropped
> without losing data. It mainly judges by testing the PG_dirty bit after taking
> the page lock. So it becomes important that the dirtying of page and the
> marking of dirtiness are both done inside the page lock. Which is a common
> practice, but sadly not a rule.
> 
> The noticeable exceptions are
> - mapped pages
> - pages with buffer_heads
> The above pages could go dirty at any time. Fortunately the hwpoison will
> unmap the page and release the buffer_heads beforehand anyway.
> 
> Many other types of pages (eg. metadata pages) can also be dirtied at will by
> their owners, the hwpoison code cannot do meaningful things to them anyway. 
> Only the dirtiness of pagecache pages owned by regular files are interested.
> 
> CC: Hugh Dickins <hugh@veritas.com>

Ah, those were the days... ;)

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
>  mm/shmem.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux.orig/mm/shmem.c
> +++ linux/mm/shmem.c
> @@ -1630,8 +1630,8 @@ shmem_write_end(struct file *file, struc
>  	if (pos + copied > inode->i_size)
>  		i_size_write(inode, pos + copied);
>  
> -	unlock_page(page);
>  	set_page_dirty(page);
> +	unlock_page(page);
>  	page_cache_release(page);
>  
>  	return copied;
> @@ -1968,13 +1968,13 @@ static int shmem_symlink(struct inode *d
>  			iput(inode);
>  			return error;
>  		}
> -		unlock_page(page);
>  		inode->i_mapping->a_ops = &shmem_aops;
>  		inode->i_op = &shmem_symlink_inode_operations;
>  		kaddr = kmap_atomic(page, KM_USER0);
>  		memcpy(kaddr, symname, len);
>  		kunmap_atomic(kaddr, KM_USER0);
>  		set_page_dirty(page);
> +		unlock_page(page);
>  		page_cache_release(page);
>  	}
>  	if (dir->i_mode & S_ISGID)
