Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbZG1Xwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbZG1Xwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZG1Xuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:32 -0400
Received: from kroah.org ([198.145.64.141]:35942 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbZG1Xu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:00 2009
Message-Id: <20090728234200.577587847@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 59/71] netfilter: nf_conntrack: fix conntrack lookup race
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-nf_conntrack-fix-conntrack-lookup-race.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 8d8890b7751387f58ce0a6428773de2fbc0fd596 upstream.

The RCU protected conntrack hash lookup only checks whether the entry
has a refcount of zero to decide whether it is stale. This is not
sufficient, entries are explicitly removed while there is at least
one reference left, possibly more. Explicitly check whether the entry
has been marked as dying to fix this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -295,7 +295,8 @@ begin:
 	h = __nf_conntrack_find(net, tuple);
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
+		if (unlikely(nf_ct_is_dying(ct) ||
+			     !atomic_inc_not_zero(&ct->ct_general.use)))
 			h = NULL;
 		else {
 			if (unlikely(!nf_ct_tuple_equal(tuple, &h->tuple))) {
@@ -474,7 +475,8 @@ static noinline int early_drop(struct ne
 			cnt++;
 		}
 
-		if (ct && unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
+		if (ct && unlikely(nf_ct_is_dying(ct) ||
+				   !atomic_inc_not_zero(&ct->ct_general.use)))
 			ct = NULL;
 		if (ct || cnt >= NF_CT_EVICTION_RANGE)
 			break;


