Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbXLRSIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbXLRSIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761040AbXLRSIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:08:41 -0500
Received: from styx.suse.cz ([82.119.242.94]:57056 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753975AbXLRSIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:08:40 -0500
Date: Tue, 18 Dec 2007 19:08:39 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix computation of SKB size for quota messages
Message-ID: <20071218180839.GG31091@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  attached patch fixes computation of buffer size needed for quota netlink
messages. Otherwise we were getting errors on some architectures. Andrew,
please apply. Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Fix computation of size of skb needed for quota message. We should use
netlink provided functions and not just an ad-hoc number. Also don't
print the return value from nla_put_foo() as it is always -1.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/dquot.c b/fs/dquot.c
index 686ab63..cee7c6f 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -895,9 +903,6 @@ out_lock:
 
 #ifdef CONFIG_QUOTA_NETLINK_INTERFACE
 
-/* Size of quota netlink message - actually an upperbound for buffer size */
-#define QUOTA_NL_MSG_SIZE 32
-
 /* Netlink family structure for quota */
 static struct genl_family quota_genl_family = {
 	.id = GENL_ID_GENERATE,
@@ -914,11 +919,13 @@ static void send_warning(const struct dquot *dquot, const char warntype)
 	struct sk_buff *skb;
 	void *msg_head;
 	int ret;
+	int msg_size = 4 * nla_total_size(sizeof(u32)) +
+		       2 * nla_total_size(sizeof(u64));
 
 	/* We have to allocate using GFP_NOFS as we are called from a
 	 * filesystem performing write and thus further recursion into
 	 * the fs to free some data could cause deadlocks. */
-	skb = genlmsg_new(QUOTA_NL_MSG_SIZE, GFP_NOFS);
+	skb = genlmsg_new(msg_size, GFP_NOFS);
 	if (!skb) {
 		printk(KERN_ERR
 		  "VFS: Not enough memory to send quota warning.\n");
@@ -959,7 +966,7 @@ static void send_warning(const struct dquot *dquot, const char warntype)
 			"VFS: Failed to send notification message: %d\n", ret);
 	return;
 attr_err_out:
-	printk(KERN_ERR "VFS: Failed to compose quota message: %d\n", ret);
+	printk(KERN_ERR "VFS: Not enough space to compose quota message!\n");
 err_out:
 	kfree_skb(skb);
 }
