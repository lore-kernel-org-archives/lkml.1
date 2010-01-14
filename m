Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841Ab0ANWwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab0ANWwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757825Ab0ANWwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:52:12 -0500
Received: from kroah.org ([198.145.64.141]:58189 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab0ANWwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:52:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 14:48:07 2010
Message-Id: <20100114224806.913050712@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 14:46:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>
Subject: [5/9] netfilter: nf_ct_ftp: fix out of bounds read in update_nl_seq()
In-Reply-To: <20100114224848.GA532@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -323,24 +323,24 @@ static void update_nl_seq(struct nf_conn
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
 


