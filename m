Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbZAWGRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbZAWGRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZAWGQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:21 -0500
Received: from kroah.org ([198.145.64.141]:36062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751864AbZAWGQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:20 -0500
Date: Thu, 22 Jan 2009 22:12:47 -0800
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
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/40] ipv6: Fix fib6_dump_table walker leak
Message-ID: <20090123061247.GB2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv6-fix-fib6_dump_table-walker-leak.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit: 7891cc818967e186be68caac32d84bfd0a3f0bd2 ]

When a fib6 table dump is prematurely ended, we won't unlink
its walker from the list.  This causes all sorts of grief for
other users of the list later.

Reported-by: Chris Caputo <ccaputo@alt.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ip6_fib.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -298,6 +298,10 @@ static void fib6_dump_end(struct netlink
 	struct fib6_walker_t *w = (void*)cb->args[2];
 
 	if (w) {
+		if (cb->args[4]) {
+			cb->args[4] = 0;
+			fib6_walker_unlink(w);
+		}
 		cb->args[2] = 0;
 		kfree(w);
 	}
@@ -330,15 +334,12 @@ static int fib6_dump_table(struct fib6_t
 		read_lock_bh(&table->tb6_lock);
 		res = fib6_walk_continue(w);
 		read_unlock_bh(&table->tb6_lock);
-		if (res != 0) {
-			if (res < 0)
-				fib6_walker_unlink(w);
-			goto end;
+		if (res <= 0) {
+			fib6_walker_unlink(w);
+			cb->args[4] = 0;
 		}
-		fib6_walker_unlink(w);
-		cb->args[4] = 0;
 	}
-end:
+
 	return res;
 }
 

