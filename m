Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZFCTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZFCTGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZFCTG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:06:27 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:55784 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZFCTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:06:26 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 3 Jun 2009 12:00:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: [patch] epoll - send POLLHUP on ->release
Message-ID: <alpine.DEB.1.10.0906031153471.18001@makko.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch allows waiters to be notified about the eventfd file* 
going away, and give them a change to unregister from the wait queue.
This is turn allows eventfd users to use the eventfd file* w/out 
holding a live reference to it.
After the eventfd user callbacks returns, any usage of the eventfd file* 
should be dropped. The eventfd user callback can acquire sleepy locks 
since it is invoked lockless.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventfd.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-05-27 12:10:03.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-05-27 12:16:57.000000000 -0700
@@ -59,7 +59,15 @@ int eventfd_signal(struct file *file, in
 
 static int eventfd_release(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
+	struct eventfd_ctx *ctx = file->private_data;
+
+	/*
+	 * No need to hold the lock here, since we are on the file cleanup
+	 * path and the ones still attached to the wait queue will be
+	 * serialized by wake_up_locked_poll().
+	 */
+	wake_up_locked_poll(&ctx->wqh, POLLHUP);
+	kfree(ctx);
 	return 0;
 }
 
