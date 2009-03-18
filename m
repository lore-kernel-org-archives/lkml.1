Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZCRN13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZCRN13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZCRN0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbZCRN0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:37 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Abhijith Das <adas@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/18] GFS2: Bring back lvb-related stuff to lock_nolock to support quotas
Date: Wed, 18 Mar 2009 12:23:37 +0000
Message-Id: <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

The quota code uses lvbs and this is currently not implemented in
lock_nolock, thereby causing panics when quota is enabled with
lock_nolock. This patch adds the relevant bits.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking.c b/fs/gfs2/locking.c
index 523243a..d3657bc 100644
--- a/fs/gfs2/locking.c
+++ b/fs/gfs2/locking.c
@@ -23,11 +23,74 @@ struct lmh_wrapper {
 	const struct lm_lockops *lw_ops;
 };
 
+struct nolock_lockspace {
+	unsigned int nl_lvb_size;
+};
+
+/**
+ * nolock_get_lock - get a lm_lock_t given a descripton of the lock
+ * @lockspace: the lockspace the lock lives in
+ * @name: the name of the lock
+ * @lockp: return the lm_lock_t here
+ *
+ * Returns: 0 on success, -EXXX on failure
+ */
+
+static int nolock_get_lock(void *lockspace, struct lm_lockname *name,
+                           void **lockp)
+{
+        *lockp = lockspace;
+        return 0;
+}
+
+/**
+ * nolock_put_lock - get rid of a lock structure
+ * @lock: the lock to throw away
+ *
+ */
+
+static void nolock_put_lock(void *lock)
+{
+}
+
+/**
+ * nolock_hold_lvb - hold on to a lock value block
+ * @lock: the lock the LVB is associated with
+ * @lvbp: return the lm_lvb_t here
+ *
+ * Returns: 0 on success, -EXXX on failure
+ */
+
+static int nolock_hold_lvb(void *lock, char **lvbp)
+{
+	struct nolock_lockspace *nl = lock;
+	int error = 0;
+
+	*lvbp = kzalloc(nl->nl_lvb_size, GFP_KERNEL);
+	if (!*lvbp)
+		error = -ENOMEM;
+
+	return error;
+}
+
+/**
+ * nolock_unhold_lvb - release a LVB
+ * @lock: the lock the LVB is associated with
+ * @lvb: the lock value block
+ *
+ */
+
+static void nolock_unhold_lvb(void *lock, char *lvb)
+{
+	kfree(lvb);
+}
+
 static int nolock_mount(char *table_name, char *host_data,
 			lm_callback_t cb, void *cb_data,
 			unsigned int min_lvb_size, int flags,
 			struct lm_lockstruct *lockstruct,
 			struct kobject *fskobj);
+static void nolock_unmount(void *lockspace);
 
 /* List of registered low-level locking protocols.  A file system selects one
    of them by name at mount time, e.g. lock_nolock, lock_dlm. */
@@ -35,6 +98,11 @@ static int nolock_mount(char *table_name, char *host_data,
 static const struct lm_lockops nolock_ops = {
 	.lm_proto_name = "lock_nolock",
 	.lm_mount = nolock_mount,
+	.lm_unmount = nolock_unmount,
+	.lm_get_lock = nolock_get_lock,
+	.lm_put_lock = nolock_put_lock,
+	.lm_hold_lvb = nolock_hold_lvb,
+	.lm_unhold_lvb = nolock_unhold_lvb,
 };
 
 static struct lmh_wrapper nolock_proto  = {
@@ -53,6 +121,7 @@ static int nolock_mount(char *table_name, char *host_data,
 {
 	char *c;
 	unsigned int jid;
+	struct nolock_lockspace *nl;
 
 	c = strstr(host_data, "jid=");
 	if (!c)
@@ -62,15 +131,28 @@ static int nolock_mount(char *table_name, char *host_data,
 		sscanf(c, "%u", &jid);
 	}
 
+	nl = kzalloc(sizeof(struct nolock_lockspace), GFP_KERNEL);
+	if (!nl)
+		return -ENOMEM;
+
+	nl->nl_lvb_size = min_lvb_size;
+
 	lockstruct->ls_jid = jid;
 	lockstruct->ls_first = 1;
 	lockstruct->ls_lvb_size = min_lvb_size;
+	lockstruct->ls_lockspace = nl;
 	lockstruct->ls_ops = &nolock_ops;
 	lockstruct->ls_flags = LM_LSFLAG_LOCAL;
 
 	return 0;
 }
 
+static void nolock_unmount(void *lockspace)
+{
+        struct nolock_lockspace *nl = lockspace;
+        kfree(nl);
+}
+
 /**
  * gfs2_register_lockproto - Register a low-level locking protocol
  * @proto: the protocol definition
-- 
1.6.0.3

