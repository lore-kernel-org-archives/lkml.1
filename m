Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYH0NuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYH0NuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYH0Nrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:47:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800AbYH0Nrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:47:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/59] CRED: Wrap task credential accesses in the eCryptFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>,
       ecryptfs-devel@lists.sourceforge.net
Date: Wed, 27 Aug 2008 14:47:35 +0100
Message-ID: <20080827134735.19980.88570.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Mike Halcrow <mhalcrow@us.ibm.com>
Cc: Phillip Hellewell <phillip@hellewell.homeip.net>
Cc: ecryptfs-devel@lists.sourceforge.net
---

 fs/ecryptfs/messaging.c |   18 ++++++++++--------
 fs/ecryptfs/miscdev.c   |   20 ++++++++++++--------
 2 files changed, 22 insertions(+), 16 deletions(-)


diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 1b5c200..92bf606 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -377,6 +377,7 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 	size_t msg_size;
 	struct nsproxy *nsproxy;
 	struct user_namespace *current_user_ns;
+	uid_t ctx_euid;
 	int rc;
 
 	if (msg->index >= ecryptfs_message_buf_len) {
@@ -401,8 +402,8 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 		goto wake_up;
 	}
 	current_user_ns = nsproxy->user_ns;
-	rc = ecryptfs_find_daemon_by_euid(&daemon, msg_ctx->task->euid,
-					  current_user_ns);
+	ctx_euid = task_euid(msg_ctx->task);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, ctx_euid, current_user_ns);
 	rcu_read_unlock();
 	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	if (rc) {
@@ -410,14 +411,14 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 		printk(KERN_WARNING "%s: User [%d] received a "
 		       "message response from process [0x%p] but does "
 		       "not have a registered daemon\n", __func__,
-		       msg_ctx->task->euid, pid);
+		       ctx_euid, pid);
 		goto wake_up;
 	}
-	if (msg_ctx->task->euid != euid) {
+	if (ctx_euid != euid) {
 		rc = -EBADMSG;
 		printk(KERN_WARNING "%s: Received message from user "
 		       "[%d]; expected message from user [%d]\n", __func__,
-		       euid, msg_ctx->task->euid);
+		       euid, ctx_euid);
 		goto unlock;
 	}
 	if (current_user_ns != user_ns) {
@@ -431,7 +432,7 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 		rc = -EBADMSG;
 		printk(KERN_ERR "%s: User [%d] sent a message response "
 		       "from an unrecognized process [0x%p]\n",
-		       __func__, msg_ctx->task->euid, pid);
+		       __func__, ctx_euid, pid);
 		goto unlock;
 	}
 	if (msg_ctx->state != ECRYPTFS_MSG_CTX_STATE_PENDING) {
@@ -482,14 +483,15 @@ ecryptfs_send_message_locked(unsigned int transport, char *data, int data_len,
 			     u8 msg_type, struct ecryptfs_msg_ctx **msg_ctx)
 {
 	struct ecryptfs_daemon *daemon;
+	uid_t euid = current_euid();
 	int rc;
 
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	if (rc || !daemon) {
 		rc = -ENOTCONN;
 		printk(KERN_ERR "%s: User [%d] does not have a daemon "
-		       "registered\n", __func__, current->euid);
+		       "registered\n", __func__, euid);
 		goto out;
 	}
 	mutex_lock(&ecryptfs_msg_ctx_lists_mux);
diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index b484792..047ac60 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -42,11 +42,12 @@ ecryptfs_miscdev_poll(struct file *file, poll_table *pt)
 {
 	struct ecryptfs_daemon *daemon;
 	unsigned int mask = 0;
+	uid_t euid = current_euid();
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
 	/* TODO: Just use file->private_data? */
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
@@ -83,6 +84,7 @@ static int
 ecryptfs_miscdev_open(struct inode *inode, struct file *file)
 {
 	struct ecryptfs_daemon *daemon = NULL;
+	uid_t euid = current_euid();
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
@@ -93,10 +95,10 @@ ecryptfs_miscdev_open(struct inode *inode, struct file *file)
 		       "count; rc = [%d]\n", __func__, rc);
 		goto out_unlock_daemon_list;
 	}
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	if (rc || !daemon) {
-		rc = ecryptfs_spawn_daemon(&daemon, current->euid,
+		rc = ecryptfs_spawn_daemon(&daemon, euid,
 					   current->nsproxy->user_ns,
 					   task_pid(current));
 		if (rc) {
@@ -147,10 +149,11 @@ static int
 ecryptfs_miscdev_release(struct inode *inode, struct file *file)
 {
 	struct ecryptfs_daemon *daemon = NULL;
+	uid_t euid = current_euid();
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
@@ -246,11 +249,12 @@ ecryptfs_miscdev_read(struct file *file, char __user *buf, size_t count,
 	char packet_length[3];
 	size_t i;
 	size_t total_length;
+	uid_t euid = current_euid();
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
 	/* TODO: Just use file->private_data? */
-	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid,
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid,
 					  current->nsproxy->user_ns);
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
@@ -290,7 +294,7 @@ check_list:
 		 * message from the queue; try again */
 		goto check_list;
 	}
-	BUG_ON(current->euid != daemon->euid);
+	BUG_ON(euid != daemon->euid);
 	BUG_ON(current->nsproxy->user_ns != daemon->user_ns);
 	BUG_ON(task_pid(current) != daemon->pid);
 	msg_ctx = list_first_entry(&daemon->msg_ctx_out_queue,
@@ -414,6 +418,7 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 	size_t packet_size, packet_size_length, i;
 	ssize_t sz = 0;
 	char *data;
+	uid_t euid = current_euid();
 	int rc;
 
 	if (count == 0)
@@ -463,8 +468,7 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 			goto out_free;
 		}
 		rc = ecryptfs_miscdev_response(&data[i], packet_size,
-					       current->euid,
-					       current->nsproxy->user_ns,
+					       euid, current->nsproxy->user_ns,
 					       task_pid(current), seq);
 		if (rc)
 			printk(KERN_WARNING "%s: Failed to deliver miscdev "

