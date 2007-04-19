Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXDSIOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXDSIOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXDSIOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:14:33 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33963 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbXDSIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:14:21 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] macintosh/mediabay: Convert to kthread API.
Date: Thu, 19 Apr 2007 01:58:50 -0600
Message-Id: <11769695954018-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the startup of the media_bay_task
to use kthread_run and not a combination of kernel_thread,
deamonize and sigfillset.

In addition since we now always want to ignore signals
the MB_IGNORE_SIGNALS define is removed along with the
test for signal_pending.

The result is slightly simpler code that is more
maintainable.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/macintosh/mediabay.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index c803d2b..90c853e 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -20,6 +20,7 @@
 #include <linux/stddef.h>
 #include <linux/init.h>
 #include <linux/ide.h>
+#include <linux/kthread.h>
 #include <asm/prom.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -35,7 +36,6 @@
 
 
 #define MB_DEBUG
-#define MB_IGNORE_SIGNALS
 
 #ifdef MB_DEBUG
 #define MBDBG(fmt, arg...)	printk(KERN_INFO fmt , ## arg)
@@ -622,11 +622,6 @@ static int media_bay_task(void *x)
 {
 	int	i;
 
-	strcpy(current->comm, "media-bay");
-#ifdef MB_IGNORE_SIGNALS
-	sigfillset(&current->blocked);
-#endif
-
 	for (;;) {
 		for (i = 0; i < media_bay_count; ++i) {
 			down(&media_bays[i].lock);
@@ -636,8 +631,6 @@ static int media_bay_task(void *x)
 		}
 
 		msleep_interruptible(MB_POLL_DELAY);
-		if (signal_pending(current))
-			return 0;
 	}
 }
 
@@ -699,7 +692,7 @@ static int __devinit media_bay_attach(struct macio_dev *mdev, const struct of_de
 
 	/* Startup kernel thread */
 	if (i == 0)
-		kernel_thread(media_bay_task, NULL, CLONE_KERNEL);
+		kthread_run(media_bay_task, NULL, "media-bay");
 
 	return 0;
 
-- 
1.5.0.g53756

