Return-Path: <linux-kernel-owner+w=401wt.eu-S1763759AbYBOWll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763759AbYBOWll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763914AbYBOWhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:42 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48733 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762534AbYBOWhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:38 -0500
Subject: [PATCH 03/30] check for null vfsmount in dentry_open()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:24 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223724.D5C70940@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make sure no-one calls dentry_open with a NULL vfsmount argument and crap
out with a stacktrace otherwise.  A NULL file->f_vfsmnt has always been
problematic, but with the per-mount r/o tracking we can't accept anymore
at all.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/open.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/open.c~check-for-NULL-vfsmount-in-dentry-open fs/open.c
--- linux-2.6.git/fs/open.c~check-for-NULL-vfsmount-in-dentry-open	2008-02-15 13:25:42.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-15 13:25:42.000000000 -0800
@@ -903,6 +903,18 @@ struct file *dentry_open(struct dentry *
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
