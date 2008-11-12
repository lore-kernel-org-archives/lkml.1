Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbYKLLjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbYKLLjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYKLLix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:38:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYKLLiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:38:52 -0500
Date: Wed, 12 Nov 2008 12:38:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] lockdep: silence warnings
Message-ID: <20081112113836.GC6372@elte.hu>
References: <20081112113646.GA4629@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081112113646.GA4629@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> net/bluetooth/af_bluetooth.c:57: warning: 'bt_key_strings' defined but not used
> net/bluetooth/af_bluetooth.c:68: warning: 'bt_slock_key_strings' defined but not used
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

similar to what i did a month ago:

--------------->
>From 15d50b15843ccea15667f0bff5eb54d389a445f9 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 17 Oct 2008 15:55:07 +0200
Subject: [PATCH] lockdep: include/linux/lockdep.h - fix warning in net/bluetooth/af_bluetooth.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix this warning:

  net/bluetooth/af_bluetooth.c:60: warning: ‘bt_key_strings’ defined but not used
  net/bluetooth/af_bluetooth.c:71: warning: ‘bt_slock_key_strings’ defined but not used

this is a lockdep macro problem in the !LOCKDEP case.

We cannot convert it to an inline because the macro works on multiple types,
but we can mark the parameter used.

[ also clean up a misaligned tab in sock_lock_init_class_and_name() ]

[ also remove #ifdefs from around af_family_clock_key strings - which
  were certainly added to get rid of the ugly build warnings. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lockdep.h |    5 +++--
 include/net/sock.h      |    2 +-
 net/core/sock.c         |    2 --
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 331e5f1..29aec6e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -331,10 +331,11 @@ static inline void lockdep_on(void)
 # define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
-# define lockdep_init_map(lock, name, key, sub)	do { (void)(key); } while (0)
+# define lockdep_init_map(lock, name, key, sub) \
+		do { (void)(name); (void)(key); } while (0)
 # define lockdep_set_class(lock, key)		do { (void)(key); } while (0)
 # define lockdep_set_class_and_name(lock, key, name) \
-		do { (void)(key); } while (0)
+		do { (void)(key); (void)(name); } while (0)
 #define lockdep_set_class_and_subclass(lock, key, sub) \
 		do { (void)(key); } while (0)
 #define lockdep_set_subclass(lock, sub)		do { } while (0)
diff --git a/include/net/sock.h b/include/net/sock.h
index ada50c0..8014a92 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -815,7 +815,7 @@ static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
  */
 #define sock_lock_init_class_and_name(sk, sname, skey, name, key) 	\
 do {									\
-	sk->sk_lock.owned = 0;					\
+	sk->sk_lock.owned = 0;						\
 	init_waitqueue_head(&sk->sk_lock.wq);				\
 	spin_lock_init(&(sk)->sk_lock.slock);				\
 	debug_check_no_locks_freed((void *)&(sk)->sk_lock,		\
diff --git a/net/core/sock.c b/net/core/sock.c
index 5e2a313..341e394 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -136,7 +136,6 @@
 static struct lock_class_key af_family_keys[AF_MAX];
 static struct lock_class_key af_family_slock_keys[AF_MAX];
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
  * Make lock validator output more readable. (we pre-construct these
  * strings build-time, so that runtime initialization of socket
@@ -187,7 +186,6 @@ static const char *af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_RXRPC" , "clock-AF_ISDN"     , "clock-AF_PHONET"   ,
   "clock-AF_MAX"
 };
-#endif
 
 /*
  * sk_callback_lock locking rules are per-address-family,

