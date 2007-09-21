Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbXIUTfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbXIUTfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761427AbXIUTfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:35:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175AbXIUTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:35:07 -0400
Date: Fri, 21 Sep 2007 12:34:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 2/3] user.c: use kmem_cache_zalloc()
Message-Id: <20070921123425.54436b17.akpm@linux-foundation.org>
In-Reply-To: <20070921093906.GB6812@localhost.sw.ru>
References: <20070921093906.GB6812@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 13:39:06 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> Quite a few fields are zeroed during user_struct creation, so use
> kmem_cache_zalloc() --  save a few lines and #ifdef. Also will help avoid
>  #ifdef CONFIG_POSIX_MQUEUE in next patch.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  kernel/user.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -129,21 +129,11 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
>  	if (!up) {
>  		struct user_struct *new;
>  
> -		new = kmem_cache_alloc(uid_cachep, GFP_KERNEL);
> +		new = kmem_cache_zalloc(uid_cachep, GFP_KERNEL);
>  		if (!new)
>  			return NULL;
>  		new->uid = uid;
>  		atomic_set(&new->__count, 1);
> -		atomic_set(&new->processes, 0);
> -		atomic_set(&new->files, 0);
> -		atomic_set(&new->sigpending, 0);
> -#ifdef CONFIG_INOTIFY_USER
> -		atomic_set(&new->inotify_watches, 0);
> -		atomic_set(&new->inotify_devs, 0);
> -#endif
> -
> -		new->mq_bytes = 0;
> -		new->locked_shm = 0;


This assumes that setting an atomic_t to the all-zeroes pattern is
equivalent to atomic_set(v, 0).

This happens to be true for all present architectures, afaik.  But an
architecture which has crappy primitives could quite legitimately implement
its atomic_t as:

typedef struct {
	int counter;
	spinlock_t lock;
} atomic_t;

in which case your assumption breaks.

So it's all a bit theoretical and a bit anal, and I'm sure we're making the
same mistake in other places, but it's not a change I particularly like..
