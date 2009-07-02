Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZGBPiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZGBPiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZGBPiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:38:16 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36919 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZGBPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:38:09 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v9 2/5] eventfd: use locked POLLHUP
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Date: Thu, 02 Jul 2009 11:38:06 -0400
Message-ID: <20090702153806.20186.76377.stgit@dev.haskins.net>
In-Reply-To: <20090702153454.20186.99191.stgit@dev.haskins.net>
References: <20090702153454.20186.99191.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eventfd currently emits a POLLHUP wakeup on f_ops->release() to generate a
"release" callback. This lets eventfd clients know if the eventfd is about
to go away and is very useful particularly for in-kernel clients. However,
as it stands today it is not possible to use this feature of eventfd in a
race-free way. This patch changes the POLLHUP code to use the locked variant
to rectify this problem.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Davide Libenzi <davidel@xmailserver.org>
---

 fs/eventfd.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index d9849a1..31d12de 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -105,12 +105,7 @@ static int eventfd_release(struct inode *inode, struct file *file)
 {
 	struct eventfd_ctx *ctx = file->private_data;
 
-	/*
-	 * No need to hold the lock here, since we are on the file cleanup
-	 * path and the ones still attached to the wait queue will be
-	 * serialized by wake_up_locked_poll().
-	 */
-	wake_up_locked_poll(&ctx->wqh, POLLHUP);
+	wake_up_poll(&ctx->wqh, POLLHUP);
 	eventfd_ctx_put(ctx);
 	return 0;
 }

