Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZC3HSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZC3HSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbZC3HSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:18:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:19964 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZC3HSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:18:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,445,1233561600"; 
   d="scan'208";a="125540074"
Date: Mon, 30 Mar 2009 15:18:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>, Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH][RESEND for 2.6.29-rc8-mm1] skip I_CLEAR state inodes
Message-ID: <20090330071824.GA9260@localhost>
References: <20090318170237.8F6C.61FB500B@jp.fujitsu.com> <20090323103846.GA16577@localhost> <20090324155655.2684.61FB500B@jp.fujitsu.com> <20090324074457.GA7745@localhost> <20090324120502.GC23439@duck.suse.cz> <20090324124001.GA25326@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324124001.GA25326@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clear_inode() will switch inode state from I_FREEING to I_CLEAR,
and do so _outside_ of inode_lock. So any I_FREEING testing is
incomplete without a coupled testing of I_CLEAR.

So add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
add_dquot_ref().

Masayoshi MIZUMA discovered the bug in drop_pagecache_sb() and Jan Kara
reminds fixing the other two cases.

Reported-by: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/drop_caches.c  |    2 +-
 fs/fs-writeback.c |    3 ++-
 fs/quota/dquot.c  |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- mm.orig/fs/drop_caches.c
+++ mm/fs/drop_caches.c
@@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
--- mm.orig/fs/fs-writeback.c
+++ mm/fs/fs-writeback.c
@@ -538,7 +538,8 @@ void generic_sync_sb_inodes(struct super
 		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 			struct address_space *mapping;
 
-			if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+			if (inode->i_state &
+					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 				continue;
 			mapping = inode->i_mapping;
 			if (mapping->nrpages == 0)
--- mm.orig/fs/quota/dquot.c
+++ mm/fs/quota/dquot.c
@@ -823,7 +823,7 @@ static void add_dquot_ref(struct super_b
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
 		if (!atomic_read(&inode->i_writecount))
 			continue;
