Return-Path: <linux-kernel-owner+w=401wt.eu-S1423478AbXD3PuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423478AbXD3PuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423480AbXD3PuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:50:19 -0400
Received: from mail.suse.de ([195.135.220.2]:45086 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423483AbXD3PuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:08 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: ebiederm@xmission.com, James.Bottomley@steeleye.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [30/34] i386: convert the monitor thread to use the kthread API
Message-Id: <20070430155003.ABE6663AC@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:50:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Eric W. Biederman <ebiederm@xmission.com>

This patch just trivially replaces kernel_thread and daemonize with a
single call to kthread_run.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-voyager/voyager_thread.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/arch/i386/mach-voyager/voyager_thread.c
===================================================================
--- linux.orig/arch/i386/mach-voyager/voyager_thread.c
+++ linux/arch/i386/mach-voyager/voyager_thread.c
@@ -24,6 +24,7 @@
 #include <linux/kmod.h>
 #include <linux/completion.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 #include <asm/desc.h>
 #include <asm/voyager.h>
 #include <asm/vic.h>
@@ -44,7 +45,7 @@ static __u8 set_timeout = 0;
 static int __init
 voyager_thread_start(void)
 {
-	if(kernel_thread(thread, NULL, CLONE_KERNEL) < 0) {
+	if (IS_ERR(kthread_run(thread, NULL, "%s", THREAD_NAME))) {
 		/* This is serious, but not fatal */
 		printk(KERN_ERR "Voyager: Failed to create system monitor thread!!!\n");
 		return 1;
@@ -123,8 +124,6 @@ thread(void *unused)
 
 	kvoyagerd_running = 1;
 
-	daemonize(THREAD_NAME);
-
 	set_timeout = 0;
 
 	init_timer(&wakeup_timer);
