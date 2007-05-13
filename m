Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbXEMTmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbXEMTmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757725AbXEMTmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:42:03 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3164 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294AbXEMTmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:42:01 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 13 May 2007 12:42:00 -0700
Subject: [patch 1/1] epoll move kfree inside ep_free ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.4954.1179085320.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the kfree() call inside the ep_free() function.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-git17.epmod/fs/eventpoll.c
===================================================================
--- linux-2.6.21-git17.epmod.orig/fs/eventpoll.c	2007-05-13 12:39:09.000000000 -0700
+++ linux-2.6.21-git17.epmod/fs/eventpoll.c	2007-05-13 12:40:04.000000000 -0700
@@ -469,18 +469,16 @@
 	}
 
 	mutex_unlock(&epmutex);
-
 	mutex_destroy(&ep->mtx);
+	kfree(ep);
 }
 
 static int ep_eventpoll_release(struct inode *inode, struct file *file)
 {
 	struct eventpoll *ep = file->private_data;
 
-	if (ep) {
+	if (ep)
 		ep_free(ep);
-		kfree(ep);
-	}
 
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: close() ep=%p\n", current, ep));
 	return 0;
@@ -1107,7 +1105,6 @@
 
 error_free:
 	ep_free(ep);
-	kfree(ep);
 error_return:
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
 		     current, size, error));

