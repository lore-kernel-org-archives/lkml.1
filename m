Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZCNAW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZCNAW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZCNASe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:34 -0400
Received: from kroah.org ([198.145.64.141]:46716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752062AbZCNASd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:40 2009
Message-Id: <20090314000740.633616698@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:21 -0700
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
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 13/96] JFFS2: fix mount crash caused by removed nodes
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=jffs2-fix-mount-crash-caused-by-removed-nodes.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 4c41bd0ec953954158f92bed5d3062645062b98e upstream.

At scan time we observed following scenario:

   node A inserted
   node B inserted
   node C inserted -> sets overlapped flag on node B

   node A is removed due to CRC failure -> overlapped flag on node B remains

   while (tn->overlapped)
   	 tn = tn_prev(tn);

   ==> crash, when tn_prev(B) is referenced.

When the ultimate node is removed at scan time and the overlapped flag
is set on the penultimate node, then nothing updates the overlapped
flag of that node. The overlapped iterators blindly expect that the
ultimate node does not have the overlapped flag set, which causes the
scan code to crash.

It would be a huge overhead to go through the node chain on node
removal and fix up the overlapped flags, so detecting such a case on
the fly in the overlapped iterators is a simpler and reliable
solution.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jffs2/readinode.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -220,7 +220,7 @@ static int jffs2_add_tn_to_tree(struct j
 				struct jffs2_tmp_dnode_info *tn)
 {
 	uint32_t fn_end = tn->fn->ofs + tn->fn->size;
-	struct jffs2_tmp_dnode_info *this;
+	struct jffs2_tmp_dnode_info *this, *ptn;
 
 	dbg_readinode("insert fragment %#04x-%#04x, ver %u at %08x\n", tn->fn->ofs, fn_end, tn->version, ref_offset(tn->fn->raw));
 
@@ -251,11 +251,18 @@ static int jffs2_add_tn_to_tree(struct j
 	if (this) {
 		/* If the node is coincident with another at a lower address,
 		   back up until the other node is found. It may be relevant */
-		while (this->overlapped)
-			this = tn_prev(this);
-
-		/* First node should never be marked overlapped */
-		BUG_ON(!this);
+		while (this->overlapped) {
+			ptn = tn_prev(this);
+			if (!ptn) {
+				/*
+				 * We killed a node which set the overlapped
+				 * flags during the scan. Fix it up.
+				 */
+				this->overlapped = 0;
+				break;
+			}
+			this = ptn;
+		}
 		dbg_readinode("'this' found %#04x-%#04x (%s)\n", this->fn->ofs, this->fn->ofs + this->fn->size, this->fn ? "data" : "hole");
 	}
 
@@ -360,7 +367,17 @@ static int jffs2_add_tn_to_tree(struct j
 			}
 			if (!this->overlapped)
 				break;
-			this = tn_prev(this);
+
+			ptn = tn_prev(this);
+			if (!ptn) {
+				/*
+				 * We killed a node which set the overlapped
+				 * flags during the scan. Fix it up.
+				 */
+				this->overlapped = 0;
+				break;
+			}
+			this = ptn;
 		}
 	}
 
@@ -456,8 +473,15 @@ static int jffs2_build_inode_fragtree(st
 		eat_last(&rii->tn_root, &last->rb);
 		ver_insert(&ver_root, last);
 
-		if (unlikely(last->overlapped))
-			continue;
+		if (unlikely(last->overlapped)) {
+			if (pen)
+				continue;
+			/*
+			 * We killed a node which set the overlapped
+			 * flags during the scan. Fix it up.
+			 */
+			last->overlapped = 0;
+		}
 
 		/* Now we have a bunch of nodes in reverse version
 		   order, in the tree at ver_root. Most of the time,


