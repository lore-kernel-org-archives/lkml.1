Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbYLCIfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbYLCIfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYLCIfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:35:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbYLCIfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:35:36 -0500
Date: Wed, 3 Dec 2008 00:35:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] hugetlb: unsigned ret cannot be negative.
Message-Id: <20081203003517.423f21f6.akpm@linux-foundation.org>
In-Reply-To: <4935BBDA.1020404@gmail.com>
References: <4931295B.7080105@gmail.com>
	<20081202140223.7d5f3538.akpm@linux-foundation.org>
	<4935BBDA.1020404@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2008 23:51:06 +0100 Roel Kluin <roel.kluin@gmail.com> wrote:

> Andrew Morton wrote:
> > On Sat, 29 Nov 2008 06:36:59 -0500
> > roel kluin <roel.kluin@gmail.com> wrote:
> > 
> >> unsigned long ret cannot be negative, but ret can get -EFAULT.
> >>
> >> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> >> ---
> >> hugetlbfs_read_actor() returns int,
> >> see 
> >> vi fs/hugetlbfs/inode.c +187
> >>
> >> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> >> index 61edc70..0af64e4 100644
> >> --- a/fs/hugetlbfs/inode.c
> >> +++ b/fs/hugetlbfs/inode.c
> >> @@ -252,6 +252,7 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
> >>  	for (;;) {
> >>  		struct page *page;
> >>  		unsigned long nr, ret;
> >> +		int ra;
> >>  
> >>  		/* nr is the maximum number of bytes to copy from this page */
> >>  		nr = huge_page_size(h);
> >> @@ -279,15 +280,16 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
> >>  			/*
> >>  			 * We have the page, copy it to user space buffer.
> >>  			 */
> >> -			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
> >> +			ra = hugetlbfs_read_actor(page, offset, buf, len, nr);
> >>  		}
> >> -		if (ret < 0) {
> >> +		if (ra < 0) {
> 
> > `ra' can obviously be used uninitialised here.  The compiler reports
> > this, too.
> 
> Yes, it was incomplete as well, sorry. This should be OK.
> (checkpatch tested)
> --------------->8----------------8<---------------------
> unsigned long ret cannot be negative, but ret can get -EFAULT.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 61edc70..07fa7e3 100644
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
> @@ -274,16 +275,19 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
>  			 */
>  			ret = len < nr ? len : nr;
>  			if (clear_user(buf, ret))
> -				ret = -EFAULT;
> +				ra = -EFAULT;
> +			else
> +				ra = 0;
>  		} else {
>  			/*
>  			 * We have the page, copy it to user space buffer.
>  			 */
> -			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
> +			ra = hugetlbfs_read_actor(page, offset, buf, len, nr);
> +			ret = ra;
>  		}
> -		if (ret < 0) {
> +		if (ra < 0) {
>  			if (retval == 0)
> -				retval = ret;
> +				retval = ra;
>  			if (page)
>  				page_cache_release(page);
>  			goto out;

Looks like it'll work, I think.

That function is pretty sad-looking now.  It has `ra', `ret' and
`retval', all rather confusingly.  After being renamed to something
useful, `ret' should have type size_t, hugetlbfs_read_actor() should
return size_t and the whole logic around these three things needs a can
of drano tipped down it.

Oh well.
