Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYJGA7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYJGA7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbYJGApc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:45:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbYJGApa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:45:30 -0400
Date: Mon, 6 Oct 2008 17:39:47 -0700
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
       alan@lxorguk.ukuu.org.uk, Timo Teras <timo.teras@iki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 51/71] af_key: Free dumping state on socket close
Message-ID: <20081007003947.GZ3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-af_key-Free-dumping-state-on-socket-close.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Timo Teras <timo.teras@iki.fi>

[ Upstream commit 0523820482dcb42784572ffd2296c2f08c275a2b ]

Fix a xfrm_{state,policy}_walk leak if pfkey socket is closed while
dumping is on-going.

Signed-off-by: Timo Teras <timo.teras@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/key/af_key.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -73,22 +73,18 @@ static int pfkey_can_dump(struct sock *s
 	return 0;
 }
 
-static int pfkey_do_dump(struct pfkey_sock *pfk)
+static void pfkey_terminate_dump(struct pfkey_sock *pfk)
 {
-	int rc;
-
-	rc = pfk->dump.dump(pfk);
-	if (rc == -ENOBUFS)
-		return 0;
-
-	pfk->dump.done(pfk);
-	pfk->dump.dump = NULL;
-	pfk->dump.done = NULL;
-	return rc;
+	if (pfk->dump.dump) {
+		pfk->dump.done(pfk);
+		pfk->dump.dump = NULL;
+		pfk->dump.done = NULL;
+	}
 }
 
 static void pfkey_sock_destruct(struct sock *sk)
 {
+	pfkey_terminate_dump(pfkey_sk(sk));
 	skb_queue_purge(&sk->sk_receive_queue);
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
@@ -310,6 +306,18 @@ static int pfkey_broadcast(struct sk_buf
 	return err;
 }
 
+static int pfkey_do_dump(struct pfkey_sock *pfk)
+{
+	int rc;
+
+	rc = pfk->dump.dump(pfk);
+	if (rc == -ENOBUFS)
+		return 0;
+
+	pfkey_terminate_dump(pfk);
+	return rc;
+}
+
 static inline void pfkey_hdr_dup(struct sadb_msg *new, struct sadb_msg *orig)
 {
 	*new = *orig;

-- 
