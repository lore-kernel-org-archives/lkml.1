Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbZC1Ac0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbZC1Ac0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZC1AcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:32:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZC1AcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:32:17 -0400
Subject: Re: Possible IRQ lock inversion from 2.6.29-Linus-03321-gbe0ea69
 (2.6.29-git)
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Li Zefan <lizf@cn.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090327120623.3056c795@bike.lwn.net>
References: <49CC5F15.4020404@lwfinger.net>
	 <200903271354.45480.bzolnier@gmail.com>
	 <20090327120623.3056c795@bike.lwn.net>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 01:32:01 +0100
Message-Id: <1238200321.4039.371.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 12:06 -0600, Jonathan Corbet wrote:
> On Fri, 27 Mar 2009 13:54:35 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > I remember looking a bit more closely into the issue and not seeing
> > the problem with the locking (though I could have missed something):
> > 
> > file->f_lock is never taken in hard-irq or soft-irq context and in
> > the only place where file->f_lock is taken with fasync_lock hold we're
> > protected against IRQs by write_lock_irq().
> 
> I do think that the warning is spurious at this time.

I think you're right (although at 1:30 am I can't be sure).

It does point to inconsistent (sloppy) lock usage though, because f_lock
is used both with and without irqs disabled -- so on that ground its
correct to complain.

> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index d865ca6..b9c1a4b 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -531,6 +531,7 @@ int fasync_helper(int fd, struct file * filp, int on, struct fasync_struct **fap
>  		if (!new)
>  			return -ENOMEM;
>  	}
> +	spin_lock(&filp->f_lock); /* outside fasync_lock to keep lockdep happy */

Please don't put in comments like that, they're worse than useless.
Either explain in detail how and why, or don't bother.

>  	write_lock_irq(&fasync_lock);
>  	for (fp = fapp; (fa = *fp) != NULL; fp = &fa->fa_next) {
>  		if (fa->fa_file == filp) {
> @@ -555,14 +556,12 @@ int fasync_helper(int fd, struct file * filp, int on, struct fasync_struct **fap
>  		result = 1;
>  	}
>  out:
> -	/* Fix up FASYNC bit while still holding fasync_lock */
> -	spin_lock(&filp->f_lock);
>  	if (on)
>  		filp->f_flags |= FASYNC;
>  	else
>  		filp->f_flags &= ~FASYNC;
> -	spin_unlock(&filp->f_lock);
>  	write_unlock_irq(&fasync_lock);
> +	spin_unlock(&filp->f_lock);
>  	return result;
>  }

