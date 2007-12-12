Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbXLLIJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbXLLIJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbXLLIJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:09:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:13942 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbXLLIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:09:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NFp0uC1jz+YGz0rTXLfHVccd9V9hwdUuoDn2prEpWh2jSmj/0ZcLn2P6uQ2sgSZ8UAczohv6S6kXTWJnKQo3PD0HC6EvUu70TQIDgsb1wRtrSL+hS8cbi9+LspQbv9DhrTv2WmcjFhDBXimjLqbX2fjztwWRRCNOXIulV4aXenM=
Subject: [PATCH] Net: Remove FASTCALL macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: netdev@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 00:09:03 -0800
Message-Id: <1197446943.5745.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_32 was the last user of the FASTCALL macro, now that it
uses regparm(3) by default, this macro expands to nothing.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Should this be coordinated with the FASTCALL() removal in the
x86 git tree?

 drivers/net/ns83820.c          |    5 +----
 include/net/bluetooth/rfcomm.h |    4 ++--
 include/net/sock.h             |    4 ++--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ns83820.c b/drivers/net/ns83820.c
index ea71f6d..972acc3 100644
--- a/drivers/net/ns83820.c
+++ b/drivers/net/ns83820.c
@@ -611,7 +611,7 @@ static inline int rx_refill(struct net_device *ndev, gfp_t gfp)
 	return i ? 0 : -ENOMEM;
 }
 
-static void FASTCALL(rx_refill_atomic(struct net_device *ndev));
+static void rx_refill_atomic(struct net_device *ndev));
 static void fastcall rx_refill_atomic(struct net_device *ndev)
 {
 	rx_refill(ndev, GFP_ATOMIC);
@@ -633,7 +633,6 @@ static inline void clear_rx_desc(struct ns83820 *dev, unsigned i)
 	build_rx_desc(dev, dev->rx_info.descs + (DESC_SIZE * i), 0, 0, CMDSTS_OWN, 0);
 }
 
-static void FASTCALL(phy_intr(struct net_device *ndev));
 static void fastcall phy_intr(struct net_device *ndev)
 {
 	struct ns83820 *dev = PRIV(ndev);
@@ -832,7 +831,6 @@ static void ns83820_cleanup_rx(struct ns83820 *dev)
 	}
 }
 
-static void FASTCALL(ns83820_rx_kick(struct net_device *ndev));
 static void fastcall ns83820_rx_kick(struct net_device *ndev)
 {
 	struct ns83820 *dev = PRIV(ndev);
@@ -854,7 +852,6 @@ static void fastcall ns83820_rx_kick(struct net_device *ndev)
 /* rx_irq
  *
  */
-static void FASTCALL(rx_irq(struct net_device *ndev));
 static void fastcall rx_irq(struct net_device *ndev)
 {
 	struct ns83820 *dev = PRIV(ndev);
diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 25aa575..98ec7a3 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -252,8 +252,8 @@ static inline void rfcomm_dlc_put(struct rfcomm_dlc *d)
 		rfcomm_dlc_free(d);
 }
 
-extern void FASTCALL(__rfcomm_dlc_throttle(struct rfcomm_dlc *d));
-extern void FASTCALL(__rfcomm_dlc_unthrottle(struct rfcomm_dlc *d));
+extern void __rfcomm_dlc_throttle(struct rfcomm_dlc *d);
+extern void __rfcomm_dlc_unthrottle(struct rfcomm_dlc *d);
 
 static inline void rfcomm_dlc_throttle(struct rfcomm_dlc *d)
 {
diff --git a/include/net/sock.h b/include/net/sock.h
index 67e35c7..bdad9ba 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -812,14 +812,14 @@ do {									\
 	lockdep_init_map(&(sk)->sk_lock.dep_map, (name), (key), 0);	\
 } while (0)
 
-extern void FASTCALL(lock_sock_nested(struct sock *sk, int subclass));
+extern void lock_sock_nested(struct sock *sk, int subclass);
 
 static inline void lock_sock(struct sock *sk)
 {
 	lock_sock_nested(sk, 0);
 }
 
-extern void FASTCALL(release_sock(struct sock *sk));
+extern void release_sock(struct sock *sk);
 
 /* BH context may only use the following locking interface. */
 #define bh_lock_sock(__sk)	spin_lock(&((__sk)->sk_lock.slock))
-- 
1.5.3.7.2212.gd092



