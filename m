Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbXJIXXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbXJIXXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXJIXWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:22:38 -0400
Received: from namei.org ([69.55.235.186]:44212 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756824AbXJIXWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:22:37 -0400
Date: Wed, 10 Oct 2007 09:22:11 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 4/6] SELinux: policy selectable handling of unknown classes
 and perms
In-Reply-To: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
Message-ID: <Xine.LNX.4.64.0710100921320.14862@us.intercode.com.au>
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Allow policy to select, in much the same way as it selects MLS support, how
the kernel should handle access decisions which contain either unknown
classes or unknown permissions in known classes.  The three choices for the
policy flags are

0 - Deny unknown security access. (default)
2 - reject loading policy if it does not contain all definitions
4 - allow unknown security access

The policy's choice is exported through 2 booleans in
selinuxfs.  /selinux/deny_unknown and /selinux/reject_unknown.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/include/security.h |    2 +
 security/selinux/selinuxfs.c        |   26 ++++++++++++
 security/selinux/ss/policydb.c      |    4 ++
 security/selinux/ss/policydb.h      |    8 ++++
 security/selinux/ss/services.c      |   75 ++++++++++++++++++++++++++++++----
 5 files changed, 106 insertions(+), 9 deletions(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 83bdd4d..39337af 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -90,6 +90,8 @@ int security_sid_mls_copy(u32 sid, u32 mls_sid, u32 *new_sid);
 
 int security_get_classes(char ***classes, int *nclasses);
 int security_get_permissions(char *class, char ***perms, int *nperms);
+int security_get_reject_unknown(void);
+int security_get_allow_unknown(void);
 
 #define SECURITY_FS_USE_XATTR		1 /* use xattr */
 #define SECURITY_FS_USE_TRANS		2 /* use transition SIDs, e.g. devpts/tmpfs */
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c9e92da..f5f3e6d 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -103,6 +103,8 @@ enum sel_inos {
 	SEL_MEMBER,	/* compute polyinstantiation membership decision */
 	SEL_CHECKREQPROT, /* check requested protection, not kernel-applied one */
 	SEL_COMPAT_NET,	/* whether to use old compat network packet controls */
+	SEL_REJECT_UNKNOWN, /* export unknown reject handling to userspace */
+	SEL_DENY_UNKNOWN, /* export unknown deny handling to userspace */
 	SEL_INO_NEXT,	/* The next inode number to use */
 };
 
@@ -177,6 +179,23 @@ static const struct file_operations sel_enforce_ops = {
 	.write		= sel_write_enforce,
 };
 
+static ssize_t sel_read_handle_unknown(struct file *filp, char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	char tmpbuf[TMPBUFLEN];
+	ssize_t length;
+	ino_t ino = filp->f_path.dentry->d_inode->i_ino;
+	int handle_unknown = (ino == SEL_REJECT_UNKNOWN) ?
+		security_get_reject_unknown() : !security_get_allow_unknown();
+
+	length = scnprintf(tmpbuf, TMPBUFLEN, "%d", handle_unknown);
+	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
+}
+
+static const struct file_operations sel_handle_unknown_ops = {
+	.read		= sel_read_handle_unknown,
+};
+
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
 static ssize_t sel_write_disable(struct file * file, const char __user * buf,
 				 size_t count, loff_t *ppos)
@@ -309,6 +328,11 @@ static ssize_t sel_write_load(struct file * file, const char __user * buf,
 		length = count;
 
 out1:
+
+	printk(KERN_INFO "SELinux: policy loaded with handle_unknown=%s\n",
+	       (security_get_reject_unknown() ? "reject" :
+		(security_get_allow_unknown() ? "allow" : "deny")));
+
 	audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_POLICY_LOAD,
 		"policy loaded auid=%u",
 		audit_get_loginuid(current->audit_context));
@@ -1575,6 +1599,8 @@ static int sel_fill_super(struct super_block * sb, void * data, int silent)
 		[SEL_MEMBER] = {"member", &transaction_ops, S_IRUGO|S_IWUGO},
 		[SEL_CHECKREQPROT] = {"checkreqprot", &sel_checkreqprot_ops, S_IRUGO|S_IWUSR},
 		[SEL_COMPAT_NET] = {"compat_net", &sel_compat_net_ops, S_IRUGO|S_IWUSR},
+		[SEL_REJECT_UNKNOWN] = {"reject_unknown", &sel_handle_unknown_ops, S_IRUGO},
+		[SEL_DENY_UNKNOWN] = {"deny_unknown", &sel_handle_unknown_ops, S_IRUGO},
 		/* last one */ {""}
 	};
 	ret = simple_fill_super(sb, SELINUX_MAGIC, selinux_files);
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 5ecbad7..539828b 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -674,6 +674,8 @@ void policydb_destroy(struct policydb *p)
 	}
 	kfree(p->type_attr_map);
 
+	kfree(p->undefined_perms);
+
 	return;
 }
 
@@ -1527,6 +1529,8 @@ int policydb_read(struct policydb *p, void *fp)
 			goto bad;
 		}
 	}
+	p->reject_unknown = !!(le32_to_cpu(buf[1]) & REJECT_UNKNOWN);
+	p->allow_unknown = !!(le32_to_cpu(buf[1]) & ALLOW_UNKNOWN);
 
 	info = policydb_lookup_compat(p->policyvers);
 	if (!info) {
diff --git a/security/selinux/ss/policydb.h b/security/selinux/ss/policydb.h
index 8319d5f..844d310 100644
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -242,6 +242,10 @@ struct policydb {
 	struct ebitmap *type_attr_map;
 
 	unsigned int policyvers;
+
+	unsigned int reject_unknown : 1;
+	unsigned int allow_unknown : 1;
+	u32 *undefined_perms;
 };
 
 extern void policydb_destroy(struct policydb *p);
@@ -253,6 +257,10 @@ extern int policydb_read(struct policydb *p, void *fp);
 
 #define POLICYDB_CONFIG_MLS    1
 
+/* the config flags related to unknown classes/perms are bits 2 and 3 */
+#define REJECT_UNKNOWN	0x00000002
+#define ALLOW_UNKNOWN	0x00000004
+
 #define OBJECT_R "object_r"
 #define OBJECT_R_VAL 1
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 6100fc0..03140ed 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -292,6 +292,7 @@ static int context_struct_compute_av(struct context *scontext,
 	struct class_datum *tclass_datum;
 	struct ebitmap *sattr, *tattr;
 	struct ebitmap_node *snode, *tnode;
+	const struct selinux_class_perm *kdefs = &selinux_class_perm;
 	unsigned int i, j;
 
 	/*
@@ -305,13 +306,6 @@ static int context_struct_compute_av(struct context *scontext,
 		    tclass <= SECCLASS_NETLINK_DNRT_SOCKET)
 			tclass = SECCLASS_NETLINK_SOCKET;
 
-	if (!tclass || tclass > policydb.p_classes.nprim) {
-		printk(KERN_ERR "security_compute_av:  unrecognized class %d\n",
-		       tclass);
-		return -EINVAL;
-	}
-	tclass_datum = policydb.class_val_to_struct[tclass - 1];
-
 	/*
 	 * Initialize the access vectors to the default values.
 	 */
@@ -322,6 +316,36 @@ static int context_struct_compute_av(struct context *scontext,
 	avd->seqno = latest_granting;
 
 	/*
+	 * Check for all the invalid cases.
+	 * - tclass 0
+	 * - tclass > policy and > kernel
+	 * - tclass > policy but is a userspace class
+	 * - tclass > policy but we do not allow unknowns
+	 */
+	if (unlikely(!tclass))
+		goto inval_class;
+	if (unlikely(tclass > policydb.p_classes.nprim))
+		if (tclass > kdefs->cts_len ||
+		    !kdefs->class_to_string[tclass - 1] ||
+		    !policydb.allow_unknown)
+			goto inval_class;
+
+	/*
+	 * Kernel class and we allow unknown so pad the allow decision
+	 * the pad will be all 1 for unknown classes.
+	 */
+	if (tclass <= kdefs->cts_len && policydb.allow_unknown)
+		avd->allowed = policydb.undefined_perms[tclass - 1];
+
+	/*
+	 * Not in policy. Since decision is completed (all 1 or all 0) return.
+	 */
+	if (unlikely(tclass > policydb.p_classes.nprim))
+		return 0;
+
+	tclass_datum = policydb.class_val_to_struct[tclass - 1];
+
+	/*
 	 * If a specific type enforcement rule was defined for
 	 * this permission check, then use it.
 	 */
@@ -387,6 +411,10 @@ static int context_struct_compute_av(struct context *scontext,
 	}
 
 	return 0;
+
+inval_class:
+	printk(KERN_ERR "%s:  unrecognized class %d\n", __FUNCTION__, tclass);
+	return -EINVAL;
 }
 
 static int security_validtrans_handle_fail(struct context *ocontext,
@@ -1054,6 +1082,13 @@ static int validate_classes(struct policydb *p)
 	const char *def_class, *def_perm, *pol_class;
 	struct symtab *perms;
 
+	if (p->allow_unknown) {
+		u32 num_classes = kdefs->cts_len;
+		p->undefined_perms = kcalloc(num_classes, sizeof(u32), GFP_KERNEL);
+		if (!p->undefined_perms)
+			return -ENOMEM;
+	}
+
 	for (i = 1; i < kdefs->cts_len; i++) {
 		def_class = kdefs->class_to_string[i];
 		if (!def_class)
@@ -1062,6 +1097,10 @@ static int validate_classes(struct policydb *p)
 			printk(KERN_INFO
 			       "security:  class %s not defined in policy\n",
 			       def_class);
+			if (p->reject_unknown)
+				return -EINVAL;
+			if (p->allow_unknown)
+				p->undefined_perms[i-1] = ~0U;
 			continue;
 		}
 		pol_class = p->p_class_val_to_name[i-1];
@@ -1087,12 +1126,16 @@ static int validate_classes(struct policydb *p)
 			printk(KERN_INFO
 			       "security:  permission %s in class %s not defined in policy\n",
 			       def_perm, pol_class);
+			if (p->reject_unknown)
+				return -EINVAL;
+			if (p->allow_unknown)
+				p->undefined_perms[class_val-1] |= perm_val;
 			continue;
 		}
 		perdatum = hashtab_search(perms->table, def_perm);
 		if (perdatum == NULL) {
 			printk(KERN_ERR
-			       "security:  permission %s in class %s not found in policy\n",
+			       "security:  permission %s in class %s not found in policy, bad policy\n",
 			       def_perm, pol_class);
 			return -EINVAL;
 		}
@@ -1130,12 +1173,16 @@ static int validate_classes(struct policydb *p)
 				printk(KERN_INFO
 				       "security:  permission %s in class %s not defined in policy\n",
 				       def_perm, pol_class);
+				if (p->reject_unknown)
+					return -EINVAL;
+				if (p->allow_unknown)
+					p->undefined_perms[class_val-1] |= (1 << j);
 				continue;
 			}
 			perdatum = hashtab_search(perms->table, def_perm);
 			if (perdatum == NULL) {
 				printk(KERN_ERR
-				       "security:  permission %s in class %s not found in policy\n",
+				       "security:  permission %s in class %s not found in policy, bad policy\n",
 				       def_perm, pol_class);
 				return -EINVAL;
 			}
@@ -2102,6 +2149,16 @@ err:
 	return rc;
 }
 
+int security_get_reject_unknown(void)
+{
+	return policydb.reject_unknown;
+}
+
+int security_get_allow_unknown(void)
+{
+	return policydb.allow_unknown;
+}
+
 struct selinux_audit_rule {
 	u32 au_seqno;
 	struct context au_ctxt;
-- 
1.5.2.4

