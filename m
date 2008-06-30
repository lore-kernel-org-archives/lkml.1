Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbYF3UdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbYF3UdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYF3UdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:33:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbYF3UdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:33:08 -0400
Date: Mon, 30 Jun 2008 13:32:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] prevent get_user_pages call from kernel thread
Message-Id: <20080630133233.a3c2a4ef.akpm@linux-foundation.org>
In-Reply-To: <m34p84uedf.fsf@dmon-lap.sw.ru>
References: <m34p84uedf.fsf@dmon-lap.sw.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jun 2008 19:37:32 +0400
Dmitri Monakhov <dmonakhov@openvz.org> wrote:

> Yes, yes.. everybody know that it is bad to write from kernel thread, and it
> is madness to do it with O_DIRECT. But occasionally file with O_DIRECT flag
> may be passed to loop device via LOOP_SET_FD. So if system hasn't address
> space ops, or simply hide it like GFS, it is possible to kill kernel via
> two lines program. In fact we can't effectively guard kernel space by
> disabling O_DIRECT in loop's code, because user space can change it back
> via fcntl(,F_SETFL,). Let's simply add sanity check mm related logic.
> 
> Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
> ---
>  drivers/block/loop.c |    1 +
>  fs/direct-io.c       |    4 ++++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index d3a25b0..bb2a262 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -753,6 +753,7 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
>  
>  	mapping = file->f_mapping;
>  	inode = mapping->host;
> +	file->f_mode &= ~O_DIRECT;
>  
>  	if (!(file->f_mode & FMODE_WRITE))
>  		lo_flags |= LO_FLAGS_READ_ONLY;
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 9e81add..8e17224 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -149,6 +149,10 @@ static int dio_refill_pages(struct dio *dio)
>  	int ret;
>  	int nr_pages;
>  
> +	if (unlikely(!current->mm)) {
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
>  	nr_pages = min(dio->total_pages - dio->curr_page, DIO_PAGES);
>  	down_read(&current->mm->mmap_sem);
>  	ret = get_user_pages(

It's a bit rude to silently turn off O_DIRECT in this case.

I think it would be better to simply fail the LOOP_SET_FD if the file
has O_DIRECT and the relevant address_space_operations vectors are
NULL.

