Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbXLKXpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbXLKXpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbXLKXov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:44:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbXLKXou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:44:50 -0500
Date: Tue, 11 Dec 2007 15:42:22 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Joonwoo Park" <joonwpark81@gmail.com>
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] [NET]: Fix Ooops of napi net_rx_action.
Message-ID: <20071211154222.0aec68fc@freepuppy.rosehill>
In-Reply-To: <b25c3fa70712111527p561b3e2i24ee0fdf3d61a98c@mail.gmail.com>
References: <001801c83bd6$2001d410$9c94fea9@jason>
	<20071211.023218.31965443.davem@davemloft.net>
	<b25c3fa70712110457g2bf04c6flc387f2b9cb51cf3b@mail.gmail.com>
	<36D9DB17C6DE9E40B059440DB8D95F5203F82FC3@orsmsx418.amr.corp.intel.com>
	<b25c3fa70712111527p561b3e2i24ee0fdf3d61a98c@mail.gmail.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps we should change the warning to identify the guilty device.


--- a/net/core/dev.c	2007-11-19 09:09:57.000000000 -0800
+++ b/net/core/dev.c	2007-12-07 15:54:03.000000000 -0800
@@ -2196,7 +2196,13 @@ static void net_rx_action(struct softirq
 		if (test_bit(NAPI_STATE_SCHED, &n->state))
 			work = n->poll(n, weight);
 
-		WARN_ON_ONCE(work > weight);
+		if (unlikely(work > weight)) {
+			if (net_ratelimit())
+				printk(KERN_WARNING
+				       "%s: driver poll bug (work=%d weight=%d)\n",
+				       work, weight);
+			work = weight;
+		}
 
 		budget -= work;
 

