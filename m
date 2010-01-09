Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353Ab0AIMig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0AIMig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 07:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128Ab0AIMif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 07:38:35 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:63421 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0AIMie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 07:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=T9JfVR30s4F4gCjjSM1YfIImtFJao96VMGHNvz1IDkkTYzESdSgLhFv3KHundMMOXX
         MH9FZfEh1U/eNmXDf5RG0Me7GimPxGXcio+exdPplfGIaK61PxGdTsoZlR8mJykzdCYm
         23NLC8C1A1JdOKRFwW9C0Kxa43unOhOHypR/c=
Date: Sat, 9 Jan 2010 13:38:27 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Michael Breuer <mbreuer@majjas.com>,
       Stephen Hemminger <shemminger@vyatta.com>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-2.6 resent] af_packet: Don't use skb after
 dev_queue_xmit()
Message-ID: <20100109123827.GB4386@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tpacket_snd() can change and kfree an skb after dev_queue_xmit(),
which is illegal.

With debugging by: Stephen Hemminger <shemminger@vyatta.com>

Reported-by: Michael Breuer <mbreuer@majjas.com>
Tested-by: Michael Breuer <mbreuer@majjas.com>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
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


