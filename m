Return-Path: <linux-kernel-owner+w=401wt.eu-S935026AbXHGUqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935026AbXHGUqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935063AbXHGUqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:46:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51245 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935026AbXHGUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:45:59 -0400
Date: Tue, 7 Aug 2007 13:42:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Patrick McHardy <kaber@trash.net>,
       Ranko Zivojnovic <ranko@spidernet.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 03/84] Fix TC deadlock.
Message-ID: <20070807204245.GD23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-tc-deadlock.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Patrick McHardy <kaber@trash.net>

[NET_SCHED]: Revert "avoid transmit softirq on watchdog wakeup" optimization

As noticed by Ranko Zivojnovic <ranko@spidernet.net>, calling qdisc_run
from the timer handler can result in deadlock:

> CPU#0
>
> qdisc_watchdog() fires and gets dev->queue_lock
> qdisc_run()...qdisc_restart()...
> -> releases dev->queue_lock and enters dev_hard_start_xmit()
>
> CPU#1
>
> tc del qdisc dev ...
> qdisc_graft()...dev_graft_qdisc()...dev_deactivate()...
> -> grabs dev->queue_lock ...
>
> qdisc_reset()...{cbq,hfsc,htb,netem,tbf}_reset()...qdisc_watchdog_cancel()...
> -> hrtimer_cancel() - waiting for the qdisc_watchdog() to exit, while still
>		        holding dev->queue_lock
>
> CPU#0
>
> dev_hard_start_xmit() returns ...
> -> wants to get dev->queue_lock(!)
>
> DEADLOCK!

The entire optimization is a bit questionable IMO, it moves potentially
large parts of NET_TX_SOFTIRQ work to TIMER_SOFTIRQ/HRTIMER_SOFTIRQ,
which kind of defeats the separation of them.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Acked-by: Ranko Zivojnovic <ranko@spidernet.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_api.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -290,11 +290,7 @@ static enum hrtimer_restart qdisc_watchd
 
 	wd->qdisc->flags &= ~TCQ_F_THROTTLED;
 	smp_wmb();
-	if (spin_trylock(&dev->queue_lock)) {
-		qdisc_run(dev);
-		spin_unlock(&dev->queue_lock);
-	} else
-		netif_schedule(dev);
+	netif_schedule(dev);
 
 	return HRTIMER_NORESTART;
 }

-- 
