Return-Path: <linux-kernel-owner+w=401wt.eu-S936898AbYBWAkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936898AbYBWAkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbYBWAei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:34:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:55466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764109AbYBWAeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:34:36 -0500
Date: Fri, 22 Feb 2008 16:30:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/38] IPV4: fib_trie: apply fixes from fib_hash
Message-ID: <20080223003029.GP7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv4-fib_trie-apply-fixes-from-fib_hash.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: 936f6f8e1bc46834bbb3e3fa3ac13ab44f1e7ba6

	Update fib_trie with some fib_hash fixes:
- check for duplicate alternative routes for prefix+tos+priority when
replacing route
- properly insert by matching tos together with priority
- fix alias walking to use list_for_each_entry_continue for insertion
and deletion when fa_head is not NULL
- copy state from fa to new_fa on replace (not a problem for now)
- additionally, avoid replacement without error if new route is same,
as Joonwoo Park suggests.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/fib_trie.c |   57 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1203,20 +1203,45 @@ static int fn_trie_insert(struct fib_tab
 	 * and we need to allocate a new one of those as well.
 	 */
 
-	if (fa && fa->fa_info->fib_priority == fi->fib_priority) {
-		struct fib_alias *fa_orig;
+	if (fa && fa->fa_tos == tos &&
+	    fa->fa_info->fib_priority == fi->fib_priority) {
+		struct fib_alias *fa_first, *fa_match;
 
 		err = -EEXIST;
 		if (cfg->fc_nlflags & NLM_F_EXCL)
 			goto out;
 
+		/* We have 2 goals:
+		 * 1. Find exact match for type, scope, fib_info to avoid
+		 * duplicate routes
+		 * 2. Find next 'fa' (or head), NLM_F_APPEND inserts before it
+		 */
+		fa_match = NULL;
+		fa_first = fa;
+		fa = list_entry(fa->fa_list.prev, struct fib_alias, fa_list);
+		list_for_each_entry_continue(fa, fa_head, fa_list) {
+			if (fa->fa_tos != tos)
+				break;
+			if (fa->fa_info->fib_priority != fi->fib_priority)
+				break;
+			if (fa->fa_type == cfg->fc_type &&
+			    fa->fa_scope == cfg->fc_scope &&
+			    fa->fa_info == fi) {
+				fa_match = fa;
+				break;
+			}
+		}
+
 		if (cfg->fc_nlflags & NLM_F_REPLACE) {
 			struct fib_info *fi_drop;
 			u8 state;
 
-			if (fi->fib_treeref > 1)
+			fa = fa_first;
+			if (fa_match) {
+				if (fa == fa_match)
+					err = 0;
 				goto out;
-
+			}
 			err = -ENOBUFS;
 			new_fa = kmem_cache_alloc(fn_alias_kmem, GFP_KERNEL);
 			if (new_fa == NULL)
@@ -1228,7 +1253,7 @@ static int fn_trie_insert(struct fib_tab
 			new_fa->fa_type = cfg->fc_type;
 			new_fa->fa_scope = cfg->fc_scope;
 			state = fa->fa_state;
-			new_fa->fa_state &= ~FA_S_ACCESSED;
+			new_fa->fa_state = state & ~FA_S_ACCESSED;
 
 			list_replace_rcu(&fa->fa_list, &new_fa->fa_list);
 			alias_free_mem_rcu(fa);
@@ -1245,20 +1270,11 @@ static int fn_trie_insert(struct fib_tab
 		 * uses the same scope, type, and nexthop
 		 * information.
 		 */
-		fa_orig = fa;
-		list_for_each_entry(fa, fa_orig->fa_list.prev, fa_list) {
-			if (fa->fa_tos != tos)
-				break;
-			if (fa->fa_info->fib_priority != fi->fib_priority)
-				break;
-			if (fa->fa_type == cfg->fc_type &&
-			    fa->fa_scope == cfg->fc_scope &&
-			    fa->fa_info == fi) {
-				goto out;
-			}
-		}
+		if (fa_match)
+			goto out;
+
 		if (!(cfg->fc_nlflags & NLM_F_APPEND))
-			fa = fa_orig;
+			fa = fa_first;
 	}
 	err = -ENOENT;
 	if (!(cfg->fc_nlflags & NLM_F_CREATE))
@@ -1614,9 +1630,8 @@ static int fn_trie_delete(struct fib_tab
 	pr_debug("Deleting %08x/%d tos=%d t=%p\n", key, plen, tos, t);
 
 	fa_to_delete = NULL;
-	fa_head = fa->fa_list.prev;
-
-	list_for_each_entry(fa, fa_head, fa_list) {
+	fa = list_entry(fa->fa_list.prev, struct fib_alias, fa_list);
+	list_for_each_entry_continue(fa, fa_head, fa_list) {
 		struct fib_info *fi = fa->fa_info;
 
 		if (fa->fa_tos != tos)

-- 
