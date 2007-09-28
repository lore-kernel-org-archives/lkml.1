Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbXI1Va1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbXI1Va1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbXI1VaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:30:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41619
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753939AbXI1VaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:30:18 -0400
Date: Fri, 28 Sep 2007 14:30:18 -0700 (PDT)
Message-Id: <20070928.143018.40816172.davem@davemloft.net>
To: pl@dlh.net
Cc: sparclinux@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: tcp rfc 2385 security/bugfix for sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070928.142015.82358847.davem@davemloft.net>
References: <23966.84.62.25.8.1191012145.squirrel@cs1.dlh.net>
	<20070928.142015.82358847.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 28 Sep 2007 14:20:15 -0700 (PDT)

> Thanks for finding this bug.
> 
> > --- linux.old/include/net/tcp.h 2007-09-28 21:43:26.000000000 +0200 +++
> > linux/include/net/tcp.h     2007-09-28 21:45:35.000000000 +0200 @@ -1055,6
> > +1055,7 @@ static inline void clear_all_retrans_hin
> 
> I'll have to apply this patch by hand because your email client
> completely corrupted the patch.

Actually, I think I'm going to put in a slightly different
fix.

If tcp4_md5sig_key and tcp6_md5sig_key have to begin with exacytly
tcp_md5sig_key's only two members, we should fully tell this
explicitly to the compiler and remove those ugly casts.

The casts are the real bug.

Here is the patch I will use after some testing:

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 185c7ec..54053de 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1059,14 +1059,12 @@ struct tcp_md5sig_key {
 };
 
 struct tcp4_md5sig_key {
-	u8			*key;
-	u16			keylen;
+	struct tcp_md5sig_key	base;
 	__be32			addr;
 };
 
 struct tcp6_md5sig_key {
-	u8			*key;
-	u16			keylen;
+	struct tcp_md5sig_key	base;
 #if 0
 	u32			scope_id;	/* XXX */
 #endif
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 9c94627..e089a97 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -833,8 +833,7 @@ static struct tcp_md5sig_key *
 		return NULL;
 	for (i = 0; i < tp->md5sig_info->entries4; i++) {
 		if (tp->md5sig_info->keys4[i].addr == addr)
-			return (struct tcp_md5sig_key *)
-						&tp->md5sig_info->keys4[i];
+			return &tp->md5sig_info->keys4[i].base;
 	}
 	return NULL;
 }
@@ -865,9 +864,9 @@ int tcp_v4_md5_do_add(struct sock *sk, __be32 addr,
 	key = (struct tcp4_md5sig_key *)tcp_v4_md5_do_lookup(sk, addr);
 	if (key) {
 		/* Pre-existing entry - just update that one. */
-		kfree(key->key);
-		key->key = newkey;
-		key->keylen = newkeylen;
+		kfree(key->base.key);
+		key->base.key = newkey;
+		key->base.keylen = newkeylen;
 	} else {
 		struct tcp_md5sig_info *md5sig;
 
@@ -906,9 +905,9 @@ int tcp_v4_md5_do_add(struct sock *sk, __be32 addr,
 			md5sig->alloced4++;
 		}
 		md5sig->entries4++;
-		md5sig->keys4[md5sig->entries4 - 1].addr   = addr;
-		md5sig->keys4[md5sig->entries4 - 1].key    = newkey;
-		md5sig->keys4[md5sig->entries4 - 1].keylen = newkeylen;
+		md5sig->keys4[md5sig->entries4 - 1].addr        = addr;
+		md5sig->keys4[md5sig->entries4 - 1].base.key    = newkey;
+		md5sig->keys4[md5sig->entries4 - 1].base.keylen = newkeylen;
 	}
 	return 0;
 }
@@ -930,7 +929,7 @@ int tcp_v4_md5_do_del(struct sock *sk, __be32 addr)
 	for (i = 0; i < tp->md5sig_info->entries4; i++) {
 		if (tp->md5sig_info->keys4[i].addr == addr) {
 			/* Free the key */
-			kfree(tp->md5sig_info->keys4[i].key);
+			kfree(tp->md5sig_info->keys4[i].base.key);
 			tp->md5sig_info->entries4--;
 
 			if (tp->md5sig_info->entries4 == 0) {
@@ -964,7 +963,7 @@ static void tcp_v4_clear_md5_list(struct sock *sk)
 	if (tp->md5sig_info->entries4) {
 		int i;
 		for (i = 0; i < tp->md5sig_info->entries4; i++)
-			kfree(tp->md5sig_info->keys4[i].key);
+			kfree(tp->md5sig_info->keys4[i].base.key);
 		tp->md5sig_info->entries4 = 0;
 		tcp_free_md5sig_pool();
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0f7defb..3e06799 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -539,7 +539,7 @@ static struct tcp_md5sig_key *tcp_v6_md5_do_lookup(struct sock *sk,
 
 	for (i = 0; i < tp->md5sig_info->entries6; i++) {
 		if (ipv6_addr_cmp(&tp->md5sig_info->keys6[i].addr, addr) == 0)
-			return (struct tcp_md5sig_key *)&tp->md5sig_info->keys6[i];
+			return &tp->md5sig_info->keys6[i].base;
 	}
 	return NULL;
 }
@@ -567,9 +567,9 @@ static int tcp_v6_md5_do_add(struct sock *sk, struct in6_addr *peer,
 	key = (struct tcp6_md5sig_key*) tcp_v6_md5_do_lookup(sk, peer);
 	if (key) {
 		/* modify existing entry - just update that one */
-		kfree(key->key);
-		key->key = newkey;
-		key->keylen = newkeylen;
+		kfree(key->base.key);
+		key->base.key = newkey;
+		key->base.keylen = newkeylen;
 	} else {
 		/* reallocate new list if current one is full. */
 		if (!tp->md5sig_info) {
@@ -603,8 +603,8 @@ static int tcp_v6_md5_do_add(struct sock *sk, struct in6_addr *peer,
 
 		ipv6_addr_copy(&tp->md5sig_info->keys6[tp->md5sig_info->entries6].addr,
 			       peer);
-		tp->md5sig_info->keys6[tp->md5sig_info->entries6].key = newkey;
-		tp->md5sig_info->keys6[tp->md5sig_info->entries6].keylen = newkeylen;
+		tp->md5sig_info->keys6[tp->md5sig_info->entries6].base.key = newkey;
+		tp->md5sig_info->keys6[tp->md5sig_info->entries6].base.keylen = newkeylen;
 
 		tp->md5sig_info->entries6++;
 	}
@@ -626,7 +626,7 @@ static int tcp_v6_md5_do_del(struct sock *sk, struct in6_addr *peer)
 	for (i = 0; i < tp->md5sig_info->entries6; i++) {
 		if (ipv6_addr_cmp(&tp->md5sig_info->keys6[i].addr, peer) == 0) {
 			/* Free the key */
-			kfree(tp->md5sig_info->keys6[i].key);
+			kfree(tp->md5sig_info->keys6[i].base.key);
 			tp->md5sig_info->entries6--;
 
 			if (tp->md5sig_info->entries6 == 0) {
@@ -657,7 +657,7 @@ static void tcp_v6_clear_md5_list (struct sock *sk)
 
 	if (tp->md5sig_info->entries6) {
 		for (i = 0; i < tp->md5sig_info->entries6; i++)
-			kfree(tp->md5sig_info->keys6[i].key);
+			kfree(tp->md5sig_info->keys6[i].base.key);
 		tp->md5sig_info->entries6 = 0;
 		tcp_free_md5sig_pool();
 	}
@@ -668,7 +668,7 @@ static void tcp_v6_clear_md5_list (struct sock *sk)
 
 	if (tp->md5sig_info->entries4) {
 		for (i = 0; i < tp->md5sig_info->entries4; i++)
-			kfree(tp->md5sig_info->keys4[i].key);
+			kfree(tp->md5sig_info->keys4[i].base.key);
 		tp->md5sig_info->entries4 = 0;
 		tcp_free_md5sig_pool();
 	}
