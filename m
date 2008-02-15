Return-Path: <linux-kernel-owner+w=401wt.eu-S1765596AbYBOKYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765596AbYBOKYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYBOKXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:23:54 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34093 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbYBOKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:23:53 -0500
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [patch] fuse: fix permission checking
Message-Id: <E1JPxjP-0004sQ-5O@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 15 Feb 2008 11:23:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for 2.6.25 and 2.6.24.y, but NOT for 2.6.23.y.

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@suse.cz>

I added a nasty local variable shadowing bug to fuse in 2.6.24, with
the result, that the 'default_permissions' mount option is basically
ignored.

How did this happen?

 - old err declaration in inner scope
 - new err getting declared in outer scope
 - 'return err' from inner scope getting removed
 - old declaration not being noticed

-Wshadow would have saved us, but it doesn't seem practical for
the kernel :(

More testing would have also saved us :((

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2008-02-15 10:46:06.000000000 +0100
+++ linux/fs/fuse/dir.c	2008-02-15 11:05:46.000000000 +0100
@@ -906,7 +906,7 @@ static int fuse_permission(struct inode 
 	}
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
-		int err = generic_permission(inode, mask, NULL);
+		err = generic_permission(inode, mask, NULL);
 
 		/* If permission is denied, try to refresh file
 		   attributes.  This is also needed, because the root
