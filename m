Return-Path: <linux-kernel-owner+w=401wt.eu-S2993141AbXDSHKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993141AbXDSHKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993155AbXDSHKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:10:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36467 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993154AbXDSHI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:08:28 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] powerpc pseries rtasd: Convert to kthread API.
Date: Thu, 19 Apr 2007 00:55:41 -0600
Message-Id: <11769657861912-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

This patch modifies the startup of rtasd to use kthread_run instaed of
a combination of kernel_thread and daemonize.  Making the code a little
simpler and more maintainble.

Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/powerpc/platforms/pseries/rtasd.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platforms/pseries/rtasd.c
index 77d0937..919a374 100644
--- a/arch/powerpc/platforms/pseries/rtasd.c
+++ b/arch/powerpc/platforms/pseries/rtasd.c
@@ -20,6 +20,7 @@
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -429,8 +430,6 @@ static int rtasd(void *unused)
 	int event_scan = rtas_token("event-scan");
 	int rc;
 
-	daemonize("rtasd");
-
 	if (event_scan == RTAS_UNKNOWN_SERVICE || get_eventscan_parms() == -1)
 		goto error;
 
@@ -497,7 +496,7 @@ static int __init rtas_init(void)
 	else
 		printk(KERN_ERR "Failed to create error_log proc entry\n");
 
-	if (kernel_thread(rtasd, NULL, CLONE_FS) < 0)
+	if (IS_ERR(kthread_run(rtasd, NULL, "rtasd")))
 		printk(KERN_ERR "Failed to start RTAS daemon\n");
 
 	return 0;
-- 
1.5.0.g53756

