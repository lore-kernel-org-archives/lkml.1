Return-Path: <linux-kernel-owner+w=401wt.eu-S1751494AbZHSKbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbZHSKbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZHSKbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:31:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:34285 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZHSKbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:31:13 -0400
Subject: [PATCH] netpoll: WARN_ONCE for start_xmit returns with interrupts
	enabled
From: DDD <Dongdong.deng@windriver.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Aug 2009 18:43:27 +0800
Message-Id: <1250678607.17891.26.camel@dengdd-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 19 Aug 2009 10:30:58.0655 (UTC) FILETIME=[242E0EF0:01CA20B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NETPOLL API requires that interrupts remain disabled in
netpoll_send_skb().

Add a WARN_ONCE when ndo_start_xmit returns with interrupts enabled
in netpoll_send_skb().

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
---
 net/core/netpoll.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index df30feb..d38103f 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -319,6 +319,12 @@ static void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 
 			udelay(USEC_PER_POLL);
 		}
+
+		WARN_ONCE(!irqs_disabled(),
+			KERN_WARNING "netpoll_send_skb(): [net driver %s]"
+			"ndo_start_xmit() shouldn't return with interrupts"
+			"enabled!", dev->name);
+
 		local_irq_restore(flags);
 	}
 
-- 
1.6.0.4


