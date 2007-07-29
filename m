Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXG2PIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXG2PIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764636AbXG2O7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47841 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763695AbXG2O7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:15 -0400
Date: Sun, 29 Jul 2007 16:58:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] net/unix/af_unix.c: make code static
Message-ID: <20070729145852.GA16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following code can now become static:
- struct unix_socket_table
- unix_table_lock

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/net/af_unix.h |   29 -----------------------------
 net/unix/af_unix.c    |   30 ++++++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 31 deletions(-)

--- linux-2.6.23-rc1-mm1/include/net/af_unix.h.old	2007-07-26 21:17:33.000000000 +0200
+++ linux-2.6.23-rc1-mm1/include/net/af_unix.h	2007-07-26 21:20:27.000000000 +0200
@@ -12,37 +12,8 @@
 
 #define UNIX_HASH_SIZE	256
 
-extern struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
-extern spinlock_t unix_table_lock;
-
 extern atomic_t unix_tot_inflight;
 
-static inline struct sock *first_unix_socket(int *i)
-{
-	for (*i = 0; *i <= UNIX_HASH_SIZE; (*i)++) {
-		if (!hlist_empty(&unix_socket_table[*i]))
-			return __sk_head(&unix_socket_table[*i]);
-	}
-	return NULL;
-}
-
-static inline struct sock *next_unix_socket(int *i, struct sock *s)
-{
-	struct sock *next = sk_next(s);
-	/* More in this chain? */
-	if (next)
-		return next;
-	/* Look for next non-empty chain. */
-	for ((*i)++; *i <= UNIX_HASH_SIZE; (*i)++) {
-		if (!hlist_empty(&unix_socket_table[*i]))
-			return __sk_head(&unix_socket_table[*i]);
-	}
-	return NULL;
-}
-
-#define forall_unix_sockets(i, s) \
-	for (s = first_unix_socket(&(i)); s; s = next_unix_socket(&(i),(s)))
-
 struct unix_address {
 	atomic_t	refcnt;
 	int		len;
--- linux-2.6.23-rc1-mm1/net/unix/af_unix.c.old	2007-07-26 21:17:48.000000000 +0200
+++ linux-2.6.23-rc1-mm1/net/unix/af_unix.c	2007-07-26 21:20:24.000000000 +0200
@@ -118,14 +118,40 @@
 
 int sysctl_unix_max_dgram_qlen __read_mostly = 10;
 
-struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
-DEFINE_SPINLOCK(unix_table_lock);
+static struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
+static DEFINE_SPINLOCK(unix_table_lock);
 static atomic_t unix_nr_socks = ATOMIC_INIT(0);
 
 #define unix_sockets_unbound	(&unix_socket_table[UNIX_HASH_SIZE])
 
 #define UNIX_ABSTRACT(sk)	(unix_sk(sk)->addr->hash != UNIX_HASH_SIZE)
 
+static struct sock *first_unix_socket(int *i)
+{
+	for (*i = 0; *i <= UNIX_HASH_SIZE; (*i)++) {
+		if (!hlist_empty(&unix_socket_table[*i]))
+			return __sk_head(&unix_socket_table[*i]);
+	}
+	return NULL;
+}
+
+static struct sock *next_unix_socket(int *i, struct sock *s)
+{
+	struct sock *next = sk_next(s);
+	/* More in this chain? */
+	if (next)
+		return next;
+	/* Look for next non-empty chain. */
+	for ((*i)++; *i <= UNIX_HASH_SIZE; (*i)++) {
+		if (!hlist_empty(&unix_socket_table[*i]))
+			return __sk_head(&unix_socket_table[*i]);
+	}
+	return NULL;
+}
+
+#define forall_unix_sockets(i, s) \
+	for (s = first_unix_socket(&(i)); s; s = next_unix_socket(&(i),(s)))
+
 #ifdef CONFIG_SECURITY_NETWORK
 static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {

