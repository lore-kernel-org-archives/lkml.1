Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbXGXAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbXGXAYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 20:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXGXAYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 20:24:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbXGXAYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 20:24:05 -0400
Date: Mon, 23 Jul 2007 17:23:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Siewior <sebastian@breakpoint.cc>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] compat_ioctl requires CONFIG_BLOCK
Message-Id: <20070723172337.de0bce58.akpm@linux-foundation.org>
In-Reply-To: <200707210108.58478.arnd@arndb.de>
References: <20070720225817.050195257@ayoka.breakpoint.cc>
	<200707210108.58478.arnd@arndb.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 01:08:57 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 21 July 2007, Sebastian Siewior wrote:
> > 
> > Got with randconfig
> > include/linux/loop.h:66: error: expected specifier-qualifier-list before
> > 'request_queue_t'
> > make[1]: *** [fs/compat_ioctl.o] Error 1
> > 
> > parts of compat ioctl require CONFIG_BLOCK to be set.
> > 
> > Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> > Index: b/fs/compat_ioctl.c
> > ===================================================================
> > --- a/fs/compat_ioctl.c
> > +++ b/fs/compat_ioctl.c
> > @@ -63,7 +63,9 @@
> > __#include <linux/wireless.h>
> > __#include <linux/atalk.h>
> > __#include <linux/blktrace_api.h>
> > +#ifdef CONFIG_BLOCK
> > __#include <linux/loop.h>
> > +#endif
> 
> Adding #ifdef around an #include is considered bad style. Better just
> make loop.h compile without any conditionals. Does the below
> patch work for you?

This is the classic why-typedefs-are-bad.  AFAIK there is no way of fixing
this build error apart from adding otherwise-unneeded nested inclusions
(very bad), or:

> 	Arnd <><
> 
> --- a/include/linux/loop.h
> +++ b/include/linux/loop.h
> @@ -63,7 +63,7 @@ struct loop_device {
>  	struct task_struct	*lo_thread;
>  	wait_queue_head_t	lo_event;
>  
> -	request_queue_t		*lo_queue;
> +	struct request_queue	*lo_queue;
>  	struct gendisk		*lo_disk;
>  	struct list_head	lo_list;
>  };

Good start.  Now can we do the rest of the kernel?  ;)
