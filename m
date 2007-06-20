Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbXFTANt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbXFTANt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 20:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXFTANa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 20:13:30 -0400
Received: from kumera.dghda.com ([80.68.90.171]:4259 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbXFTAN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 20:13:29 -0400
From: "Duane Griffin" <duaneg@dghda.com>
Message-Id: <20070620000647.280620153@dastardly.home.dghda.com>
References: <20070620000644.891099313@dastardly.home.dghda.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 01:06:46 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, didier <did447@gmail.com>,
       Solra Bizna <sbizna@tejat.net>, Daniel Drake <dsd@gentoo.org>
Subject: [patch 2/2] HFS+: Add custom dentry hash and comparison operations
Content-Disposition: inline; filename=hfsplus-custom-dentry-ops.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add custom dentry hash and comparison operations for HFS+ filesystems
that are case-insensitive and/or do automatic unicode decomposition.
The new operations reuse the existing HFS+ ASCII to unicode conversion,
unicode decomposition and case folding functionality.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

--- linux-2.6.21.orig/fs/hfsplus/dir.c
+++ linux-2.6.21/fs/hfsplus/dir.c
@@ -36,6 +36,11 @@ static struct dentry *hfsplus_lookup(str
 	u16 type;
 
 	sb = dir->i_sb;
+
+	if (!(HFSPLUS_SB(sb).flags & HFSPLUS_SB_HFSX) ||
+	    !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_NODECOMPOSE))
+		dentry->d_op = &hfsplus_dentry_operations;
+
 	dentry->d_fsdata = NULL;
 	hfs_find_init(HFSPLUS_SB(sb).cat_tree, &fd);
 	hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, &dentry->d_name);
--- linux-2.6.21.orig/fs/hfsplus/hfsplus_fs.h
+++ linux-2.6.21/fs/hfsplus/hfsplus_fs.h
@@ -321,6 +321,7 @@ void hfsplus_file_truncate(struct inode 
 /* inode.c */
 extern const struct address_space_operations hfsplus_aops;
 extern const struct address_space_operations hfsplus_btree_aops;
+extern struct dentry_operations hfsplus_dentry_operations;
 
 void hfsplus_inode_read_fork(struct inode *, struct hfsplus_fork_raw *);
 void hfsplus_inode_write_fork(struct inode *, struct hfsplus_fork_raw *);
@@ -353,6 +354,8 @@ int hfsplus_strcasecmp(const struct hfsp
 int hfsplus_strcmp(const struct hfsplus_unistr *, const struct hfsplus_unistr *);
 int hfsplus_uni2asc(struct super_block *, const struct hfsplus_unistr *, char *, int *);
 int hfsplus_asc2uni(struct super_block *, struct hfsplus_unistr *, const char *, int);
+int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str);
+int hfsplus_compare_dentry(struct dentry *dentry, struct qstr *s1, struct qstr *s2);
 
 /* wrapper.c */
 int hfsplus_read_wrapper(struct super_block *);
--- linux-2.6.21.orig/fs/hfsplus/inode.c
+++ linux-2.6.21/fs/hfsplus/inode.c
@@ -130,6 +130,12 @@ const struct address_space_operations hf
 	.writepages	= hfsplus_writepages,
 };
 
+struct dentry_operations hfsplus_dentry_operations = {
+	.d_revalidate = NULL,
+	.d_hash       = hfsplus_hash_dentry,
+	.d_compare    = hfsplus_compare_dentry,
+};
+
 static struct dentry *hfsplus_file_lookup(struct inode *dir, struct dentry *dentry,
 					  struct nameidata *nd)
 {
--- linux-2.6.21.orig/fs/hfsplus/super.c
+++ linux-2.6.21/fs/hfsplus/super.c
@@ -396,6 +396,10 @@ static int hfsplus_fill_super(struct sup
 	} else
 		hfs_find_exit(&fd);
 
+	if (!(HFSPLUS_SB(sb).flags & HFSPLUS_SB_HFSX) ||
+	    !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_NODECOMPOSE))
+		sb->s_root->d_op = &hfsplus_dentry_operations;
+
 	if (sb->s_flags & MS_RDONLY)
 		goto out;
 
--- linux-2.6.21.orig/fs/hfsplus/unicode.c
+++ linux-2.6.21/fs/hfsplus/unicode.c
@@ -314,6 +314,22 @@ static int asc2ucd(struct super_block *s
 	return size;
 }
 
+/*
+ * Convert a ASCII character(s) to a unicode character.
+ * The unicode character will be decomposed and/or case-folded, if required.
+ * Returns the number of ASCII characters converted.
+ */
+static int asc2ucdf(struct super_block *sb,
+	const char *astr, int len, struct decomposed_uc *duc)
+{
+	int ii;
+	int size = asc2ucd(sb, astr, len, duc);
+	bool fold = !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_HFSX);
+	for (ii = 0; fold && ii <= duc->size; ++ii)
+		duc->str[ii] = case_fold(duc->str[ii]);
+	return size;
+}
+
 int hfsplus_asc2uni(struct super_block *sb,
 	struct hfsplus_unistr *ustr, const char *astr, int len)
 {
@@ -336,3 +352,89 @@ int hfsplus_asc2uni(struct super_block *
 		return -ENAMETOOLONG;
 	return 0;
 }
+
+/*
+ * Hash a string to an integer as appropriate for the HFS+ filesystem.
+ * Composed unicode characters are decomposed and case-folding is performed
+ * if the appropriate bits are (un)set on the superblock.
+ */
+int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str)
+{
+	int len = str->len;
+	const char *astr = str->name;
+	struct decomposed_uc duc;
+	unsigned hash = init_name_hash();
+
+	while (len > 0) {
+		int ii;
+		int size = asc2ucdf(dentry->d_sb, astr, len, &duc);
+		astr += size;
+		len -= size;
+		for (ii = 0; ii < duc.size; ++ii) {
+			if (duc.str[ii])
+				hash = partial_name_hash(duc.str[ii], hash);
+		}
+	}
+	str->hash = end_name_hash(hash);
+
+	return 0;
+}
+
+/*
+ * Compare strings with HFS+ filename ordering.
+ * Composed unicode characters are decomposed and case-folding is performed
+ * if the appropriate bits are (un)set on the superblock.
+ */
+int
+hfsplus_compare_dentry(struct dentry *dentry, struct qstr *s1, struct qstr *s2)
+{
+	int off1 = 0;
+	int off2 = 0;
+	struct decomposed_uc duc1;
+	struct decomposed_uc duc2;
+	int len1 = s1->len;
+	int len2 = s2->len;
+	const char *astr1 = s1->name;
+	const char *astr2 = s2->name;
+
+	duc1.size = 0;
+	duc2.size = 0;
+
+	while ((off1 < duc1.size || len1 > 0) &&
+	       (off2 < duc2.size || len2 > 0)) {
+
+		if (off1 == duc1.size) {
+			int size = asc2ucdf(dentry->d_sb, astr1, len1, &duc1);
+			astr1 += size;
+			len1 -= size;
+			off1 = 0;
+		}
+
+		if (off2 == duc2.size) {
+			int size = asc2ucdf(dentry->d_sb, astr2, len2, &duc2);
+			astr2 += size;
+			len2 -= size;
+			off2 = 0;
+		}
+
+		while (off1 < duc1.size && !duc1.str[off1])
+			++off1;
+		while (off2 < duc2.size && !duc2.str[off2])
+			++off2;
+
+		while (off1 < duc1.size && off2 < duc2.size) {
+			if (duc1.str[off1] < duc2.str[off2])
+				return -1;
+			if (duc1.str[off1] > duc2.str[off2])
+				return 1;
+			++off1;
+			++off2;
+		}
+	}
+
+	if (len1 < len2)
+		return -1;
+	if (len1 > len2)
+		return 1;
+	return 0;
+}

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
