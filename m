Return-Path: <linux-kernel-owner+w=401wt.eu-S1946282AbXBCCmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946282AbXBCCmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946264AbXBCCmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:42:04 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53452 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946258AbXBCClt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:41:49 -0500
Message-Id: <20070203024559.408317000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:53 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Olsson <robert.olsson@its.uu.se>
Subject: [patch 49/59] IPV4: Fix the fib trie iterator to work with a single entry routing tables
Content-Disposition: inline; filename=ipv4-fix-the-fib-trie-iterator-to-work-with-a-single-entry-routing-tables.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Eric W. Biederman <ebiederm@xmission.com>

In a kernel with trie routing enabled I had a simple routing setup
with only a single route to the outside world and no default
route. "ip route table list main" showed my the route just fine but
/proc/net/route was an empty file.  What was going on?

Thinking it was a bug in something I did and I looked deeper.  Eventually
I setup a second route and everything looked correct, huh?  Finally I
realized that the it was just the iterator pair in fib_trie_get_first,
fib_trie_get_next just could not handle a routing table with a single entry.

So to save myself and others further confusion, here is a simple fix for
the fib proc iterator so it works even when there is only a single route
in a routing table.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Robert Olsson <robert.olsson@its.uu.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/fib_trie.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- linux-2.6.19.2.orig/net/ipv4/fib_trie.c
+++ linux-2.6.19.2/net/ipv4/fib_trie.c
@@ -1989,6 +1989,10 @@ static struct node *fib_trie_get_next(st
 	unsigned cindex = iter->index;
 	struct tnode *p;
 
+	/* A single entry routing table */
+	if (!tn)
+		return NULL;
+
 	pr_debug("get_next iter={node=%p index=%d depth=%d}\n",
 		 iter->tnode, iter->index, iter->depth);
 rescan:
@@ -2037,11 +2041,18 @@ static struct node *fib_trie_get_first(s
 	if(!iter)
 		return NULL;
 
-	if (n && IS_TNODE(n)) {
-		iter->tnode = (struct tnode *) n;
-		iter->trie = t;
-		iter->index = 0;
-		iter->depth = 1;
+	if (n) {
+		if (IS_TNODE(n)) {
+			iter->tnode = (struct tnode *) n;
+			iter->trie = t;
+			iter->index = 0;
+			iter->depth = 1;
+		} else {
+			iter->tnode = NULL;
+			iter->trie  = t;
+			iter->index = 0;
+			iter->depth = 0;
+		}
 		return n;
 	}
 	return NULL;

--
