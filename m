Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZLWJwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZLWJwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 04:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZLWJwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 04:52:15 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60887 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZLWJwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 04:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=AIiyc07y4bhwLov4FJ4IsdPZ6NsHKyjojOTPT9cMJd0162GELwBI7X99pAJsQ78Wwd
         NB7YiqS4Mvk8lEgjN0vvvpsggikPi7cn2ieTjtTafDHnhbIHrD0RXyouJpRtO2xKh0qY
         LRcb/PbYcNu3hGJeCeeDfjpA68fWjpOztVHWk=
Date: Wed, 23 Dec 2009 09:52:03 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Roger Luethi <rl@hellgate.ch>
Cc: Andrey Rahmatullin <wrar@altlinux.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: via_rhine kernel crashes in 2.6.32
Message-ID: <20091223095203.GA7824@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222152658.GA16043@core.hellgate.ch>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-12-2009 16:26, Roger Luethi wrote:
> On Tue, 22 Dec 2009 20:00:45 +0500, Andrey Rahmatullin wrote:
>> On Tue, Dec 22, 2009 at 01:38:17PM +0000, Jarek Poplawski wrote:
>>>>> It looks like napi_disable() should be illegal in ndo_tx_timeout().
>>>>> Here is a patch which moves most of the timeout work to a workqueue,
>>>>> similarly to tg3 etc. It should prevent at least one of reported
>>>>> bugs. Alas I can't even check-compile it at the moment, so let me
>>>>> know on any problems.
>>>> It seems I needlessly changed locking btw, so here it is again.
>>> Hmm... On the other hand, it definitely needs at least _bh now...
>> I've tried this patch. There are lots of "Transmit timed out", but no
>> crashes.
> 
> ACK. Looks like you guys tracked down the crashing and fixed it (thanks!).
> I suspect we shouldn't have to reset due to timeouts that often, but that's
> another story.

BTW, it seems a change in 2.6.31 might trigger these timeouts more
often than before. Andrey, could you try if this matters here?

Thanks,
Jarek P.

--- (on top of net-2.6 with the previous "Fix scheduling..." patch)

diff -Nurp a/drivers/net/via-rhine.c b/drivers/net/via-rhine.c
--- a/drivers/net/via-rhine.c	2009-12-23 09:28:25.000000000 +0000
+++ b/drivers/net/via-rhine.c	2009-12-23 09:33:57.000000000 +0000
@@ -1226,6 +1226,7 @@ static void rhine_tx_timeout(struct net_
 	       mdio_read(dev, rp->mii_if.phy_id, MII_BMSR));
 
 	schedule_work(&rp->reset_task);
+	netdev_get_tx_queue(dev, 0)->trans_start = jiffies;
 }
 
 static netdev_tx_t rhine_start_tx(struct sk_buff *skb,
