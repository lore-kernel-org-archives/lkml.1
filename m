Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbZLGA2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbZLGA2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934440AbZLGA1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:27:50 -0500
Received: from kroah.org ([198.145.64.141]:34413 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758464AbZLGANI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:49 2009
Message-Id: <20091207000649.092477223@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>
Subject: [050/119] ima: replace GFP_KERNEL with GFP_NOFS
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=ima-replace-gfp_kernel-with-gfp_nofs.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit c09c59e6a070d6af05f238f255aea268185273ef upstream.

While running fsstress tests on the NFSv4 mounted ext3 and ext4
filesystem, the following call trace was generated on the nfs
server machine.

Replace GFP_KERNEL with GFP_NOFS in ima_iint_insert() to avoid a
potential deadlock.

     =================================
    [ INFO: inconsistent lock state ]
    2.6.31-31.el6.x86_64 #1
    ---------------------------------
    inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
    kswapd2/75 [HC0[0]:SC0[0]:HE1:SE1] takes:
     (jbd2_handle){+.+.?.}, at: [<ffffffff811edd5e>] jbd2_journal_start+0xfe/0x13f
    {RECLAIM_FS-ON-W} state was registered at:
      [<ffffffff81091e40>] mark_held_locks+0x65/0x99
      [<ffffffff81091f31>] lockdep_trace_alloc+0xbd/0xf5
      [<ffffffff81126fdd>] kmem_cache_alloc+0x40/0x185
      [<ffffffff812344d7>] ima_iint_insert+0x3d/0xf1
      [<ffffffff812345b0>] ima_inode_alloc+0x25/0x44
      [<ffffffff811484ac>] inode_init_always+0xec/0x271
      [<ffffffff81148682>] alloc_inode+0x51/0xa1
      [<ffffffff81148700>] new_inode+0x2e/0x94
      [<ffffffff811b2f08>] ext4_new_inode+0xb8/0xdc9
      [<ffffffff811be611>] ext4_create+0xcf/0x175
      [<ffffffff8113e2cd>] vfs_create+0x82/0xb8
      [<ffffffff8113f337>] do_filp_open+0x32c/0x9ee
      [<ffffffff811309b9>] do_sys_open+0x6c/0x12c
      [<ffffffff81130adc>] sys_open+0x2e/0x44
      [<ffffffff81011e42>] system_call_fastpath+0x16/0x1b
      [<ffffffffffffffff>] 0xffffffffffffffff
    irq event stamp: 90371
    hardirqs last  enabled at (90371): [<ffffffff8112708d>]
    kmem_cache_alloc+0xf0/0x185
    hardirqs last disabled at (90370): [<ffffffff81127026>]
    kmem_cache_alloc+0x89/0x185
    softirqs last  enabled at (89492): [<ffffffff81068ecf>]
    __do_softirq+0x1bf/0x1eb
    softirqs last disabled at (89477): [<ffffffff8101312c>] call_softirq+0x1c/0x30

    other info that might help us debug this:
    2 locks held by kswapd2/75:
     #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810f98ba>] shrink_slab+0x44/0x177
     #1:  (&type->s_umount_key#25){++++..}, at: [<ffffffff811450ba>]

Reported-by: Muni P. Beerakam <mbeeraka@in.ibm.com>
Reported-by: Amit K. Arora <amitarora@in.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/integrity/ima/ima_iint.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -58,11 +58,11 @@ struct ima_iint_cache *ima_iint_insert(s
 
 	if (!ima_initialized)
 		return iint;
-	iint = kmem_cache_alloc(iint_cache, GFP_KERNEL);
+	iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
 	if (!iint)
 		return iint;
 
-	rc = radix_tree_preload(GFP_KERNEL);
+	rc = radix_tree_preload(GFP_NOFS);
 	if (rc < 0)
 		goto out;
 


