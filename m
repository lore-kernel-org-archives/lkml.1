Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0CJRYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:24:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38554 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab0CJRYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:24:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Zqz6xpL5R9n6QEw9TyMZtc3/E+cxe9NpLSgUSaKC9Y2T595chGTqU22NV2OzAUBgBh
         Co4yJPnxSur7QJVR4um3SZg4p6s6IX0F26ebfvfOHB18mXXE7ecwRYpZjiL3WKwdQMbt
         viVzAY/uNCrvG5ejmr/nmWPyXd6A8nP/P/EqI=
MIME-Version: 1.0
Date: Wed, 10 Mar 2010 18:24:50 +0100
Message-ID: <58f704b21003100924x5ff296a1tb54a96b18ebaf20b@mail.gmail.com>
Subject: [PATCH] audit keys: support for multiple audit keys
From: Juraj Hlista <juro.hlista@gmail.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, mitr@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An audit rule can have more than 1 key, the keys can be of
different types (only AUDIT_FILTERKEY for now)

For example, it is possible to create a rule such as:
    auditctl -a exit,always -F path=/file -F key=k1 -F key=k2 -F key=k3


Kernel patch:
---
 include/linux/audit.h |   11 ++-
 kernel/audit.c        |   12 ++--
 kernel/audit_tree.c   |    4 +-
 kernel/audit_watch.c  |    5 +-
 kernel/auditfilter.c  |  167 +++++++++++++++++++++++++++++++++++--------------
 kernel/auditsc.c      |   81 ++++++++++++++++++------
 6 files changed, 204 insertions(+), 76 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index f391d45..bc77a9f 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -152,10 +152,12 @@
 #define AUDIT_POSSIBLE 1	/* Build context if rule matches  */
 #define AUDIT_ALWAYS   2	/* Generate audit record if rule matches */

+
 /* Rule structure sizes -- if these change, different AUDIT_ADD and
  * AUDIT_LIST commands must be implemented. */
 #define AUDIT_MAX_FIELDS   64
 #define AUDIT_MAX_KEY_LEN  256
+#define AUDIT_MAX_KEYS	   8
 #define AUDIT_BITMASK_SIZE 64
 #define AUDIT_WORD(nr) ((__u32)((nr)/32))
 #define AUDIT_BIT(nr)  (1 << ((nr) - AUDIT_WORD(nr)*32))
@@ -384,8 +386,9 @@ struct audit_krule {
 	u32			action;
 	u32			mask[AUDIT_BITMASK_SIZE];
 	u32			buflen; /* for data alloc on list rules */
+	u32			keyfield_count;
 	u32			field_count;
-	char			*filterkey; /* ties events to rules */
+	struct audit_field	*keyfields;
 	struct audit_field	*fields;
 	struct audit_field	*arch_f; /* quick access to arch field */
 	struct audit_field	*inode_f; /* quick access to an inode field */
@@ -598,8 +601,8 @@ extern void		    audit_log_untrustedstring(struct
audit_buffer *ab,
 extern void		    audit_log_d_path(struct audit_buffer *ab,
 					     const char *prefix,
 					     struct path *path);
-extern void		    audit_log_key(struct audit_buffer *ab,
-					  char *key);
+extern void		    audit_log_key(struct audit_buffer *ab, int type,
+					 	char *key);
 extern void		    audit_log_lost(const char *message);
 extern int		    audit_update_lsm_rules(void);

@@ -622,7 +625,7 @@ extern int audit_enabled;
 #define audit_log_n_untrustedstring(a,n,s) do { ; } while (0)
 #define audit_log_untrustedstring(a,s) do { ; } while (0)
 #define audit_log_d_path(b, p, d) do { ; } while (0)
-#define audit_log_key(b, k) do { ; } while (0)
+#define audit_log_key(b, t, k) do { ; } while (0)
 #define audit_enabled 0
 #endif
 #endif
diff --git a/kernel/audit.c b/kernel/audit.c
index c3b6cb5..18090c0 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1440,13 +1440,15 @@ void audit_log_d_path(struct audit_buffer *ab,
const char *prefix,
 	kfree(pathname);
 }

-void audit_log_key(struct audit_buffer *ab, char *key)
+void audit_log_key(struct audit_buffer *ab, int type, char *key)
 {
-	audit_log_format(ab, " key=");
-	if (key)
+	if (!key) {
+		audit_log_format(ab, " key=(null)");
+		return;
+	} else if (type == AUDIT_FILTERKEY) {
+		audit_log_format(ab, " key=");
 		audit_log_untrustedstring(ab, key);
-	else
-		audit_log_format(ab, "(null)");
+	}
 }

 /**
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index f671d6b..f45c4d0 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -454,6 +454,7 @@ static void kill_rules(struct audit_tree *tree)
 	struct audit_krule *rule, *next;
 	struct audit_entry *entry;
 	struct audit_buffer *ab;
+	int i;

 	list_for_each_entry_safe(rule, next, &tree->rules, rlist) {
 		entry = container_of(rule, struct audit_entry, rule);
@@ -466,7 +467,8 @@ static void kill_rules(struct audit_tree *tree)
 			audit_log_string(ab, "remove rule");
 			audit_log_format(ab, " dir=");
 			audit_log_untrustedstring(ab, rule->tree->pathname);
-			audit_log_key(ab, rule->filterkey);
+			for (i = 0; i < rule->keyfield_count; i++)
+				audit_log_key(ab, rule->keyfields[i].type, rule->keyfields[i].lsm_str);
 			audit_log_format(ab, " list=%d res=1", rule->listnr);
 			audit_log_end(ab);
 			rule->tree = NULL;
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 31f9be8..5a306e5 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -240,6 +240,8 @@ static void audit_watch_log_rule_change(struct
audit_krule *r, struct audit_watc
 {
 	if (audit_enabled) {
 		struct audit_buffer *ab;
+		int i;
+
 		ab = audit_log_start(NULL, GFP_NOFS, AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, "auid=%u ses=%u op=",
 				 audit_get_loginuid(current),
@@ -247,7 +249,8 @@ static void audit_watch_log_rule_change(struct
audit_krule *r, struct audit_watc
 		audit_log_string(ab, op);
 		audit_log_format(ab, " path=");
 		audit_log_untrustedstring(ab, w->path);
-		audit_log_key(ab, r->filterkey);
+		for (i = 0; i < r->keyfield_count; i++)
+			audit_log_key(ab, r->keyfields[i].type, r->keyfields[i].lsm_str);
 		audit_log_format(ab, " list=%d res=1", r->listnr);
 		audit_log_end(ab);
 	}
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f5e4cae..79c4978 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -74,14 +74,24 @@ static inline void audit_free_rule(struct audit_entry *e)
 	/* some rules don't have associated watches */
 	if (erule->watch)
 		audit_put_watch(erule->watch);
-	if (erule->fields)
+	if (erule->fields) {
 		for (i = 0; i < erule->field_count; i++) {
 			struct audit_field *f = &erule->fields[i];
 			kfree(f->lsm_str);
 			security_audit_rule_free(f->lsm_rule);
 		}
+	}
 	kfree(erule->fields);
-	kfree(erule->filterkey);
+
+	if (erule->keyfields) {
+		for (i = 0; i < erule->keyfield_count; i++) {
+			struct audit_field *f = &erule->keyfields[i];
+			kfree(f->lsm_str);
+			security_audit_rule_free(f->lsm_rule);
+		}
+	}
+	kfree(erule->keyfields);
+
 	kfree(e);
 }

@@ -92,10 +102,11 @@ void audit_free_rule_rcu(struct rcu_head *head)
 }

 /* Initialize an audit filterlist entry. */
-static inline struct audit_entry *audit_init_entry(u32 field_count)
+static inline struct audit_entry *audit_init_entry(u32 field_count,
u32 keyfield_count)
 {
 	struct audit_entry *entry;
 	struct audit_field *fields;
+	struct audit_field *keyfields;

 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (unlikely(!entry))
@@ -108,6 +119,14 @@ static inline struct audit_entry
*audit_init_entry(u32 field_count)
 	}
 	entry->rule.fields = fields;

+	keyfields = kzalloc(sizeof(*keyfields) * keyfield_count, GFP_KERNEL);
+	if (unlikely(!keyfields)) {
+		kfree(entry);
+		kfree(fields);
+		return NULL;
+	}
+	entry->rule.keyfields = keyfields;
+
 	return entry;
 }

@@ -151,6 +170,15 @@ static inline int audit_to_inode(struct audit_krule *krule,
 	return 0;
 }

+static inline int audit_to_key(struct audit_krule *krule,
+			       struct audit_field *f)
+{
+	if (krule->listnr != AUDIT_FILTER_EXIT ||
+	    f->op != Audit_equal)
+		return -EINVAL;
+
+	return 0;
+}
 static __u32 *classes[AUDIT_SYSCALL_CLASSES];

 int __init audit_register_class(int class, unsigned *list)
@@ -227,6 +255,7 @@ static inline struct audit_entry
*audit_to_entry_common(struct audit_rule *rule)
 {
 	unsigned listnr;
 	struct audit_entry *entry;
+	int kf_count = 0;
 	int i, err;

 	err = -EINVAL;
@@ -252,15 +281,24 @@ static inline struct audit_entry
*audit_to_entry_common(struct audit_rule *rule)
 	if (rule->field_count > AUDIT_MAX_FIELDS)
 		goto exit_err;

+	for (i = 0; i < rule->field_count; i++) {
+		if (rule->fields[i] == AUDIT_FILTERKEY)
+			kf_count++;
+	}
+
+	if (kf_count > AUDIT_MAX_KEYS)
+		goto exit_err;
+
 	err = -ENOMEM;
-	entry = audit_init_entry(rule->field_count);
+	entry = audit_init_entry(rule->field_count - kf_count, kf_count);
 	if (!entry)
 		goto exit_err;

 	entry->rule.flags = rule->flags & AUDIT_FILTER_PREPEND;
 	entry->rule.listnr = listnr;
 	entry->rule.action = rule->action;
-	entry->rule.field_count = rule->field_count;
+	entry->rule.field_count = rule->field_count - kf_count;
+	entry->rule.keyfield_count = kf_count;

 	for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
 		entry->rule.mask[i] = rule->mask[i];
@@ -411,10 +449,11 @@ static struct audit_entry
*audit_data_to_entry(struct audit_rule_data *data,
 					       size_t datasz)
 {
 	int err = 0;
-	struct audit_entry *entry;
+	struct audit_entry *entry = NULL;
 	void *bufp;
 	size_t remain = datasz - sizeof(struct audit_rule_data);
 	int i;
+	int f_count = 0, kf_count = 0;
 	char *str;

 	entry = audit_to_entry_common((struct audit_rule *)data);
@@ -424,7 +463,11 @@ static struct audit_entry
*audit_data_to_entry(struct audit_rule_data *data,
 	bufp = data->buf;
 	entry->rule.vers_ops = 2;
 	for (i = 0; i < data->field_count; i++) {
-		struct audit_field *f = &entry->rule.fields[i];
+		struct audit_field *f = NULL;
+		if (data->fields[i] == AUDIT_FILTERKEY)
+			f = &entry->rule.keyfields[kf_count++];
+		else
+			f = &entry->rule.fields[f_count++];

 		err = -EINVAL;

@@ -522,13 +565,20 @@ static struct audit_entry
*audit_data_to_entry(struct audit_rule_data *data,
 			break;
 		case AUDIT_FILTERKEY:
 			err = -EINVAL;
-			if (entry->rule.filterkey || f->val > AUDIT_MAX_KEY_LEN)
+			if (f->val > AUDIT_MAX_KEY_LEN)
 				goto exit_free;
 			str = audit_unpack_string(&bufp, &remain, f->val);
 			if (IS_ERR(str))
 				goto exit_free;
 			entry->rule.buflen += f->val;
-			entry->rule.filterkey = str;
+
+			err = audit_to_key(&entry->rule, f);
+			if (err) {
+				kfree(str);
+				goto exit_free;
+			} else {
+				f->lsm_str = str;
+			}
 			break;
 		case AUDIT_PERM:
 			if (f->val & ~15)
@@ -565,6 +615,18 @@ static inline size_t audit_pack_string(void
**bufp, const char *str)
 	return len;
 }

+
+static inline void audit_op_translate(struct audit_krule *krule,
struct audit_rule *rule, int j)
+{
+	if (krule->vers_ops == 1) {
+		if (krule->fields[j].op == Audit_not_equal)
+				rule->fields[j] |= AUDIT_NEGATE;
+		} else {
+			rule->fields[j] |= audit_ops[krule->fields[j].op];
+	}
+}
+
+
 /* Translate kernel rule respresentation to struct audit_rule.
  * Exists for backward compatibility with userspace. */
 static struct audit_rule *audit_krule_to_rule(struct audit_krule *krule)
@@ -578,19 +640,20 @@ static struct audit_rule
*audit_krule_to_rule(struct audit_krule *krule)

 	rule->flags = krule->flags | krule->listnr;
 	rule->action = krule->action;
-	rule->field_count = krule->field_count;
-	for (i = 0; i < rule->field_count; i++) {
+	rule->field_count = krule->field_count + krule->keyfield_count;
+	for (i = 0; i < krule->field_count; i++) {
 		rule->values[i] = krule->fields[i].val;
 		rule->fields[i] = krule->fields[i].type;
-
-		if (krule->vers_ops == 1) {
-			if (krule->fields[i].op == Audit_not_equal)
-				rule->fields[i] |= AUDIT_NEGATE;
-		} else {
-			rule->fields[i] |= audit_ops[krule->fields[i].op];
-		}
+		audit_op_translate(krule, rule, i);
 	}
-	for (i = 0; i < AUDIT_BITMASK_SIZE; i++) rule->mask[i] = krule->mask[i];
+	for (i = 0; i < krule->keyfield_count; i++) {
+		rule->values[i] = krule->keyfields[i].val;
+		rule->fields[i] = krule->keyfields[i].type;
+		audit_op_translate(krule, rule, i);
+	}
+
+	for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
+		rule->mask[i] = krule->mask[i];

 	return rule;
 }
@@ -600,7 +663,7 @@ static struct audit_rule_data
*audit_krule_to_data(struct audit_krule *krule)
 {
 	struct audit_rule_data *data;
 	void *bufp;
-	int i;
+	int i, j;

 	data = kmalloc(sizeof(*data) + krule->buflen, GFP_KERNEL);
 	if (unlikely(!data))
@@ -609,9 +672,9 @@ static struct audit_rule_data
*audit_krule_to_data(struct audit_krule *krule)

 	data->flags = krule->flags | krule->listnr;
 	data->action = krule->action;
-	data->field_count = krule->field_count;
+	data->field_count = krule->field_count + krule->keyfield_count;
 	bufp = data->buf;
-	for (i = 0; i < data->field_count; i++) {
+	for (i = 0; i < krule->field_count; i++) {
 		struct audit_field *f = &krule->fields[i];

 		data->fields[i] = f->type;
@@ -640,15 +703,20 @@ static struct audit_rule_data
*audit_krule_to_data(struct audit_krule *krule)
 				audit_pack_string(&bufp,
 						  audit_tree_path(krule->tree));
 			break;
-		case AUDIT_FILTERKEY:
-			data->buflen += data->values[i] =
-				audit_pack_string(&bufp, krule->filterkey);
-			break;
 		default:
 			data->values[i] = f->val;
 		}
 	}
-	for (i = 0; i < AUDIT_BITMASK_SIZE; i++) data->mask[i] = krule->mask[i];
+	j = i;
+	for (i = 0; i < krule->keyfield_count; i++, j++) {
+		struct audit_field *f = &krule->keyfields[i];
+
+		data->fields[j] = f->type;
+		data->fieldflags[j] = audit_ops[f->op];
+		data->buflen += data->values[j] = audit_pack_string(&bufp, f->lsm_str);
+	}
+	for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
+		data->mask[i] = krule->mask[i];

 	return data;
 }
@@ -662,7 +730,8 @@ static int audit_compare_rule(struct audit_krule
*a, struct audit_krule *b)
 	if (a->flags != b->flags ||
 	    a->listnr != b->listnr ||
 	    a->action != b->action ||
-	    a->field_count != b->field_count)
+	    a->field_count != b->field_count ||
+	    a->keyfield_count != b->keyfield_count)
 		return 1;

 	for (i = 0; i < a->field_count; i++) {
@@ -694,17 +763,17 @@ static int audit_compare_rule(struct audit_krule
*a, struct audit_krule *b)
 				   audit_tree_path(b->tree)))
 				return 1;
 			break;
-		case AUDIT_FILTERKEY:
-			/* both filterkeys exist based on above type compare */
-			if (strcmp(a->filterkey, b->filterkey))
-				return 1;
-			break;
 		default:
 			if (a->fields[i].val != b->fields[i].val)
 				return 1;
 		}
 	}
-
+	for (i = 0; i < a->keyfield_count; i++) {
+		if (a->keyfields[i].type != b->keyfields[i].type ||
+		    a->keyfields[i].op != b->keyfields[i].op ||
+		    strcmp(a->keyfields[i].lsm_str, b->keyfields[i].lsm_str))
+			return 1;
+	}
 	for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
 		if (a->mask[i] != b->mask[i])
 			return 1;
@@ -748,13 +817,13 @@ static inline int audit_dupe_lsm_field(struct
audit_field *df,
  * the initial copy. */
 struct audit_entry *audit_dupe_rule(struct audit_krule *old)
 {
-	u32 fcount = old->field_count;
+	u32 f_count = old->field_count;
+	u32 kf_count = old->keyfield_count;
 	struct audit_entry *entry;
 	struct audit_krule *new;
-	char *fk;
 	int i, err = 0;

-	entry = audit_init_entry(fcount);
+	entry = audit_init_entry(f_count, kf_count);
 	if (unlikely(!entry))
 		return ERR_PTR(-ENOMEM);

@@ -768,6 +837,7 @@ struct audit_entry *audit_dupe_rule(struct audit_krule *old)
 	new->prio = old->prio;
 	new->buflen = old->buflen;
 	new->inode_f = old->inode_f;
+	new->keyfield_count = old->keyfield_count;
 	new->field_count = old->field_count;

 	/*
@@ -778,11 +848,12 @@ struct audit_entry *audit_dupe_rule(struct
audit_krule *old)
 	 * the beginning of list scan.
 	 */
 	new->tree = old->tree;
-	memcpy(new->fields, old->fields, sizeof(struct audit_field) * fcount);
+	memcpy(new->keyfields, old->keyfields, sizeof(struct audit_field) * kf_count);
+	memcpy(new->fields, old->fields, sizeof(struct audit_field) * f_count);

 	/* deep copy this information, updating the lsm_rule fields, because
 	 * the originals will all be freed when the old rule is freed. */
-	for (i = 0; i < fcount; i++) {
+	for (i = 0; i < f_count; i++) {
 		switch (new->fields[i].type) {
 		case AUDIT_SUBJ_USER:
 		case AUDIT_SUBJ_ROLE:
@@ -797,19 +868,21 @@ struct audit_entry *audit_dupe_rule(struct
audit_krule *old)
 			err = audit_dupe_lsm_field(&new->fields[i],
 						       &old->fields[i]);
 			break;
-		case AUDIT_FILTERKEY:
-			fk = kstrdup(old->filterkey, GFP_KERNEL);
-			if (unlikely(!fk))
-				err = -ENOMEM;
-			else
-				new->filterkey = fk;
 		}
 		if (err) {
 			audit_free_rule(entry);
 			return ERR_PTR(err);
 		}
 	}
+	for (i = 0; i < kf_count; i++) {
+		err = audit_dupe_lsm_field(&new->keyfields[i],
+					       &old->keyfields[i]);

+		if (err) {
+			audit_free_rule(entry);
+			return ERR_PTR(err);
+		}
+	}
 	if (old->watch) {
 		audit_get_watch(old->watch);
 		new->watch = old->watch;
@@ -1053,6 +1126,7 @@ static void audit_log_rule_change(uid_t
loginuid, u32 sessionid, u32 sid,
 				  int res)
 {
 	struct audit_buffer *ab;
+	int i;

 	if (!audit_enabled)
 		return;
@@ -1073,7 +1147,8 @@ static void audit_log_rule_change(uid_t
loginuid, u32 sessionid, u32 sid,
 	}
 	audit_log_format(ab, " op=");
 	audit_log_string(ab, action);
-	audit_log_key(ab, rule->filterkey);
+	for (i = 0; i < rule->keyfield_count; i++)
+		audit_log_key(ab, rule->keyfields[i].type, rule->keyfields[i].lsm_str);
 	audit_log_format(ab, " list=%d res=%d", rule->listnr, res);
 	audit_log_end(ab);
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f286982..1760dcd 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -161,6 +161,11 @@ struct audit_tree_refs {
 	struct audit_chunk *c[31];
 };

+struct audit_keys {
+	int type;
+	char *key;
+};
+
 /* The per-task audit context. */
 struct audit_context {
 	int		    dummy;	/* must be the first element */
@@ -175,7 +180,8 @@ struct audit_context {
 	int		    return_valid; /* return code is valid */
 	int		    name_count;
 	struct audit_names  names[AUDIT_NAMES];
-	char *		    filterkey;	/* key for rule that triggered record */
+	int		    key_count;
+	struct audit_keys   keys[AUDIT_MAX_KEYS];
 	struct path	    pwd;
 	struct audit_context *previous; /* For nested syscalls */
 	struct audit_aux_data *aux;
@@ -641,9 +647,14 @@ static int audit_filter_rules(struct task_struct *tsk,
 	if (ctx) {
 		if (rule->prio <= ctx->prio)
 			return 0;
-		if (rule->filterkey) {
-			kfree(ctx->filterkey);
-			ctx->filterkey = kstrdup(rule->filterkey, GFP_ATOMIC);
+		ctx->key_count = rule->keyfield_count;
+		for (i = 0; i < ctx->key_count; i++) {
+			ctx->keys[i].type = rule->keyfields[i].type;
+			if (rule->keyfields[i].lsm_str) {
+				if (ctx->keys[i].key)
+					kfree(ctx->keys[i].key);
+			}
+			ctx->keys[i].key = kstrdup(rule->keyfields[i].lsm_str, GFP_ATOMIC);
 		}
 		ctx->prio = rule->prio;
 	}
@@ -659,16 +670,24 @@ static int audit_filter_rules(struct task_struct *tsk,
  * completely disabled for this task.  Since we only have the task
  * structure at this point, we can only check uid and gid.
  */
-static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
+static enum audit_state audit_filter_task(struct task_struct *tsk,
struct audit_keys *k, int *count)
 {
 	struct audit_entry *e;
 	enum audit_state   state;
+	int i, key_count;

 	rcu_read_lock();
 	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_TASK], list) {
 		if (audit_filter_rules(tsk, &e->rule, NULL, NULL, &state)) {
-			if (state == AUDIT_RECORD_CONTEXT)
-				*key = kstrdup(e->rule.filterkey, GFP_ATOMIC);
+			if (state == AUDIT_RECORD_CONTEXT) {
+				key_count = e->rule.keyfield_count;
+
+				for (i = 0; key_count; i++) {
+					k[i].type = e->rule.keyfields[i].type;
+					k[i].key = kstrdup(e->rule.keyfields[i].lsm_str, GFP_ATOMIC);
+				}
+				*count = key_count;
+			}
 			rcu_read_unlock();
 			return state;
 		}
@@ -822,6 +841,16 @@ static inline void audit_free_names(struct
audit_context *context)
 	context->pwd.mnt = NULL;
 }

+static inline void audit_free_keys(struct audit_context *context)
+{
+	int i;
+
+	for (i = 0; i < context->key_count; i++) {
+		kfree(context->keys[i].key);
+		context->keys[i].key = NULL;
+	}
+}
+
 static inline void audit_free_aux(struct audit_context *context)
 {
 	struct audit_aux_data *aux;
@@ -868,21 +897,29 @@ int audit_alloc(struct task_struct *tsk)
 {
 	struct audit_context *context;
 	enum audit_state     state;
-	char *key = NULL;
+	struct audit_keys keys[AUDIT_MAX_KEYS];
+	int i, key_count = 0;
+
+	memset(&keys, 0, AUDIT_MAX_KEYS * sizeof(struct audit_keys));

 	if (likely(!audit_ever_enabled))
 		return 0; /* Return if not auditing. */

-	state = audit_filter_task(tsk, &key);
+	state = audit_filter_task(tsk, keys, &key_count);
 	if (likely(state == AUDIT_DISABLED))
 		return 0;

 	if (!(context = audit_alloc_context(state))) {
-		kfree(key);
+		for (i = 0; i < key_count; i++)
+			kfree(keys[i].key);
 		audit_log_lost("out of memory in audit_alloc");
 		return -ENOMEM;
 	}
-	context->filterkey = key;
+	context->key_count = key_count;
+	for (i = 0; i < key_count; i++) {
+		context->keys[i].type = keys[i].type;
+		context->keys[i].key = keys[i].key;
+	}

 	tsk->audit_context  = context;
 	set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
@@ -907,7 +944,7 @@ static inline void audit_free_context(struct
audit_context *context)
 		unroll_tree_refs(context, NULL, 0);
 		free_tree_refs(context);
 		audit_free_aux(context);
-		kfree(context->filterkey);
+		audit_free_keys(context);
 		kfree(context->sockaddr);
 		kfree(context);
 		context  = previous;
@@ -1369,9 +1406,12 @@ static void audit_log_exit(struct audit_context
*context, struct task_struct *ts
 		  context->egid, context->sgid, context->fsgid, tty,
 		  tsk->sessionid);

-
 	audit_log_task_info(ab, tsk);
-	audit_log_key(ab, context->filterkey);
+
+	for (i = 0; i < context->key_count; i++)
+		audit_log_key(ab, context->keys[i].type, context->keys[i].key);
+	if (!i)
+		audit_log_key(ab, 0, NULL);
 	audit_log_end(ab);

 	for (aux = context->aux; aux; aux = aux->next) {
@@ -1646,6 +1686,8 @@ void audit_finish_fork(struct task_struct *child)
 {
 	struct audit_context *ctx = current->audit_context;
 	struct audit_context *p = child->audit_context;
+	int i;
+
 	if (!p || !ctx)
 		return;
 	if (!ctx->in_syscall || ctx->current_state != AUDIT_RECORD_CONTEXT)
@@ -1656,7 +1698,10 @@ void audit_finish_fork(struct task_struct *child)
 	p->ctime = ctx->ctime;
 	p->dummy = ctx->dummy;
 	p->in_syscall = ctx->in_syscall;
-	p->filterkey = kstrdup(ctx->filterkey, GFP_KERNEL);
+	for (i = 0; i < ctx->key_count; i++) {
+		p->keys[i].type = ctx->keys[i].type;
+		p->keys[i].key = kstrdup(ctx->keys[i].key, GFP_KERNEL);
+	}
 	p->ppid = current->pid;
 	p->prio = ctx->prio;
 	p->current_state = ctx->current_state;
@@ -1708,10 +1753,8 @@ void audit_syscall_exit(int valid, long return_code)
 		context->sockaddr_len = 0;
 		context->type = 0;
 		context->fds[0] = -1;
-		if (context->state != AUDIT_RECORD_CONTEXT) {
-			kfree(context->filterkey);
-			context->filterkey = NULL;
-		}
+		if (context->state != AUDIT_RECORD_CONTEXT)
+			audit_free_keys(context);
 		tsk->audit_context = context;
 	}
 }
-- 
1.6.4.4





User space audit patch:

Index: src/auditctl.c
===================================================================
--- src/auditctl.c	(revision 392)
+++ src/auditctl.c	(working copy)
@@ -73,6 +73,7 @@
 /* External vars */
 extern int audit_archadded;
 extern int audit_syscalladded;
+extern int audit_keyadded;
 extern unsigned int audit_elf;
 extern int audit_permadded;

@@ -84,6 +85,7 @@
 {
 	list_requested = 0;
 	audit_syscalladded = 0;
+	audit_keyadded = 0;
 	audit_permadded = 0;
 	audit_archadded = 0;
 	audit_elf = 0;
@@ -818,6 +820,9 @@
 							AUDIT_MAX_KEY_LEN) {
 			fprintf(stderr, "key option exceeds size limit\n");
 			retval = -1;
+		} else if (audit_keyadded >= AUDIT_MAX_KEYS) {
+			fprintf(stderr, "too many kyes (ctl)\n");
+			retval = -1;
 		} else {
 			if (strncmp(optarg, "ids-", 4) == 0) {
 				if (check_ids_key(optarg)) {
@@ -834,6 +839,7 @@
 			}
 			strncat(key, optarg, keylen);
 			keylen = AUDIT_MAX_KEY_LEN - strlen(key);
+			audit_keyadded++;
 		}
 		break;
 	case 'p':
Index: lib/libaudit.h
===================================================================
--- lib/libaudit.h	(revision 392)
+++ lib/libaudit.h	(working copy)
@@ -203,6 +203,9 @@
 /* This is related to the filterkey patch */
 #define AUDIT_KEY_SEPARATOR 0x01

+/* Max number of audit keys */
+#define AUDIT_MAX_KEYS		8
+
 /* These are used in filter control */
 #define AUDIT_FILTER_EXCLUDE	AUDIT_FILTER_TYPE
 #define AUDIT_FILTER_MASK	0x07	/* Mask to get actual filter */
Index: lib/errormsg.h
===================================================================
--- lib/errormsg.h	(revision 392)
+++ lib/errormsg.h	(working copy)
@@ -54,5 +54,6 @@
     { -19,    0,    "Key field needs a watch or syscall given prior to it" },
     { -20,    2,    "-F missing value after operation for" },
     { -21,    2,    "-F value should be number for" },
-    { -22,    2,    "-F missing field name before operator for" }
+    { -22,    2,    "-F missing field name before operator for" },
+    { -23,    2,    "too many keys" }
 };
Index: lib/libaudit.c
===================================================================
--- lib/libaudit.c	(revision 392)
+++ lib/libaudit.c	(working copy)
@@ -80,6 +80,7 @@
 int audit_permadded hidden = 0;
 int audit_archadded hidden = 0;
 int audit_syscalladded hidden = 0;
+int audit_keyadded hidden = 0;
 unsigned int audit_elf hidden = 0U;
 static struct libaudit_conf config;

@@ -943,14 +944,18 @@
 		case AUDIT_SUBJ_SEN:
 		case AUDIT_SUBJ_CLR:
 		case AUDIT_FILTERKEY:
-			if (field == AUDIT_FILTERKEY && !(audit_syscalladded || audit_permadded))
-                                return -19;
 			vlen = strlen(v);
-			if (field == AUDIT_FILTERKEY &&
-					vlen > AUDIT_MAX_KEY_LEN)
+			if (field == AUDIT_FILTERKEY) {
+				if (!(audit_syscalladded || audit_permadded))
+	                                return -19;
+				else if (vlen > AUDIT_MAX_KEY_LEN)
+					return -11;
+				else if (audit_keyadded >= AUDIT_MAX_KEYS)
+					return -23;
+				audit_keyadded++;
+			} else if (vlen > PATH_MAX) {
 				return -11;
-			else if (vlen > PATH_MAX)
-				return -11;
+			}
 			rule->values[rule->field_count] = vlen;
 			offset = rule->buflen;
 			rule->buflen += vlen;
