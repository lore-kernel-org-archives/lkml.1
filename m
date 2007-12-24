Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbXLXOr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbXLXOr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXLXOrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:47:48 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:37297 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbXLXOrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:47:47 -0500
Date: Mon, 24 Dec 2007 15:47:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: patrick@tykepenguin.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 31/38] net/decnet: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241547080.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
--- a/net/decnet/af_decnet.c	2007-11-08 08:00:53.000000000 +0100
+++ b/net/decnet/af_decnet.c	2007-12-23 20:30:40.000000000 +0100
@@ -128,6 +128,7 @@ Version 0.0.6    2.1.110   07-aug-98   E
 #include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/poll.h>
+#include <linux/jiffies.h>
 #include <net/net_namespace.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
@@ -601,7 +602,7 @@ int dn_destroy_timer(struct sock *sk)
 	if (sk->sk_socket)
 		return 0;
 
-	if ((jiffies - scp->stamp) >= (HZ * decnet_time_wait)) {
+	if (time_before_eq(jiffies, scp->stamp + HZ * decnet_time_wait)) {
 		dn_unhash_sock(sk);
 		sock_put(sk);
 		return 1;
diff -r -u -p a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
--- a/net/decnet/dn_dev.c	2007-12-04 13:19:55.000000000 +0100
+++ b/net/decnet/dn_dev.c	2007-12-23 20:30:40.000000000 +0100
@@ -40,6 +40,7 @@
 #include <linux/skbuff.h>
 #include <linux/sysctl.h>
 #include <linux/notifier.h>
+#include <linux/jiffies.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <net/net_namespace.h>
@@ -926,7 +927,7 @@ static void dn_send_endnode_hello(struct
 static int dn_am_i_a_router(struct dn_neigh *dn, struct dn_dev *dn_db, struct dn_ifaddr *ifa)
 {
 	/* First check time since device went up */
-	if ((jiffies - dn_db->uptime) < DRDELAY)
+	if (time_before(jiffies, dn_db->uptime + DRDELAY))
 		return 0;
 
 	/* If there is no router, then yes... */
diff -r -u -p a/net/decnet/dn_nsp_out.c b/net/decnet/dn_nsp_out.c
--- a/net/decnet/dn_nsp_out.c	2007-06-02 22:32:45.000000000 +0200
+++ b/net/decnet/dn_nsp_out.c	2007-12-23 20:30:40.000000000 +0100
@@ -61,6 +61,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/if_packet.h>
+#include <linux/jiffies.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
 #include <net/flow.h>
@@ -364,7 +365,7 @@ void dn_nsp_queue_xmit(struct sock *sk, 
 	 * Slow start: If we have been idle for more than
 	 * one RTT, then reset window to min size.
 	 */
-	if ((jiffies - scp->stamp) > t)
+	if (time_after(jiffies, scp->stamp + t))
 		scp->snd_window = NSP_MIN_WINDOW;
 
 	if (oth)
diff -r -u -p a/net/decnet/dn_route.c b/net/decnet/dn_route.c
--- a/net/decnet/dn_route.c	2007-11-13 16:01:33.000000000 +0100
+++ b/net/decnet/dn_route.c	2007-12-23 20:30:40.000000000 +0100
@@ -76,6 +76,7 @@
 #include <linux/netfilter_decnet.h>
 #include <linux/rcupdate.h>
 #include <linux/times.h>
+#include <linux/jiffies.h>
 #include <asm/errno.h>
 #include <net/net_namespace.h>
 #include <net/netlink.h>
@@ -178,7 +179,7 @@ static void dn_dst_check_expire(unsigned
 		}
 		spin_unlock(&dn_rt_hash_table[i].lock);
 
-		if ((jiffies - now) > 0)
+		if (time_after(jiffies, now))
 			break;
 	}
 
diff -r -u -p a/net/decnet/dn_timer.c b/net/decnet/dn_timer.c
--- a/net/decnet/dn_timer.c	2006-11-30 19:05:46.000000000 +0100
+++ b/net/decnet/dn_timer.c	2007-12-23 20:30:40.000000000 +0100
@@ -21,6 +21,7 @@
 #include <linux/netdevice.h>
 #include <linux/timer.h>
 #include <linux/spinlock.h>
+#include <linux/jiffies.h>
 #include <net/sock.h>
 #include <asm/atomic.h>
 #include <net/flow.h>
@@ -96,7 +97,7 @@ static void dn_slow_timer(unsigned long 
 	 * since the last successful transmission.
 	 */
 	if (scp->keepalive && scp->keepalive_fxn && (scp->state == DN_RUN)) {
-		if ((jiffies - scp->stamp) >= scp->keepalive)
+		if (time_before_eq(jiffies, scp->stamp + scp->keepalive))
 			scp->keepalive_fxn(sk);
 	}
 
