Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYGZNRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYGZNRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYGZNRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:17:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:65173 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYGZNRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F4LMW4SW0pcWf6i7OA1m5DBdIkmaQ+ha+Hk6i7N8GPaLGzM3muQAoqjZOuVNVkJbuF
         g4LBj0GriHMRDiXufYTSmrgjlyPaanNMMIdbqfFPjYBbRRjyVeblFVehfuzBINElU42n
         itb+5YCJ8gb1vvWImf8QHvc6EWkPOyfQhwlIM=
Date: Sat, 26 Jul 2008 15:18:38 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, netdev@axxeo.de, peterz@infradead.org,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080726131838.GA2873@ami.dom.local>
References: <20080725193416.GB3107@ami.dom.local> <1217014575.4758.7.camel@johannes.berg> <20080725200137.GC3107@ami.dom.local> <20080726.021846.236624483.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726.021846.236624483.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 02:18:46AM -0700, David Miller wrote:
...
> I think there might be an easier way, but we may have
> to modify the state bits a little.
> 
> Every call into ->hard_start_xmit() is made like this:
> 
> 1. lock TX queue
> 2. check TX queue stopped
> 3. call ->hard_start_xmit() if not stopped
> 
> This means that we can in fact do something like:
> 
> 	unsigned int i;
> 
> 	for (i = 0; i < dev->num_tx_queues; i++) {
> 		struct netdev_queue *txq;
> 
> 		txq = netdev_get_tx_queue(dev, i);
> 		spin_lock_bh(&txq->_xmit_lock);
> 		netif_tx_freeze_queue(txq);
> 		spin_unlock_bh(&txq->_xmit_lock);
> 	}
> 
> netif_tx_freeze_queue() just sets a new bit we add.
> 
> Then we go to the ->hard_start_xmit() call sites and check this new
> "frozen" bit as well as the existing "stopped" bit.
> 
> When we unfreeze each queue later, we see if it is stopped, and if not
> we schedule it's qdisc for packet processing.

I guess some additional synchronization will be added yet to prevent
parallel freeze and especially unfreeze.

Jarek P.
