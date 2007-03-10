Return-Path: <linux-kernel-owner+w=401wt.eu-S2993159AbXCJCeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993159AbXCJCeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 21:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993160AbXCJCeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 21:34:13 -0500
Received: from postel.suug.ch ([194.88.212.233]:36308 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993159AbXCJCeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 21:34:12 -0500
Date: Sat, 10 Mar 2007 03:34:32 +0100
From: Thomas Graf <tgraf@suug.ch>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       David Miller <davem@davemloft.net>, "Garzik, Jeff" <jgarzik@pobox.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Kok, Auke" <auke@foo-projects.org>,
       "Ronciak, John" <john.ronciak@intel.com>
Subject: Re: [PATCH 1/2] NET: Multiple queue network device support
Message-ID: <20070310023432.GJ521@postel.suug.ch>
References: <20070309230143.GI521@postel.suug.ch> <D5C1322C3E673F459512FB59E0DDC329026E9F85@orsmsx414.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329026E9F85@orsmsx414.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Waskiewicz Jr, Peter P <peter.p.waskiewicz.jr@intel.com> 2007-03-09 15:27
> That's the entire point of this extra locking.  enqueue() is going to
> put an skb into a band somewhere that maps to some queue, and there is
> no way to guarantee the skb I retrieve from dequeue() is headed for the
> same queue.  Therefore, I need to unlock the queue after I finish
> enqueuing, since having that lock makes little sense to dequeue().
> dequeue() will then grab *a* lock on a queue; it may be the same one we
> had during enqueue(), but it may not be.  And the placement of the
> unlock of that queue is exactly where it happens in non-multiqueue,
> which is right before the hard_start_xmit().

The lock is already unlocked after dequeue, from your prio_dequeue():

       if (netif_is_multiqueue(sch->dev)) {
               queue = q->band2queue[prio];
               if (spin_trylock(&sch->dev->egress_subqueue[queue].queue_lock)) {
                       qdisc = q->queues[prio];
                       skb = qdisc->dequeue(qdisc);
                       if (skb) {
                               sch->q.qlen--;
                               skb->priority = prio;
                               spin_unlock(&sch->dev->egress_subqueue[queue].queue_lock);
                               return skb;
                       }
                       spin_unlock(&sch->dev->egress_subqueue[queue].queue_lock);
       }
