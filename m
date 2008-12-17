Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757734AbYLQFO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbYLQFO6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759068AbYLQFMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:12:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37068 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759582AbYLQFMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:12:52 -0500
To: linux-audit@redhat.com
Subject: [PATCH 11/15] fixing audit rule ordering mess, part 1
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCoiI-0000Eu-Ty@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:12:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Problem: ordering between the rules on exit chain is currently lost;
all watch and inode rules are listed after everything else _and_
exit,never on one kind doesn't stop exit,always on another from
being matched.

Solution: assign priorities to rules, keep track of the current
highest-priority matching rule and its result (always/never).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h |    1 +
 kernel/audit.h        |    5 +--
 kernel/auditfilter.c  |   17 +++++++++--
 kernel/auditsc.c      |   79 ++++++++++++++++++++++++++----------------------
 4 files changed, 59 insertions(+), 43 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index c5e95e7..d28682c 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -371,6 +371,7 @@ struct audit_krule {
 	struct audit_watch	*watch;	/* associated watch */
 	struct audit_tree	*tree;	/* associated watched tree */
 	struct list_head	rlist;	/* entry in audit_{watch,tree}.rules list */
+	u64			prio;
 };
 
 struct audit_field {
diff --git a/kernel/audit.h b/kernel/audit.h
index 9d67174..16f18ca 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -159,11 +159,8 @@ static inline int audit_signal_info(int sig, struct task_struct *t)
 		return __audit_signal_info(sig, t);
 	return 0;
 }
-extern enum audit_state audit_filter_inodes(struct task_struct *,
-					    struct audit_context *);
-extern void audit_set_auditable(struct audit_context *);
+extern void audit_filter_inodes(struct task_struct *, struct audit_context *);
 #else
 #define audit_signal_info(s,t) AUDIT_DISABLED
 #define audit_filter_inodes(t,c) AUDIT_DISABLED
-#define audit_set_auditable(c)
 #endif
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 0febaa0..995a2e8 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -919,6 +919,7 @@ static struct audit_entry *audit_dupe_rule(struct audit_krule *old,
 	new->action = old->action;
 	for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
 		new->mask[i] = old->mask[i];
+	new->prio = old->prio;
 	new->buflen = old->buflen;
 	new->inode_f = old->inode_f;
 	new->watch = NULL;
@@ -987,9 +988,8 @@ static void audit_update_watch(struct audit_parent *parent,
 
 		/* If the update involves invalidating rules, do the inode-based
 		 * filtering now, so we don't omit records. */
-		if (invalidating && current->audit_context &&
-		    audit_filter_inodes(current, current->audit_context) == AUDIT_RECORD_CONTEXT)
-			audit_set_auditable(current->audit_context);
+		if (invalidating && current->audit_context)
+			audit_filter_inodes(current, current->audit_context);
 
 		nwatch = audit_dupe_watch(owatch);
 		if (IS_ERR(nwatch)) {
@@ -1258,6 +1258,9 @@ static int audit_add_watch(struct audit_krule *krule, struct nameidata *ndp,
 	return ret;
 }
 
+static u64 prio_low = ~0ULL/2;
+static u64 prio_high = ~0ULL/2 - 1;
+
 /* Add rule to given filterlist if not a duplicate. */
 static inline int audit_add_rule(struct audit_entry *entry,
 				 struct list_head *list)
@@ -1319,6 +1322,14 @@ static inline int audit_add_rule(struct audit_entry *entry,
 		}
 	}
 
+	entry->rule.prio = ~0ULL;
+	if (entry->rule.listnr == AUDIT_FILTER_EXIT) {
+		if (entry->rule.flags & AUDIT_FILTER_PREPEND)
+			entry->rule.prio = ++prio_high;
+		else
+			entry->rule.prio = --prio_low;
+	}
+
 	if (entry->rule.flags & AUDIT_FILTER_PREPEND) {
 		list_add_rcu(&entry->list, list);
 		entry->rule.flags &= ~AUDIT_FILTER_PREPEND;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 5de0087..296d329 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -139,14 +139,14 @@ struct audit_tree_refs {
 struct audit_context {
 	int		    dummy;	/* must be the first element */
 	int		    in_syscall;	/* 1 if task is in a syscall */
-	enum audit_state    state;
+	enum audit_state    state, current_state;
 	unsigned int	    serial;     /* serial number for record */
 	struct timespec	    ctime;      /* time of syscall entry */
 	int		    major;      /* syscall number */
 	unsigned long	    argv[4];    /* syscall arguments */
 	int		    return_valid; /* return code is valid */
 	long		    return_code;/* syscall return code */
-	int		    auditable;  /* 1 if record should be written */
+	u64		    prio;
 	int		    name_count;
 	struct audit_names  names[AUDIT_NAMES];
 	char *		    filterkey;	/* key for rule that triggered record */
@@ -597,8 +597,16 @@ static int audit_filter_rules(struct task_struct *tsk,
 		if (!result)
 			return 0;
 	}
-	if (rule->filterkey && ctx)
-		ctx->filterkey = kstrdup(rule->filterkey, GFP_ATOMIC);
+
+	if (ctx) {
+		if (rule->prio <= ctx->prio)
+			return 0;
+		if (rule->filterkey) {
+			kfree(ctx->filterkey);
+			ctx->filterkey = kstrdup(rule->filterkey, GFP_ATOMIC);
+		}
+		ctx->prio = rule->prio;
+	}
 	switch (rule->action) {
 	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;
 	case AUDIT_ALWAYS:   *state = AUDIT_RECORD_CONTEXT; break;
@@ -651,6 +659,7 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 			    audit_filter_rules(tsk, &e->rule, ctx, NULL,
 					       &state)) {
 				rcu_read_unlock();
+				ctx->current_state = state;
 				return state;
 			}
 		}
@@ -664,15 +673,14 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
  * buckets applicable to the inode numbers in audit_names[].
  * Regarding audit_state, same rules apply as for audit_filter_syscall().
  */
-enum audit_state audit_filter_inodes(struct task_struct *tsk,
-				     struct audit_context *ctx)
+void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
 {
 	int i;
 	struct audit_entry *e;
 	enum audit_state state;
 
 	if (audit_pid && tsk->tgid == audit_pid)
-		return AUDIT_DISABLED;
+		return;
 
 	rcu_read_lock();
 	for (i = 0; i < ctx->name_count; i++) {
@@ -689,17 +697,20 @@ enum audit_state audit_filter_inodes(struct task_struct *tsk,
 			if ((e->rule.mask[word] & bit) == bit &&
 			    audit_filter_rules(tsk, &e->rule, ctx, n, &state)) {
 				rcu_read_unlock();
-				return state;
+				ctx->current_state = state;
+				return;
 			}
 		}
 	}
 	rcu_read_unlock();
-	return AUDIT_BUILD_CONTEXT;
 }
 
-void audit_set_auditable(struct audit_context *ctx)
+static void audit_set_auditable(struct audit_context *ctx)
 {
-	ctx->auditable = 1;
+	if (!ctx->prio) {
+		ctx->prio = 1;
+		ctx->current_state = AUDIT_RECORD_CONTEXT;
+	}
 }
 
 static inline struct audit_context *audit_get_context(struct task_struct *tsk,
@@ -730,23 +741,11 @@ static inline struct audit_context *audit_get_context(struct task_struct *tsk,
 	else
 		context->return_code  = return_code;
 
-	if (context->in_syscall && !context->dummy && !context->auditable) {
-		enum audit_state state;
-
-		state = audit_filter_syscall(tsk, context, &audit_filter_list[AUDIT_FILTER_EXIT]);
-		if (state == AUDIT_RECORD_CONTEXT) {
-			context->auditable = 1;
-			goto get_context;
-		}
-
-		state = audit_filter_inodes(tsk, context);
-		if (state == AUDIT_RECORD_CONTEXT)
-			context->auditable = 1;
-
+	if (context->in_syscall && !context->dummy) {
+		audit_filter_syscall(tsk, context, &audit_filter_list[AUDIT_FILTER_EXIT]);
+		audit_filter_inodes(tsk, context);
 	}
 
-get_context:
-
 	tsk->audit_context = NULL;
 	return context;
 }
@@ -756,8 +755,7 @@ static inline void audit_free_names(struct audit_context *context)
 	int i;
 
 #if AUDIT_DEBUG == 2
-	if (context->auditable
-	    ||context->put_count + context->ino_count != context->name_count) {
+	if (context->put_count + context->ino_count != context->name_count) {
 		printk(KERN_ERR "%s:%d(:%d): major=%d in_syscall=%d"
 		       " name_count=%d put_count=%d"
 		       " ino_count=%d [NOT freeing]\n",
@@ -808,6 +806,7 @@ static inline void audit_zero_context(struct audit_context *context,
 {
 	memset(context, 0, sizeof(*context));
 	context->state      = state;
+	context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
 }
 
 static inline struct audit_context *audit_alloc_context(enum audit_state state)
@@ -1456,7 +1455,7 @@ void audit_free(struct task_struct *tsk)
 	 * We use GFP_ATOMIC here because we might be doing this
 	 * in the context of the idle thread */
 	/* that can happen only if we are called from do_exit() */
-	if (context->in_syscall && context->auditable)
+	if (context->in_syscall && context->current_state == AUDIT_RECORD_CONTEXT)
 		audit_log_exit(context, tsk);
 
 	audit_free_context(context);
@@ -1540,15 +1539,17 @@ void audit_syscall_entry(int arch, int major,
 
 	state = context->state;
 	context->dummy = !audit_n_rules;
-	if (!context->dummy && (state == AUDIT_SETUP_CONTEXT || state == AUDIT_BUILD_CONTEXT))
+	if (!context->dummy && state == AUDIT_BUILD_CONTEXT) {
+		context->prio = 0;
 		state = audit_filter_syscall(tsk, context, &audit_filter_list[AUDIT_FILTER_ENTRY]);
+	}
 	if (likely(state == AUDIT_DISABLED))
 		return;
 
 	context->serial     = 0;
 	context->ctime      = CURRENT_TIME;
 	context->in_syscall = 1;
-	context->auditable  = !!(state == AUDIT_RECORD_CONTEXT);
+	context->current_state  = state;
 	context->ppid       = 0;
 }
 
@@ -1556,17 +1557,20 @@ void audit_finish_fork(struct task_struct *child)
 {
 	struct audit_context *ctx = current->audit_context;
 	struct audit_context *p = child->audit_context;
-	if (!p || !ctx || !ctx->auditable)
+	if (!p || !ctx)
+		return;
+	if (!ctx->in_syscall || ctx->current_state != AUDIT_RECORD_CONTEXT)
 		return;
 	p->arch = ctx->arch;
 	p->major = ctx->major;
 	memcpy(p->argv, ctx->argv, sizeof(ctx->argv));
 	p->ctime = ctx->ctime;
 	p->dummy = ctx->dummy;
-	p->auditable = ctx->auditable;
 	p->in_syscall = ctx->in_syscall;
 	p->filterkey = kstrdup(ctx->filterkey, GFP_KERNEL);
 	p->ppid = current->pid;
+	p->prio = ctx->prio;
+	p->current_state = ctx->current_state;
 }
 
 /**
@@ -1590,11 +1594,11 @@ void audit_syscall_exit(int valid, long return_code)
 	if (likely(!context))
 		return;
 
-	if (context->in_syscall && context->auditable)
+	if (context->in_syscall && context->current_state == AUDIT_RECORD_CONTEXT)
 		audit_log_exit(context, tsk);
 
 	context->in_syscall = 0;
-	context->auditable  = 0;
+	context->prio = context->state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
 
 	if (context->previous) {
 		struct audit_context *new_context = context->previous;
@@ -1975,7 +1979,10 @@ int auditsc_get_stamp(struct audit_context *ctx,
 	t->tv_sec  = ctx->ctime.tv_sec;
 	t->tv_nsec = ctx->ctime.tv_nsec;
 	*serial    = ctx->serial;
-	ctx->auditable = 1;
+	if (!ctx->prio) {
+		ctx->prio = 1;
+		ctx->current_state = AUDIT_RECORD_CONTEXT;
+	}
 	return 1;
 }
 
-- 
1.5.6.5


