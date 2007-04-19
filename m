Return-Path: <linux-kernel-owner+w=401wt.eu-S2993148AbXDSHI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993148AbXDSHI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993151AbXDSHIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:08:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46307 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161274AbXDSHAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:00:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] bluetooth cmtp: Convert to use kthread API.
Date: Thu, 19 Apr 2007 00:55:47 -0600
Message-Id: <11769658013589-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

This patch modifies the kcmptd_ctr_%d daemon using kthread_run
instead of a combination of kernel_thread and daemonize making
the code a little simpler and more maintainable.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/bluetooth/cmtp/core.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index e1b9db9..993303f 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -35,6 +35,7 @@
 #include <linux/file.h>
 #include <linux/init.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 #include <net/sock.h>
 
 #include <linux/isdn/capilli.h>
@@ -286,7 +287,6 @@ static int cmtp_session(void *arg)
 
 	BT_DBG("session %p", session);
 
-	daemonize("kcmtpd_ctr_%d", session->num);
 	set_user_nice(current, -15);
 
 	init_waitqueue_entry(&wait, current);
@@ -329,6 +329,7 @@ static int cmtp_session(void *arg)
 int cmtp_add_connection(struct cmtp_connadd_req *req, struct socket *sock)
 {
 	struct cmtp_session *session, *s;
+	struct task_struct *task;
 	bdaddr_t src, dst;
 	int i, err;
 
@@ -375,8 +376,9 @@ int cmtp_add_connection(struct cmtp_connadd_req *req, struct socket *sock)
 
 	__cmtp_link_session(session);
 
-	err = kernel_thread(cmtp_session, session, CLONE_KERNEL);
-	if (err < 0)
+	task = kthread_run(cmtp_session, session, "kcmtpd_ctr_%d", session->num);
+	err = PTR_ERR(task);
+	if (IS_ERR(task))
 		goto unlink;
 
 	if (!(session->flags & (1 << CMTP_LOOPBACK))) {
-- 
1.5.0.g53756

