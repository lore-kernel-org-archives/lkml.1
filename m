Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZFSSwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZFSSwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZFSSvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:51:36 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38425 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZFSSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:51:33 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/3] eventfd: Allow waiters to be notified about the eventfd
	file* going away
To: davidel@xmailserver.org
Cc: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Date: Fri, 19 Jun 2009 14:51:27 -0400
Message-ID: <20090619185127.31118.2893.stgit@dev.haskins.net>
In-Reply-To: <20090619183534.31118.30934.stgit@dev.haskins.net>
References: <20090619183534.31118.30934.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>

And give them a change to unregister from the wait queue.

This is turn allows eventfd users to use the eventfd file* w/out holding a
live reference to it.

After the eventfd user callbacks returns, any usage of the eventfd file*
should be dropped.  The eventfd user callback can acquire sleepy locks
since it is invoked lockless.

This is a feature, needed by KVM to avoid an awkward workaround when using
eventfd.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Tested-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---

 fs/eventfd.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 2a701d5..c71f51d 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -59,7 +59,15 @@ int eventfd_signal(struct file *file, int n)
 
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
 

