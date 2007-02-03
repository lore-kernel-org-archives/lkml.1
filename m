Return-Path: <linux-kernel-owner+w=401wt.eu-S1946294AbXBCCoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946294AbXBCCoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946289AbXBCCn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:43:56 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53567 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946287AbXBCCnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:43:52 -0500
Message-Id: <20070203024610.275987000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:54 -0800
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
       Robert Olsson <robert.olsson@its.uu.se>,
       Eric W Biederman <ebiederm@xmission.com>
Subject: [patch 50/59] IPV4: Fix single-entry /proc/net/fib_trie output.
Content-Disposition: inline; filename=ipv4-fix-single-entry-proc-net-fib_trie-output.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Robert Olsson <robert.olsson@its.uu.se>

When main table is just a single leaf this gets printed as belonging to the
local table in /proc/net/fib_trie. A fix is below.

Signed-off-by: Robert Olsson <robert.olsson@its.uu.se>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/fib_trie.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux-2.6.19.2.orig/net/ipv4/fib_trie.c
+++ linux-2.6.19.2/net/ipv4/fib_trie.c
@@ -2290,16 +2290,17 @@ static int fib_trie_seq_show(struct seq_
 	if (v == SEQ_START_TOKEN)
 		return 0;
 
+	if (!NODE_PARENT(n)) {
+		if (iter->trie == trie_local)
+			seq_puts(seq, "<local>:\n");
+		else
+			seq_puts(seq, "<main>:\n");
+	}
+
 	if (IS_TNODE(n)) {
 		struct tnode *tn = (struct tnode *) n;
 		__be32 prf = htonl(MASK_PFX(tn->key, tn->pos));
 
-		if (!NODE_PARENT(n)) {
-			if (iter->trie == trie_local)
-				seq_puts(seq, "<local>:\n");
-			else
-				seq_puts(seq, "<main>:\n");
-		} 
 		seq_indent(seq, iter->depth-1);
 		seq_printf(seq, "  +-- %d.%d.%d.%d/%d %d %d %d\n",
 			   NIPQUAD(prf), tn->pos, tn->bits, tn->full_children, 

--
