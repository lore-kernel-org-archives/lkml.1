Return-Path: <linux-kernel-owner+w=401wt.eu-S1763840AbXJZUZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763840AbXJZUZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXJZUZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:25:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbXJZUZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:25:32 -0400
Date: Fri, 26 Oct 2007 13:24:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <antipov@dev.rtsoft.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] -EINVAL if no fasync op for file
Message-Id: <20071026132439.decb40d9.akpm@linux-foundation.org>
In-Reply-To: <471728F7.6020809@dev.rtsoft.ru>
References: <471728F7.6020809@dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 13:35:51 +0400
Dmitry Antipov <antipov@dev.rtsoft.ru> wrote:

> This patch proposes an additional error checking performed within setfl().
> 
> As a result, fcntl (fd, F_SETFL, O_ASYNC) will return -1 and set errno
> to -EINVAL if filp->f_op->fasync is NULL for file specified by fd. This
> is possible, for example, if fd is a descriptor returned by inotify_init().
> 
> 
> Dmitry
> 
> 
> 
> [2.6.23-fcntl-fasync-check.patch  text/x-patch (353B)]
> Signed-off-by: Dmitry Antipov <antipov@dev.rtsoft.ru>
> 
> --- .orig-2.6.23/fs/fcntl.c	2007-10-17 15:26:06.000000000 +0400
> +++ 2.6.23/fs/fcntl.c	2007-10-17 15:25:27.000000000 +0400
> @@ -240,6 +240,9 @@
>  			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
>  			if (error < 0)
>  				goto out;
> +		} else {
> +			error = -EINVAL;
> +			goto out;
>  		}
>  	}

This would have made sense whent he code was originally written
but it now has a (small) potential to break existing applications.

I guess if the _only_ fd's which don't implement fasync are inotify,
signalfd and other such new-and-obscure things then the risk is
probably acceptably low.

But is the proposed change actually very useful?
