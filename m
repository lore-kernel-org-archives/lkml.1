Return-Path: <linux-kernel-owner+w=401wt.eu-S2993183AbXDSISY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993183AbXDSISY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993178AbXDSIEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:04:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45799 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993180AbXDSIEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:04:09 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Neil Brown <neilb@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: [PATCH] nfs lockd reclaimer: Convert to kthread API
Date: Thu, 19 Apr 2007 01:58:59 -0600
Message-Id: <11769696321319-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Start the reclaimer thread using kthread_run instead
of a combination of kernel_thread and daemonize.
The small amount of signal handling code is also removed
as it makes no sense and is a maintenance problem to handle
signals in kernel threads.

Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/lockd/clntlock.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
index f4d45d4..83591f6 100644
--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/time.h>
+#include <linux/kthread.h>
 #include <linux/nfs_fs.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
@@ -153,7 +154,7 @@ nlmclnt_recovery(struct nlm_host *host)
 	if (!host->h_reclaiming++) {
 		nlm_get_host(host);
 		__module_get(THIS_MODULE);
-		if (kernel_thread(reclaimer, host, CLONE_KERNEL) < 0)
+		if (IS_ERR(kthread_run(reclaimer, host, "%s-reclaim", host->h_name)))
 			module_put(THIS_MODULE);
 	}
 }
@@ -166,9 +167,6 @@ reclaimer(void *ptr)
 	struct file_lock *fl, *next;
 	u32 nsmstate;
 
-	daemonize("%s-reclaim", host->h_name);
-	allow_signal(SIGKILL);
-
 	down_write(&host->h_rwsem);
 
 	/* This one ensures that our parent doesn't terminate while the
@@ -193,8 +191,6 @@ restart:
 		list_del_init(&fl->fl_u.nfs_fl.list);
 
 		/* Why are we leaking memory here? --okir */
-		if (signalled())
-			continue;
 		if (nlmclnt_reclaim(host, fl) != 0)
 			continue;
 		list_add_tail(&fl->fl_u.nfs_fl.list, &host->h_granted);
-- 
1.5.0.g53756

