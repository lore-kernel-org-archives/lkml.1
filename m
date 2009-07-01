Return-Path: <linux-kernel-owner+w=401wt.eu-S1764184AbZGAAxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764184AbZGAAxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761406AbZGAAeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:31 -0400
Received: from kroah.org ([198.145.64.141]:60182 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761352AbZGAAe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:19 2009
Message-Id: <20090701002419.672727891@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 023/108] x25: Fix sleep from timer on socket destroy.
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=x25-fix-sleep-from-timer-on-socket-destroy.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 14ebaf81e13ce66bff275380b246796fd16cbfa1 ]

If socket destuction gets delayed to a timer, we try to
lock_sock() from that timer which won't work.

Use bh_lock_sock() in that case.

Signed-off-by: David S. Miller <davem@davemloft.net>
Tested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/x25.h   |    2 +-
 net/x25/af_x25.c    |   23 ++++++++++++++++++-----
 net/x25/x25_timer.c |    2 +-
 3 files changed, 20 insertions(+), 7 deletions(-)

--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -187,7 +187,7 @@ extern int  x25_addr_ntoa(unsigned char 
 extern int  x25_addr_aton(unsigned char *, struct x25_address *,
 			  struct x25_address *);
 extern struct sock *x25_find_socket(unsigned int, struct x25_neigh *);
-extern void x25_destroy_socket(struct sock *);
+extern void x25_destroy_socket_from_timer(struct sock *);
 extern int  x25_rx_call_request(struct sk_buff *, struct x25_neigh *, unsigned int);
 extern void x25_kill_by_neigh(struct x25_neigh *);
 
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -332,14 +332,14 @@ static unsigned int x25_new_lci(struct x
 /*
  *	Deferred destroy.
  */
-void x25_destroy_socket(struct sock *);
+static void __x25_destroy_socket(struct sock *);
 
 /*
  *	handler for deferred kills.
  */
 static void x25_destroy_timer(unsigned long data)
 {
-	x25_destroy_socket((struct sock *)data);
+	x25_destroy_socket_from_timer((struct sock *)data);
 }
 
 /*
@@ -349,12 +349,10 @@ static void x25_destroy_timer(unsigned l
  *	will touch it and we are (fairly 8-) ) safe.
  *	Not static as it's used by the timer
  */
-void x25_destroy_socket(struct sock *sk)
+static void __x25_destroy_socket(struct sock *sk)
 {
 	struct sk_buff *skb;
 
-	sock_hold(sk);
-	lock_sock(sk);
 	x25_stop_heartbeat(sk);
 	x25_stop_timer(sk);
 
@@ -385,7 +383,22 @@ void x25_destroy_socket(struct sock *sk)
 		/* drop last reference so sock_put will free */
 		__sock_put(sk);
 	}
+}
 
+void x25_destroy_socket_from_timer(struct sock *sk)
+{
+	sock_hold(sk);
+	bh_lock_sock(sk);
+	__x25_destroy_socket(sk);
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+static void x25_destroy_socket(struct sock *sk)
+{
+	sock_hold(sk);
+	lock_sock(sk);
+	__x25_destroy_socket(sk);
 	release_sock(sk);
 	sock_put(sk);
 }
--- a/net/x25/x25_timer.c
+++ b/net/x25/x25_timer.c
@@ -113,7 +113,7 @@ static void x25_heartbeat_expiry(unsigne
 			    (sk->sk_state == TCP_LISTEN &&
 			     sock_flag(sk, SOCK_DEAD))) {
 				bh_unlock_sock(sk);
-				x25_destroy_socket(sk);
+				x25_destroy_socket_from_timer(sk);
 				return;
 			}
 			break;


