Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZCNATy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZCNATy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZCNASZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:25 -0400
Received: from kroah.org ([198.145.64.141]:46611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750926AbZCNASY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:39 2009
Message-Id: <20090314000739.203280155@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 04/96] net: Kill skb_truesize_check(), it only catches false-positives.
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=net-kill-skb_truesize_check-it-only-catches-false-positives.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 92a0acce186cde8ead56c6915d9479773673ea1a ]

A long time ago we had bugs, primarily in TCP, where we would modify
skb->truesize (for TSO queue collapsing) in ways which would corrupt
the socket memory accounting.

skb_truesize_check() was added in order to try and catch this error
more systematically.

However this debugging check has morphed into a Frankenstein of sorts
and these days it does nothing other than catch false-positives.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/skbuff.h |    9 ---------
 include/net/sock.h     |    1 -
 net/core/skbuff.c      |    8 --------
 net/core/sock.c        |    1 -
 4 files changed, 19 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -395,15 +395,6 @@ extern void	      skb_over_panic(struct 
 				     void *here);
 extern void	      skb_under_panic(struct sk_buff *skb, int len,
 				      void *here);
-extern void	      skb_truesize_bug(struct sk_buff *skb);
-
-static inline void skb_truesize_check(struct sk_buff *skb)
-{
-	int len = sizeof(struct sk_buff) + skb->len;
-
-	if (unlikely((int)skb->truesize < len))
-		skb_truesize_bug(skb);
-}
 
 extern int skb_append_datato_frags(struct sock *sk, struct sk_buff *skb,
 			int getfrag(void *from, char *to, int offset,
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -777,7 +777,6 @@ static inline void sk_mem_uncharge(struc
 
 static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 {
-	skb_truesize_check(skb);
 	sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
 	sk->sk_wmem_queued -= skb->truesize;
 	sk_mem_uncharge(sk, skb->truesize);
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -143,14 +143,6 @@ void skb_under_panic(struct sk_buff *skb
 	BUG();
 }
 
-void skb_truesize_bug(struct sk_buff *skb)
-{
-	printk(KERN_ERR "SKB BUG: Invalid truesize (%u) "
-	       "len=%u, sizeof(sk_buff)=%Zd\n",
-	       skb->truesize, skb->len, sizeof(struct sk_buff));
-}
-EXPORT_SYMBOL(skb_truesize_bug);
-
 /* 	Allocate a new skbuff. We do this ourselves so we can fill in a few
  *	'private' fields and also do memory statistics to find all the
  *	[BEEP] leaks.
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1136,7 +1136,6 @@ void sock_rfree(struct sk_buff *skb)
 {
 	struct sock *sk = skb->sk;
 
-	skb_truesize_check(skb);
 	atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
 	sk_mem_uncharge(skb->sk, skb->truesize);
 }


