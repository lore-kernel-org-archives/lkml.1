Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXB1NRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXB1NRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbXB1NRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:17:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46101 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282AbXB1NR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:17:29 -0500
Date: Wed, 28 Feb 2007 18:47:21 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228131721.GD15509@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702272251.28844.rjw@sisk.pl> <20070228030113.GJ29179@in.ibm.com> <20070228035149.GL29179@in.ibm.com> <200702281211.04515.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702281211.04515.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 12:11:03PM +0100, Rafael J. Wysocki wrote:
> > In addition to thawing worker thread before kthread_stopping it, there
> > are minor changes required in worker threads, to check for
> > is_cpu_offline(bind_cpu) when they come out of refrigerator and jump to
> > wait_to_die if so (ex: softirq.c).
> > 
> > I guess you would need these changes before freezer-based hotplug is
> > merged, in which case Gautham can send those patches out first.
> 
> Yes, please, if that's possible.

After looking at the current workqueue code, the above minor change I
suggested is not required.

So you should be able to fix your "kthread_stop on a frozen worker
thread hangs" problem by just a simple patch like this (against
2.6.20-mm2):


--- workqueue.c.org	2007-02-28 18:32:48.000000000 +0530
+++ workqueue.c	2007-02-28 18:44:23.000000000 +0530
@@ -718,6 +718,8 @@ static void cleanup_workqueue_thread(str
 		insert_wq_barrier(cwq, &barr, 1);
 		cwq->should_stop = 1;
 		alive = 1;
+		if (frozen(cwq->thread))
+			thaw(cwq->thread);
 	}
 	spin_unlock_irq(&cwq->lock);
 

Can you test with this?

Note that as Oleg commented, freezable workqueues are broken w/o his
patch here:

	http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755	

So you need to have Andrew/Linux pick up the above patch first to have
correctly functioning freezable workqueues.

-- 
Regards,
vatsa
