Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYGRClA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYGRClA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbYGRCku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:40:50 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:9306
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360AbYGRCks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:40:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACaff0jLO9AP/2dsb2JhbACveQ
X-IronPort-AV: E=Sophos;i="4.31,207,1215360000"; 
   d="scan'208";a="358809616"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 1/7] autofs4 - indirect dentry must almost always be positive
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Jul 2008 10:36:53 +0800
Message-ID: <20080718023651.12802.59107.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been seeing mount requests comming to the automount daemon
for keys of the form "<map key>/<non key directory>" which are
lookups for invalid map keys. But we can check for this in the
kernel module and return a fail immediately, without having to
send a request to the daemon.

It is possible to recognise these requests are invalid based on
whether the request dentry is negative and its relation to the
autofs file system root.

For example, given the indirect multi-mount map entry:

idm1  \
    /mm1  <server>:/<path1>
    /mm2  <server>:/<path2>

For a request to mount idm1, IS_ROOT((idm1)->d_parent) will be
always be true and the dentry may be negative. But directories
idm1/mm1 and idm1/mm2 will always be created as part of the
mount request for idm1. So any mount request within idm1 itself
must have a positive dentry otherwise the map key is invalid.

In version 4 these multi-mount entries are all mounted and umounted
as a single request and in version 5 the directories idm1/mm1 and
idm1/mm2 are created and an autofs fs mounted on them to act as a
mount trigger so the above is also true.

This also holds true for the autofs version 4 pseudo direct mount
feature. When this feature is used without the "--ghost" option
automount(8) will create internal submounts as we go down the
map key paths which are essentially normal indirect mounts for
which the above holds. If the "--ghost" option is given the
directories for map keys are created at daemon startup so valid
map entries correspond to postive dentries in the autofs fs.

autofs version 5 direct mount maps are similar except that the
IS_ROOT check is not needed. This has been addressed in a previous
patch tittled "autofs4 - detect invalid direct mount requests".

For example, given the direct multi-mount map entry:

/test/dm1  \
    /mm1  <server>:/<path1>
    /mm2  <server>:/<path2>

An autofs fs is mounted on /test/dm1 as a trigger mount and when
a mount is triggered for /test/dm1, the multi-mount offset
directories /test/dm1/mm1 and /test/dm1/mm2 are created and an
autofs fs is mounted on them to act as mount triggers. So valid
direct mount requests must always have a positive dentry if they
correspond to a valid map entry.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/waitq.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index bcb6c52..35216d1 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -328,9 +328,20 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 	if (sbi->catatonic)
 		return -ENOENT;
 
-	if (!dentry->d_inode &&
-	    (sbi->type & (AUTOFS_TYPE_DIRECT | AUTOFS_TYPE_OFFSET)))
-		return -ENOENT;
+	if (!dentry->d_inode) {
+		/*
+		 * A wait for a negative dentry is invalid for certain
+		 * cases. A direct or offset mount "always" has its mount
+		 * point directory created and so the request dentry must
+		 * be positive or the map key doesn't exist. The situation
+		 * is very similar for indirect mounts except only dentrys
+		 * in the root of the autofs file system may be negative.
+		 */
+		if (sbi->type & (AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET))
+			return -ENOENT;
+		else if (!IS_ROOT(dentry->d_parent))
+			return -ENOENT;
+	}
 
 	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!name)
