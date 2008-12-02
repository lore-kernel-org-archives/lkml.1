Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYLBWCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYLBWCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYLBWCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:02:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbYLBWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:02:40 -0500
Date: Tue, 2 Dec 2008 14:02:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: unsigned ret cannot be negative.
Message-Id: <20081202140223.7d5f3538.akpm@linux-foundation.org>
In-Reply-To: <4931295B.7080105@gmail.com>
References: <4931295B.7080105@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 06:36:59 -0500
roel kluin <roel.kluin@gmail.com> wrote:

> unsigned long ret cannot be negative, but ret can get -EFAULT.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> hugetlbfs_read_actor() returns int,
> see 
> vi fs/hugetlbfs/inode.c +187
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 61edc70..0af64e4 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -252,6 +252,7 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
>  	for (;;) {
>  		struct page *page;
>  		unsigned long nr, ret;
> +		int ra;
>  
>  		/* nr is the maximum number of bytes to copy from this page */
>  		nr = huge_page_size(h);
> @@ -279,15 +280,16 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
>  			/*
>  			 * We have the page, copy it to user space buffer.
>  			 */
> -			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
> +			ra = hugetlbfs_read_actor(page, offset, buf, len, nr);
>  		}
> -		if (ret < 0) {
> +		if (ra < 0) {
>  			if (retval == 0)
> -				retval = ret;
> +				retval = ra;
>  			if (page)
>  				page_cache_release(page);
>  			goto out;
>  		}
> +		ret = ra;
>  
>  		offset += ret;
>  		retval += ret;

`ra' can obviously be used uninitialised here.  The compiler reports
this, too.

