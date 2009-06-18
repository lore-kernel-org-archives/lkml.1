Return-Path: <linux-kernel-owner+w=401wt.eu-S1764214AbZFRObF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764214AbZFRObF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760875AbZFROay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:30:54 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:63994 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbZFROay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:30:54 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [git pull] vfs patches, part 1 
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090612014507.GA8633@ZenIV.linux.org.uk>
References: <20090612014507.GA8633@ZenIV.linux.org.uk>
Date: Thu, 18 Jun 2009 23:30:15 +0900
Message-ID: <8501.1245335415@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
>       Cache root in nameidata

Didn't you forget path_put() for the new member before returning in the
middle of do_filp_open()?


J. R. Okajima

----------------------------------------------------------------------
commit ccf163f67e7c4bf3890010a5a593eb62c3004a6a
Author: J. R. Okajima <hooanon05@yahoo.co.jp>
Date:   Thu Jun 18 23:26:34 2009 +0900

    vfs: nd->root in do_filp_open()
    
    commit 2a737871108de9ba8930f7650d549f1383767f8b
    "Cache root in nameidata"
    introduced a new member nd->root, but forgot to put it in
    do_filp_open().
    
    Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>

diff --git a/fs/namei.c b/fs/namei.c
index 527119a..5b961eb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1698,8 +1698,11 @@ struct file *do_filp_open(int dfd, const char *pathname,
 	if (error)
 		return ERR_PTR(error);
 	error = path_walk(pathname, &nd);
-	if (error)
+	if (error) {
+		if (nd.root.mnt)
+			path_put(&nd.root);
 		return ERR_PTR(error);
+	}
 	if (unlikely(!audit_dummy_context()))
 		audit_inode(pathname, nd.path.dentry);
 
@@ -1759,6 +1762,8 @@ do_last:
 		}
 		filp = nameidata_to_filp(&nd, open_flag);
 		mnt_drop_write(nd.path.mnt);
+		if (nd.root.mnt)
+			path_put(&nd.root);
 		return filp;
 	}
 
@@ -1819,6 +1824,8 @@ ok:
 	 */
 	if (will_write)
 		mnt_drop_write(nd.path.mnt);
+	if (nd.root.mnt)
+		path_put(&nd.root);
 	return filp;
 
 exit_mutex_unlock:
@@ -1859,6 +1866,8 @@ do_link:
 		 * with "intent.open".
 		 */
 		release_open_intent(&nd);
+		if (nd.root.mnt)
+			path_put(&nd.root);
 		return ERR_PTR(error);
 	}
 	nd.flags &= ~LOOKUP_PARENT;
