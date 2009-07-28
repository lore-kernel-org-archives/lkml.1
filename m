Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZG1R4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZG1R4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZG1R4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:56:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35650 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbZG1R4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:56:39 -0400
Date: Tue, 28 Jul 2009 20:55:38 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: davidel@xmailserver.org, avi@redhat.com, gleb@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH-RFC 2/2] eventfd: EFD_STATE flag
Message-ID: <20090728175538.GC21549@redhat.com>
References: <cover.1248803500.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1248803500.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a new EFD_STATE flag for eventfd.
When set, this flag changes eventfd behaviour in the following way:
- write simply stores the value written, and is always non-blocking
- read unblocks when the value written changes, and
  returns the value written

Motivation: we'd like to use eventfd in qemu to pass interrupts from
(emulated or assigned) devices to guest. For level interrupts, the
counter supported currently by eventfd is not a good match: we really
need to set interrupt to a level, typically 0 or 1, and give the guest
ability to see the last value written.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 fs/eventfd.c            |   41 ++++++++++++++++++++++++++++++++++-------
 include/linux/eventfd.h |    3 ++-
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 347a0e0..7b279e3 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -31,37 +31,59 @@ struct eventfd_ctx {
 	 * issue a wakeup.
 	 */
 	__u64 count;
+	/*
+	 * When EF_STATE flag is set, eventfd behaves differently:
+	 * value written gets stored in "count", read will copy
+	 * "count" to "state".
+	 */
+	__u64 state;
 	unsigned int flags;
 };
 
 
 static inline int eventfd_readable(struct eventfd_ctx *ctx)
 {
-	return ctx->count > 0;
+	if (ctx->flags & EFD_STATE)
+		return ctx->state != ctx->count;
+	else
+		return ctx->count > 0;
 }
 
 static inline int eventfd_writeable(struct eventfd_ctx *ctx, u64 n)
 {
-	return ULLONG_MAX - n > ctx->count;
+	if (ctx->flags & EFD_STATE)
+		return 1;
+	else
+		return ULLONG_MAX - n > ctx->count;
 }
 
 static inline int eventfd_overflow(struct eventfd_ctx *ctx, u64 cnt)
 {
-	return cnt == ULLONG_MAX;
+	if (ctx->flags & EFD_STATE)
+		return 0;
+	else
+		return cnt == ULLONG_MAX;
 }
 
 static inline void eventfd_dowrite(struct eventfd_ctx *ctx, u64 ucnt)
 {
-	if (eventfd_writeable(ctx, ucnt))
-		ucnt = ULLONG_MAX - ctx->count;
+	if (ctx->flags & EFD_STATE)
+		ctx->count = ucnt;
+	else {
+		if (ULLONG_MAX - ctx->count < ucnt)
+			ucnt = ULLONG_MAX - ctx->count;
 
-	ctx->count += ucnt;
+		ctx->count += ucnt;
+	}
 }
 
 static inline u64 eventfd_doread(struct eventfd_ctx *ctx)
 {
 	u64 ucnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
-	ctx->count -= ucnt;
+	if (ctx->flags & EFD_STATE)
+		ctx->state = ucnt;
+	else
+		ctx->count -= ucnt;
 	return ucnt;
 }
 
@@ -337,6 +359,10 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 
 	if (flags & ~EFD_FLAGS_SET)
 		return -EINVAL;
+	/* State together with semaphore does not make sense. */
+	if ((flags & EFD_STATE) && (flags & EFD_SEMAPHORE))
+		return -EINVAL;
+
 
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -344,6 +370,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 
 	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
+	ctx->state = count;
 	ctx->count = count;
 	ctx->flags = flags;
 
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 3b85ba6..78ff649 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -19,11 +19,12 @@
  * shared O_* flags.
  */
 #define EFD_SEMAPHORE (1 << 0)
+#define EFD_STATE (1 << 1)
 #define EFD_CLOEXEC O_CLOEXEC
 #define EFD_NONBLOCK O_NONBLOCK
 
 #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
-#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
+#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE | EFD_STATE)
 
 #ifdef CONFIG_EVENTFD
 
-- 
1.6.2.5
