Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZGACsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZGACsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZGACsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:48:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53070 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbZGACsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:48:08 -0400
Date: Tue, 30 Jun 2009 22:48:03 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, nhorman@tuxdriver.com
Subject: [PATCH] kmod: Fix race in usermodehelper code
Message-ID: <20090701024803.GA19659@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User Mode Helper: Fix race in UMH_WAIT_EXEC case

The user mode helper code has a race in it.  call_usermodehelper_exec takes an
allocated subprocess_info structure, which it passes to a workqueue, and then
passes it to a kernel thread which it creates, after which it calls complete to
signal to the caller of call_usremodehelper_exec that it can free the
subprocess_info struct.  But since we use that structure in the created thread,
we can't call complete from __call_usermodehelper, which is where we create the
kernel_thread.  We need to call complete from within the kernel thread and then
not use subprocess_info afterward in the case of UMH_WAIT_EXEC.  Tested
successfully by me.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 7e95bed..afff87a 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -136,6 +136,7 @@ struct subprocess_info {
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
+	enum umh_wait wait = sub_info->wait;
 	int retval;
 
 	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
@@ -177,10 +178,14 @@ static int ____call_usermodehelper(void *data)
 	 */
 	set_user_nice(current, 0);
 
+	if (wait == UMH_WAIT_EXEC)
+		complete(sub_info->complete);
+
 	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
-	sub_info->retval = retval;
+	if (wait != UMH_WAIT_EXEC)
+		sub_info->retval = retval;
 	do_exit(0);
 }
 
@@ -259,16 +264,14 @@ static void __call_usermodehelper(struct work_struct *work)
 
 	switch (wait) {
 	case UMH_NO_WAIT:
+	case UMH_WAIT_EXEC:
 		break;
 
 	case UMH_WAIT_PROC:
 		if (pid > 0)
 			break;
 		sub_info->retval = pid;
-		/* FALLTHROUGH */
-
-	case UMH_WAIT_EXEC:
-		complete(sub_info->complete);
+		break;
 	}
 }
 
