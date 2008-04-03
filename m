Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbYDCAfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbYDCAfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760181AbYDCAeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:34:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:9328 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760106AbYDCAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=paDQrHCdxTx8VWe5jqP+14ZwVozLGdtML6WAl2sMD2p90CUQg6iMKCwVhZ/r/qa5eqDbtx+T5oUP7/BJpyfJDs38LeZFd+eiyNTDRSrI8/tJc2yBUz951rjSoDGtwyTkHeH9HYlr7F7OW9wS9NLOEhrmIiCqZPAXI8/cRwCbFqQ=
Subject: [PATCH 5/7] audit: move extern declarations to audit.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 17:33:37 -0700
Message-Id: <1207182817.5740.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leave audit_sig_{uid|pid|sid} protected by #ifdef CONFIG_AUDITSYSCALL.

Noticed by sparse:
kernel/audit.c:73:6: warning: symbol 'audit_ever_enabled' was not declared. Should it be static?
kernel/audit.c:100:8: warning: symbol 'audit_sig_uid' was not declared. Should it be static?
kernel/audit.c:101:8: warning: symbol 'audit_sig_pid' was not declared. Should it be static?
kernel/audit.c:102:6: warning: symbol 'audit_sig_sid' was not declared. Should it be static?
kernel/audit.c:117:23: warning: symbol 'audit_ih' was not declared. Should it be static?
kernel/auditfilter.c:78:18: warning: symbol 'audit_filter_list' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/audit.h       |   11 +++++++++++
 kernel/auditfilter.c |    5 -----
 kernel/auditsc.c     |    6 ------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index 2554bd5..bbed72f 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -99,6 +99,9 @@ struct audit_entry {
 	struct audit_krule	rule;
 };
 
+extern int audit_enabled;
+extern int audit_ever_enabled;
+
 extern int audit_pid;
 
 #define AUDIT_INODE_BUCKETS	32
@@ -129,6 +132,9 @@ struct audit_netlink_list {
 int audit_send_list(void *);
 
 struct inotify_watch;
+/* Inotify handle */
+extern struct inotify_handle *audit_ih;
+
 extern void audit_free_parent(struct inotify_watch *);
 extern void audit_handle_ievent(struct inotify_watch *, u32, u32, u32,
 				const char *, struct inode *);
@@ -136,6 +142,7 @@ extern int selinux_audit_rule_update(void);
 
 extern struct mutex audit_filter_mutex;
 extern void audit_free_rule_rcu(struct rcu_head *);
+extern struct list_head audit_filter_list[];
 
 #ifdef CONFIG_AUDIT_TREE
 extern struct audit_chunk *audit_tree_lookup(const struct inode *);
@@ -162,6 +169,10 @@ extern void audit_put_tree(struct audit_tree *);
 
 extern char *audit_unpack_string(void **, size_t *, size_t);
 
+extern pid_t audit_sig_pid;
+extern uid_t audit_sig_uid;
+extern u32 audit_sig_sid;
+
 #ifdef CONFIG_AUDITSYSCALL
 extern int __audit_signal_info(int sig, struct task_struct *t);
 static inline int audit_signal_info(int sig, struct task_struct *t)
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 2f2914b..0c63577 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -89,14 +89,9 @@ struct list_head audit_filter_list[AUDIT_NR_FILTERS] = {
 
 DEFINE_MUTEX(audit_filter_mutex);
 
-/* Inotify handle */
-extern struct inotify_handle *audit_ih;
-
 /* Inotify events we care about. */
 #define AUDIT_IN_WATCH IN_MOVE|IN_CREATE|IN_DELETE|IN_DELETE_SELF|IN_MOVE_SELF
 
-extern int audit_enabled;
-
 void audit_free_parent(struct inotify_watch *i_watch)
 {
 	struct audit_parent *parent;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 782262e..12e7183 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -69,9 +69,6 @@
 
 #include "audit.h"
 
-extern struct list_head audit_filter_list[];
-extern int audit_ever_enabled;
-
 /* AUDIT_NAMES is the number of slots we reserve in the audit_context
  * for saving names from getname(). */
 #define AUDIT_NAMES    20
@@ -2360,9 +2357,6 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct task_struct *tsk = current;
 	struct audit_context *ctx = tsk->audit_context;
-	extern pid_t audit_sig_pid;
-	extern uid_t audit_sig_uid;
-	extern u32 audit_sig_sid;
 
 	if (audit_pid && t->tgid == audit_pid) {
 		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1) {
-- 
1.5.5.rc1.135.g8527


