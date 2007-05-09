Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbXEISrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbXEISrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbXEISq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:46:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21290 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbXEISqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:46:55 -0400
Date: Wed, 9 May 2007 11:51:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>, mark.fasheh@oracle.com,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] ocfs2: kobject/kset foobar
Message-Id: <20070509115110.a72ae462.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc warning and Oops that it causes:

fs/ocfs2/cluster/masklog.c:161: warning: assignment from incompatible pointer type
[ 2776.204120] OCFS2 Node Manager 1.3.3
[ 2776.211729] BUG: spinlock bad magic on CPU#0, modprobe/4424
[ 2776.214269]  lock: ffff810021c8fe18, .magic: ffffffff, .owner: /6394416, .owner_cpu: 0
[ 2776.217864] [ 2776.217865] Call Trace:
[ 2776.219662]  [<ffffffff803426c8>] spin_bug+0x9e/0xe9
[ 2776.221921]  [<ffffffff803427bf>] _raw_spin_lock+0x23/0xf9
[ 2776.224417]  [<ffffffff8051acf4>] _spin_lock+0x9/0xb
[ 2776.226676]  [<ffffffff8033c3b1>] kobject_shadow_add+0x98/0x1ac
[ 2776.229367]  [<ffffffff8033c4d0>] kobject_add+0xb/0xd
[ 2776.231665]  [<ffffffff8033c4df>] kset_add+0xd/0xf
[ 2776.233845]  [<ffffffff8033c5a6>] kset_register+0x23/0x28
[ 2776.236309]  [<ffffffff8808ccb7>] :ocfs2_nodemanager:mlog_sys_init+0x68/0x6d
[ 2776.239518]  [<ffffffff8808ccee>] :ocfs2_nodemanager:o2cb_sys_init+0x32/0x4a
[ 2776.242726]  [<ffffffff880b80a6>] :ocfs2_nodemanager:init_o2nm+0xa6/0xd5
[ 2776.245772]  [<ffffffff8025266c>] sys_init_module+0x1471/0x15d2
[ 2776.248465]  [<ffffffff8033f250>] simple_strtoull+0x0/0xdc
[ 2776.250959]  [<ffffffff8020948e>] system_call+0x7e/0x83 

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/ocfs2/cluster/masklog.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.21-git10.orig/fs/ocfs2/cluster/masklog.c
+++ linux-2.6.21-git10/fs/ocfs2/cluster/masklog.c
@@ -144,7 +144,8 @@ static struct kobj_type mlog_ktype = {
 };
 
 static struct kset mlog_kset = {
-	.kobj   = {.name = "logmask", .ktype = &mlog_ktype},
+	.kobj  = {.name = "logmask"},
+	.ktype = &mlog_ktype
 };
 
 int mlog_sys_init(struct kset *o2cb_subsys)
@@ -157,7 +158,7 @@ int mlog_sys_init(struct kset *o2cb_subs
 	}
 	mlog_attr_ptrs[i] = NULL;
 
-	kobj_set_kset_s(&mlog_kset, o2cb_subsys);
+	kobj_set_kset_s(&mlog_kset, *o2cb_subsys);
 	return kset_register(&mlog_kset);
 }
 
