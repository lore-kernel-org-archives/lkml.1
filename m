Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339Ab0ANWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0ANWeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745Ab0ANWeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:34:15 -0500
Received: from kroah.org ([198.145.64.141]:60619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab0ANW2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Patrick McHardy <kaber@trash.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/52] netfilter: nf_ct_ftp: fix out of bounds read in update_nl_seq()
Date: Thu, 14 Jan 2010 14:27:13 -0800
Message-Id: <1263508051-7868-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-33-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>

commit aaff23a95aea5f000895f50d90e91f1e2f727002 upstream.

As noticed by Dan Carpenter <error27@gmail.com>, update_nl_seq()
currently contains an out of bounds read of the seq_aft_nl array
when looking for the oldest sequence number position.

Fix it to only compare valid positions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/netfilter/nf_conntrack_ftp.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 5509dd1..7dfd469 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -323,24 +323,24 @@ static void update_nl_seq(struct nf_conn *ct, u32 nl_seq,
 			  struct nf_ct_ftp_master *info, int dir,
 			  struct sk_buff *skb)
 {
-	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
+	unsigned int i, oldest;
 
 	/* Look for oldest: if we find exact match, we're done. */
 	for (i = 0; i < info->seq_aft_nl_num[dir]; i++) {
 		if (info->seq_aft_nl[dir][i] == nl_seq)
 			return;
-
-		if (oldest == info->seq_aft_nl_num[dir] ||
-		    before(info->seq_aft_nl[dir][i],
-			   info->seq_aft_nl[dir][oldest]))
-			oldest = i;
 	}
 
 	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
-	} else if (oldest != NUM_SEQ_TO_REMEMBER &&
-		   after(nl_seq, info->seq_aft_nl[dir][oldest])) {
-		info->seq_aft_nl[dir][oldest] = nl_seq;
+	} else {
+		if (before(info->seq_aft_nl[dir][0], info->seq_aft_nl[dir][1]))
+			oldest = 0;
+		else
+			oldest = 1;
+
+		if (after(nl_seq, info->seq_aft_nl[dir][oldest]))
+			info->seq_aft_nl[dir][oldest] = nl_seq;
 	}
 }
 
-- 
1.6.6

