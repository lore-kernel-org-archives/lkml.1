Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZBHJDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZBHJDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 04:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZBHJC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 04:02:58 -0500
Received: from verein.lst.de ([213.95.11.210]:51086 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbZBHJC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 04:02:56 -0500
Date: Sun, 8 Feb 2009 10:02:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/4] Use f_lock to protect f_flags
Message-ID: <20090208090220.GB18521@lst.de>
References: <1234037217-16124-1-git-send-email-corbet@lwn.net> <1234037217-16124-3-git-send-email-corbet@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234037217-16124-3-git-send-email-corbet@lwn.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 01:06:55PM -0700, Jonathan Corbet wrote:
> Traditionally, changes to struct file->f_flags have been done under BKL
> protection, or with no protection at all.  This patch causes all f_flags
> changes after file open/creation time to be done under protection of
> f_lock.  This allows the removal of some BKL usage and fixes a number of
> longstanding (if microscopic) races.

Looks good to me.


Reviewed-by: Christoph Hellwig <hch@lst.de>

One comments only tangentially related to the patch:


> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index bc84e12..224f271 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -2162,13 +2162,12 @@ static int fionbio(struct file *file, int __user *p)
>  	if (get_user(nonblock, p))
>  		return -EFAULT;
>  
> -	/* file->f_flags is still BKL protected in the fs layer - vomit */
> -	lock_kernel();
> +	spin_lock(&file->f_lock);
>  	if (nonblock)
>  		file->f_flags |= O_NONBLOCK;
>  	else
>  		file->f_flags &= ~O_NONBLOCK;
> -	unlock_kernel();
> +	spin_unlock(&file->f_lock);
>  	return 0;
>  }

Why is this code there at all?  It's a duplicate of
fs/ioctl.c:ioctl_fionbio minus the sparc special case, and from looking
at the flow in fs/ioctl.c I'm pretty sure FIONBIO never gets handed to
the chardev ioctl methods..

