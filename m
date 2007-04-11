Return-Path: <linux-kernel-owner+w=401wt.eu-S964852AbXDKTKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbXDKTKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbXDKTK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:10:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbXDKTKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:10:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/8] AFS: Fix callback aggregator work item deadlock
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, dhowells@redhat.com
Date: Wed, 11 Apr 2007 20:10:12 +0100
Message-ID: <20070411191012.15499.94466.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070411190956.15499.55352.stgit@warthog.cambridge.redhat.com>
References: <20070411190956.15499.55352.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a deadlock in the give-up-callback aggregator dispatcher work item whereby
the aggregator runs on keventd as does timed autounmount, thus leading to the
unmount blocking keventd whilst waiting for keventd to run the aggregator when
the give-up-callback buffer is full.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 fs/afs/callback.c |   14 +++++++++-----
 fs/afs/fsclient.c |    6 ++++--
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index fdad11c..1533b49 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -232,7 +232,8 @@ static void afs_do_give_up_callback(struct afs_server *server,
 	 * possible to ship in one operation */
 	switch (atomic_inc_return(&server->cb_break_n)) {
 	case 1 ... AFSCBMAX - 1:
-		schedule_delayed_work(&server->cb_break_work, HZ * 2);
+		queue_delayed_work(afs_callback_update_worker,
+				   &server->cb_break_work, HZ * 2);
 		break;
 	case AFSCBMAX:
 		afs_flush_callback_breaks(server);
@@ -271,9 +272,11 @@ void afs_give_up_callback(struct afs_vnode *vnode)
 	spin_lock(&server->cb_lock);
 	if (vnode->cb_promised && afs_breakring_space(server) == 0) {
 		add_wait_queue(&server->cb_break_waitq, &myself);
-		while (vnode->cb_promised &&
-		       afs_breakring_space(server) == 0) {
+		for (;;) {
 			set_current_state(TASK_UNINTERRUPTIBLE);
+			if (!vnode->cb_promised ||
+			    afs_breakring_space(server) != 0)
+				break;
 			spin_unlock(&server->cb_lock);
 			schedule();
 			spin_lock(&server->cb_lock);
@@ -315,7 +318,8 @@ void afs_dispatch_give_up_callbacks(struct work_struct *work)
 void afs_flush_callback_breaks(struct afs_server *server)
 {
 	if (try_to_cancel_delayed_work(&server->cb_break_work) >= 0)
-		schedule_delayed_work(&server->cb_break_work, 0);
+		queue_delayed_work(afs_callback_update_worker,
+				   &server->cb_break_work, 0);
 }
 
 #if 0
@@ -426,7 +430,7 @@ static void afs_callback_updater(struct work_struct *work)
 int __init afs_callback_update_init(void)
 {
 	afs_callback_update_worker =
-		create_singlethread_workqueue("kafs_cbupdated");
+		create_singlethread_workqueue("kafs_callbackd");
 	return afs_callback_update_worker ? 0 : -ENOMEM;
 }
 
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index d955178..e2a36f8 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -355,10 +355,11 @@ int afs_fs_give_up_callbacks(struct afs_server *server,
 	__be32 *bp, *tp;
 	int loop;
 
-	_enter("");
-
 	ncallbacks = CIRC_CNT(server->cb_break_head, server->cb_break_tail,
 			      ARRAY_SIZE(server->cb_break));
+
+	_enter("{%zu},", ncallbacks);
+
 	if (ncallbacks == 0)
 		return 0;
 	if (ncallbacks > AFSCBMAX)
@@ -398,6 +399,7 @@ int afs_fs_give_up_callbacks(struct afs_server *server,
 			(ARRAY_SIZE(server->cb_break) - 1);
 	}
 
+	ASSERT(ncallbacks > 0);
 	wake_up_nr(&server->cb_break_waitq, ncallbacks);
 
 	return afs_make_call(&server->addr, call, GFP_NOFS, wait_mode);

