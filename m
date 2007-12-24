Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbXLXOtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbXLXOtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXLXOtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:49:11 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:49873 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXLXOtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:49:09 -0500
Date: Mon, 24 Dec 2007 15:48:43 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: davem@davemloft.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 33/38] net/ipv4: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241548180.23999@ask.diku.dk>
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

diff -r -u -p a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
--- a/net/ipv4/ip_gre.c	2007-11-01 10:30:44.000000000 +0100
+++ b/net/ipv4/ip_gre.c	2007-12-23 20:44:52.000000000 +0100
@@ -28,6 +28,7 @@
 #include <linux/igmp.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/if_ether.h>
+#include <linux/jiffies.h>
 
 #include <net/sock.h>
 #include <net/ip.h>
@@ -373,7 +374,7 @@ static void ipgre_err(struct sk_buff *sk
 	if (t->parms.iph.ttl == 0 && type == ICMP_TIME_EXCEEDED)
 		goto out;
 
-	if (jiffies - t->err_time < IPTUNNEL_ERR_TIMEO)
+	if (time_before(jiffies, t->err_time + IPTUNNEL_ERR_TIMEO))
 		t->err_count++;
 	else
 		t->err_count = 1;
@@ -799,7 +800,8 @@ static int ipgre_tunnel_xmit(struct sk_b
 #endif
 
 	if (tunnel->err_count > 0) {
-		if (jiffies - tunnel->err_time < IPTUNNEL_ERR_TIMEO) {
+		if (time_before(jiffies,
+				tunnel->err_time + IPTUNNEL_ERR_TIMEO)) {
 			tunnel->err_count--;
 
 			dst_link_failure(skb);
diff -r -u -p a/net/ipv4/ipip.c b/net/ipv4/ipip.c
--- a/net/ipv4/ipip.c	2007-11-01 10:30:44.000000000 +0100
+++ b/net/ipv4/ipip.c	2007-12-23 20:45:06.000000000 +0100
@@ -108,6 +108,7 @@
 #include <linux/init.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/if_ether.h>
+#include <linux/jiffies.h>
 
 #include <net/sock.h>
 #include <net/ip.h>
@@ -317,7 +318,7 @@ static int ipip_err(struct sk_buff *skb,
 	if (t->parms.iph.ttl == 0 && type == ICMP_TIME_EXCEEDED)
 		goto out;
 
-	if (jiffies - t->err_time < IPTUNNEL_ERR_TIMEO)
+	if (time_before(jiffies, t->err_time + IPTUNNEL_ERR_TIMEO))
 		t->err_count++;
 	else
 		t->err_count = 1;
@@ -582,7 +583,8 @@ static int ipip_tunnel_xmit(struct sk_bu
 	}
 
 	if (tunnel->err_count > 0) {
-		if (jiffies - tunnel->err_time < IPTUNNEL_ERR_TIMEO) {
+		if (time_before(jiffies,
+				tunnel->err_time + IPTUNNEL_ERR_TIMEO)) {
 			tunnel->err_count--;
 			dst_link_failure(skb);
 		} else
diff -r -u -p a/net/ipv4/ipvs/ip_vs_lblcr.c b/net/ipv4/ipvs/ip_vs_lblcr.c
--- a/net/ipv4/ipvs/ip_vs_lblcr.c	2007-12-09 09:35:20.000000000 +0100
+++ b/net/ipv4/ipvs/ip_vs_lblcr.c	2007-12-23 20:45:42.000000000 +0100
@@ -733,7 +733,8 @@ ip_vs_lblcr_schedule(struct ip_vs_servic
 			ip_vs_dest_set_insert(&en->set, dest);
 		}
 		if (atomic_read(&en->set.size) > 1 &&
-		    jiffies-en->set.lastmod > sysctl_ip_vs_lblcr_expiration) {
+		    time_after(jiffies,
+			       en->set.lastmod+sysctl_ip_vs_lblcr_expiration)){
 			struct ip_vs_dest *m;
 			m = ip_vs_dest_set_max(&en->set);
 			if (m)
