Return-Path: <linux-kernel-owner+w=401wt.eu-S1764699AbZCTXlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764699AbZCTXlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763459AbZCTXaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:30:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:51431 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763429AbZCTXaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=cB28K+wvcTl4TqpttVST3pEl04w1GGB1zH8li+tH272IreXdJICRS8XCkKKrxrjGXk
         aHztFIP+G01VDrHnXq8oG7QsarNmo8NwhCoegtCWUvqHHN60cDUxPtlfoyED2oSEiJ6C
         fIdqUYH58CKRh5ucbUUnmEg2cBa9tlhdd5LE8=
Date: Sat, 21 Mar 2009 00:29:43 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: High contention on the sk_buff_head.lock
Message-ID: <20090320232943.GA3024@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C156E8.1090306@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vernon Mauery wrote, On 03/18/2009 09:17 PM:
...
> This patch does seem to reduce the number of contentions by about 10%.  That is
> a good start (and a good catch on the cacheline bounces).  But, like I mentioned
> above, this lock still has 2 orders of magnitude greater contention than the
> next lock, so even a large decrease like 10% makes little difference in the
> overall contention characteristics.
> 
> So we will have to do something more.  Whether it needs to be more complex or
> not is still up in the air.  Batched enqueueing/dequeueing are just two options
> and the former would be a *lot* less complex than the latter.
> 
> If anyone else has any ideas they have been holding back, now would be a great
> time to get them out in the open.

I think there would be interesting to check another idea around this
contention: not all contenders are equal here. One thread is doing
qdisc_run() and owning the transmit queue (even after releasing the TX
lock). So if it waits for the qdisc lock the NIC, if not multiqueue,
is idle. Probably some handicap like in the patch below could make
some difference in throughput; alas I didn't test it.

Jarek P.
---

 net/core/dev.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f112970..d5ad808 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1852,7 +1852,11 @@ gso:
 	if (q->enqueue) {
 		spinlock_t *root_lock = qdisc_lock(q);
 
-		spin_lock(root_lock);
+		while (!spin_trylock(root_lock)) {
+			do {
+				cpu_relax();
+			} while (spin_is_locked(root_lock));
+		}
 
 		if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state))) {
 			kfree_skb(skb);
