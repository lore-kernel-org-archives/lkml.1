Return-Path: <linux-kernel-owner+w=401wt.eu-S932797Ab0AFVJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0AFVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932276Ab0AFVJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:09:56 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62293 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab0AFVJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LU3LP6BeNp7pplqHlCzJWJPhys+f9qFfHmNhRYIGhYge2XydA6d5jS4DEox5h1OYbo
         OzWxZdLdPTNeWCPLc6oNsoUDZxry2wbuNfa4LCDmI3kqCM0F86c9NoqDrWWv5IrAGy8m
         I5lxBKU2dP7KwLlXMub+/qS6C3QHLe+mMVFn0=
Date: Wed, 6 Jan 2010 22:09:41 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: David Miller <davem@davemloft.net>, shemminger@linux-foundation.org,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100106210941.GC3354@del.dom.local>
References: <20100105230746.GA6612@del.dom.local>
 <4B43F72C.9090004@majjas.com>
 <20100106072208.GA6711@ff.dom.local>
 <4B44E952.5000804@majjas.com>
 <20100106202212.GB3354@del.dom.local>
 <4B44F381.3000206@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B44F381.3000206@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 03:33:05PM -0500, Michael Breuer wrote:
> On 1/6/2010 3:22 PM, Jarek Poplawski wrote:
> >On Wed, Jan 06, 2010 at 02:49:38PM -0500, Michael Breuer wrote:
> >>On 1/6/2010 2:22 AM, Jarek Poplawski wrote:
> >>>On Tue, Jan 05, 2010 at 09:36:28PM -0500, Michael Breuer wrote:
> >>>>On 1/5/2010 6:07 PM, Jarek Poplawski wrote:
> >>>>>----------------->
> >>>>>
> >>>>>Changing an skb after dev_queue_xmit() is illegal. And since it's
> >>>>>inconsistent to treat specially net_xmit_errno() non-zero return,
> >>>>>while ignoring other dev_queue_xmit() errors, there is no reason
> >>>>>to break the loop in tpacket_snd() in this case.
> >>>>>
> >>>>>With debugging by: Stephen Hemminger<shemminger@linux-foundation.org>
> >>>>>
> >>>>>Reported-by: Michael Breuer<mbreuer@majjas.com>
> >>>>>Signed-off-by: Jarek Poplawski<jarkao2@gmail.com>
> >>>>>---
> >>>>>
> >>>>>   net/packet/af_packet.c |    8 +++-----
> >>>>>   1 files changed, 3 insertions(+), 5 deletions(-)
> >>>>>
> >>>>>diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> >>>>>index e0516a2..984a1fa 100644
> >>>>>--- a/net/packet/af_packet.c
> >>>>>+++ b/net/packet/af_packet.c
> >>>>>@@ -1021,8 +1021,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> >>>>>
> >>>>>   		status = TP_STATUS_SEND_REQUEST;
> >>>>>   		err = dev_queue_xmit(skb);
> >>>>>-		if (unlikely(err>    0&&    (err = net_xmit_errno(err)) != 0))
> >>>>>-			goto out_xmit;
> >>>>>+		if (unlikely(err>    0))
> >>>>>+			err = net_xmit_errno(err);
> >>>>>+
> >>>>>   		packet_increment_head(&po->tx_ring);
> >>>>>   		len_sum += tp_len;
> >>>>>   	} while (likely((ph != NULL) ||
> >>>>>@@ -1033,9 +1034,6 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> >>>>>   	err = len_sum;
> >>>>>   	goto out_put;
> >>>>>
> >>>>>-out_xmit:
> >>>>>-	skb->destructor = sock_wfree;
> >>>>>-	atomic_dec(&po->tx_ring.pending);
> >>>>>   out_status:
> >>>>>   	__packet_set_status(po, ph, status);
> >>>>>   	kfree_skb(skb);
> >>>>>--
...
> >>This patch at first behaved similarly to the previous one - seemed
> >>to be running a bit better... until the adapter went down :(
> >I'm not sure: do you mean this patch above vs previous one by Stephen,
> >or did you manage to try my "alernative #2" patch already?
> >
> >BTW, I forgot to mention, and maybe it doesn't matter here, but it
> >would be better to (always) use my sky2 patch from Berck Nash's
> >thread.
> >
> >Jarek P.
> This was using "alternative #2" patch. I didn't get the hang with
> alternative #1. Your sky2 patch from Berck Nash's thread was
> included in both cases; Stephen's was not.

OK, so I guess "alternative #1" (above) seems safer to recommend for
now (as I assumed earlier).

On the other hand, we really don't know if it's only because it's
because it's nicer for your hardware (or still some other bug around),
so as before: let David choose ;-)

BTW, I think you could still use Stephen's patch too (there might be
still something more like this). There was also mentioned this network
manager again. I might be wrong, but IMHO there could be some
interaction even if it doesn't use this device; so could/did you try
to disable it entirely?

Thanks for testing!
Jarek P.

 

