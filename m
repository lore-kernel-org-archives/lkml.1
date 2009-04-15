Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZDOAOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZDOAOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbZDOAOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:14:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263AbZDOAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:14:05 -0400
Date: Tue, 14 Apr 2009 17:11:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       xcf@ustc.edu.cn
Subject: Re: [RFC][PATCH] vfs: check inode size on no_cached_page
Message-Id: <20090414171114.04a47932.akpm@linux-foundation.org>
In-Reply-To: <20090412071605.GA14058@localhost>
References: <20090412071605.GA14058@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Apr 2009 15:16:05 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> [This patch may not necessarily be merged, but at least we should
>  be aware of the problem.]
> 
> When user space requests past-EOF data, do_generic_file_read() will
> issue a bonus readpage call, which may be unfavorable.
> 
> do_generic_file_read:
>         -> find_page:
>         -> find_get_page()             = NULL
>         -> page_cache_sync_readahead()
>         -> find_get_page()             = NULL
>         -> no_cached_page:
>         -> readpage:
>                 -> nfs_readpage()      = error
>         -> readpage_error:
> 
> Reported-by: Xu Chenfeng <xcf@ustc.edu.cn>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/filemap.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- mm.orig/mm/filemap.c
> +++ mm/mm/filemap.c
> @@ -1269,6 +1269,11 @@ readpage_error:
>  		goto out;
>  
>  no_cached_page:
> +		isize = i_size_read(inode);
> +		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
> +		if (unlikely(!isize || index > end_index))
> +			goto out;
> +
>  		/*
>  		 * Ok, it wasn't cached, so we need to create a new
>  		 * page..

Is this a problem which needs to be solved?  userspace does something
silly and the kernel behaves a bit suboptimally?

If thats the only problem here then it's not worth adding fastpath
cycles to fix it?


