Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbXKWSvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbXKWSvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 13:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXKWSvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 13:51:44 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:60657 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbXKWSvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 13:51:43 -0500
Date: Fri, 23 Nov 2007 21:51:02 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: 2.6.23 WARNING: at kernel/softirq.c:139 local_bh_enable()
Message-ID: <20071123185101.GA17582@2ka.mipt.ru>
References: <4745DCD7.8070805@simon.arlott.org.uk> <20071123002157.cb27f4a1.akpm@linux-foundation.org> <20071123105518.GA22062@2ka.mipt.ru> <20071123170756.GV19691@waste.org> <20071123175757.GA23991@2ka.mipt.ru> <20071123184851.GA14415@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071123184851.GA14415@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 09:48:51PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> Stop, we are trying to free skb without destructor and catch connection
> tracking, so it is not a solution. To fix the problem we need to check
> if it is not netfilter related, kind of this (not tested), Simon please
> give it a try:

And to be really cool we need to bypass skbs with xfrm attached, since
its freeing also assumes BH context.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 758dafe..5f86e60 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -196,7 +196,8 @@ static void zap_completion_queue(void)
 		while (clist != NULL) {
 			struct sk_buff *skb = clist;
 			clist = clist->next;
-			if (skb->destructor)
+			if (skb->destructor || skb->nfct ||
+					skb->nfct_reasm || skb->sp)
 				dev_kfree_skb_any(skb); /* put this one back */
 			else
 				__kfree_skb(skb);


-- 
	Evgeniy Polyakov
