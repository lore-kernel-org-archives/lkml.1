Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbXJ1OMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbXJ1OMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 10:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXJ1OMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 10:12:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38080 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXJ1OMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 10:12:30 -0400
Date: Sun, 28 Oct 2007 14:12:22 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] VFS: apply coding standards to fs/ioctl.c
Message-ID: <20071028141222.GA29323@infradead.org>
References: <11935266454097-git-send-email-ezk@cs.sunysb.edu> <11935266451616-git-send-email-ezk@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11935266451616-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nice, I always hated these double-indented switch statements.

> +	case FIBMAP:
> +	{
> +		struct address_space *mapping = filp->f_mapping;
> +		int res;
> +		/* do we support this mess? */
> +		if (!mapping->a_ops->bmap)
> +			return -EINVAL;
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +		error = get_user(block, p);
> +		if (error)
> +			return error;
> +		lock_kernel();
> +		res = mapping->a_ops->bmap(mapping, block);
> +		unlock_kernel();
> +		return put_user(res, p);

While you're at it, it's probably worth splitting this out into
a small helper function.

> +	case FIONBIO:
> +		error = get_user(on, (int __user *)arg);
> +		if (error)
> +			break;
> +		flag = O_NONBLOCK;
>  #ifdef __sparc__
> +		/* SunOS compatibility item. */
> +		if (O_NONBLOCK != O_NDELAY)
> +			flag |= O_NDELAY;
>  #endif
> +		if (on)
> +			filp->f_flags |= flag;
> +		else
> +			filp->f_flags &= ~flag;
> +		break;

Same here.

> +	case FIOASYNC:
> +		error = get_user(on, (int __user *)arg);
> +		if (error)
>  			break;
> +		flag = on ? FASYNC : 0;
> +
> +		/* Did FASYNC state change ? */
> +		if ((flag ^ filp->f_flags) & FASYNC) {
> +			if (filp->f_op && filp->f_op->fasync) {
> +				lock_kernel();
> +				error = filp->f_op->fasync(fd, filp, on);
> +				unlock_kernel();
> +			} else
>  				error = -ENOTTY;
> +		}
> +		if (error != 0)
>  			break;
> +
> +		if (on)
> +			filp->f_flags |= FASYNC;
> +		else
> +			filp->f_flags &= ~FASYNC;
> +		break;

And here.

