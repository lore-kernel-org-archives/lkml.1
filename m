Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbXKFCxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbXKFCxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 21:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbXKFCxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 21:53:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186AbXKFCxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 21:53:22 -0500
Date: Mon, 5 Nov 2007 18:52:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Loopback mounts should update the mtime of the
 underlying file on writes
Message-Id: <20071105185241.7ff1d8f3.akpm@linux-foundation.org>
In-Reply-To: <20071106010924.GT17536@waste.org>
References: <20071106010924.GT17536@waste.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007 19:09:24 -0600 Matt Mackall <mpm@selenic.com> wrote:

> Noticed by a Mercurial user. I think this should fix it.
> 

"should".  That pitter patter sound your hear is little akpm feet running
away.

> 
> Index: l/drivers/block/loop.c
> ===================================================================
> --- l.orig/drivers/block/loop.c	2007-11-05 17:50:07.000000000 -0600
> +++ l/drivers/block/loop.c	2007-11-05 19:03:51.000000000 -0600
> @@ -221,6 +221,7 @@ static int do_lo_send_aops(struct loop_d
>  	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
>  	bv_offs = bvec->bv_offset;
>  	len = bvec->bv_len;
> +	file_update_time(file);
>  	while (len > 0) {
>  		sector_t IV;
>  		unsigned size;
> @@ -299,6 +300,7 @@ static int __do_lo_send_write(struct fil
>  
>  	set_fs(get_ds());
>  	bw = file->f_op->write(file, buf, len, &pos);
> +	file_update_time(file);
>  	set_fs(old_fs);
>  	if (likely(bw == len))
>  		return 0;

Probably makes sense, but bear in mind that we can be fairly deep in
filesystem A functions here, and file_update_time() can do stuff like
starting journal transactions on filesystem B.

I expect the worst we'll see is not-yet-suppressed lockdep warnings and
possibly extra stack windup, but this patch may end up being more complex
than one expects..

