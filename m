Return-Path: <linux-kernel-owner+w=401wt.eu-S1423365AbXBIW6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423365AbXBIW6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423376AbXBIWyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:14 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42501 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423375AbXBIWxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:47 -0500
Subject: [PATCH 19/22] elevate writer count for custom struct_file
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:43 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225343.E53763C0@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Some filesystems forego the use of normal vfs calls to create
struct files.  Make sure that these users elevate the mnt writer
count.  These probably don't have any real meaning because there
is no real backing store for these mounts, but it is here for
consistency.


Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/file_table.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/file_table.c~22-24-elevate-writer-count-for-custom-struct-file fs/file_table.c
--- lxc/fs/file_table.c~22-24-elevate-writer-count-for-custom-struct-file	2007-02-09 14:26:59.000000000 -0800
+++ lxc-dave/fs/file_table.c	2007-02-09 14:26:59.000000000 -0800
@@ -171,6 +171,10 @@ int init_file(struct file *file, struct 
 	file->f_mapping = dentry->d_inode->i_mapping;
 	file->f_mode = mode;
 	file->f_op = fop;
+	if (mode & FMODE_WRITE) {
+		error = mnt_want_write(mnt);
+		WARN_ON(error);
+	}
 	return error;
 }
 
_
