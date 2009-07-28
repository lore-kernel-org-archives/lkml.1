Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbZG1Xue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbZG1Xue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbZG1Xub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:31 -0400
Received: from kroah.org ([198.145.64.141]:35939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbZG1Xu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:00 2009
Message-Id: <20090728234200.417694192@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 58/71] netfilter: nf_conntrack: fix confirmation race condition
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-nf_conntrack-fix-confirmation-race-condition.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 5c8ec910e789a92229978d8fd1fce7b62e8ac711 upstream.

New connection tracking entries are inserted into the hash before they
are fully set up, namely the CONFIRMED bit is not set and the timer not
started yet. This can theoretically lead to a race with timer, which
would set the timeout value to a relative value, most likely already in
the past.

Perform hash insertion as the final step to fix this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -385,7 +385,6 @@ __nf_conntrack_confirm(struct sk_buff *s
 	/* Remove from unconfirmed list */
 	hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 
-	__nf_conntrack_hash_insert(ct, hash, repl_hash);
 	/* Timer relative to confirmation time, not original
 	   setting time, otherwise we'd get timer wrap in
 	   weird delay cases. */
@@ -393,8 +392,16 @@ __nf_conntrack_confirm(struct sk_buff *s
 	add_timer(&ct->timeout);
 	atomic_inc(&ct->ct_general.use);
 	set_bit(IPS_CONFIRMED_BIT, &ct->status);
+
+	/* Since the lookup is lockless, hash insertion must be done after
+	 * starting the timer and setting the CONFIRMED bit. The RCU barriers
+	 * guarantee that no other CPU can find the conntrack before the above
+	 * stores are visible.
+	 */
+	__nf_conntrack_hash_insert(ct, hash, repl_hash);
 	NF_CT_STAT_INC(net, insert);
 	spin_unlock_bh(&nf_conntrack_lock);
+
 	help = nfct_help(ct);
 	if (help && help->helper)
 		nf_conntrack_event_cache(IPCT_HELPER, ct);


