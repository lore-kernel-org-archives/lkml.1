Return-Path: <linux-kernel-owner+w=401wt.eu-S1750967AbXC0JDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbXC0JDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 05:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXC0JDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 05:03:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXC0JDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 05:03:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=I83z2265x/UIYaQ5YwM+5KeYm3a1SeBJkWv+uIbjaC1Zh2wSdSAjN75rTnVD/JJUL
	pG0oNrIhW/95nc1I0+ghA==
Date: Tue, 27 Mar 2007 02:03:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: [patch] usb: call bdev_read_only() only on CONFIG_BLOCK
Message-ID: <Pine.LNX.4.64.0703270201410.10410@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bdev_read_only() is only defined on CONFIG_BLOCK so we make sure not to
call it unless we have it.  A new static inline function,
is_inode_read_only(), is invoked to call bdev_read_only() on CONFIG_BLOCK
and return zero otherwise.

Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/usb/gadget/file_storage.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3493,6 +3493,14 @@ static int fsg_main_thread(void *fsg_)
 	complete_and_exit(&fsg->thread_notifier, 0);
 }
 
+#ifdef CONFIG_BLOCK
+static inline int is_inode_read_only(struct inode *inode)
+{
+	return bdev_read_only(inode->i_bdev);
+}
+#else
+#define is_inode_read_only(inode)	(0)
+#endif
 
 /*-------------------------------------------------------------------------*/
 
@@ -3528,7 +3536,7 @@ static int open_backing_file(struct lun *curlun, const char *filename)
 	if (filp->f_path.dentry)
 		inode = filp->f_path.dentry->d_inode;
 	if (inode && S_ISBLK(inode->i_mode)) {
-		if (bdev_read_only(inode->i_bdev))
+		if (is_inode_read_only(inode))
 			ro = 1;
 	} else if (!inode || !S_ISREG(inode->i_mode)) {
 		LINFO(curlun, "invalid file type: %s\n", filename);
