Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYHKWke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYHKWke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYHKWkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:40:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:10457 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYHKWkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=G27FzdROZ2TdWv1RGUlZ6sur6Zli8U5o4gVVpNnuOlVk9xw7R0LqpZykIO9R83qe/e
         IOYbMZEiY8YEcdfAxX396tXi+qrkU2c54jdFxMM7QepAk4BCPOKnty0UrutN7WcGdp0n
         mBor4j2wyNa25Lg5hBv62q0R/ki06b5hQZfJs=
Message-ID: <48A0BFC9.40502@gmail.com>
Date: Mon, 11 Aug 2008 18:40:09 -0400
From: Ryan Hope <rmh3093@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080805)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Reiserfs mailing list <reiserfs-devel@vger.kernel.org>
Subject: [PATCH 3/3][reiser4] dont get radix-tree dirty tagging out of sync
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was item #14 on the todo list for reiser4 inclusion in mainline:

diff --git a/fs/reiser4/page_cache.c b/fs/reiser4/page_cache.c
index fe71368..a662c25 100644
--- a/fs/reiser4/page_cache.c
+++ b/fs/reiser4/page_cache.c
@@ -467,15 +467,14 @@ int reiser4_set_page_dirty_internal(struct page *page)
  	BUG_ON(mapping == NULL);

  	if (!TestSetPageDirty(page)) {
+		spin_lock_irq(&mapping->tree_lock);
  		if (mapping_cap_account_dirty(mapping))
  			inc_zone_page_state(page, NR_FILE_DIRTY);
-
+		radix_tree_tag_set(&mapping->page_tree,
+			page_index(page), PAGECACHE_TAG_DIRTY);
  		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+		spin_unlock_irq(&mapping->tree_lock);
  	}
-
-	/* znode must be dirty ? */
-	if (mapping->host == reiser4_get_super_fake(mapping->host->i_sb))
-		assert("", JF_ISSET(jprivate(page), JNODE_DIRTY));
  	return 0;
  }

-Ryan
