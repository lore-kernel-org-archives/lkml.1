Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYBHW2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYBHW2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbYBHW0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:26:55 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55040 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774AbYBHW0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:26:53 -0500
Subject: [RFC][PATCH 03/30] check for null vfsmount in dentry_open()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:26:45 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222645.EE1914E8@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make sure no-one calls dentry_open with a NULL vfsmount argument and crap
out with a stacktrace otherwise.  A NULL file->f_vfsmnt has always been
problematic, but with the per-mount r/o tracking we can't accept anymore
at all.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/open.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/open.c~check-for-NULL-vfsmount-in-dentry-open fs/open.c
--- linux-2.6.git/fs/open.c~check-for-NULL-vfsmount-in-dentry-open	2008-02-08 13:04:45.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-08 13:04:45.000000000 -0800
@@ -906,6 +906,18 @@ struct file *dentry_open(struct dentry *
 	int error;
 	struct file *f;
 
+	/*
+	 * We must always pass in a valid mount pointer.   Historically
+	 * callers got away with not passing it, but we must enforce this at
+	 * the earliest possible point now to avoid strange problems deep in the
+	 * filesystem stack.
+	 */
+	if (!mnt) {
+		printk(KERN_WARNING "%s called with NULL vfsmount\n", __func__);
+		dump_stack();
+		return ERR_PTR(-EINVAL);
+	}
+
 	error = -ENFILE;
 	f = get_empty_filp();
 	if (f == NULL) {
_
