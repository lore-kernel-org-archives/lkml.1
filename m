Return-Path: <linux-kernel-owner+w=401wt.eu-S2992958AbXDYTOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992958AbXDYTOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992960AbXDYTOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:14:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43158 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992958AbXDYTOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:14:00 -0400
Date: Wed, 25 Apr 2007 20:13:59 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in tty_io.c
Message-ID: <20070425191359.GA13241@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20070425154934.GP6798@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425154934.GP6798@traven>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 05:49:34PM +0200, Matthias Kaehlcke wrote:
> drivers/char/tty_io.c uses a semaphore as mutex. use the mutex API
> instead of the (binary) semaphore

This looks like it should be a spinlock:

> -		down(&allocated_ptys_lock);
> +		mutex_lock(&allocated_ptys_lock);
>  		idr_remove(&allocated_ptys, idx);
> -		up(&allocated_ptys_lock);
> +		mutex_unlock(&allocated_ptys_lock);

idr_remove is a quick operation that doesn't sleep.

> @@ -2639,24 +2639,24 @@ static int ptmx_open(struct inode * inode, struct file * filp)
>  	nonseekable_open(inode, filp);
>  
>  	/* find a device that is not in use. */
> -	down(&allocated_ptys_lock);
> +	mutex_lock(&allocated_ptys_lock);
>  	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
> -		up(&allocated_ptys_lock);

The idr_pre_get should be moved out of the lock, that's the whole
point for it's existance..

> +		mutex_unlock(&allocated_ptys_lock);
>  		return -ENOMEM;
>  	}
>  	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
>  	if (idr_ret < 0) {
> -		up(&allocated_ptys_lock);
> +		mutex_unlock(&allocated_ptys_lock);
>  		if (idr_ret == -EAGAIN)
>  			return -ENOMEM;
>  		return -EIO;
>  	}
>  	if (index >= pty_limit) {
>  		idr_remove(&allocated_ptys, index);
> -		up(&allocated_ptys_lock);
> +		mutex_unlock(&allocated_ptys_lock);
>  		return -EIO;
>  	}
> -	up(&allocated_ptys_lock);
> +	mutex_unlock(&allocated_ptys_lock);

And idr_get_new is another quick, non-blocking operation.

