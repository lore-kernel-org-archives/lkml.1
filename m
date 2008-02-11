Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbYBKSjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbYBKSjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYBKSix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:38:53 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:30529 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbYBKSiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:38:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J7fK7QhtkIUY6B0M9RM7yGVJmrDf9KD5ZNjI7VsaZ/KTXEeVzNFL9BYiRnA0BuKgJhc+LmRUk9m1rB0/ZtCshLSWvovoLJLxzGn+Ll4ncoR+gS0focL3SABxP6p6KxmS1AvTfvIvyNt2PduglcTGaHYHzZ8wmAnFzxLBuh9LsU4=
Subject: [PATCH 2/3] remove final fastcall users
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 10:38:41 -0800
Message-Id: <1202755121.6313.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastcall always expands to empty, remove it.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, as promised, here's a rollup vs. -rc1 of remaining fastcall
uses.

 kernel/signal.c             |    2 +-
 mm/filemap.c                |    2 +-
 net/bluetooth/rfcomm/core.c |    4 ++--
 net/core/dev.c              |    2 +-
 net/core/sock.c             |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2c1f08d..84917fe 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -972,7 +972,7 @@ void zap_other_threads(struct task_struct *p)
 	}
 }
 
-int fastcall __fatal_signal_pending(struct task_struct *tsk)
+int __fatal_signal_pending(struct task_struct *tsk)
 {
 	return sigismember(&tsk->pending.signal, SIGKILL);
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index b7b1be6..5c74b68 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -604,7 +604,7 @@ void __lock_page(struct page *page)
 }
 EXPORT_SYMBOL(__lock_page);
 
-int fastcall __lock_page_killable(struct page *page)
+int __lock_page_killable(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index d3e4e18..0c2c937 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -465,7 +465,7 @@ int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 	return len;
 }
 
-void fastcall __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
+void __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
 {
 	BT_DBG("dlc %p state %ld", d, d->state);
 
@@ -476,7 +476,7 @@ void fastcall __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
 	rfcomm_schedule(RFCOMM_SCHED_TX);
 }
 
-void fastcall __rfcomm_dlc_unthrottle(struct rfcomm_dlc *d)
+void __rfcomm_dlc_unthrottle(struct rfcomm_dlc *d)
 {
 	BT_DBG("dlc %p state %ld", d, d->state);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 9549417..b2f6cb5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2143,7 +2143,7 @@ static int process_backlog(struct napi_struct *napi, int quota)
  *
  * The entry's receive function will be scheduled to run
  */
-void fastcall __napi_schedule(struct napi_struct *n)
+void __napi_schedule(struct napi_struct *n)
 {
 	unsigned long flags;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 433715f..09cb3a7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1731,7 +1731,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	atomic_set(&sk->sk_drops, 0);
 }
 
-void fastcall lock_sock_nested(struct sock *sk, int subclass)
+void lock_sock_nested(struct sock *sk, int subclass)
 {
 	might_sleep();
 	spin_lock_bh(&sk->sk_lock.slock);
@@ -1748,7 +1748,7 @@ void fastcall lock_sock_nested(struct sock *sk, int subclass)
 
 EXPORT_SYMBOL(lock_sock_nested);
 
-void fastcall release_sock(struct sock *sk)
+void release_sock(struct sock *sk)
 {
 	/*
 	 * The sk_lock has mutex_unlock() semantics:
-- 
1.5.4.1219.g65b9


