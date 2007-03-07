Return-Path: <linux-kernel-owner+w=401wt.eu-S1422853AbXCGR33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422853AbXCGR33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422874AbXCGRRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:15 -0500
Received: from mx1.suse.de ([195.135.220.2]:44128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422853AbXCGRQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:49 -0500
Message-Id: <20070307171511.258148132@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 068/101] Fix TCP MD5 locking.
Content-Disposition: inline; filename=fix-tcp-md5-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

[TCP]: Fix MD5 signature pool locking.

The locking calls assumed that these code paths were only
invoked in software interrupt context, but that isn't true.

Therefore we need to use spin_{lock,unlock}_bh() throughout.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- linux-2.6.20.1.orig/net/ipv4/tcp.c
+++ linux-2.6.20.1/net/ipv4/tcp.c
@@ -2266,12 +2266,12 @@ void tcp_free_md5sig_pool(void)
 {
 	struct tcp_md5sig_pool **pool = NULL;
 
-	spin_lock(&tcp_md5sig_pool_lock);
+	spin_lock_bh(&tcp_md5sig_pool_lock);
 	if (--tcp_md5sig_users == 0) {
 		pool = tcp_md5sig_pool;
 		tcp_md5sig_pool = NULL;
 	}
-	spin_unlock(&tcp_md5sig_pool_lock);
+	spin_unlock_bh(&tcp_md5sig_pool_lock);
 	if (pool)
 		__tcp_free_md5sig_pool(pool);
 }
@@ -2314,36 +2314,36 @@ struct tcp_md5sig_pool **tcp_alloc_md5si
 	int alloc = 0;
 
 retry:
-	spin_lock(&tcp_md5sig_pool_lock);
+	spin_lock_bh(&tcp_md5sig_pool_lock);
 	pool = tcp_md5sig_pool;
 	if (tcp_md5sig_users++ == 0) {
 		alloc = 1;
-		spin_unlock(&tcp_md5sig_pool_lock);
+		spin_unlock_bh(&tcp_md5sig_pool_lock);
 	} else if (!pool) {
 		tcp_md5sig_users--;
-		spin_unlock(&tcp_md5sig_pool_lock);
+		spin_unlock_bh(&tcp_md5sig_pool_lock);
 		cpu_relax();
 		goto retry;
 	} else
-		spin_unlock(&tcp_md5sig_pool_lock);
+		spin_unlock_bh(&tcp_md5sig_pool_lock);
 
 	if (alloc) {
 		/* we cannot hold spinlock here because this may sleep. */
 		struct tcp_md5sig_pool **p = __tcp_alloc_md5sig_pool();
-		spin_lock(&tcp_md5sig_pool_lock);
+		spin_lock_bh(&tcp_md5sig_pool_lock);
 		if (!p) {
 			tcp_md5sig_users--;
-			spin_unlock(&tcp_md5sig_pool_lock);
+			spin_unlock_bh(&tcp_md5sig_pool_lock);
 			return NULL;
 		}
 		pool = tcp_md5sig_pool;
 		if (pool) {
 			/* oops, it has already been assigned. */
-			spin_unlock(&tcp_md5sig_pool_lock);
+			spin_unlock_bh(&tcp_md5sig_pool_lock);
 			__tcp_free_md5sig_pool(p);
 		} else {
 			tcp_md5sig_pool = pool = p;
-			spin_unlock(&tcp_md5sig_pool_lock);
+			spin_unlock_bh(&tcp_md5sig_pool_lock);
 		}
 	}
 	return pool;
@@ -2354,11 +2354,11 @@ EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 struct tcp_md5sig_pool *__tcp_get_md5sig_pool(int cpu)
 {
 	struct tcp_md5sig_pool **p;
-	spin_lock(&tcp_md5sig_pool_lock);
+	spin_lock_bh(&tcp_md5sig_pool_lock);
 	p = tcp_md5sig_pool;
 	if (p)
 		tcp_md5sig_users++;
-	spin_unlock(&tcp_md5sig_pool_lock);
+	spin_unlock_bh(&tcp_md5sig_pool_lock);
 	return (p ? *per_cpu_ptr(p, cpu) : NULL);
 }
 

--
