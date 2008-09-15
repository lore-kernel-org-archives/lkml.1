Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYIOVLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYIOVLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYIOVG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:06:56 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64425 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbYIOVG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:28 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 05/14] SELinux: Add new labeling type native labels
Date: Mon, 15 Sep 2008 16:41:09 -0400
Message-Id: <1221511278-28051-6-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There currently doesn't exist a labeling type that is adequate for use with
labeled NFS. Since NFS doesn't really support xattrs we can't use the use xattr
labeling behavior. For this we developed a new labeling type. The native
labeling type is used solely by NFS to ensure NFS inodes are labeled at runtime
by the NFS code instead of relying on the SELinux security server on the client
end.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 security/selinux/hooks.c            |   74 +++++++++++++++++++++++++++-------
 security/selinux/include/security.h |    4 ++
 security/selinux/ss/policydb.c      |    5 ++-
 3 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 248fa5c..78e79d3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -88,7 +88,7 @@
 #define XATTR_SELINUX_SUFFIX "selinux"
 #define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
 
-#define NUM_SEL_MNT_OPTS 4
+#define NUM_SEL_MNT_OPTS 5
 
 extern unsigned int policydb_loaded_version;
 extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
@@ -300,13 +300,14 @@ extern int ss_initialized;
 
 /* The file system's label must be initialized prior to use. */
 
-static char *labeling_behaviors[6] = {
+static char *labeling_behaviors[7] = {
 	"uses xattr",
 	"uses transition SIDs",
 	"uses task SIDs",
 	"uses genfs_contexts",
 	"not configured for labeling",
 	"uses mountpoint labeling",
+	"uses native labels",
 };
 
 static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dentry);
@@ -322,6 +323,7 @@ enum {
 	Opt_fscontext = 2,
 	Opt_defcontext = 3,
 	Opt_rootcontext = 4,
+	Opt_native_labels = 5,
 };
 
 static match_table_t tokens = {
@@ -329,6 +331,7 @@ static match_table_t tokens = {
 	{Opt_fscontext, FSCONTEXT_STR "%s"},
 	{Opt_defcontext, DEFCONTEXT_STR "%s"},
 	{Opt_rootcontext, ROOTCONTEXT_STR "%s"},
+	{Opt_native_labels, NATIVELABELS_STR},
 	{Opt_error, NULL},
 };
 
@@ -516,6 +519,10 @@ static int selinux_get_mnt_opts(const struct super_block *sb,
 		opts->mnt_opts[i] = context;
 		opts->mnt_opts_flags[i++] = ROOTCONTEXT_MNT;
 	}
+	if (sbsec->flags == NATIVE_LABELS_MNT) {
+		opts->mnt_opts[i] = NULL;
+		opts->mnt_opts_flags[i++] = NATIVE_LABELS_MNT;
+	}
 
 	BUG_ON(i != opts->num_mnt_opts);
 
@@ -604,12 +611,16 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	 */
 	for (i = 0; i < num_opts; i++) {
 		u32 sid;
+		if (flags[i] == NATIVE_LABELS_MNT) {
+			sbsec->flags | = NATIVE_LABELS_MNT;
+			continue;
+		}
 		rc = security_context_to_sid(mount_options[i],
-					     strlen(mount_options[i]), &sid);
+				strlen(mount_options[i]), &sid);
 		if (rc) {
 			printk(KERN_WARNING "SELinux: security_context_to_sid"
-			       "(%s) failed for (dev %s, type %s) errno=%d\n",
-			       mount_options[i], sb->s_id, name, rc);
+					"(%s) failed for (dev %s, type %s) errno=%d\n",
+					mount_options[i], sb->s_id, name, rc);
 			goto out;
 		}
 		switch (flags[i]) {
@@ -668,14 +679,15 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	if (strcmp(sb->s_type->name, "proc") == 0)
 		sbsec->proc = 1;
 
-	/* Determine the labeling behavior to use for this filesystem type. */
-	rc = security_fs_use(sb->s_type->name, &sbsec->behavior, &sbsec->sid);
-	if (rc) {
-		printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
-		       __func__, sb->s_type->name, rc);
-		goto out;
+	if (!sbsec->behavior) {
+		/* Determine the labeling behavior to use for this filesystem type. */
+		rc = security_fs_use(sb->s_type->name, &sbsec->behavior, &sbsec->sid);
+		if (rc) {
+			printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
+					__func__, sb->s_type->name, rc);
+			goto out;
+		}
 	}
-
 	/* sets the context of the superblock for the fs being mounted. */
 	if (fscontext_sid) {
 
@@ -691,6 +703,11 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	 * sets the label used on all file below the mountpoint, and will set
 	 * the superblock context if not already set.
 	 */
+	/* NATIVE_LABELS can be overridden by 'context=' mounts, below. */
+	if (sbsec->flags & NATIVE_LABELS_MNT) {
+		sbsec->behavior = SECURITY_FS_USE_NATIVE;
+	}
+
 	if (context_sid) {
 		if (!fscontext_sid) {
 			rc = may_context_mount_sb_relabel(context_sid, sbsec, tsec);
@@ -707,6 +724,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 
 		sbsec->mntpoint_sid = context_sid;
 		sbsec->behavior = SECURITY_FS_USE_MNTPOINT;
+		sbsec->flags &= ~NATIVE_LABELS_MNT; /* Exclusive */
 	}
 
 	if (rootcontext_sid) {
@@ -719,7 +737,8 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	}
 
 	if (defcontext_sid) {
-		if (sbsec->behavior != SECURITY_FS_USE_XATTR) {
+		if (sbsec->behavior != SECURITY_FS_USE_XATTR &&
+			sbsec->behavior != SECURITY_FS_USE_NATIVE) {
 			rc = -EINVAL;
 			printk(KERN_WARNING "SELinux: defcontext option is "
 			       "invalid for this filesystem type\n");
@@ -816,6 +835,7 @@ static int selinux_parse_opts_str(char *options,
 	char *p;
 	char *context = NULL, *defcontext = NULL;
 	char *fscontext = NULL, *rootcontext = NULL;
+	int native_labels = 0;
 	int rc, num_mnt_opts = 0;
 
 	opts->num_mnt_opts = 0;
@@ -883,9 +903,15 @@ static int selinux_parse_opts_str(char *options,
 			}
 			break;
 
+		case Opt_native_labels:
+			printk("%s() got Opt_native_labels\n", __func__);
+			native_labels = 1;
+			break;
+
+
 		default:
 			rc = -EINVAL;
-			printk(KERN_WARNING "SELinux:  unknown mount option\n");
+			printk(KERN_WARNING "SELinux: unknown mount option \"%s\"\n", p);
 			goto out_err;
 
 		}
@@ -918,6 +944,10 @@ static int selinux_parse_opts_str(char *options,
 		opts->mnt_opts[num_mnt_opts] = defcontext;
 		opts->mnt_opts_flags[num_mnt_opts++] = DEFCONTEXT_MNT;
 	}
+	if (native_labels) {
+		opts->mnt_opts[num_mnt_opts] = NULL;
+		opts->mnt_opts_flags[num_mnt_opts++] = NATIVE_LABELS_MNT;
+	}
 
 	opts->num_mnt_opts = num_mnt_opts;
 	return 0;
@@ -963,7 +993,12 @@ void selinux_write_opts(struct seq_file *m, struct security_mnt_opts *opts)
 	char *prefix;
 
 	for (i = 0; i < opts->num_mnt_opts; i++) {
-		char *has_comma = strchr(opts->mnt_opts[i], ',');
+		char *has_comma;
+
+		if (opts->mnt_opts[i])
+			has_comma = strchr(opts->mnt_opts[i], ',');
+		else
+			has_comma = NULL;
 
 		switch (opts->mnt_opts_flags[i]) {
 		case CONTEXT_MNT:
@@ -978,6 +1013,10 @@ void selinux_write_opts(struct seq_file *m, struct security_mnt_opts *opts)
 		case DEFCONTEXT_MNT:
 			prefix = DEFCONTEXT_STR;
 			break;
+		case NATIVE_LABELS_MNT:
+			seq_putc(m, ',');
+			seq_puts(m, NATIVELABELS_STR);
+			continue;
 		default:
 			BUG();
 		};
@@ -1185,6 +1224,8 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 	}
 
 	switch (sbsec->behavior) {
+	case SECURITY_FS_USE_NATIVE:
+		break;
 	case SECURITY_FS_USE_XATTR:
 		if (!inode->i_op->getxattr) {
 			isec->sid = sbsec->def_sid;
@@ -2360,7 +2401,8 @@ static inline int selinux_option(char *option, int len)
 	return (match_prefix(CONTEXT_STR, sizeof(CONTEXT_STR)-1, option, len) ||
 		match_prefix(FSCONTEXT_STR, sizeof(FSCONTEXT_STR)-1, option, len) ||
 		match_prefix(DEFCONTEXT_STR, sizeof(DEFCONTEXT_STR)-1, option, len) ||
-		match_prefix(ROOTCONTEXT_STR, sizeof(ROOTCONTEXT_STR)-1, option, len));
+		match_prefix(ROOTCONTEXT_STR, sizeof(ROOTCONTEXT_STR)-1, option, len) ||
+		match_prefix(NATIVELABELS_STR, sizeof(NATIVELABELS_STR)-1, option, len));
 }
 
 static inline void take_option(char **to, char *from, int *first, int len)
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 7c54300..effe060 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -40,11 +40,13 @@
 #define FSCONTEXT_MNT	0x02
 #define ROOTCONTEXT_MNT	0x04
 #define DEFCONTEXT_MNT	0x08
+#define	NATIVE_LABELS_MNT	0x10
 
 #define CONTEXT_STR	"context="
 #define FSCONTEXT_STR	"fscontext="
 #define ROOTCONTEXT_STR	"rootcontext="
 #define DEFCONTEXT_STR	"defcontext="
+#define NATIVELABELS_STR "native_labels"
 
 struct netlbl_lsm_secattr;
 
@@ -134,6 +136,8 @@ int security_get_allow_unknown(void);
 #define SECURITY_FS_USE_GENFS		4 /* use the genfs support */
 #define SECURITY_FS_USE_NONE		5 /* no labeling support */
 #define SECURITY_FS_USE_MNTPOINT	6 /* use mountpoint labeling */
+#define SECURITY_FS_USE_NATIVE		7 /* use native label support */
+#define SECURITY_FS_USE_MAX		7 /* Highest SECURITY_FS_USE_XXX */
 
 int security_fs_use(const char *fstype, unsigned int *behavior,
 	u32 *sid);
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 2391761..4740a5a 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1764,7 +1764,10 @@ int policydb_read(struct policydb *p, void *fp)
 				if (rc < 0)
 					goto bad;
 				c->v.behavior = le32_to_cpu(buf[0]);
-				if (c->v.behavior > SECURITY_FS_USE_NONE)
+				/* Determined at runtime, not in policy DB. */
+				if (c->v.behavior == SECURITY_FS_USE_MNTPOINT)
+					goto bad;
+				if (c->v.behavior > SECURITY_FS_USE_MAX)
 					goto bad;
 				len = le32_to_cpu(buf[1]);
 				c->u.name = kmalloc(len + 1, GFP_KERNEL);
-- 
1.5.5.1

