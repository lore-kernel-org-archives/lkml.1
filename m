Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbXFYPT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbXFYPT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXFYPTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:19:49 -0400
Received: from mail.screens.ru ([213.234.233.54]:46734 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739AbXFYPTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:19:48 -0400
Date: Mon, 25 Jun 2007 19:20:11 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Uli Luckas <u.luckas@road.de>,
       linux-kernel@vger.kernel.org
Subject: synchronize_qrcu_timeout()
Message-ID: <20070625152011.GA160@tv-sign.ru>
References: <20070625104332.GA147@tv-sign.ru> <20070625145851.GB12976@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625145851.GB12976@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Paul E. McKenney wrote:
>
> On Mon, Jun 25, 2007 at 02:43:32PM +0400, Oleg Nesterov wrote:
> > 
> > Sadly, you can't use srcu/qrcu because it doesn't handle timeouts.	
> 
> Interesting...  So the thought is to have a synchronize_srcu_timeout()
> or something similar that waited for a grace period to elapse or for
> a timeout to expire, whichever comes first?  It should not be too hard
> to arrange something, if needed.

Yes. As for qrcu (see http://marc.info/?t=116484476500001), I think it is easy.
First, we add "int interrupted" into struct qrcu_struct, then something like this

	long synchronize_qrcu_timeout(struct qrcu_struct *qp, long tout)
	{
		int idx;

		smp_mb();
		mutex_lock(&qp->mutex);

	again:
		idx = qp->completed & 0x1;

		if (unlikely(qp->interrupted)) {
			idx ^= 0x1;
			goto restart;
		}


		if (atomic_read(qp->ctr + idx) == 1)
			goto out;

		atomic_inc(qp->ctr + (idx ^ 0x1));
		qp->completed++;

		atomic_dec(qp->ctr + idx);
	restart:
		__wait_event_timeout(qp->wq, !atomic_read(qp->ctr + idx), tout);
		if (unlikely(!tout)) {
			qp->interrupted = 1;
			goto out;
		}

		if (unlikely(qp->interrupted)) {
			qp->interrupted = 0;
			goto again;
		}

	out:
		mutex_unlock(&qp->mutex);
		smp_mb();

		return tout;
	}

Of course, this needs some other changes to implement synchronize_qrcu() on top
of synchronize_qrcu_timeout(). I also think that this doesn't break

	[RFC PATCH] QRCU fastpath optimization
	http://marc.info/?l=linux-kernel&m=117125577710947

Looks like we can do something similar for srcu.

Oleg.

