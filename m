Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYECT3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYECT3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYECT2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:28:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYECT2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:28:49 -0400
Date: Sat, 3 May 2008 15:28:45 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805031928.m43JSjRC001739@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] tiny mq_open optimization
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A very small cleanup for mq_open.  We do not have to call set_close_on_exit
if we create the file descriptor right away with the flag set.  We have a
function for this now.  The resulting code is smaller and a tiny bit faster.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 94fd3b0..b3b69fd 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -673,7 +673,7 @@ asmlinkage long sys_mq_open(const char __user *u_name, int oflag, mode_t mode,
 	if (IS_ERR(name = getname(u_name)))
 		return PTR_ERR(name);
 
-	fd = get_unused_fd();
+	fd = get_unused_fd_flags(O_CLOEXEC);
 	if (fd < 0)
 		goto out_putname;
 
@@ -709,7 +709,6 @@ asmlinkage long sys_mq_open(const char __user *u_name, int oflag, mode_t mode,
 		goto out_putfd;
 	}
 
-	set_close_on_exec(fd, 1);
 	fd_install(fd, filp);
 	goto out_upsem;
 
