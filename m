Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbXERKfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbXERKfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbXERKfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:35:15 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:59059 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbXERKfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:35:13 -0400
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [patch 1/2] fuse: generic_write_checks() for direct_io
Message-Id: <E1Hozmu-0003qO-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 May 2007 12:34:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

These are for 2.6.22, please apply.

Thanks.

----
From: Miklos Szeredi <mszeredi@suse.cz>

This fixes O_APPEND in direct IO mode.  Also checks writes against
file size limits, notably rlimits.

Reported by Greg Bruno.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-04-26 12:54:32.000000000 +0200
+++ linux/fs/fuse/file.c	2007-05-02 20:17:27.000000000 +0200
@@ -609,7 +609,9 @@ static ssize_t fuse_direct_write(struct 
 	ssize_t res;
 	/* Don't allow parallel writes to the same file */
 	mutex_lock(&inode->i_mutex);
-	res = fuse_direct_io(file, buf, count, ppos, 1);
+	res = generic_write_checks(file, ppos, &count, 0);
+	if (!res)
+		res = fuse_direct_io(file, buf, count, ppos, 1);
 	mutex_unlock(&inode->i_mutex);
 	return res;
 }
