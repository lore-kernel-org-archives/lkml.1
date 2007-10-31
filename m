Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbXJaP0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbXJaP0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759887AbXJaPYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33463 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759627AbXJaPYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:30 -0400
Date: Wed, 31 Oct 2007 08:11:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/26] : Fix TCP MD5 on big-endian.
Message-ID: <20071031151136.GL2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-tcp-md5-on-big-endian.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Miller <davem@davemloft.net>

changeset f8ab18d2d987a59ccbf0495032b2aef05b730037 in mainline.

Based upon a report and initial patch by Peter Lieven.

tcp4_md5sig_key and tcp6_md5sig_key need to start with
the exact same members as tcp_md5sig_key.  Because they
are both cast to that type by tcp_v{4,6}_md5_do_lookup().

Unfortunately tcp{4,6}_md5sig_key use a u16 for the key
length instead of a u8, which is what tcp_md5sig_key
uses.  This just so happens to work by accident on
little-endian, but on big-endian it doesn't.

Instead of casting, just place tcp_md5sig_key as the first member of
the address-family specific structures, adjust the access sites, and
kill off the ugly casts.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/tcp.h   |    6 ++----
 net/ipv4/tcp_ipv4.c |   19 +++++++++----------
 net/ipv6/tcp_ipv6.c |   18 +++++++++---------
 3 files changed, 20 insertions(+), 23 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1061,14 +1061,12 @@ struct tcp_md5sig_key {
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
@@ -865,9 +864,9 @@ int tcp_v4_md5_do_add(struct sock *sk, _
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
 
@@ -906,9 +905,9 @@ int tcp_v4_md5_do_add(struct sock *sk, _
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
@@ -930,7 +929,7 @@ int tcp_v4_md5_do_del(struct sock *sk, _
 	for (i = 0; i < tp->md5sig_info->entries4; i++) {
 		if (tp->md5sig_info->keys4[i].addr == addr) {
 			/* Free the key */
-			kfree(tp->md5sig_info->keys4[i].key);
+			kfree(tp->md5sig_info->keys4[i].base.key);
 			tp->md5sig_info->entries4--;
 
 			if (tp->md5sig_info->entries4 == 0) {
@@ -964,7 +963,7 @@ static void tcp_v4_clear_md5_list(struct
 	if (tp->md5sig_info->entries4) {
 		int i;
 		for (i = 0; i < tp->md5sig_info->entries4; i++)
-			kfree(tp->md5sig_info->keys4[i].key);
+			kfree(tp->md5sig_info->keys4[i].base.key);
 		tp->md5sig_info->entries4 = 0;
 		tcp_free_md5sig_pool();
 	}
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -551,7 +551,7 @@ static struct tcp_md5sig_key *tcp_v6_md5
 
 	for (i = 0; i < tp->md5sig_info->entries6; i++) {
 		if (ipv6_addr_cmp(&tp->md5sig_info->keys6[i].addr, addr) == 0)
-			return (struct tcp_md5sig_key *)&tp->md5sig_info->keys6[i];
+			return &tp->md5sig_info->keys6[i].base;
 	}
 	return NULL;
 }
@@ -579,9 +579,9 @@ static int tcp_v6_md5_do_add(struct sock
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
@@ -615,8 +615,8 @@ static int tcp_v6_md5_do_add(struct sock
 
 		ipv6_addr_copy(&tp->md5sig_info->keys6[tp->md5sig_info->entries6].addr,
 			       peer);
-		tp->md5sig_info->keys6[tp->md5sig_info->entries6].key = newkey;
-		tp->md5sig_info->keys6[tp->md5sig_info->entries6].keylen = newkeylen;
+		tp->md5sig_info->keys6[tp->md5sig_info->entries6].base.key = newkey;
+		tp->md5sig_info->keys6[tp->md5sig_info->entries6].base.keylen = newkeylen;
 
 		tp->md5sig_info->entries6++;
 	}
@@ -638,7 +638,7 @@ static int tcp_v6_md5_do_del(struct sock
 	for (i = 0; i < tp->md5sig_info->entries6; i++) {
 		if (ipv6_addr_cmp(&tp->md5sig_info->keys6[i].addr, peer) == 0) {
 			/* Free the key */
-			kfree(tp->md5sig_info->keys6[i].key);
+			kfree(tp->md5sig_info->keys6[i].base.key);
 			tp->md5sig_info->entries6--;
 
 			if (tp->md5sig_info->entries6 == 0) {
@@ -669,7 +669,7 @@ static void tcp_v6_clear_md5_list (struc
 
 	if (tp->md5sig_info->entries6) {
 		for (i = 0; i < tp->md5sig_info->entries6; i++)
-			kfree(tp->md5sig_info->keys6[i].key);
+			kfree(tp->md5sig_info->keys6[i].base.key);
 		tp->md5sig_info->entries6 = 0;
 		tcp_free_md5sig_pool();
 	}
@@ -680,7 +680,7 @@ static void tcp_v6_clear_md5_list (struc
 
 	if (tp->md5sig_info->entries4) {
 		for (i = 0; i < tp->md5sig_info->entries4; i++)
-			kfree(tp->md5sig_info->keys4[i].key);
+			kfree(tp->md5sig_info->keys4[i].base.key);
 		tp->md5sig_info->entries4 = 0;
 		tcp_free_md5sig_pool();
 	}

-- 
