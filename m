Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYDXBcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYDXBcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYDXBcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:32:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36729 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYDXBcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:32:15 -0400
Date: Wed, 23 Apr 2008 18:32:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, shemminger@vyatta.com, linville@tuxdriver.com,
       sri@us.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] list_for_each_rcu must die: networking
Message-ID: <20080424013208.GA26526@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ll uses of list_for_each_rcu() can be profitably replaced by the
easier-to-use list_for_each_entry_rcu().  This patch makes this change
for networking, in preparation for removing the list_for_each_rcu()
API entirely.

Signed_off_by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 drivers/net/wireless/strip.c |    6 +++---
 net/802/psnap.c              |    4 +---
 net/ipv4/af_inet.c           |    3 +--
 net/ipv6/af_inet6.c          |    3 +--
 4 files changed, 6 insertions(+), 10 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25/drivers/net/wireless/strip.c linux-2.6.25-lfer-net/drivers/net/wireless/strip.c
--- linux-2.6.25/drivers/net/wireless/strip.c	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.25-lfer-net/drivers/net/wireless/strip.c	2008-04-23 16:52:42.000000000 -0700
@@ -962,12 +962,12 @@ static char *time_delta(char buffer[], l
 /* get Nth element of the linked list */
 static struct strip *strip_get_idx(loff_t pos) 
 {
-	struct list_head *l;
+	struct strip *s;
 	int i = 0;
 
-	list_for_each_rcu(l, &strip_list) {
+	list_for_each_entry_rcu(s, &strip_list, list) {
 		if (pos == i)
-			return list_entry(l, struct strip, list);
+			return s;
 		++i;
 	}
 	return NULL;
diff -urpNa -X dontdiff linux-2.6.25/net/802/psnap.c linux-2.6.25-lfer-net/net/802/psnap.c
--- linux-2.6.25/net/802/psnap.c	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.25-lfer-net/net/802/psnap.c	2008-04-23 16:56:21.000000000 -0700
@@ -30,11 +30,9 @@ static struct llc_sap *snap_sap;
  */
 static struct datalink_proto *find_snap_client(unsigned char *desc)
 {
-	struct list_head *entry;
 	struct datalink_proto *proto = NULL, *p;
 
-	list_for_each_rcu(entry, &snap_list) {
-		p = list_entry(entry, struct datalink_proto, node);
+	list_for_each_entry_rcu(p, &snap_list, node) {
 		if (!memcmp(p->type, desc, 5)) {
 			proto = p;
 			break;
diff -urpNa -X dontdiff linux-2.6.25/net/ipv4/af_inet.c linux-2.6.25-lfer-net/net/ipv4/af_inet.c
--- linux-2.6.25/net/ipv4/af_inet.c	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.25-lfer-net/net/ipv4/af_inet.c	2008-04-23 16:56:03.000000000 -0700
@@ -274,8 +274,7 @@ static int inet_create(struct net *net, 
 lookup_protocol:
 	err = -ESOCKTNOSUPPORT;
 	rcu_read_lock();
-	list_for_each_rcu(p, &inetsw[sock->type]) {
-		answer = list_entry(p, struct inet_protosw, list);
+	list_for_each_entry_rcu(answer, &inetsw[sock->type], list) {
 
 		/* Check the non-wild match. */
 		if (protocol == answer->protocol) {
diff -urpNa -X dontdiff linux-2.6.25/net/ipv6/af_inet6.c linux-2.6.25-lfer-net/net/ipv6/af_inet6.c
--- linux-2.6.25/net/ipv6/af_inet6.c	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.25-lfer-net/net/ipv6/af_inet6.c	2008-04-23 16:55:51.000000000 -0700
@@ -105,8 +105,7 @@ static int inet6_create(struct net *net,
 lookup_protocol:
 	err = -ESOCKTNOSUPPORT;
 	rcu_read_lock();
-	list_for_each_rcu(p, &inetsw6[sock->type]) {
-		answer = list_entry(p, struct inet_protosw, list);
+	list_for_each_entry_rcu(answer, &inetsw6[sock->type], list) {
 
 		/* Check the non-wild match. */
 		if (protocol == answer->protocol) {
