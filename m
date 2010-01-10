Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018Ab0AJVv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0AJVv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 16:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982Ab0AJVv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 16:51:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50685
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab0AJVv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 16:51:27 -0500
Date: Sun, 10 Jan 2010 13:51:35 -0800 (PST)
Message-Id: <20100110.135135.237364018.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: mbreuer@majjas.com, shemminger@vyatta.com, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6 resent] af_packet: Don't use skb after
 dev_queue_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100109123827.GB4386@del.dom.local>
References: <20100109123827.GB4386@del.dom.local>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Sat, 9 Jan 2010 13:38:27 +0100

> tpacket_snd() can change and kfree an skb after dev_queue_xmit(),
> which is illegal.
> 
> With debugging by: Stephen Hemminger <shemminger@vyatta.com>
> 
> Reported-by: Michael Breuer <mbreuer@majjas.com>
> Tested-by: Michael Breuer <mbreuer@majjas.com>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
> Acked-by: Stephen Hemminger <shemminger@vyatta.com>

Jarek, if this code path triggers, it will deadlock the
send ring with your changes.

We will now leave the ring packet status in the "SENDING" state.

That's not right.

Then, if the application calls send again, we will just return
immediately since we only make progress if the head ring entry is in
SEND_REQUEST state.

This is really bogus behavior.  When the qdisc or mid-layer
drops the packet, we should at least mark the packet state
properly (which is what the current code would does, sans
the "reference SKB after dev_queue_xmit()" issue).  And
advance the packet ring pointer.

This way the user:

1) can see that the packet got dropped and couldn't be sent

2) can call send again to try sending the rest of the ring

Fix the use after dev_queue_xmit() issue, but don't change other side
effects which are important for correct AF_PACKET TX ring semantics.
