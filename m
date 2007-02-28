Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXB1TPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXB1TPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbXB1TPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:15:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXB1TPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:15:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vatsa@in.ibm.com
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 20:17:38 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl> <200702281211.04515.rjw@sisk.pl> <20070228131721.GD15509@in.ibm.com>
In-Reply-To: <20070228131721.GD15509@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702282017.39752.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 14:17, Srivatsa Vaddagiri wrote:
> On Wed, Feb 28, 2007 at 12:11:03PM +0100, Rafael J. Wysocki wrote:
> > > In addition to thawing worker thread before kthread_stopping it, there
> > > are minor changes required in worker threads, to check for
> > > is_cpu_offline(bind_cpu) when they come out of refrigerator and jump to
> > > wait_to_die if so (ex: softirq.c).
> > > 
> > > I guess you would need these changes before freezer-based hotplug is
> > > merged, in which case Gautham can send those patches out first.
> > 
> > Yes, please, if that's possible.
> 
> After looking at the current workqueue code, the above minor change I
> suggested is not required.
> 
> So you should be able to fix your "kthread_stop on a frozen worker
> thread hangs" problem by just a simple patch like this (against
> 2.6.20-mm2):
> 
> 
> --- workqueue.c.org	2007-02-28 18:32:48.000000000 +0530
> +++ workqueue.c	2007-02-28 18:44:23.000000000 +0530
> @@ -718,6 +718,8 @@ static void cleanup_workqueue_thread(str
>  		insert_wq_barrier(cwq, &barr, 1);
>  		cwq->should_stop = 1;
>  		alive = 1;
> +		if (frozen(cwq->thread))
> +			thaw(cwq->thread);
>  	}
>  	spin_unlock_irq(&cwq->lock);
>  
> 
> Can you test with this?

Unfortunately, the above code is mm-only.  Is the analogous fix for 2.6.21-rc2
viable?

Rafael
