Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbXBOEXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbXBOEXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 23:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932653AbXBOEXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 23:23:00 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58503 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932616AbXBOEXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 23:23:00 -0500
X-Sasl-enc: /QM2JFsDUNrkk7lmy+fJGdsL9vvKL02Q/ha6z2Mx4QGI 1171513376
Date: Thu, 15 Feb 2007 13:23:40 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@osdl.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>
Subject: [PATCH 2/2] autofs4 - check for directory re-create in lookup 
Message-ID: <Pine.LNX.4.64.0702151316110.8001@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

This problem was identified and fixed some time ago by Jeff Moyer
but it fell through the cracks somehow.

It is possible that a user space application could remove and
re-create a directory during a request. To avoid returning a
failure from lookup incorrectly when our current dentry is
unhashed we need to check if another positive, hashed dentry
matching this one exists and if so return it instead of a fail.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Ian Kent <raven@themaw.net>

Ian

---

--- linux-2.6.20/fs/autofs4/root.c.lookup-check-unhased	2007-02-12 13:49:46.000000000 +0900
+++ linux-2.6.20/fs/autofs4/root.c	2007-02-12 13:54:58.000000000 +0900
@@ -655,14 +655,29 @@ static struct dentry *autofs4_lookup(str
 
 	/*
 	 * If this dentry is unhashed, then we shouldn't honour this
-	 * lookup even if the dentry is positive.  Returning ENOENT here
-	 * doesn't do the right thing for all system calls, but it should
-	 * be OK for the operations we permit from an autofs.
+	 * lookup.  Returning ENOENT here doesn't do the right thing
+	 * for all system calls, but it should be OK for the operations
+	 * we permit from an autofs.
 	 */
 	if (dentry->d_inode && d_unhashed(dentry)) {
+		/*
+		 * A user space application can (and has done in the past)
+		 * remove and re-create this directory during the callback.
+		 * This can leave us with an unhashed dentry, but a
+		 * successful mount!  So we need to perform another
+		 * cached lookup in case the dentry now exists.
+		 */
+		struct dentry *parent = dentry->d_parent;
+		struct dentry *new = d_lookup(parent, &dentry->d_name);
+		if (new != NULL)
+			dentry = new;
+		else
+			dentry = ERR_PTR(-ENOENT);
+
 		if (unhashed)
 			dput(unhashed);
-		return ERR_PTR(-ENOENT);
+
+		return dentry;
 	}
 
 	if (unhashed)
