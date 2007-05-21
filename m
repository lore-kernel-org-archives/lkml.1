Return-Path: <linux-kernel-owner+w=401wt.eu-S935622AbXEUTue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935622AbXEUTue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933843AbXEUT3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:16 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52642 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbXEUT3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:14 -0400
Message-Id: <20070521191728.137091000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jeff Garzik <jgarzik@pobox.com>, Tom Rini <trini@kernel.crashing.org>,
       Matt Mackall <mpm@selenic.com>
Subject: [patch 32/69] NETPOLL: Fix TX queue overflow in trapped mode.
Content-Disposition: inline; filename=netpoll-fix-tx-queue-overflow-in-trapped-mode.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

CONFIG_NETPOLL_TRAP causes the TX queue controls to be completely bypassed in
the netpoll's "trapped" mode which easily causes overflows in the drivers with
short TX queues (most notably, in 8139too with its 4-deep queue).  So, make
this option more sensible by making it only bypass the TX softirq wakeup.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Jeff Garzik <jgarzik@pobox.com>
Acked-by: Tom Rini <trini@kernel.crashing.org>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/netdevice.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- linux-2.6.21.1.orig/include/linux/netdevice.h
+++ linux-2.6.21.1/include/linux/netdevice.h
@@ -647,8 +647,10 @@ static inline void netif_start_queue(str
 static inline void netif_wake_queue(struct net_device *dev)
 {
 #ifdef CONFIG_NETPOLL_TRAP
-	if (netpoll_trap())
+	if (netpoll_trap()) {
+		clear_bit(__LINK_STATE_XOFF, &dev->state);
 		return;
+	}
 #endif
 	if (test_and_clear_bit(__LINK_STATE_XOFF, &dev->state))
 		__netif_schedule(dev);
@@ -656,10 +658,6 @@ static inline void netif_wake_queue(stru
 
 static inline void netif_stop_queue(struct net_device *dev)
 {
-#ifdef CONFIG_NETPOLL_TRAP
-	if (netpoll_trap())
-		return;
-#endif
 	set_bit(__LINK_STATE_XOFF, &dev->state);
 }
 

-- 
