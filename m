Return-Path: <linux-kernel-owner+w=401wt.eu-S1760372AbXK1CGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372AbXK1CGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 21:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXK1CGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 21:06:12 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:48554 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759586AbXK1CGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 21:06:10 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2007 21:06:10 EST
Message-ID: <474CBEEF.3060303@namesys.com>
Date: Wed, 28 Nov 2007 04:05:51 +0300
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Reiserfs-list <reiserfs-devel@vger.kernel.org>
CC: bfields@citi.umich.edu, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [patch 2/2] reiser4: new export ops
References: <200710212348.l9LNm3Cq000694@imap1.linux-foundation.org>
In-Reply-To: <200710212348.l9LNm3Cq000694@imap1.linux-foundation.org>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------070502030008070301020602"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070502030008070301020602
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

akpm@linux-foundation.org wrote:

>The patch titled
>     git-nfsd-broke-reiser4
>has been removed from the -mm tree.  Its filename was
>     git-nfsd-broke-reiser4.patch
>
>This patch was dropped because it was folded into reiser4.patch
>
>------------------------------------------------------
>Subject: git-nfsd-broke-reiser4
>From: Andrew Morton <akpm@linux-foundation.org>
>
>fs/reiser4/export_ops.c: In function 'reiser4_decode_fh':
>fs/reiser4/export_ops.c:96: error: 'const struct export_operations' has no member named 'find_exported_dentry'
>fs/reiser4/export_ops.c:96: warning: type defaults to 'int' in declaration of 'fn'
>fs/reiser4/export_ops.c:98: error: 'const struct export_operations' has no member named 'find_exported_dentry'
>fs/reiser4/export_ops.c:99: warning: comparison between pointer and integer
>fs/reiser4/export_ops.c:101: error: called object 'fn' is not a function
>fs/reiser4/export_ops.c: At top level:
>fs/reiser4/export_ops.c:282: error: unknown field 'decode_fh' specified in initializer
>fs/reiser4/export_ops.c:282: warning: initialization from incompatible pointer type
>fs/reiser4/export_ops.c:284: error: unknown field 'get_dentry' specified in initializer
>fs/reiser4/export_ops.c:285: warning: excess elements in struct initializer
>fs/reiser4/export_ops.c:285: warning: (near initialization for 'reiser4_export_operations')
>
>help!
>
done

Thanks,
Edward.

--------------070502030008070301020602
Content-Type: text/x-patch;
 name="reiser4-new-export-ops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-new-export-ops.patch"

Adjust reiser4 for the new export ops.

Signed-off-by: Edward Shishkin <edward@namesys.com>
---
 linux-2.6.23-mm1/fs/reiser4/dscale.c                    |   20 ++++
 linux-2.6.23-mm1/fs/reiser4/dscale.h                    |    3 
 linux-2.6.23-mm1/fs/reiser4/export_ops.c                |   72 ++++++++--------
 linux-2.6.23-mm1/fs/reiser4/kassign.c                   |   19 +++-
 linux-2.6.23-mm1/fs/reiser4/kassign.h                   |    1 
 linux-2.6.23-mm1/fs/reiser4/plugin/file_plugin_common.c |    2 
 6 files changed, 78 insertions(+), 39 deletions(-)

--- linux-2.6.23-mm1/fs/reiser4/export_ops.c.orig
+++ linux-2.6.23-mm1/fs/reiser4/export_ops.c
@@ -29,7 +29,8 @@
 
 /*
  * read serialized object identity from @addr and store information about
- * object in @obj. This is dual to encode_inode().
+ * object in @obj. If @obj == NULL, then don't read, just skip the encoded
+ * object (only return updated position).
  */
 static char *decode_inode(struct super_block *s, char *addr,
 			  reiser4_object_on_wire * obj)
@@ -41,7 +42,8 @@
 	fplug = file_plugin_by_disk_id(reiser4_get_tree(s), (d16 *) addr);
 	if (fplug != NULL) {
 		addr += sizeof(d16);
-		obj->plugin = fplug;
+		if (obj)
+			obj->plugin = fplug;
 		assert("nikita-3520", fplug->wire.read != NULL);
 		/* plugin specific encoding of object identity. */
 		addr = fplug->wire.read(addr, obj);
@@ -50,28 +52,23 @@
 	return addr;
 }
 
+static struct dentry *reiser4_get_dentry(struct super_block *super,
+					 void *data);
 /**
- * reiser4_decode_fh - decode_fh of export operations
- * @super: super block
- * @fh: nfsd file handle
- * @len: length of file handle
- * @fhtype: type of file handle
- * @acceptable: acceptability testing function
- * @context: argument for @acceptable
+ * reiser4_decode_fh: decode onwire object - helper function
+ * for fh_to_dentry, fh_to_parent export operations;
+ * @super: super block;
+ * @fh: here are onwire objects to be extracted for decoding;
+ * @parent: skip first onwire object and decode parent.
  *
- * Returns dentry referring to the same file as @fh.
+ * Returns dentry referring to the object being decoded.
  */
 static struct dentry *reiser4_decode_fh(struct super_block *super, __u32 *fh,
-					int len, int fhtype,
-					int (*acceptable) (void *context,
-							   struct dentry *de),
-					void *context)
+					int len, int fhtype, int parent)
 {
 	reiser4_context *ctx;
 	reiser4_object_on_wire object;
-	reiser4_object_on_wire parent;
 	char *addr;
-	int with_parent;
 
 	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx))
@@ -80,25 +77,19 @@
 	assert("vs-1482",
 	       fhtype == FH_WITH_PARENT || fhtype == FH_WITHOUT_PARENT);
 
-	with_parent = (fhtype == FH_WITH_PARENT);
-
 	addr = (char *)fh;
 
 	object_on_wire_init(&object);
-	object_on_wire_init(&parent);
-#if 0
-	addr = decode_inode(super, addr, &object);
+
+	if (parent)
+		/* skip first onwire object */
+		addr = decode_inode(super, addr, NULL);
 	if (!IS_ERR(addr)) {
-		if (with_parent)
-			addr = decode_inode(super, addr, &parent);
+		addr = decode_inode(super, addr, &object);
 		if (!IS_ERR(addr)) {
 			struct dentry *d;
-			typeof(super->s_export_op->find_exported_dentry) fn;
 
-			fn = super->s_export_op->find_exported_dentry;
-			assert("nikita-3521", fn != NULL);
-			d = fn(super, &object, with_parent ? &parent : NULL,
-			       acceptable, context);
+			d = reiser4_get_dentry(super, &object);
 			if (d != NULL && !IS_ERR(d))
 				/* FIXME check for -ENOMEM */
 			  	reiser4_get_dentry_fsdata(d)->stateless = 1;
@@ -106,13 +97,24 @@
 		}
 	}
 	object_on_wire_done(&object);
-	object_on_wire_done(&parent);
-
 	reiser4_exit_context(ctx);
 	return (void *)addr;
-#else
-	return ERR_PTR(-EINVAL);
-#endif
+}
+
+static struct dentry *reiser4_fh_to_dentry(struct super_block *sb,
+					   struct fid *fid,
+					   int fh_len, int fh_type)
+{
+	return reiser4_decode_fh(sb, fid->raw, fh_len, fh_type, 0);
+}
+
+static struct dentry *reiser4_fh_to_parent(struct super_block *sb,
+					   struct fid *fid,
+					   int fh_len, int fh_type)
+{
+	if (fh_type == FH_WITHOUT_PARENT)
+		return NULL;
+	return reiser4_decode_fh(sb, fid->raw, fh_len, fh_type, 1);
 }
 
 /*
@@ -281,9 +283,9 @@
 
 struct export_operations reiser4_export_operations = {
 	.encode_fh = reiser4_encode_fh,
-//	.decode_fh = reiser4_decode_fh,
+	.fh_to_dentry = reiser4_fh_to_dentry,
+	.fh_to_parent = reiser4_fh_to_parent,
 	.get_parent = reiser4_get_dentry_parent,
-//	.get_dentry = reiser4_get_dentry
 };
 
 /*
--- linux-2.6.23-mm1/fs/reiser4/dscale.c.orig
+++ linux-2.6.23-mm1/fs/reiser4/dscale.c
@@ -126,6 +126,24 @@
 	return 1 << tag;
 }
 
+/* number of bytes consumed */
+int dscale_bytes_to_read(unsigned char *address)
+{
+	int tag;
+
+	tag = gettag(address);
+	switch (tag) {
+	case 0:
+	case 1:
+	case 2:
+		return 1 << tag;
+	case 3:
+		return 9;
+	default:
+		return RETERR(-EIO);
+	}
+}
+
 /* store @value at @address and return number of bytes consumed */
 int dscale_write(unsigned char *address, __u64 value)
 {
@@ -144,7 +162,7 @@
 }
 
 /* number of bytes required to store @value */
-int dscale_bytes(__u64 value)
+int dscale_bytes_to_write(__u64 value)
 {
 	int bytes;
 
--- linux-2.6.23-mm1/fs/reiser4/dscale.h.orig
+++ linux-2.6.23-mm1/fs/reiser4/dscale.h
@@ -10,7 +10,8 @@
 
 extern int dscale_read(unsigned char *address, __u64 * value);
 extern int dscale_write(unsigned char *address, __u64 value);
-extern int dscale_bytes(__u64 value);
+extern int dscale_bytes_to_read(unsigned char *address);
+extern int dscale_bytes_to_write(__u64 value);
 extern int dscale_fit(__u64 value, __u64 other);
 
 /* __FS_REISER4_DSCALE_H__ */
--- linux-2.6.23-mm1/fs/reiser4/kassign.c.orig
+++ linux-2.6.23-mm1/fs/reiser4/kassign.c
@@ -604,8 +604,8 @@
 {
 	int result;
 
-	result = dscale_bytes(get_inode_oid(inode));
-	result += dscale_bytes(get_inode_locality(inode));
+	result = dscale_bytes_to_write(get_inode_oid(inode));
+	result += dscale_bytes_to_write(get_inode_locality(inode));
 
 	/*
 	 * ordering is large (it usually has highest bits set), so it makes
@@ -650,6 +650,21 @@
 	return addr;
 }
 
+/*
+ * skip a key that was previously encoded by build_inode_onwire() at @addr
+ */
+char * locate_obj_key_id_onwire(char * addr)
+{
+	/* locality */
+	addr += dscale_bytes_to_read(addr);
+	/* objectid */
+	addr += dscale_bytes_to_read(addr);
+#if REISER4_LARGE_KEY
+	addr += sizeof ((obj_key_id *)0)->ordering;
+#endif
+	return addr;
+}
+
 /* Make Linus happy.
    Local variables:
    c-indentation-style: "K&R"
--- linux-2.6.23-mm1/fs/reiser4/kassign.h.orig
+++ linux-2.6.23-mm1/fs/reiser4/kassign.h
@@ -64,6 +64,7 @@
 
 extern int inode_onwire_size(const struct inode *obj);
 extern char *build_inode_onwire(const struct inode *obj, char *area);
+extern char *locate_obj_key_id_onwire(char *area);
 extern char *extract_obj_key_id_from_onwire(char *area, obj_key_id * key_id);
 
 extern int build_inode_key_id(const struct inode *obj, obj_key_id * id);
--- linux-2.6.23-mm1/fs/reiser4/plugin/file_plugin_common.c.orig
+++ linux-2.6.23-mm1/fs/reiser4/plugin/file_plugin_common.c
@@ -459,6 +459,8 @@
 
 char *wire_read_common(char *addr, reiser4_object_on_wire * obj)
 {
+	if (!obj)
+		return locate_obj_key_id_onwire(addr);
 	return extract_obj_key_id_from_onwire(addr, &obj->u.std.key_id);
 }
 

--------------070502030008070301020602--
