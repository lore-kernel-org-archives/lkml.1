Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbZC0SGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbZC0SGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZC0SGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:06:30 -0400
Received: from vena.lwn.net ([206.168.112.25]:60251 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbZC0SG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:06:28 -0400
Date: Fri, 27 Mar 2009 12:06:23 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Li Zefan <lizf@cn.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Possible IRQ lock inversion from 2.6.29-Linus-03321-gbe0ea69
 (2.6.29-git)
Message-ID: <20090327120623.3056c795@bike.lwn.net>
In-Reply-To: <200903271354.45480.bzolnier@gmail.com>
References: <49CC5F15.4020404@lwfinger.net>
 <200903271354.45480.bzolnier@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 13:54:35 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> I remember looking a bit more closely into the issue and not seeing
> the problem with the locking (though I could have missed something):
> 
> file->f_lock is never taken in hard-irq or soft-irq context and in
> the only place where file->f_lock is taken with fasync_lock hold we're
> protected against IRQs by write_lock_irq().

I do think that the warning is spurious at this time.

> [ Despite not being a problem now I think that changing spin_[un]lock()
>   to *_irq() variants for file->f_lock could be (given that it really
>   fixes the warning) more viable long-term solution than adding special
>   lockdep handling (well, it could be that one day file->f_lock is used
>   in soft-irq context and then the irq lock inversion issue will become
>   a real one) and shouldn't incurr performance penalty since we hold it
>   only for a very brief time. ]

We could do that.  When I made the change I'd verified that there were
no users in IRQ context, and I couldn't really see why there should
be.  I'd rather avoid adding all those IRQ disables if I can avoid it.

How about, instead, just reversing the order of lock acquisition in
fasync_helper()?  That would increase the hold time for f_lock, but I
have a hard time seeing that being a real problem.  I'm running with
the following now; all seems well.  I'll send it up in a bit if nobody
gripes.

Thanks,

jon

diff --git a/fs/fcntl.c b/fs/fcntl.c
index d865ca6..b9c1a4b 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -531,6 +531,7 @@ int fasync_helper(int fd, struct file * filp, int on, struct fasync_struct **fap
 		if (!new)
 			return -ENOMEM;
 	}
+	spin_lock(&filp->f_lock); /* outside fasync_lock to keep lockdep happy */
 	write_lock_irq(&fasync_lock);
 	for (fp = fapp; (fa = *fp) != NULL; fp = &fa->fa_next) {
 		if (fa->fa_file == filp) {
@@ -555,14 +556,12 @@ int fasync_helper(int fd, struct file * filp, int on, struct fasync_struct **fap
 		result = 1;
 	}
 out:
-	/* Fix up FASYNC bit while still holding fasync_lock */
-	spin_lock(&filp->f_lock);
 	if (on)
 		filp->f_flags |= FASYNC;
 	else
 		filp->f_flags &= ~FASYNC;
-	spin_unlock(&filp->f_lock);
 	write_unlock_irq(&fasync_lock);
+	spin_unlock(&filp->f_lock);
 	return result;
 }
 
