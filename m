Return-Path: <linux-kernel-owner+w=401wt.eu-S965122AbXCSVnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122AbXCSVnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbXCSVmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:42:37 -0400
Received: from mail.suse.de ([195.135.220.2]:55830 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030628AbXCSVly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:41:54 -0400
Date: Mon, 19 Mar 2007 14:39:57 -0700
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
       Robert Olsson <robert.olsson@its.uu.se>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 19/31] : Fix GFP_KERNEL with preemption disabled in fib_trie
Message-ID: <20070319213957.GU9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-gfp_kernel-with-preemption-disabled-in-fib_trie.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Olsson <robert.olsson@its.uu.se>

[IPV4]: Do not disable preemption in trie_leaf_remove().

Hello, Just discussed this Patrick...

We have two users of trie_leaf_remove, fn_trie_flush and fn_trie_delete
both are holding RTNL. So there shouldn't be need for this preempt stuff.
This is assumed to a leftover from an older RCU-take.

> Mhh .. I think I just remembered something - me incorrectly suggesting
> to add it there while we were talking about this at OLS :) IIRC the
> idea was to make sure tnode_free (which at that time didn't use
> call_rcu) wouldn't free memory while still in use in a rcu read-side
> critical section. It should have been synchronize_rcu of course,
> but with tnode_free using call_rcu it seems to be completely
> unnecessary. So I guess we can simply remove it.

Signed-off-by: Robert Olsson <robert.olsson@its.uu.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/fib_trie.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1528,7 +1528,6 @@ static int trie_leaf_remove(struct trie 
 	t->revision++;
 	t->size--;
 
-	preempt_disable();
 	tp = NODE_PARENT(n);
 	tnode_free((struct tnode *) n);
 
@@ -1538,7 +1537,6 @@ static int trie_leaf_remove(struct trie 
 		rcu_assign_pointer(t->trie, trie_rebalance(t, tp));
 	} else
 		rcu_assign_pointer(t->trie, NULL);
-	preempt_enable();
 
 	return 1;
 }

-- 
