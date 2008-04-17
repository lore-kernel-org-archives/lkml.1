Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbYDQBT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbYDQBT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759890AbYDQBIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:15 -0400
Received: from sous-sol.org ([216.99.217.87]:58909 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858AbYDQBIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:13 -0400
Message-Id: <20080417010346.426206703@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chidambar ilLogict Zinnoury <illogict@online.fr>,
       Vlad Yasevich <vladislav.yasevich@hp.com>,
       David S Miller <davem@davemloft.net>
Subject: SCTP: Fix local_addr deletions during list traversals.
Content-Disposition: inline; filename=sctp-fix-local_addr-deletions-during-list-traversals.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Chidambar 'ilLogict' Zinnoury <illogict@online.fr>

Upstream commit: 22626216c46f2ec86287e75ea86dd9ac3df54265

Since the lists are circular, we need to explicitely tag
the address to be deleted since we might end up freeing
the list head instead.  This fixes some interesting SCTP
crashes.

Signed-off-by: Chidambar 'ilLogict' Zinnoury <illogict@online.fr>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/sctp/bind_addr.c |    4 +++-
 net/sctp/ipv6.c      |    4 +++-
 net/sctp/protocol.c  |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -209,6 +209,7 @@ int sctp_add_bind_addr(struct sctp_bind_
 int sctp_del_bind_addr(struct sctp_bind_addr *bp, union sctp_addr *del_addr)
 {
 	struct sctp_sockaddr_entry *addr, *temp;
+	int found = 0;
 
 	/* We hold the socket lock when calling this function,
 	 * and that acts as a writer synchronizing lock.
@@ -216,13 +217,14 @@ int sctp_del_bind_addr(struct sctp_bind_
 	list_for_each_entry_safe(addr, temp, &bp->address_list, list) {
 		if (sctp_cmp_addr_exact(&addr->a, del_addr)) {
 			/* Found the exact match. */
+			found = 1;
 			addr->valid = 0;
 			list_del_rcu(&addr->list);
 			break;
 		}
 	}
 
-	if (addr && !addr->valid) {
+	if (found) {
 		call_rcu(&addr->rcu, sctp_local_addr_free);
 		SCTP_DBG_OBJCNT_DEC(addr);
 		return 0;
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -89,6 +89,7 @@ static int sctp_inet6addr_event(struct n
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
 	struct sctp_sockaddr_entry *addr = NULL;
 	struct sctp_sockaddr_entry *temp;
+	int found = 0;
 
 	switch (ev) {
 	case NETDEV_UP:
@@ -111,13 +112,14 @@ static int sctp_inet6addr_event(struct n
 					&sctp_local_addr_list, list) {
 			if (ipv6_addr_equal(&addr->a.v6.sin6_addr,
 					     &ifa->addr)) {
+				found = 1;
 				addr->valid = 0;
 				list_del_rcu(&addr->list);
 				break;
 			}
 		}
 		spin_unlock_bh(&sctp_local_addr_lock);
-		if (addr && !addr->valid)
+		if (found)
 			call_rcu(&addr->rcu, sctp_local_addr_free);
 		break;
 	}
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -626,6 +626,7 @@ static int sctp_inetaddr_event(struct no
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
 	struct sctp_sockaddr_entry *addr = NULL;
 	struct sctp_sockaddr_entry *temp;
+	int found = 0;
 
 	switch (ev) {
 	case NETDEV_UP:
@@ -645,13 +646,14 @@ static int sctp_inetaddr_event(struct no
 		list_for_each_entry_safe(addr, temp,
 					&sctp_local_addr_list, list) {
 			if (addr->a.v4.sin_addr.s_addr == ifa->ifa_local) {
+				found = 1;
 				addr->valid = 0;
 				list_del_rcu(&addr->list);
 				break;
 			}
 		}
 		spin_unlock_bh(&sctp_local_addr_lock);
-		if (addr && !addr->valid)
+		if (found)
 			call_rcu(&addr->rcu, sctp_local_addr_free);
 		break;
 	}

-- 
