Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZHMT7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZHMT7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZHMT7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:18 -0400
Received: from kroah.org ([198.145.64.141]:41652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbZHMT7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:25 2009
Message-Id: <20090813195125.796359983@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/74] net: sock_copy() fixes
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=net-sock_copy-fixes.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 4dc6dc7162c08b9965163c9ab3f9375d4adff2c7 ]

Commit e912b1142be8f1e2c71c71001dc992c6e5eb2ec1
(net: sk_prot_alloc() should not blindly overwrite memory)
took care of not zeroing whole new socket at allocation time.

sock_copy() is another spot where we should be very careful.
We should not set refcnt to a non null value, until
we are sure other fields are correctly setup, or
a lockless reader could catch this socket by mistake,
while not fully (re)initialized.

This patch puts sk_node & sk_refcnt to the very beginning
of struct sock to ease sock_copy() & sk_prot_alloc() job.

We add appropriate smp_wmb() before sk_refcnt initializations
to match our RCU requirements (changes to sock keys should
be committed to memory before sk_refcnt setting)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/sock.h |   32 +++++++++++++++++++-------------
 net/core/sock.c    |   20 ++++++++++++++++++--
 2 files changed, 37 insertions(+), 15 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -103,15 +103,15 @@ struct net;
 
 /**
  *	struct sock_common - minimal network layer representation of sockets
+ *	@skc_node: main hash linkage for various protocol lookup tables
+ *	@skc_nulls_node: main hash linkage for UDP/UDP-Lite protocol
+ *	@skc_refcnt: reference count
+ *	@skc_hash: hash value used with various protocol lookup tables
  *	@skc_family: network address family
  *	@skc_state: Connection state
  *	@skc_reuse: %SO_REUSEADDR setting
  *	@skc_bound_dev_if: bound device index if != 0
- *	@skc_node: main hash linkage for various protocol lookup tables
- *	@skc_nulls_node: main hash linkage for UDP/UDP-Lite protocol
  *	@skc_bind_node: bind hash linkage for various protocol lookup tables
- *	@skc_refcnt: reference count
- *	@skc_hash: hash value used with various protocol lookup tables
  *	@skc_prot: protocol handlers inside a network family
  *	@skc_net: reference to the network namespace of this socket
  *
@@ -119,17 +119,21 @@ struct net;
  *	for struct sock and struct inet_timewait_sock.
  */
 struct sock_common {
-	unsigned short		skc_family;
-	volatile unsigned char	skc_state;
-	unsigned char		skc_reuse;
-	int			skc_bound_dev_if;
+	/*
+	 * first fields are not copied in sock_copy()
+	 */
 	union {
 		struct hlist_node	skc_node;
 		struct hlist_nulls_node skc_nulls_node;
 	};
-	struct hlist_node	skc_bind_node;
 	atomic_t		skc_refcnt;
+
 	unsigned int		skc_hash;
+	unsigned short		skc_family;
+	volatile unsigned char	skc_state;
+	unsigned char		skc_reuse;
+	int			skc_bound_dev_if;
+	struct hlist_node	skc_bind_node;
 	struct proto		*skc_prot;
 #ifdef CONFIG_NET_NS
 	struct net	 	*skc_net;
@@ -207,15 +211,17 @@ struct sock {
 	 * don't add nothing before this first member (__sk_common) --acme
 	 */
 	struct sock_common	__sk_common;
+#define sk_node			__sk_common.skc_node
+#define sk_nulls_node		__sk_common.skc_nulls_node
+#define sk_refcnt		__sk_common.skc_refcnt
+
+#define sk_copy_start		__sk_common.skc_hash
+#define sk_hash			__sk_common.skc_hash
 #define sk_family		__sk_common.skc_family
 #define sk_state		__sk_common.skc_state
 #define sk_reuse		__sk_common.skc_reuse
 #define sk_bound_dev_if		__sk_common.skc_bound_dev_if
-#define sk_node			__sk_common.skc_node
-#define sk_nulls_node		__sk_common.skc_nulls_node
 #define sk_bind_node		__sk_common.skc_bind_node
-#define sk_refcnt		__sk_common.skc_refcnt
-#define sk_hash			__sk_common.skc_hash
 #define sk_prot			__sk_common.skc_prot
 #define sk_net			__sk_common.skc_net
 	unsigned char		sk_shutdown : 2,
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -915,13 +915,19 @@ static inline void sock_lock_init(struct
 			af_family_keys + sk->sk_family);
 }
 
+/*
+ * Copy all fields from osk to nsk but nsk->sk_refcnt must not change yet,
+ * even temporarly, because of RCU lookups. sk_node should also be left as is.
+ */
 static void sock_copy(struct sock *nsk, const struct sock *osk)
 {
 #ifdef CONFIG_SECURITY_NETWORK
 	void *sptr = nsk->sk_security;
 #endif
-
-	memcpy(nsk, osk, osk->sk_prot->obj_size);
+	BUILD_BUG_ON(offsetof(struct sock, sk_copy_start) !=
+		     sizeof(osk->sk_node) + sizeof(osk->sk_refcnt));
+	memcpy(&nsk->sk_copy_start, &osk->sk_copy_start,
+	       osk->sk_prot->obj_size - offsetof(struct sock, sk_copy_start));
 #ifdef CONFIG_SECURITY_NETWORK
 	nsk->sk_security = sptr;
 	security_sk_clone(osk, nsk);
@@ -1118,6 +1124,11 @@ struct sock *sk_clone(const struct sock 
 
 		newsk->sk_err	   = 0;
 		newsk->sk_priority = 0;
+		/*
+		 * Before updating sk_refcnt, we must commit prior changes to memory
+		 * (Documentation/RCU/rculist_nulls.txt for details)
+		 */
+		smp_wmb();
 		atomic_set(&newsk->sk_refcnt, 2);
 
 		/*
@@ -1809,6 +1820,11 @@ void sock_init_data(struct socket *sock,
 
 	sk->sk_stamp = ktime_set(-1L, 0);
 
+	/*
+	 * Before updating sk_refcnt, we must commit prior changes to memory
+	 * (Documentation/RCU/rculist_nulls.txt for details)
+	 */
+	smp_wmb();
 	atomic_set(&sk->sk_refcnt, 1);
 	atomic_set(&sk->sk_drops, 0);
 }


