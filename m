Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYCXDeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYCXDeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 23:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYCXDeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 23:34:15 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:23675 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751299AbYCXDeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 23:34:14 -0400
Date: Mon, 24 Mar 2008 12:33:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Greg KH <greg@kroah.com>, dwmw2 <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] 3/3 maple: update bus driver to support Dreamcast VMU
Message-ID: <20080324033344.GB15872@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Greg KH <greg@kroah.com>, dwmw2 <dwmw2@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	MTD <linux-mtd@lists.infradead.org>,
	linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209786.6324.41.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206209786.6324.41.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 06:16:26PM +0000, Adrian McMenamin wrote:
> Changes to allow support of the VMU as well as clean up some of the
> horrors that got imported in with the rewrite of the 2.4 driver.
> 
> - Adds a mutex to allow packets (eg block reads and writes) to be
> injected into the waiting queue with any risk of data corruption.
> 
> - Removes unneeded locking of queue of processed packets while properly
> locking access to the queue of waiting packets
> 
> - Allows proper probing and removal of device drivers rather than
> force majure approach based on function supported
> 
> - Separate out "rescan" function to make the code easier to read
> and maintain.
> 
> - properly initialise and clean up waiting and sent queues
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
Getting better, though still some issues..

> +	if (!mq->recvbuf)
> +		goto failed_p2;
> +	/***
> +	 * most devices do not need the mutex - but
> +	 * anything that injects block reads or writes
> +	 * will rely on it
> +	 */
> +	mutex_init(&mq->mutex);
>  
>  	return mq;

The commenting style here is highly irregular.

> @@ -377,53 +383,62 @@
>  
>  	if ((maple_dev->interval > 0)
>  	    && time_after(jiffies, maple_dev->when)) {
> +		/***
> +		* Can only queue one command per device at a time
> +		* so if cannot aquire the mutex, just return
> +		*/
> +		if (!mutex_trylock(&maple_dev->mq->mutex))
> +			goto setup_finished;

Here also. Not only is the commenting weird, so is the indentation.

Also, unrelated to this patch, why is the && on the left of the second
line instead of the right of the first one? Please do not invent new
styles.

> +			/* Use trylock again to avoid corrupting
> +			* any already queued commands */

This one is almost sane.

> +			locking = mutex_trylock(&mdev_add->mq->mutex);
> +			if (locking == 0)
> +				return;

The variable here is pretty pointless, since you don't really use it for
anything.

> +	fullscan = 1;
> +	for (i = 0; i < MAPLE_PORTS; i++) {
> +		if (checked[i] == false) {
> +			fullscan = 0;
> +			mdev = baseunits[i];
> +			/**
> +			*  Use trylock in case scan has failed
> +			*  but device is still locked
> +			*/
> +			locking = mutex_trylock(&mdev->mq->mutex);
> +			if (locking == 0) {
> +				mutex_unlock(&mdev->mq->mutex);
> +				locking = mutex_lock_interruptible
> +					(&mdev->mq->mutex);
> +				if (locking)
> +					continue;
> +			}

So here we have the same issue as in the previous patch, but with the
mutex API instead. The entire point of adding a comment for clarity is
that it becomes obvious what this is trying to accomplish, which it still
isn't. Maple shouldn't require a supplemental document to detail its
locking strategy in a way that doesn't induce blindness.

The mutex_unlock() here looks very suspicious. You first try to grab the
lock via the trylock, if it's contended, then you try to unlock it and
then grab it again for yourself before continuing on. This sort of
juggling looks really racy. Under what conditions will this lock be
contended, and under what conditions is it released? If you have a
transfer in place, you contend on the lock, and then this code suddenly
unlocks, what happens to your queue? It seems like you are trying to lock
down the mq for the duration of its lifetime, in addition to having a
separate list lock for guarding against the list getting mangled from
underneath you.

It looks like you are trying to roll your own complex queuing mechanism
in a fairly non-obvious fashion. Have you considered using things like
the block layer qeueing for dealing with a lot of this for you? This is
what we ended up using for OMAP mailboxes and it worked out pretty well
(arch/arm/plat-omap/mailbox.c) there.

This sort of obscure locking is going to cause you nothing but trouble in
the long run.
