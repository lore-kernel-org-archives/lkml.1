Return-Path: <linux-kernel-owner+w=401wt.eu-S2993152AbXDSHI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993152AbXDSHI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993148AbXDSHIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:08:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46305 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161264AbXDSHAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:00:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] bluetooth bnep: Convert to kthread API.
Date: Thu, 19 Apr 2007 00:55:46 -0600
Message-Id: <11769657942558-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

This patch starts kbenpd using kthread_run replacing
a combination of kernel_thread and daemonize.  Making
the code a little simpler and more maintainable.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/bluetooth/bnep/core.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index a9f1e88..de3caed 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/init.h>
@@ -473,7 +474,6 @@ static int bnep_session(void *arg)
 
 	BT_DBG("");
 
-	daemonize("kbnepd %s", dev->name);
 	set_user_nice(current, -15);
 
 	init_waitqueue_entry(&wait, current);
@@ -539,6 +539,7 @@ static struct device *bnep_get_device(struct bnep_session *session)
 
 int bnep_add_connection(struct bnep_connadd_req *req, struct socket *sock)
 {
+	struct task_struct *task;
 	struct net_device *dev;
 	struct bnep_session *s, *ss;
 	u8 dst[ETH_ALEN], src[ETH_ALEN];
@@ -598,9 +599,10 @@ int bnep_add_connection(struct bnep_connadd_req *req, struct socket *sock)
 
 	__bnep_link_session(s);
 
-	err = kernel_thread(bnep_session, s, CLONE_KERNEL);
-	if (err < 0) {
+	task = kthread_run(bnep_session, s, "kbnepd %s", dev->name);
+	if (IS_ERR(task)) {
 		/* Session thread start failed, gotta cleanup. */
+		err = PTR_ERR(task);
 		unregister_netdev(dev);
 		__bnep_unlink_session(s);
 		goto failed;
-- 
1.5.0.g53756

