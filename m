Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbZJUVTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbZJUVTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZJUVTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:19:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52429 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbZJUVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JZ72rzqskUJWCyOkph+jxnsoWwCDDYF0EcIu1wGj7PExG5v3s3B10d10CgOqgKFEOn
         W+rUBKMHXMLPep61EYybZgBb64uXMbb74XoqqJD+zjexdjM/NB7GvL6Yt6QKRPOvVHTu
         HvYDJm2XgJyD8U0xnfkVG7RCy2r25SYzu5g7w=
Date: Wed, 21 Oct 2009 23:19:06 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
Subject: [PATCH] net: Adjust softirq raising in __napi_schedule
Message-ID: <20091021211906.GA11401@ami.dom.local>
References: <4AD31213.6020006@imap.cc>
 <20091015114052.GA9870@ff.dom.local>
 <4AD76184.6030900@gmail.com>
 <4ADF5710.4030505@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADF5710.4030505@imap.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 08:46:40PM +0200, Tilman Schmidt wrote:
...
> I have tested your patch and I can confirm that it fixes the messages.
> I have not noticed any ill effects.

OK. So, in any case, here is this next variant/proposal.

Thanks,
Jarek P.
------------------------>
net: Adjust softirq raising in __napi_schedule

This patch changes __raise_softirq_irqoff() to raise_softirq_irqoff()
in __napi_schedule() to enable proper softirq scheduling from process
context. The main intent is to let use netif_rx() universally, and
make netif_rx_ni() redundant.

Currently using netif_rx() instead of netif_rx_ni() triggers:
"NOHZ: local_softirq_pending 08" warnings, but additional cost of one
"if" on the fast path doesn't seem to justify maintaining it
separately.

This patch is based on the analysis, suggestions and the original
patch for mac80211 by: Michael Buesch <mb@bu3sch.de>

Another patch calling netif_rx variants conditionally was done by:
Oliver Hartkopp <oliver@hartkopp.net>

Reported-by: Michael Buesch <mb@bu3sch.de>
Reported-by: Oliver Hartkopp <oliver@hartkopp.net>
Reported-by: Tilman Schmidt <tilman@imap.cc>
Diagnosed-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

 net/core/dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 28b0b9e..7fc4009 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2728,7 +2728,7 @@ void __napi_schedule(struct napi_struct *n)
 
 	local_irq_save(flags);
 	list_add_tail(&n->poll_list, &__get_cpu_var(softnet_data).poll_list);
-	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+	raise_softirq_irqoff(NET_RX_SOFTIRQ);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__napi_schedule);
