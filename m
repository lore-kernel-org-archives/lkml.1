Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbZKFWcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbZKFWcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932527AbZKFWXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:15 -0500
Received: from kroah.org ([198.145.64.141]:56917 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760201AbZKFWXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:46 2009
Message-Id: <20091106221546.158296779@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [54/99] nilfs2: fix dirty page accounting leak causing hang at write
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=nilfs2-fix-dirty-page-accounting-leak-causing-hang-at-write.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit b1e19e5601277845b4f17ecd7c9ba04f73ee11aa upstream.

Bruno Prémont and Dunphy, Bill noticed me that NILFS will certainly
hang on ARM-based targets.

I found this was caused by an underflow of dirty pages counter.  A
b-tree cache routine was marking page dirty without adjusting page
account information.

This fixes the dirty page accounting leak and resolves the hang on
arm-based targets.

Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Reported-by: Dunphy, Bill <WDunphy@tandbergdata.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/btnode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -276,8 +276,7 @@ void nilfs_btnode_commit_change_key(stru
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
-		if (!test_set_buffer_dirty(obh) && TestSetPageDirty(opage))
-			BUG();
+		nilfs_btnode_mark_dirty(obh);
 
 		spin_lock_irq(&btnc->tree_lock);
 		radix_tree_delete(&btnc->page_tree, oldkey);


