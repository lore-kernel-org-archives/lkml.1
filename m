Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZFDMsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZFDMsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbZFDMsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:48:14 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35386 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZFDMsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:48:11 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 1/2] Allow waiters to be notified about the eventfd
	file* going away, and give
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davdel@xmailserver.org,
       mst@redhat.com, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Date: Thu, 04 Jun 2009 08:48:07 -0400
Message-ID: <20090604124807.10544.6071.stgit@dev.haskins.net>
In-Reply-To: <20090604124047.10544.38861.stgit@dev.haskins.net>
References: <20090604124047.10544.38861.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>

them a change to unregister from the wait queue.  This is turn allows
eventfd users to use the eventfd file* w/out holding a live reference to
it.

After the eventfd user callbacks returns, any usage of the eventfd file*
should be dropped.  The eventfd user callback can acquire sleepy locks
since it is invoked lockless.

This is a feature, needed by KVM to avoid an awkward workaround when using
eventdf.

[gmh: pulled from -mmotm for inclusion in kvm.git]

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Tested-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 fs/eventfd.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 3f0e197..72f5f8d 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -61,7 +61,15 @@ EXPORT_SYMBOL_GPL(eventfd_signal);
 
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
 

