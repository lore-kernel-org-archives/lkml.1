Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbZH0JFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbZH0JFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZH0JFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:05:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZH0JFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:05:42 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Date: Thu, 27 Aug 2009 11:05:30 +0200
Message-Id: <1251363930-3916-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com>
References: <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, so why not using the eventfd counter as state?
> On the device side:
> 
> void write_state(int sfd, int state) {
> 	u64 cnt;
> 
> 	/* Clear the current state, sfd is in non-blocking mode */
> 	read(sfd,&cnt, sizeof(cnt));
> 	/* Writes new state */
> 	cnt = 1 + !!state;
> 	write(sfd,&cnt, sizeof(cnt));
> }

It's interesting [no sarcasm intended, mind] that EFD_SEMAPHORE was
added exactly to avoid a read+write combination for the case of
decrementing a value.  Here it's the same, just it's about the case of
writing a *given* value.  What about having EFD_STATE simply mean "do
not use a counter, just write the value" without affecting the way
read works, and use

	/* Writes new state */
	cnt = 1 + !!state;
	write(sfd,&cnt, sizeof(cnt));

See below?

Paolo

> On the hypervisor side:
> 
> int read_state(int sfd) {
> 	u64 cnt;
> 
> 	read(sfd,&cnt, sizeof(cnt));
> 	return state - 1;
> }


------------- 8<-- ---------------
Subject: [PATCH] eventfd: new EFD_ABSOLUTE flag

This implements a new EFD_ABSOLUTE flag for eventfd.
This changes eventfd behaviour so that write simply
stores the value written, and is always non-blocking.

Untested (I just modified Michael's patch, and given
the simpler code I'm not sure it's now worthwhile
introducing the inline functions), but otherwise

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 fs/eventfd.c            |   13 ++++++++-----
 include/linux/eventfd.h |    4 ++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 347a0e0..7b279e3 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -31,8 +31,6 @@
 
 static inline int eventfd_writeable(struct eventfd_ctx *ctx, u64 n)
 {
-	return ULLONG_MAX - n > ctx->count;
-	return (ctx->flags & EFD_ABSOLUTE) || (ULLONG_MAX - n > ctx->count);
 }
 
 static inline int eventfd_overflow(struct eventfd_ctx *ctx, u64 cnt)
@@ -42,10 +40,14 @@
 
 static inline void eventfd_dowrite(struct eventfd_ctx *ctx, u64 ucnt)
 {
-	if (eventfd_writeable(ctx, ucnt))
-		ucnt = ULLONG_MAX - ctx->count;
+	if (ctx->flags & EFD_ABSOLUTE)
+		ctx->count = ucnt;
+	else {
+		if (ULLONG_MAX - ctx->count < ucnt)
+			ucnt = ULLONG_MAX - ctx->count;
 
-	ctx->count += ucnt;
+		ctx->count += ucnt;
+	}
 }
 
 static inline u64 eventfd_doread(struct eventfd_ctx *ctx)
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 3b85ba6..78ff649 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -19,11 +19,12 @@
  * shared O_* flags.
  */
 #define EFD_SEMAPHORE (1 << 0)
+#define EFD_ABSOLUTE (1 << 1)
 #define EFD_CLOEXEC O_CLOEXEC
 #define EFD_NONBLOCK O_NONBLOCK
 
 #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
-#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
+#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE | EFD_ABSOLUTE)
 
 #ifdef CONFIG_EVENTFD
--
1.6.2.5 
