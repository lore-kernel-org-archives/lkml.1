Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbXJ2Ngz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbXJ2Ngz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXJ2Ngq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:36:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10138 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbXJ2Ngp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:36:45 -0400
Date: Mon, 29 Oct 2007 09:36:18 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Mike Waychison <mikew@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Waychison <mikew@google.com>
Subject: Re: [patch 4/6][RFC] Attempt to plug race with truncate
Message-ID: <20071029093618.2c671643@think.oraclecorp.com>
In-Reply-To: <20071026233848.693899140@crlf.corp.google.com>
References: <20071026233732.568575496@crlf.corp.google.com>
	<20071026233848.693899140@crlf.corp.google.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 16:37:36 -0700
Mike Waychison <mikew@google.com> wrote:

> Attempt to deal with races with truncate paths.
> 
> I'm not really sure on the locking here, but these seem to be taken
> by the truncate path.  BKL is left as some filesystem may(?) still
> require it.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
>  fs/ioctl.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux-2.6.23/fs/ioctl.c
> ===================================================================
> --- linux-2.6.23.orig/fs/ioctl.c	2007-10-26 15:27:29.000000000
> -0700 +++ linux-2.6.23/fs/ioctl.c	2007-10-26
> 16:16:28.000000000 -0700 @@ -43,13 +43,21 @@ static long
> do_ioctl(struct file *filp, static int do_fibmap(struct address_space
> *mapping, sector_t block, sector_t *phys_block)
>  {
> +	struct inode *inode = mapping->host;
> +
>  	if (!capable(CAP_SYS_RAWIO))
>  		return -EPERM;
>  	if (!mapping->a_ops->bmap)
>  		return -EINVAL;
>  
>  	lock_kernel();
> +	/* Avoid races with truncate */
> +	mutex_lock(&inode->i_mutex);
> +	/* FIXME: Do we really need i_alloc_sem? */
> +	down_read(&inode->i_alloc_sem);


i_alloc_sem will avoid races with filesystems filling holes inside
writepage (where i_mutex isn't held).  I'd expect everyone to currently
give some consistent result (either the old value or the new but not
garbage), but I wouldn't expect taking the semaphore to hurt anything.

-chris
