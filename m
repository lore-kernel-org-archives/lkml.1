Return-Path: <linux-kernel-owner+w=401wt.eu-S1763915AbZAUKMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763915AbZAUKMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbZAUKKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:10:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:48344 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180AbZAUKKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:10:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,299,1231142400"; 
   d="scan'208";a="380250367"
From: Patrick Ohly <patrick.ohly@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       linux-api@vger.kernel.org, Patrick Ohly <patrick.ohly@intel.com>
Subject: [PATCH NET-NEXT 04/12] sockets: allow allocating skb with optional structures
Date: Wed, 21 Jan 2009 11:10:04 +0100
Message-Id: <1232532612-10382-4-git-send-email-patrick.ohly@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1232532612-10382-3-git-send-email-patrick.ohly@intel.com>
References: <1232532457.7829.19.camel@ecld0pohly>
 <1232532612-10382-1-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-2-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-3-git-send-email-patrick.ohly@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The internal sock_alloc_send_pskb() is now exposed
as sock_alloc_send_skb_flags() and takes a flags
parameter with additional instructions for how the
skb is to be allocated. This is necessary for adding
send time stamping information to outgoing packets.

sock_alloc_send_skb() is turned into a simple wrapper
which preserves compatibility with code that
passes a boolean "nblock" instead of the flags
bitmask.

sock_alloc_send_pskb() was never called with non-zero
data_len, therefore the obsolete code and parameter
were removed.
---
 include/net/sock.h |   17 +++++++++++++----
 net/core/sock.c    |   50 +++++++-------------------------------------------
 2 files changed, 20 insertions(+), 47 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 36807e4..6cb120c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -948,10 +948,19 @@ extern int			sock_setsockopt(struct socket *sock, int level,
 extern int			sock_getsockopt(struct socket *sock, int level,
 						int op, char __user *optval, 
 						int __user *optlen);
-extern struct sk_buff 		*sock_alloc_send_skb(struct sock *sk,
-						     unsigned long size,
-						     int noblock,
-						     int *errcode);
+extern struct sk_buff		*sock_alloc_send_skb_flags(struct sock *sk,
+						unsigned long size,
+						int flags,
+						int *errcode);
+inline static struct sk_buff 	*sock_alloc_send_skb(struct sock *sk,
+						unsigned long size,
+						int noblock,
+						int *errcode)
+{
+	return sock_alloc_send_skb_flags(sk, size,
+					noblock ? SKB_FLAGS_NOBLOCK : 0,
+					errcode);
+}
 extern void *sock_kmalloc(struct sock *sk, int size,
 			  gfp_t priority);
 extern void sock_kfree_s(struct sock *sk, void *mem, int size);
diff --git a/net/core/sock.c b/net/core/sock.c
index 2846274..c6618d0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1300,10 +1300,9 @@ static long sock_wait_for_wmem(struct sock * sk, long timeo)
  *	Generic send/receive buffer handlers
  */
 
-static struct sk_buff *sock_alloc_send_pskb(struct sock *sk,
+struct sk_buff *sock_alloc_send_skb_flags(struct sock *sk,
 					    unsigned long header_len,
-					    unsigned long data_len,
-					    int noblock, int *errcode)
+					    int flags, int *errcode)
 {
 	struct sk_buff *skb;
 	gfp_t gfp_mask;
@@ -1314,7 +1313,9 @@ static struct sk_buff *sock_alloc_send_pskb(struct sock *sk,
 	if (gfp_mask & __GFP_WAIT)
 		gfp_mask |= __GFP_REPEAT;
 
-	timeo = sock_sndtimeo(sk, noblock);
+	timeo = sock_sndtimeo(sk, 
+			(flags & SKB_FLAGS_NOBLOCK) ?
+			MSG_DONTWAIT : 0);
 	while (1) {
 		err = sock_error(sk);
 		if (err != 0)
@@ -1325,39 +1326,8 @@ static struct sk_buff *sock_alloc_send_pskb(struct sock *sk,
 			goto failure;
 
 		if (atomic_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf) {
-			skb = alloc_skb(header_len, gfp_mask);
+			skb = __alloc_skb_flags(header_len, gfp_mask, flags, -1);
 			if (skb) {
-				int npages;
-				int i;
-
-				/* No pages, we're done... */
-				if (!data_len)
-					break;
-
-				npages = (data_len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
-				skb->truesize += data_len;
-				skb_shinfo(skb)->nr_frags = npages;
-				for (i = 0; i < npages; i++) {
-					struct page *page;
-					skb_frag_t *frag;
-
-					page = alloc_pages(sk->sk_allocation, 0);
-					if (!page) {
-						err = -ENOBUFS;
-						skb_shinfo(skb)->nr_frags = i;
-						kfree_skb(skb);
-						goto failure;
-					}
-
-					frag = &skb_shinfo(skb)->frags[i];
-					frag->page = page;
-					frag->page_offset = 0;
-					frag->size = (data_len >= PAGE_SIZE ?
-						      PAGE_SIZE :
-						      data_len);
-					data_len -= PAGE_SIZE;
-				}
-
 				/* Full success... */
 				break;
 			}
@@ -1384,12 +1354,6 @@ failure:
 	return NULL;
 }
 
-struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
-				    int noblock, int *errcode)
-{
-	return sock_alloc_send_pskb(sk, size, 0, noblock, errcode);
-}
-
 static void __lock_sock(struct sock *sk)
 {
 	DEFINE_WAIT(wait);
@@ -2323,7 +2287,7 @@ subsys_initcall(proto_init);
 EXPORT_SYMBOL(sk_alloc);
 EXPORT_SYMBOL(sk_free);
 EXPORT_SYMBOL(sk_send_sigurg);
-EXPORT_SYMBOL(sock_alloc_send_skb);
+EXPORT_SYMBOL(sock_alloc_send_skb_flags);
 EXPORT_SYMBOL(sock_init_data);
 EXPORT_SYMBOL(sock_kfree_s);
 EXPORT_SYMBOL(sock_kmalloc);
-- 
1.5.5.3

