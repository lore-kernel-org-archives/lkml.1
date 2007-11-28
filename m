Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbXK1XMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbXK1XMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbXK1XMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:12:06 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:37979 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbXK1XMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:12:01 -0500
Message-ID: <474DDBBB.5050506@namesys.com>
Date: Thu, 29 Nov 2007 00:20:59 +0300
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Reiserfs-list <reiserfs-devel@vger.kernel.org>, bfields@citi.umich.edu,
       Neil Brown <neilb@suse.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [patch 2/2] reiser4: new export ops
References: <200710212348.l9LNm3Cq000694@imap1.linux-foundation.org> <474CBEEF.3060303@namesys.com> <20071128094301.GA7760@lst.de>
In-Reply-To: <20071128094301.GA7760@lst.de>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------080401050800040901000103"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080401050800040901000103
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Christoph Hellwig wrote:

>This code looks a little confusing to me..
>
>  
>
>>  */
>> static char *decode_inode(struct super_block *s, char *addr,
>> 			  reiser4_object_on_wire * obj)
>>@@ -41,7 +42,8 @@
>> 	fplug = file_plugin_by_disk_id(reiser4_get_tree(s), (d16 *) addr);
>> 	if (fplug != NULL) {
>> 		addr += sizeof(d16);
>>-		obj->plugin = fplug;
>>+		if (obj)
>>+			obj->plugin = fplug;
>>    
>>
>
>You are adding quite a few of those if (obj) clauses.  I can't see a
>reason for that - care to explain?  The new aops
>

new _export_ ops

> should not disallow for
>any functionality that has been there before.
>
>  
>

Actually they don't disallow existing functionality, but
require a new one: earlier we performed decoding in
_each_ iteration (decode_fh), and now you want it to be
done separately (fh_to_dentry, fh_to_parent). So we need
something like "empty" iteration, which only moves to the
next position.

Every object in reiser4, that can be serialized, has
special non-zero "wire" methods. I guess that "empty"
iteration should be performed via wire->read() method
which is responsible for extracting on-wire object.
Can not promise to avoid "if" here: I think it is not
a good reason to add a new plugin method for such
empty skip.

The attached patch avoids other two ifs.

>>static struct dentry *reiser4_decode_fh(struct super_block *super, __u32 *fh,
>>+					int len, int fhtype, int parent)
>> {
>> 	reiser4_context *ctx;
>> 	reiser4_object_on_wire object;
>> 	char *addr;
>> 
>> 	ctx = reiser4_init_context(super);
>> 	if (IS_ERR(ctx))
>>@@ -80,25 +77,19 @@
>> 	assert("vs-1482",
>> 	       fhtype == FH_WITH_PARENT || fhtype == FH_WITHOUT_PARENT);
>> 
>>	addr = (char *)fh;
>>
>>	object_on_wire_init(&object);
>>+
>>+	if (parent)
>>+		/* skip first onwire object */
>>+		addr = decode_inode(super, addr, NULL);
>>	if (!IS_ERR(addr)) {
>>+		addr = decode_inode(super, addr, &object);
>>		if (!IS_ERR(addr)) {
>>			struct dentry *d;
>>
>>+			d = reiser4_get_dentry(super, &object);
>>    
>>
>
>I'd suggest to directly poke into the place where the parent handle
>is stored.  XFS used a similar construct to the decode_inode helper,
>but with the new aops it's faster and easier to read if you just have
>a helper on how many bytes to skip.  Did you take a look at how the
>various other filesystem handle the export ops?
>
>  
>

We don't have a number of u32s to poke, like other filesystems do;
packing/extracting serialized objects in reiser4 is more complex:
first extract object's plugin, which knows how to extract further, etc..

>>--- linux-2.6.23-mm1/fs/reiser4/dscale.c.orig
>>+++ linux-2.6.23-mm1/fs/reiser4/dscale.c
>>@@ -126,6 +126,24 @@
>>    
>>
>
>How are the changes to all these other files related to the export
>operations changes?
>
>  
>
So we have to define an "if" branch for wire_read_common()
(plugin/file_plugin_common.c). The best place to do it is kassign.c
(as we actually pack/extract key components). Plus a small change in
dscale.c where a packing taxonomy is implemented. Have I missed
something?

Thanks,
Edward.


--------------080401050800040901000103
Content-Type: text/x-patch;
 name="reiser4-new-export-ops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-new-export-ops.patch"

Adjust reiser4 to new export ops.

Signed-off-by: Edward Shishkin <edward@namesys.com>
---
 linux-2.6.23-mm1/fs/reiser4/dscale.c                    |   20 ++
 linux-2.6.23-mm1/fs/reiser4/dscale.h                    |    3 
 linux-2.6.23-mm1/fs/reiser4/export_ops.c                |  128 +++++++++-------
 linux-2.6.23-mm1/fs/reiser4/kassign.c                   |   20 ++
 linux-2.6.23-mm1/fs/reiser4/kassign.h                   |    1 
 linux-2.6.23-mm1/fs/reiser4/plugin/file_plugin_common.c |    2 
 6 files changed, 117 insertions(+), 57 deletions(-)

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
--- linux-2.6.23-mm1/fs/reiser4/export_ops.c.orig
+++ linux-2.6.23-mm1/fs/reiser4/export_ops.c
@@ -50,69 +50,91 @@
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
- *
- * Returns dentry referring to the same file as @fh.
- */
-static struct dentry *reiser4_decode_fh(struct super_block *super, __u32 *fh,
-					int len, int fhtype,
-					int (*acceptable) (void *context,
-							   struct dentry *de),
-					void *context)
+ * reiser4_decode_fh: decode on-wire object - helper function
+ * for fh_to_dentry, fh_to_parent export operations;
+ * @super: super block;
+ * @addr: onwire object to be decoded;
+ *
+ * Returns dentry referring to the object being decoded.
+ */
+static struct dentry *reiser4_decode_fh(struct super_block * super,
+					char * addr)
 {
-	reiser4_context *ctx;
 	reiser4_object_on_wire object;
-	reiser4_object_on_wire parent;
-	char *addr;
-	int with_parent;
 
-	ctx = reiser4_init_context(super);
+	object_on_wire_init(&object);
+
+	addr = decode_inode(super, addr, &object);
+	if (!IS_ERR(addr)) {
+		struct dentry *d;
+		d = reiser4_get_dentry(super, &object);
+		if (d != NULL && !IS_ERR(d))
+			/* FIXME check for -ENOMEM */
+			reiser4_get_dentry_fsdata(d)->stateless = 1;
+		addr = (char *)d;
+	}
+	object_on_wire_done(&object);
+	return (void *)addr;
+}
+
+static struct dentry *reiser4_fh_to_dentry(struct super_block *sb,
+					   struct fid *fid,
+					   int fh_len, int fh_type)
+{
+	reiser4_context *ctx;
+	struct dentry *d;
+
+	assert("edward-1536",
+	       fh_type == FH_WITH_PARENT || fh_type == FH_WITHOUT_PARENT);
+
+	ctx = reiser4_init_context(sb);
 	if (IS_ERR(ctx))
 		return (struct dentry *)ctx;
 
-	assert("vs-1482",
-	       fhtype == FH_WITH_PARENT || fhtype == FH_WITHOUT_PARENT);
+	d = reiser4_decode_fh(sb, (char *)fid->raw);
 
-	with_parent = (fhtype == FH_WITH_PARENT);
+	reiser4_exit_context(ctx);
+	return d;
+}
 
-	addr = (char *)fh;
+static struct dentry *reiser4_fh_to_parent(struct super_block *sb,
+					   struct fid *fid,
+					   int fh_len, int fh_type)
+{
+	char * addr;
+	struct dentry * d;
+	reiser4_context *ctx;
+	file_plugin *fplug;
 
-	object_on_wire_init(&object);
-	object_on_wire_init(&parent);
-#if 0
-	addr = decode_inode(super, addr, &object);
-	if (!IS_ERR(addr)) {
-		if (with_parent)
-			addr = decode_inode(super, addr, &parent);
-		if (!IS_ERR(addr)) {
-			struct dentry *d;
-			typeof(super->s_export_op->find_exported_dentry) fn;
-
-			fn = super->s_export_op->find_exported_dentry;
-			assert("nikita-3521", fn != NULL);
-			d = fn(super, &object, with_parent ? &parent : NULL,
-			       acceptable, context);
-			if (d != NULL && !IS_ERR(d))
-				/* FIXME check for -ENOMEM */
-			  	reiser4_get_dentry_fsdata(d)->stateless = 1;
-			addr = (char *)d;
-		}
-	}
-	object_on_wire_done(&object);
-	object_on_wire_done(&parent);
+	if (fh_type == FH_WITHOUT_PARENT)
+		return NULL;
+	assert("edward-1537", fh_type == FH_WITH_PARENT);
 
+	ctx = reiser4_init_context(sb);
+	if (IS_ERR(ctx))
+		return (struct dentry *)ctx;
+	addr = (char *)fid->raw;
+	/* extract 2-bytes file plugin id */
+	fplug = file_plugin_by_disk_id(reiser4_get_tree(sb), (d16 *)addr);
+	if (fplug == NULL) {
+		d = ERR_PTR(RETERR(-EINVAL));
+		goto exit;
+	}
+	addr += sizeof(d16);
+	/* skip previously encoded object */
+	addr = fplug->wire.read(addr, NULL /* skip */);
+	if (IS_ERR(addr)) {
+		d = (struct dentry *)addr;
+		goto exit;
+	}
+	/* @extract and decode parent object */
+	d = reiser4_decode_fh(sb, addr);
+ exit:
 	reiser4_exit_context(ctx);
-	return (void *)addr;
-#else
-	return ERR_PTR(-EINVAL);
-#endif
+	return d;
 }
 
 /*
@@ -281,9 +303,9 @@
 
 struct export_operations reiser4_export_operations = {
 	.encode_fh = reiser4_encode_fh,
-//	.decode_fh = reiser4_decode_fh,
+	.fh_to_dentry = reiser4_fh_to_dentry,
+	.fh_to_parent = reiser4_fh_to_parent,
 	.get_parent = reiser4_get_dentry_parent,
-//	.get_dentry = reiser4_get_dentry
 };
 
 /*
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
@@ -650,6 +650,22 @@
 	return addr;
 }
 
+/*
+ * skip a key that was previously encoded by build_inode_onwire() at @addr
+ * FIXME: handle IO errors.
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
 

--------------080401050800040901000103--
