Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556Ab0AEXHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0AEXHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324Ab0AEXHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:07:53 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33016 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab0AEXHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:07:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=Hi3g2P086E7DWRjCSoAATx6LCNrdmBe2dAaACEeFXoZp1ZWxUMafd2yFXbYWbOExwB
         Ugnp7QAsYGGmYMLXcYteebepYcEf5KAxuYQStiIQswwjZIk6tr1cND5GcFqZ19k+kY8c
         Rcprb1iVR8bjPEZWRPs1Y4PnNno/zseqV1yRc=
Date: Wed, 6 Jan 2010 00:07:46 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@linux-foundation.org, mbreuer@majjas.com,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100105230746.GA6612@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091226.201107.35060733.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote, On 12/27/2009 05:11 AM:

> From: David Miller <davem@davemloft.net>
> Date: Sat, 26 Dec 2009 19:44:18 -0800 (PST)
> 
>> From: Stephen Hemminger <shemminger@linux-foundation.org>
>> Date: Sat, 26 Dec 2009 14:05:44 -0800
>>
>>> Other drivers may have same problem, I really think this ought
>>> to be done at higher level.
>> I tend to agree with you, and I thought we had handled all
>> cases.  Let's simply make AF_PACKET linearize the link
>> level header before sending things out to the transmit path.
>>
>> I can work on this if you want.
> 
> Actually Stephen, I took a look and I can't see how AF_PACKET
> can create this situation.
> 
> It always copies into the linear area of the SKB it allocates
> for sendmsg() processing.  Whether the data comes from sendmsg
> data or the mmap() ring buffer.

Actually, I think there is a bug in this place, but of course this
might be unconnected. Anyway, Michael, could you try this patch?
BTW, did you try with CONFIG_PACKET_MMAP disabled?

Thanks,
Jarek P.
----------------->

Changing an skb after dev_queue_xmit() is illegal. And since it's
inconsistent to treat specially net_xmit_errno() non-zero return,
while ignoring other dev_queue_xmit() errors, there is no reason
to break the loop in tpacket_snd() in this case.

With debugging by: Stephen Hemminger <shemminger@linux-foundation.org>

Reported-by: Michael Breuer <mbreuer@majjas.com>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

 net/packet/af_packet.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e0516a2..984a1fa 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1021,8 +1021,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 		status = TP_STATUS_SEND_REQUEST;
 		err = dev_queue_xmit(skb);
-		if (unlikely(err > 0 && (err = net_xmit_errno(err)) != 0))
-			goto out_xmit;
+		if (unlikely(err > 0))
+			err = net_xmit_errno(err);
+
 		packet_increment_head(&po->tx_ring);
 		len_sum += tp_len;
 	} while (likely((ph != NULL) ||
@@ -1033,9 +1034,6 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	err = len_sum;
 	goto out_put;
 
-out_xmit:
-	skb->destructor = sock_wfree;
-	atomic_dec(&po->tx_ring.pending);
 out_status:
 	__packet_set_status(po, ph, status);
 	kfree_skb(skb);
