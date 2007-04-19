Return-Path: <linux-kernel-owner+w=401wt.eu-S2993165AbXDSICP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993165AbXDSICP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993169AbXDSICP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:02:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45717 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993165AbXDSICL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:02:11 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] i386 voyager: Convert the monitor thread to use the kthread API
Date: Thu, 19 Apr 2007 01:58:32 -0600
Message-Id: <11769695543419-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patch just trivially replaces kernel_thread and daemonize
with a single call to kthread_run.

CC: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/mach-voyager/voyager_thread.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/i386/mach-voyager/voyager_thread.c b/arch/i386/mach-voyager/voyager_thread.c
index ebfd913..ee23d9b 100644
--- a/arch/i386/mach-voyager/voyager_thread.c
+++ b/arch/i386/mach-voyager/voyager_thread.c
@@ -23,6 +23,7 @@
 #include <linux/kmod.h>
 #include <linux/completion.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 #include <asm/desc.h>
 #include <asm/voyager.h>
 #include <asm/vic.h>
@@ -43,7 +44,7 @@ static __u8 set_timeout = 0;
 static int __init
 voyager_thread_start(void)
 {
-	if(kernel_thread(thread, NULL, CLONE_KERNEL) < 0) {
+	if (IS_ERR(kthread_run(thread, NULL, "%s", THREAD_NAME))) {
 		/* This is serious, but not fatal */
 		printk(KERN_ERR "Voyager: Failed to create system monitor thread!!!\n");
 		return 1;
@@ -122,8 +123,6 @@ thread(void *unused)
 
 	kvoyagerd_running = 1;
 
-	daemonize(THREAD_NAME);
-
 	set_timeout = 0;
 
 	init_timer(&wakeup_timer);
-- 
1.5.0.g53756

