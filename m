Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbXHCRxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbXHCRxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764601AbXHCRu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:50:29 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:52174 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763547AbXHCRu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:50:27 -0400
Message-Id: <20070803175003.754698659@szeredi.hu>
References: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 11/11] fuse: no ENOENT from fuse device read
Content-Disposition: inline; filename=fuse_read_no_enoent.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Don't return -ENOENT for a read() on the fuse device when the request
was aborted.  Instead return -ENODEV, meaning the filesystem has been
force-umounted or aborted.

Previously ENOENT meant that the request was interrupted, but now the
'aborted' flag is not set in case of interrupts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dev.c
===================================================================
--- linux.orig/fs/fuse/dev.c	2007-08-03 18:40:17.000000000 +0200
+++ linux/fs/fuse/dev.c	2007-08-03 18:40:17.000000000 +0200
@@ -747,11 +747,12 @@ static ssize_t fuse_dev_read(struct kioc
 	fuse_copy_finish(&cs);
 	spin_lock(&fc->lock);
 	req->locked = 0;
-	if (!err && req->aborted)
-		err = -ENOENT;
+	if (req->aborted) {
+		request_end(fc, req);
+		return -ENODEV;
+	}
 	if (err) {
-		if (!req->aborted)
-			req->out.h.error = -EIO;
+		req->out.h.error = -EIO;
 		request_end(fc, req);
 		return err;
 	}

--
