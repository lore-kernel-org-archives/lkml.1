Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193Ab0CMBO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:14:56 -0500
Received: from kroah.org ([198.145.64.141]:46560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935175Ab0CMAa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:26 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:05 2010
Message-Id: <20100313002705.316705521@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [001/145] fix LOOKUP_FOLLOW on automount "symlinks"
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Al Viro <viro@ZenIV.linux.org.uk>

commit ac278a9c505092dd82077a2446af8f9fc0d9c095 upstream.

Make sure that automount "symlinks" are followed regardless of LOOKUP_FOLLOW;
it should have no effect on them.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -829,6 +829,17 @@ fail:
 }
 
 /*
+ * This is a temporary kludge to deal with "automount" symlinks; proper
+ * solution is to trigger them on follow_mount(), so that do_lookup()
+ * would DTRT.  To be killed before 2.6.34-final.
+ */
+static inline int follow_on_final(struct inode *inode, unsigned lookup_flags)
+{
+	return inode && unlikely(inode->i_op->follow_link) &&
+		((lookup_flags & LOOKUP_FOLLOW) || S_ISDIR(inode->i_mode));
+}
+
+/*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
  * the final dentry. We expect 'base' to be positive and a directory.
@@ -964,8 +975,7 @@ last_component:
 		if (err)
 			break;
 		inode = next.dentry->d_inode;
-		if ((lookup_flags & LOOKUP_FOLLOW)
-		    && inode && inode->i_op->follow_link) {
+		if (follow_on_final(inode, lookup_flags)) {
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;


