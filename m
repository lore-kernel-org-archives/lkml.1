Return-Path: <linux-kernel-owner+w=401wt.eu-S965701AbXCSGhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965701AbXCSGhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 02:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXCSGhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 02:37:10 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:33335 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965696AbXCSGhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 02:37:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=I9sjubiI7j/8Su8LTIpt5p4LQ/pWS6990zjFumsIBJ5c6viyV61Ia7I+k4wM+33duNWEKY41mlUkE31lIm/21zt0fMxJDocirEpd3882HsWcS4Xwn8BTb86zk6AUGZo8lk8zTtEWJ6G5wWxrzDo7LkTueXQZqNN4J219tsua0bE=  ;
X-YMail-OSG: aLthSDMVM1md0HKkcvl1WUD0RNg.NqAVLovQX3x5a.SdHZufI7wZLp7eksAIY.lgPpRL1bmh7gRGZDUO96rgPIKDiMcWtw1ZmFgDEn0sq.z_SOboBJJ0coJOAniTF_SYJdTbod1SDCqWXsD4CQvqbFouMQ--
Message-ID: <45FE2F8F.6010603@yahoo.com.au>
Date: Mon, 19 Mar 2007 17:37:03 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
References: <20070318233008.GA32597093@melbourne.sgi.com>
In-Reply-To: <20070318233008.GA32597093@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Generic page_mkwrite functionality.
> 
> Filesystems that make use of the VM ->page_mkwrite() callout will generally use
> the same core code to implement it. There are several tricky truncate-related
> issues that we need to deal with here as we cannot take the i_mutex as we
> normally would for these paths.  These issues are not documented anywhere yet
> so block_page_mkwrite() seems like the best place to start.



> 
> Version 2:
> 
> - read inode size only once
> - more comments explaining implementation restrictions
> 
> Signed-Off-By: Dave Chinner <dgc@sgi.com>
> 
> ---
>  fs/buffer.c                 |   47 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/buffer_head.h |    2 +
>  2 files changed, 49 insertions(+)
> 
> Index: 2.6.x-xfs-new/fs/buffer.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/buffer.c	2007-03-17 10:55:32.291414968 +1100
> +++ 2.6.x-xfs-new/fs/buffer.c	2007-03-19 08:13:54.519909087 +1100
> @@ -2194,6 +2194,52 @@ int generic_commit_write(struct file *fi
>  	return 0;
>  }
>  
> +/*
> + * block_page_mkwrite() is not allowed to change the file size as it gets
> + * called from a page fault handler when a page is first dirtied. Hence we must
> + * be careful to check for EOF conditions here. We set the page up correctly
> + * for a written page which means we get ENOSPC checking when writing into
> + * holes and correct delalloc and unwritten extent mapping on filesystems that
> + * support these features.
> + *
> + * We are not allowed to take the i_mutex here so we have to play games to
> + * protect against truncate races as the page could now be beyond EOF.  Because
> + * vmtruncate() writes the inode size before removing pages, once we have the
> + * page lock we can determine safely if the page is beyond EOF. If it is not
> + * beyond EOF, then the page is guaranteed safe against truncation until we
> + * unlock the page.
> + */
> +int
> +block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
> +		   get_block_t get_block)
> +{
> +	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
> +	unsigned long end;
> +	loff_t size;
> +	int ret = -EINVAL;
> +
> +	lock_page(page);
> +	size = i_size_read(inode);
> +	if ((page->mapping != inode->i_mapping) ||
> +	    ((page->index << PAGE_CACHE_SHIFT) > size)) {
> +		/* page got truncated out from underneath us */
> +		goto out_unlock;
> +	}

I see your explanation above, but I still don't see why this can't
just follow the conventional if (!page->mapping) check for truncation.
If the test happens to be performed after truncate concurrently
decreases i_size, then the blocks are going to get truncated by the
truncate afterwards anyway.

> +
> +	/* page is wholly or partially inside EOF */
> +	if (((page->index + 1) << PAGE_CACHE_SHIFT) > size)
> +		end = size & ~PAGE_CACHE_MASK;
> +	else
> +		end = PAGE_CACHE_SIZE;
> +
> +	ret = block_prepare_write(page, 0, end, get_block);
> +	if (!ret)
> +		ret = block_commit_write(page, 0, end);
> +
> +out_unlock:
> +	unlock_page(page);
> +	return ret;
> +}

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
