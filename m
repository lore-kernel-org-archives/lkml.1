Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXCJUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXCJUha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 15:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbXCJUha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 15:37:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:6199 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224AbXCJUh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 15:37:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,270,1170662400"; 
   d="scan'208"; a="207221523:sNHT23513154"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] NET: Multiple queue network device support
Date: Sat, 10 Mar 2007 12:37:24 -0800
Message-ID: <D5C1322C3E673F459512FB59E0DDC329026EA188@orsmsx414.amr.corp.intel.com>
In-Reply-To: <20070310023432.GJ521@postel.suug.ch>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] NET: Multiple queue network device support
thread-index: AcdivJfpWkVmf8swT6yqGA2hYCnVcAAlutSA
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Thomas Graf" <tgraf@suug.ch>
Cc: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "David Miller" <davem@davemloft.net>,
       "Garzik, Jeff" <jgarzik@pobox.com>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Kok, Auke" <auke@foo-projects.org>,
       "Ronciak, John" <john.ronciak@intel.com>
X-OriginalArrivalTime: 10 Mar 2007 20:37:26.0394 (UTC) FILETIME=[EA13A5A0:01C76353]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Thomas Graf [mailto:tgraf@suug.ch] 
> Sent: Friday, March 09, 2007 6:35 PM
> To: Waskiewicz Jr, Peter P
> Cc: Kok, Auke-jan H; David Miller; Garzik, Jeff; 
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; 
> Brandeburg, Jesse; Kok, Auke; Ronciak, John
> Subject: Re: [PATCH 1/2] NET: Multiple queue network device support
> 
> * Waskiewicz Jr, Peter P <peter.p.waskiewicz.jr@intel.com> 
> 2007-03-09 15:27
> > That's the entire point of this extra locking.  enqueue() 
> is going to 
> > put an skb into a band somewhere that maps to some queue, 
> and there is 
> > no way to guarantee the skb I retrieve from dequeue() is headed for 
> > the same queue.  Therefore, I need to unlock the queue 
> after I finish 
> > enqueuing, since having that lock makes little sense to dequeue().
> > dequeue() will then grab *a* lock on a queue; it may be the 
> same one 
> > we had during enqueue(), but it may not be.  And the 
> placement of the 
> > unlock of that queue is exactly where it happens in non-multiqueue, 
> > which is right before the hard_start_xmit().
> 
> The lock is already unlocked after dequeue, from your prio_dequeue():
> 
>        if (netif_is_multiqueue(sch->dev)) {
>                queue = q->band2queue[prio];
>                if 
> (spin_trylock(&sch->dev->egress_subqueue[queue].queue_lock)) {
>                        qdisc = q->queues[prio];
>                        skb = qdisc->dequeue(qdisc);
>                        if (skb) {
>                                sch->q.qlen--;
>                                skb->priority = prio;
>                                
> spin_unlock(&sch->dev->egress_subqueue[queue].queue_lock);
>                                return skb;
>                        }
>                        
> spin_unlock(&sch->dev->egress_subqueue[queue].queue_lock);
>        }

Ok, now I see what's wrong.  Taking Dave M.'s recommendation to store
the queue mapping in the skb will let me unlock the queue when dequeue()
returns.  I'll fix this locking issue; thanks for the feedback and
persistent drilling into my thick head.

-PJ Waskiewicz
peter.p.waskiewicz.jr@intel.com
