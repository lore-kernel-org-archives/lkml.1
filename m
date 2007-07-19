Return-Path: <linux-kernel-owner+w=401wt.eu-S1762497AbXGSV3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497AbXGSV3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbXGSV2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:28:55 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41768 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbXGSV2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:28:54 -0400
Date: Thu, 19 Jul 2007 16:26:37 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tchicks@us.ibm.com,
       trevor.highland@gmail.com, pregan@ic.sunysb.edu, toml@us.ibm.com,
       sergeh@us.ibm.com, mike@halcrow.us
Subject: [PATCH 2/8] eCryptfs: Use list_for_each_entry_safe() when wiping auth toks
Message-ID: <20070719212637.GC13821@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070719212453.GA13821@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719212453.GA13821@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry_safe() when wiping the authentication token
list.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/keystore.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index ef4904a..590f29c 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -469,26 +469,19 @@ out:
 
 static void wipe_auth_tok_list(struct list_head *auth_tok_list_head)
 {
-	struct list_head *walker;
 	struct ecryptfs_auth_tok_list_item *auth_tok_list_item;
+	struct ecryptfs_auth_tok_list_item *auth_tok_list_item_tmp;
 
-	walker = auth_tok_list_head->next;
-	while (walker != auth_tok_list_head) {
-		auth_tok_list_item =
-		    list_entry(walker, struct ecryptfs_auth_tok_list_item,
-			       list);
-		walker = auth_tok_list_item->list.next;
-		memset(auth_tok_list_item, 0,
-		       sizeof(struct ecryptfs_auth_tok_list_item));
+	list_for_each_entry_safe(auth_tok_list_item, auth_tok_list_item_tmp,
+				 auth_tok_list_head, list) {
+		list_del(&auth_tok_list_item->list);
 		kmem_cache_free(ecryptfs_auth_tok_list_item_cache,
 				auth_tok_list_item);
 	}
-	auth_tok_list_head->next = NULL;
 }
 
 struct kmem_cache *ecryptfs_auth_tok_list_item_cache;
 
-
 /**
  * parse_tag_1_packet
  * @crypt_stat: The cryptographic context to modify based on packet
-- 
1.4.4.4

