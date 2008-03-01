Return-Path: <linux-kernel-owner+w=401wt.eu-S1762174AbYCAUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762174AbYCAUEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYCAUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:04:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:32313 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbYCAUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:04:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=HhpUbftkg6QfS2JwfAdvtXh9tkJvLXCMSWbMoDhZ2+c5QiFXk+e0c4OwOV+rOC1qVw8c6lurbghquLHaGHOO7yFWKroZGg5GQIDyo3NZajnFb4qnJVJ9F4JbWePBuxr81WCReWRXY3tl+u9xVvFDTJvEneE4lJlfA3PD2FCBpaM=
Date: Sat, 1 Mar 2008 22:01:11 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: [PATCH 7/9] Audit: internally use the new LSM audit hooks
Message-ID: <20080301200111.GH19636@ubuntu>
References: <20080301194752.GA19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301194752.GA19636@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert Audit to use the new LSM Audit hooks instead of
the exported SELinux interface.

Basically, use:
security_audit_rule_init
secuirty_audit_rule_free
security_audit_rule_known
security_audit_rule_match

instad of (respectively) :
selinux_audit_rule_init
selinux_audit_rule_free
audit_rule_has_selinux
selinux_audit_rule_match

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 audit.c       |    7 ------
 auditfilter.c |   61 ++++++++++++++++------------------------------------------
 auditsc.c     |    9 +++-----
 3 files changed, 22 insertions(+), 55 deletions(-)

Andrew, please atomically merge patch #7 and patch #8. Although
a system with patch7 and without patch8 will be compiled fine,
the SELinux Audit hooks are not set up yet. This means below
audit hooks will point to the dummy hooks instead of SELinux
ones even if SELinux is enabled.

I could not setup the SELinux hooks first cause they have
the same name of the old exported SELinux interface with a 
difference of one parameter.

Thanks!

diff --git a/kernel/audit.c b/kernel/audit.c
index d79f866..40c3507 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -21,7 +21,7 @@
  *
  * Written by Rickard E. (Rik) Faith <faith@redhat.com>
  *
- * Goals: 1) Integrate fully with SELinux.
+ * Goals: 1) Integrate fully with Security Modules.
  *	  2) Minimal run-time overhead:
  *	     a) Minimal when syscall auditing is disabled (audit_enable=0).
  *	     b) Small when syscall auditing is enabled and no audit record
@@ -55,7 +55,6 @@
 #include <net/netlink.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
-#include <linux/selinux.h>
 #include <linux/inotify.h>
 #include <linux/freezer.h>
 #include <linux/tty.h>
@@ -874,10 +873,6 @@ static int __init audit_init(void)
 	audit_enabled = audit_default;
 	audit_ever_enabled |= !!audit_default;
 
-	/* Register the callback with selinux.  This callback will be invoked
-	 * when a new policy is loaded. */
-	selinux_audit_set_callback(&selinux_audit_rule_update);
-
 	audit_log(NULL, GFP_KERNEL, AUDIT_KERNEL, "initialized");
 
 #ifdef CONFIG_AUDITSYSCALL
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 35e58a1..7c69cb5 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -29,7 +29,6 @@
 #include <linux/sched.h>
 #include <linux/inotify.h>
 #include <linux/security.h>
-#include <linux/selinux.h>
 #include "audit.h"
 
 /*
@@ -39,7 +38,7 @@
  * 		Synchronizes writes and blocking reads of audit's filterlist
  * 		data.  Rcu is used to traverse the filterlist and access
  * 		contents of structs audit_entry, audit_watch and opaque
- * 		selinux rules during filtering.  If modified, these structures
+ * 		LSM rules during filtering.  If modified, these structures
  * 		must be copied and replace their counterparts in the filterlist.
  * 		An audit_parent struct is not accessed during filtering, so may
  * 		be written directly provided audit_filter_mutex is held.
@@ -141,7 +140,7 @@ static inline void audit_free_rule(struct audit_entry *e)
 		for (i = 0; i < e->rule.field_count; i++) {
 			struct audit_field *f = &e->rule.fields[i];
 			kfree(f->se_str);
-			selinux_audit_rule_free(f->se_rule);
+			security_audit_rule_free(f->se_rule);
 		}
 	kfree(e->rule.fields);
 	kfree(e->rule.filterkey);
@@ -598,12 +597,12 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 				goto exit_free;
 			entry->rule.buflen += f->val;
 
-			err = selinux_audit_rule_init(f->type, f->op, str,
-						      &f->se_rule);
+			err = security_audit_rule_init(f->type, f->op, str,
+						       (void **)&f->se_rule);
 			/* Keep currently invalid fields around in case they
 			 * become valid after a policy reload. */
 			if (err == -EINVAL) {
-				printk(KERN_WARNING "audit rule for selinux "
+				printk(KERN_WARNING "audit rule for LSM "
 				       "\'%s\' is invalid\n",  str);
 				err = 0;
 			}
@@ -863,9 +862,9 @@ out:
 	return new;
 }
 
-/* Duplicate selinux field information.  The se_rule is opaque, so must be
+/* Duplicate LSM field information.  The se_rule is opaque, so must be
  * re-initialized. */
-static inline int audit_dupe_selinux_field(struct audit_field *df,
+static inline int audit_dupe_lsm_field(struct audit_field *df,
 					   struct audit_field *sf)
 {
 	int ret = 0;
@@ -878,12 +877,12 @@ static inline int audit_dupe_selinux_field(struct audit_field *df,
 	df->se_str = se_str;
 
 	/* our own (refreshed) copy of se_rule */
-	ret = selinux_audit_rule_init(df->type, df->op, df->se_str,
-				      &df->se_rule);
+	ret = security_audit_rule_init(df->type, df->op, df->se_str,
+				       (void **)&df->se_rule);
 	/* Keep currently invalid fields around in case they
 	 * become valid after a policy reload. */
 	if (ret == -EINVAL) {
-		printk(KERN_WARNING "audit rule for selinux \'%s\' is "
+		printk(KERN_WARNING "audit rule for LSM \'%s\' is "
 		       "invalid\n", df->se_str);
 		ret = 0;
 	}
@@ -892,7 +891,7 @@ static inline int audit_dupe_selinux_field(struct audit_field *df,
 }
 
 /* Duplicate an audit rule.  This will be a deep copy with the exception
- * of the watch - that pointer is carried over.  The selinux specific fields
+ * of the watch - that pointer is carried over.  The LSM specific fields
  * will be updated in the copy.  The point is to be able to replace the old
  * rule with the new rule in the filterlist, then free the old rule.
  * The rlist element is undefined; list manipulations are handled apart from
@@ -945,7 +944,7 @@ static struct audit_entry *audit_dupe_rule(struct audit_krule *old,
 		case AUDIT_OBJ_TYPE:
 		case AUDIT_OBJ_LEV_LOW:
 		case AUDIT_OBJ_LEV_HIGH:
-			err = audit_dupe_selinux_field(&new->fields[i],
+			err = audit_dupe_lsm_field(&new->fields[i],
 						       &old->fields[i]);
 			break;
 		case AUDIT_FILTERKEY:
@@ -1763,38 +1762,12 @@ unlock_and_return:
 	return result;
 }
 
-/* Check to see if the rule contains any selinux fields.  Returns 1 if there
-   are selinux fields specified in the rule, 0 otherwise. */
-static inline int audit_rule_has_selinux(struct audit_krule *rule)
-{
-	int i;
-
-	for (i = 0; i < rule->field_count; i++) {
-		struct audit_field *f = &rule->fields[i];
-		switch (f->type) {
-		case AUDIT_SUBJ_USER:
-		case AUDIT_SUBJ_ROLE:
-		case AUDIT_SUBJ_TYPE:
-		case AUDIT_SUBJ_SEN:
-		case AUDIT_SUBJ_CLR:
-		case AUDIT_OBJ_USER:
-		case AUDIT_OBJ_ROLE:
-		case AUDIT_OBJ_TYPE:
-		case AUDIT_OBJ_LEV_LOW:
-		case AUDIT_OBJ_LEV_HIGH:
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
 /* This function will re-initialize the se_rule field of all applicable rules.
- * It will traverse the filter lists serarching for rules that contain selinux
+ * It will traverse the filter lists serarching for rules that contain LSM
  * specific filter fields.  When such a rule is found, it is copied, the
- * selinux field is re-initialized, and the old rule is replaced with the
+ * LSM field is re-initialized, and the old rule is replaced with the
  * updated rule. */
-int selinux_audit_rule_update(void)
+int audit_update_lsm_rules(void)
 {
 	struct audit_entry *entry, *n, *nentry;
 	struct audit_watch *watch;
@@ -1806,7 +1779,7 @@ int selinux_audit_rule_update(void)
 
 	for (i = 0; i < AUDIT_NR_FILTERS; i++) {
 		list_for_each_entry_safe(entry, n, &audit_filter_list[i], list) {
-			if (!audit_rule_has_selinux(&entry->rule))
+			if (!security_audit_rule_known(&entry->rule))
 				continue;
 
 			watch = entry->rule.watch;
@@ -1817,7 +1790,7 @@ int selinux_audit_rule_update(void)
 				 * return value */
 				if (!err)
 					err = PTR_ERR(nentry);
-				audit_panic("error updating selinux filters");
+				audit_panic("error updating LSM filters");
 				if (watch)
 					list_del(&entry->rule.rlist);
 				list_del_rcu(&entry->list);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a9fc9dd..8afd349 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -61,7 +61,6 @@
 #include <linux/security.h>
 #include <linux/list.h>
 #include <linux/tty.h>
-#include <linux/selinux.h>
 #include <linux/binfmts.h>
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
@@ -533,7 +532,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 					security_task_getsecid(tsk, &sid);
 					need_sid = 0;
 				}
-				result = selinux_audit_rule_match(sid, f->type,
+				result = security_audit_rule_match(sid, f->type,
 				                                  f->op,
 				                                  f->se_rule,
 				                                  ctx);
@@ -549,12 +548,12 @@ static int audit_filter_rules(struct task_struct *tsk,
 			if (f->se_rule) {
 				/* Find files that match */
 				if (name) {
-					result = selinux_audit_rule_match(
+					result = security_audit_rule_match(
 					           name->osid, f->type, f->op,
 					           f->se_rule, ctx);
 				} else if (ctx) {
 					for (j = 0; j < ctx->name_count; j++) {
-						if (selinux_audit_rule_match(
+						if (security_audit_rule_match(
 						      ctx->names[j].osid,
 						      f->type, f->op,
 						      f->se_rule, ctx)) {
@@ -570,7 +569,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 					     aux = aux->next) {
 						if (aux->type == AUDIT_IPC) {
 							struct audit_aux_data_ipcctl *axi = (void *)aux;
-							if (selinux_audit_rule_match(axi->osid, f->type, f->op, f->se_rule, ctx)) {
+							if (security_audit_rule_match(axi->osid, f->type, f->op, f->se_rule, ctx)) {
 								++result;
 								break;
 							}

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

