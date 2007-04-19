Return-Path: <linux-kernel-owner+w=401wt.eu-S1161327AbXDSHBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161327AbXDSHBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161095AbXDSHBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:01:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46326 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161337AbXDSHAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:00:35 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] bluetooth hidp: Convert to kthread API.
Date: Thu, 19 Apr 2007 00:55:48 -0600
Message-Id: <1176965803335-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

This patch starts up khidp using kthread_run instead
of kernel_thread and daemonize, resulting is slightly
simpler and more maintainable code.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/bluetooth/hidp/core.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index df2c471..1c9b202 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -36,6 +36,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 #include <net/sock.h>
 
 #include <linux/input.h>
@@ -531,22 +532,11 @@ static int hidp_session(void *arg)
 	struct sock *ctrl_sk = session->ctrl_sock->sk;
 	struct sock *intr_sk = session->intr_sock->sk;
 	struct sk_buff *skb;
-	int vendor = 0x0000, product = 0x0000;
 	wait_queue_t ctrl_wait, intr_wait;
 
 	BT_DBG("session %p", session);
 
-	if (session->input) {
-		vendor  = session->input->id.vendor;
-		product = session->input->id.product;
-	}
-
-	if (session->hid) {
-		vendor  = session->hid->vendor;
-		product = session->hid->product;
-	}
 
-	daemonize("khidpd_%04x%04x", vendor, product);
 	set_user_nice(current, -15);
 
 	init_waitqueue_entry(&ctrl_wait, current);
@@ -747,7 +737,9 @@ static inline void hidp_setup_hid(struct hidp_session *session, struct hidp_conn
 
 int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
 {
+	int vendor = 0x0000, product = 0x0000;
 	struct hidp_session *session, *s;
+	struct task_struct *task;
 	int err;
 
 	BT_DBG("");
@@ -834,8 +826,19 @@ int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock,
 
 	hidp_set_timer(session);
 
-	err = kernel_thread(hidp_session, session, CLONE_KERNEL);
-	if (err < 0)
+	if (session->input) {
+		vendor  = session->input->id.vendor;
+		product = session->input->id.product;
+	}
+
+	if (session->hid) {
+		vendor  = session->hid->vendor;
+		product = session->hid->product;
+	}
+	task = kthread_run(hidp_session, session,
+			   "khidpd_%04x%04x", vendor, product);
+	err = PTR_ERR(task);
+	if (IS_ERR(task))
 		goto unlink;
 
 	if (session->input) {
-- 
1.5.0.g53756

