Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbZCQXxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbZCQXxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZCQXxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:53:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:42456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZCQXxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:53:22 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 29/32] ocfs2/dlm: Tweak mle_state output
Date: Tue, 17 Mar 2009 13:01:19 -0700
Message-Id: <1237320082-12921-30-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

The debugfs file, mle_state, now prints the number of largest number of mles
in one hash link.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmdebug.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index bdf1c78..df52f70 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -494,7 +494,7 @@ static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 	struct hlist_head *bucket;
 	struct hlist_node *list;
 	int i, out = 0;
-	unsigned long total = 0;
+	unsigned long total = 0, longest = 0, bktcnt;
 
 	out += snprintf(db->buf + out, db->len - out,
 			"Dumping MLEs for Domain: %s\n", dlm->name);
@@ -506,15 +506,18 @@ static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 			mle = hlist_entry(list, struct dlm_master_list_entry,
 					  master_hash_node);
 			++total;
+			++bktcnt;
 			if (db->len - out < 200)
 				continue;
 			out += dump_mle(mle, db->buf + out, db->len - out);
 		}
+		longest = max(longest, bktcnt);
+		bktcnt = 0;
 	}
 	spin_unlock(&dlm->master_lock);
 
 	out += snprintf(db->buf + out, db->len - out,
-			"Total on list: %ld\n", total);
+			"Total: %ld, Longest: %ld\n", total, longest);
 	return out;
 }
 
-- 
1.5.6

