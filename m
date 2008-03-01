Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbYCAUI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbYCAUI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbYCAUIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:08:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:44862 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbYCAUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:08:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Jyi1fgqlO1mYk2UCM3naHbA4kmho1ByHSMg0UqxJthBzRTaWFzNgtzcnwEvvoKHNXX5Bemb1ox2ZV2guewW3iIOaU6B6328WQW88f+IEq/69rlTfOS98cbnFRgLbGRwqTByVm4+iB3GuvWQlUGttGehiNPwJn7x3QJWXlYJfkuU=
Date: Sat, 1 Mar 2008 22:05:37 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: [PATCH 9/9] Audit: Final renamings and cleanup
Message-ID: <20080301200537.GJ19636@ubuntu>
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

Rename the se_str and se_rule audit fields elements to
lsm_str and lsm_rule to avoid confusion.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 include/linux/audit.h |    4 ++--
 kernel/auditfilter.c  |   40 ++++++++++++++++++++--------------------
 kernel/auditsc.c      |   12 ++++++------
 3 files changed, 28 insertions(+), 28 deletions(-)

Woo, hooo .. That was fun ;)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 3367c80..a35678e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -377,8 +377,8 @@ struct audit_field {
 	u32				type;
 	u32				val;
 	u32				op;
-	char				*se_str;
-	void				*se_rule;
+	char				*lsm_str;
+	void				*lsm_rule;
 };
 
 #define AUDITSC_INVALID 0
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 7c69cb5..28fef6b 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -139,8 +139,8 @@ static inline void audit_free_rule(struct audit_entry *e)
 	if (e->rule.fields)
 		for (i = 0; i < e->rule.field_count; i++) {
 			struct audit_field *f = &e->rule.fields[i];
-			kfree(f->se_str);
-			security_audit_rule_free(f->se_rule);
+			kfree(f->lsm_str);
+			security_audit_rule_free(f->lsm_rule);
 		}
 	kfree(e->rule.fields);
 	kfree(e->rule.filterkey);
@@ -554,8 +554,8 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		f->op = data->fieldflags[i] & AUDIT_OPERATORS;
 		f->type = data->fields[i];
 		f->val = data->values[i];
-		f->se_str = NULL;
-		f->se_rule = NULL;
+		f->lsm_str = NULL;
+		f->lsm_rule = NULL;
 		switch(f->type) {
 		case AUDIT_PID:
 		case AUDIT_UID:
@@ -598,7 +598,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			entry->rule.buflen += f->val;
 
 			err = security_audit_rule_init(f->type, f->op, str,
-						       (void **)&f->se_rule);
+						       (void **)&f->lsm_rule);
 			/* Keep currently invalid fields around in case they
 			 * become valid after a policy reload. */
 			if (err == -EINVAL) {
@@ -610,7 +610,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 				kfree(str);
 				goto exit_free;
 			} else
-				f->se_str = str;
+				f->lsm_str = str;
 			break;
 		case AUDIT_WATCH:
 			str = audit_unpack_string(&bufp, &remain, f->val);
@@ -754,7 +754,7 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 		case AUDIT_OBJ_LEV_LOW:
 		case AUDIT_OBJ_LEV_HIGH:
 			data->buflen += data->values[i] =
-				audit_pack_string(&bufp, f->se_str);
+				audit_pack_string(&bufp, f->lsm_str);
 			break;
 		case AUDIT_WATCH:
 			data->buflen += data->values[i] =
@@ -806,7 +806,7 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
 		case AUDIT_OBJ_TYPE:
 		case AUDIT_OBJ_LEV_LOW:
 		case AUDIT_OBJ_LEV_HIGH:
-			if (strcmp(a->fields[i].se_str, b->fields[i].se_str))
+			if (strcmp(a->fields[i].lsm_str, b->fields[i].lsm_str))
 				return 1;
 			break;
 		case AUDIT_WATCH:
@@ -862,28 +862,28 @@ out:
 	return new;
 }
 
-/* Duplicate LSM field information.  The se_rule is opaque, so must be
+/* Duplicate LSM field information.  The lsm_rule is opaque, so must be
  * re-initialized. */
 static inline int audit_dupe_lsm_field(struct audit_field *df,
 					   struct audit_field *sf)
 {
 	int ret = 0;
-	char *se_str;
+	char *lsm_str;
 
-	/* our own copy of se_str */
-	se_str = kstrdup(sf->se_str, GFP_KERNEL);
-	if (unlikely(!se_str))
+	/* our own copy of lsm_str */
+	lsm_str = kstrdup(sf->lsm_str, GFP_KERNEL);
+	if (unlikely(!lsm_str))
 		return -ENOMEM;
-	df->se_str = se_str;
+	df->lsm_str = lsm_str;
 
-	/* our own (refreshed) copy of se_rule */
-	ret = security_audit_rule_init(df->type, df->op, df->se_str,
-				       (void **)&df->se_rule);
+	/* our own (refreshed) copy of lsm_rule */
+	ret = security_audit_rule_init(df->type, df->op, df->lsm_str,
+				       (void **)&df->lsm_rule);
 	/* Keep currently invalid fields around in case they
 	 * become valid after a policy reload. */
 	if (ret == -EINVAL) {
 		printk(KERN_WARNING "audit rule for LSM \'%s\' is "
-		       "invalid\n", df->se_str);
+		       "invalid\n", df->lsm_str);
 		ret = 0;
 	}
 
@@ -930,7 +930,7 @@ static struct audit_entry *audit_dupe_rule(struct audit_krule *old,
 	new->tree = old->tree;
 	memcpy(new->fields, old->fields, sizeof(struct audit_field) * fcount);
 
-	/* deep copy this information, updating the se_rule fields, because
+	/* deep copy this information, updating the lsm_rule fields, because
 	 * the originals will all be freed when the old rule is freed. */
 	for (i = 0; i < fcount; i++) {
 		switch (new->fields[i].type) {
@@ -1762,7 +1762,7 @@ unlock_and_return:
 	return result;
 }
 
-/* This function will re-initialize the se_rule field of all applicable rules.
+/* This function will re-initialize the lsm_rule field of all applicable rules.
  * It will traverse the filter lists serarching for rules that contain LSM
  * specific filter fields.  When such a rule is found, it is copied, the
  * LSM field is re-initialized, and the old rule is replaced with the
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 8afd349..6ac71bb 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -527,14 +527,14 @@ static int audit_filter_rules(struct task_struct *tsk,
 			   match for now to avoid losing information that
 			   may be wanted.   An error message will also be
 			   logged upon error */
-			if (f->se_rule) {
+			if (f->lsm_rule) {
 				if (need_sid) {
 					security_task_getsecid(tsk, &sid);
 					need_sid = 0;
 				}
 				result = security_audit_rule_match(sid, f->type,
 				                                  f->op,
-				                                  f->se_rule,
+				                                  f->lsm_rule,
 				                                  ctx);
 			}
 			break;
@@ -545,18 +545,18 @@ static int audit_filter_rules(struct task_struct *tsk,
 		case AUDIT_OBJ_LEV_HIGH:
 			/* The above note for AUDIT_SUBJ_USER...AUDIT_SUBJ_CLR
 			   also applies here */
-			if (f->se_rule) {
+			if (f->lsm_rule) {
 				/* Find files that match */
 				if (name) {
 					result = security_audit_rule_match(
 					           name->osid, f->type, f->op,
-					           f->se_rule, ctx);
+					           f->lsm_rule, ctx);
 				} else if (ctx) {
 					for (j = 0; j < ctx->name_count; j++) {
 						if (security_audit_rule_match(
 						      ctx->names[j].osid,
 						      f->type, f->op,
-						      f->se_rule, ctx)) {
+						      f->lsm_rule, ctx)) {
 							++result;
 							break;
 						}
@@ -569,7 +569,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 					     aux = aux->next) {
 						if (aux->type == AUDIT_IPC) {
 							struct audit_aux_data_ipcctl *axi = (void *)aux;
-							if (security_audit_rule_match(axi->osid, f->type, f->op, f->se_rule, ctx)) {
+							if (security_audit_rule_match(axi->osid, f->type, f->op, f->lsm_rule, ctx)) {
 								++result;
 								break;
 							}

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

