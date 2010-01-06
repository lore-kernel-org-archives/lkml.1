Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621Ab0AFJPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0AFJPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722Ab0AFJPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:15:41 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35305 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0AFJPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:15:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wu5xSKgbULUQpCdoSrdxxx1SfJlV9naWyI9jOCLElvePq7azmklhxFlzNkCYGhUWLu
         9wyqjElerFp1+QVM6QU5lFMW25exiEuncVCpcG04LivmlTV+tzfAkld3oMDzGLKsyfHJ
         viO3ObEIrOiRTSS/LOyKGqniq5NPEIzJflFYs=
Date: Wed, 6 Jan 2010 09:15:32 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: David Miller <davem@davemloft.net>, shemminger@linux-foundation.org,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH alt.2] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100106091532.GA10201@ff.dom.local>
References: <20100105230746.GA6612@del.dom.local> <4B43F72C.9090004@majjas.com> <20100106072208.GA6711@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106072208.GA6711@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 07:22:08AM +0000, Jarek Poplawski wrote:
> On Tue, Jan 05, 2010 at 09:36:28PM -0500, Michael Breuer wrote:
> > Is it possible that this patch is causing the transmission to  
> > momentarily halt such that the overall utilization appears low at the  
> > time I see the interrupt errors, vs. the other patch which perhaps  
> > doesn't interrupt the traffic flow quite so much?
> 
> Yes, without this patch xmit could be stopped earlier on some kind of
> errors, with retransmit of the last message possible. On the other
> hand, other dev_queue_xmit() (negative) errors, are ignored. So this
> place could be still improved by adding proper err handling (or
> removing getting err return from dev_queue_xmit() at all).

On the other hand, returning just this one net_xmit_errno() would be
consistent with non-MMAP sendmsg, so here is an alternative version
for testing.

Thanks,
Jarek P.

-----------------> (alternative #2)

tpacket_snd() can change and kfree an skb after dev_queue_xmit(),
which is illegal.

With debugging by: Stephen Hemminger <shemminger@linux-foundation.org>

Reported-by: Michael Breuer <mbreuer@majjas.com>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

 net/packet/af_packet.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e0516a2..aba2049 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1021,9 +1021,10 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 		status = TP_STATUS_SEND_REQUEST;
 		err = dev_queue_xmit(skb);
-		if (unlikely(err > 0 && (err = net_xmit_errno(err)) != 0))
-			goto out_xmit;
 		packet_increment_head(&po->tx_ring);
+		if (unlikely(err > 0 && (err = net_xmit_errno(err)) != 0))
+			goto out_put;
+
 		len_sum += tp_len;
 	} while (likely((ph != NULL) ||
 			((!(msg->msg_flags & MSG_DONTWAIT)) &&
@@ -1033,9 +1034,6 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	err = len_sum;
 	goto out_put;
 
-out_xmit:
-	skb->destructor = sock_wfree;
-	atomic_dec(&po->tx_ring.pending);
 out_status:
 	__packet_set_status(po, ph, status);
 	kfree_skb(skb);
