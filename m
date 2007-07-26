Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbXGZQex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbXGZQex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934272AbXGZQdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:33:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35197 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934252AbXGZQdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:33:40 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] net/* misc endianness annotations
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1IE6HT-0005D6-Gs@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:33:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/bridge/br_input.c     |    6 +++---
 net/key/af_key.c          |    4 ++--
 net/rxrpc/ar-connection.c |    2 +-
 net/sunrpc/svcsock.c      |    4 ++--
 net/tipc/msg.h            |    6 ++----
 5 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 420bbb9..5c18595 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -112,9 +112,9 @@ static int br_handle_local_finish(struct sk_buff *skb)
  */
 static inline int is_link_local(const unsigned char *dest)
 {
-	const u16 *a = (const u16 *) dest;
-	static const u16 *const b = (const u16 *const ) br_group_address;
-	static const u16 m = __constant_cpu_to_be16(0xfff0);
+	__be16 *a = (__be16 *)dest;
+	static const __be16 *b = (const __be16 *)br_group_address;
+	static const __be16 m = __constant_cpu_to_be16(0xfff0);
 
 	return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | ((a[2] ^ b[2]) & m)) == 0;
 }
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 0f8304b..7b0a95a 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2540,7 +2540,7 @@ static int pfkey_migrate(struct sock *sk, struct sk_buff *skb,
 	sel.proto = pfkey_proto_to_xfrm(sa->sadb_address_proto);
 	sel.sport = ((struct sockaddr_in *)(sa + 1))->sin_port;
 	if (sel.sport)
-		sel.sport_mask = ~0;
+		sel.sport_mask = htons(0xffff);
 
 	/* set destination address info of selector */
 	sa = ext_hdrs[SADB_EXT_ADDRESS_DST - 1],
@@ -2549,7 +2549,7 @@ static int pfkey_migrate(struct sock *sk, struct sk_buff *skb,
 	sel.proto = pfkey_proto_to_xfrm(sa->sadb_address_proto);
 	sel.dport = ((struct sockaddr_in *)(sa + 1))->sin_port;
 	if (sel.dport)
-		sel.dport_mask = ~0;
+		sel.dport_mask = htons(0xffff);
 
 	rq = (struct sadb_x_ipsecrequest *)(pol + 1);
 
diff --git a/net/rxrpc/ar-connection.c b/net/rxrpc/ar-connection.c
index 372b244..d6667f7 100644
--- a/net/rxrpc/ar-connection.c
+++ b/net/rxrpc/ar-connection.c
@@ -71,7 +71,7 @@ struct rxrpc_conn_bundle *rxrpc_get_bundle(struct rxrpc_sock *rx,
 	struct rb_node *p, *parent, **pp;
 
 	_enter("%p{%x},%x,%hx,",
-	       rx, key_serial(key), trans->debug_id, ntohl(service_id));
+	       rx, key_serial(key), trans->debug_id, ntohs(service_id));
 
 	if (rx->trans == trans && rx->bundle) {
 		atomic_inc(&rx->bundle->usage);
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 64b9b8c..12ff5da 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -131,13 +131,13 @@ static char *__svc_print_addr(struct sockaddr *addr, char *buf, size_t len)
 	case AF_INET:
 		snprintf(buf, len, "%u.%u.%u.%u, port=%u",
 			NIPQUAD(((struct sockaddr_in *) addr)->sin_addr),
-			htons(((struct sockaddr_in *) addr)->sin_port));
+			ntohs(((struct sockaddr_in *) addr)->sin_port));
 		break;
 
 	case AF_INET6:
 		snprintf(buf, len, "%x:%x:%x:%x:%x:%x:%x:%x, port=%u",
 			NIP6(((struct sockaddr_in6 *) addr)->sin6_addr),
-			htons(((struct sockaddr_in6 *) addr)->sin6_port));
+			ntohs(((struct sockaddr_in6 *) addr)->sin6_port));
 		break;
 
 	default:
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 35d5ba1..ce26598 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -72,10 +72,8 @@ static inline void msg_set_bits(struct tipc_msg *m, u32 w,
 				u32 pos, u32 mask, u32 val)
 {
 	val = (val & mask) << pos;
-	val = htonl(val);
-	mask = htonl(mask << pos);
-	m->hdr[w] &= ~mask;
-	m->hdr[w] |= val;
+	m->hdr[w] &= ~htonl(mask << pos);
+	m->hdr[w] |= htonl(val);
 }
 
 /*
-- 
1.5.3.GIT


