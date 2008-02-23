Return-Path: <linux-kernel-owner+w=401wt.eu-S936989AbYBWAk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936989AbYBWAk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934593AbYBWAem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:34:42 -0500
Received: from ns2.suse.de ([195.135.220.15]:55487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764545AbYBWAek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:34:40 -0500
Date: Fri, 22 Feb 2008 16:30:33 -0800
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
Subject: [patch 16/38] IPV4: fib: fix route replacement, fib_info is shared
Message-ID: <20080223003033.GQ7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv4-fib-fix-route-replacement-fib_info-is-shared.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: c18865f39276435abb9286f9a816cb5b66c99a00

fib_info can be shared by many route prefixes but we don't want
duplicate alternative routes for a prefix+tos+priority. Last change
was not correct to check fib_treeref because it accounts usage from
other prefixes. Additionally, avoid replacement without error if new
route is same, as Joonwoo Park suggests.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/fib_hash.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

--- a/net/ipv4/fib_hash.c
+++ b/net/ipv4/fib_hash.c
@@ -434,19 +434,43 @@ static int fn_hash_insert(struct fib_tab
 
 	if (fa && fa->fa_tos == tos &&
 	    fa->fa_info->fib_priority == fi->fib_priority) {
-		struct fib_alias *fa_orig;
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
+		list_for_each_entry_continue(fa, &f->fn_alias, fa_list) {
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
 			write_lock_bh(&fib_hash_lock);
 			fi_drop = fa->fa_info;
 			fa->fa_info = fi;
@@ -469,20 +493,11 @@ static int fn_hash_insert(struct fib_tab
 		 * uses the same scope, type, and nexthop
 		 * information.
 		 */
-		fa_orig = fa;
-		fa = list_entry(fa->fa_list.prev, struct fib_alias, fa_list);
-		list_for_each_entry_continue(fa, &f->fn_alias, fa_list) {
-			if (fa->fa_tos != tos)
-				break;
-			if (fa->fa_info->fib_priority != fi->fib_priority)
-				break;
-			if (fa->fa_type == cfg->fc_type &&
-			    fa->fa_scope == cfg->fc_scope &&
-			    fa->fa_info == fi)
-				goto out;
-		}
+		if (fa_match)
+			goto out;
+
 		if (!(cfg->fc_nlflags & NLM_F_APPEND))
-			fa = fa_orig;
+			fa = fa_first;
 	}
 
 	err = -ENOENT;

-- 
