Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYDXDjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYDXDjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 23:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYDXDjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 23:39:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38325 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbYDXDjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 23:39:08 -0400
Date: Wed, 23 Apr 2008 20:38:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, shemminger@vyatta.com, linville@tuxdriver.com,
       sri@us.ibm.com, davem@davemloft.net
Subject: [PATCH] list_for_each_rcu must die: networking
Message-ID: <20080424033849.GA4401@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All uses of list_for_each_rcu() can be profitably replaced by the
easier-to-use list_for_each_entry_rcu().  This patch makes this change
for networking, in preparation for removing the list_for_each_rcu()
API entirely.

Updated to remove the two now-unused variables as noted by Dave Miller.

Acked-by: David S. Miller <davem@davemloft.net> (lkml.org/lkml/2008/4/23/448)
Signed_off_by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 drivers/net/wireless/strip.c |    6 +++---
 net/802/psnap.c              |    4 +---
 net/ipv4/af_inet.c           |    4 +---
 net/ipv6/af_inet6.c          |    4 +---
 4 files changed, 6 insertions(+), 12 deletions(-)

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
+++ linux-2.6.25-lfer-net/net/ipv4/af_inet.c	2008-04-23 19:16:12.000000000 -0700
@@ -250,7 +250,6 @@ EXPORT_SYMBOL(build_ehash_secret);
 static int inet_create(struct net *net, struct socket *sock, int protocol)
 {
 	struct sock *sk;
-	struct list_head *p;
 	struct inet_protosw *answer;
 	struct inet_sock *inet;
 	struct proto *answer_prot;
@@ -274,8 +273,7 @@ static int inet_create(struct net *net, 
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
+++ linux-2.6.25-lfer-net/net/ipv6/af_inet6.c	2008-04-23 19:16:33.000000000 -0700
@@ -84,7 +84,6 @@ static int inet6_create(struct net *net,
 	struct inet_sock *inet;
 	struct ipv6_pinfo *np;
 	struct sock *sk;
-	struct list_head *p;
 	struct inet_protosw *answer;
 	struct proto *answer_prot;
 	unsigned char answer_flags;
@@ -105,8 +104,7 @@ static int inet6_create(struct net *net,
 lookup_protocol:
 	err = -ESOCKTNOSUPPORT;
 	rcu_read_lock();
-	list_for_each_rcu(p, &inetsw6[sock->type]) {
-		answer = list_entry(p, struct inet_protosw, list);
+	list_for_each_entry_rcu(answer, &inetsw6[sock->type], list) {
 
 		/* Check the non-wild match. */
 		if (protocol == answer->protocol) {
