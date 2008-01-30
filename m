Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYA3VFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYA3VFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYA3VEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:04:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:25275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYA3VEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:04:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=YnyslF+7zAWgnTA8PBddXqJaLXGfUZfkxrX7//iqGH+yihy1X60Dph6mJ+jt4HuXp6BQCzSe6JkbSbKPyIFUDl0GyO/1eQKwdRqSp897FaBK7bD/iQBwqIlt8f8RdK8+Y86sI1Bv4gJAEPEfNgcNWXLxq9CO+RIJbtUzsVVT53A=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 01/10] udf: udf_CS0toUTF8 cleanup
Date: Wed, 30 Jan 2008 22:03:51 +0100
Message-Id: <1201727040-6769-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- fix error handling - always zero output variable
- don't zero explicitely fields zeroed by memset
- mark "in" paramater as const
- remove outdated comment

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/udfdecl.h |    2 +-
 fs/udf/unicode.c |   27 ++++++++++-----------------
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 681dc2b..0c525e8 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -157,7 +157,7 @@ extern int udf_get_filename(struct super_block *, uint8_t *, uint8_t *, int);
 extern int udf_put_filename(struct super_block *, const uint8_t *, uint8_t *,
 			    int);
 extern int udf_build_ustr(struct ustr *, dstring *, int);
-extern int udf_CS0toUTF8(struct ustr *, struct ustr *);
+extern int udf_CS0toUTF8(struct ustr *, const struct ustr *);
 
 /* ialloc.c */
 extern void udf_free_inode(struct inode *);
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index e533b11..f969617 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -83,9 +83,6 @@ static int udf_build_ustr_exact(struct ustr *dest, dstring *ptr, int exactsize)
  * PURPOSE
  *	Convert OSTA Compressed Unicode to the UTF-8 equivalent.
  *
- * DESCRIPTION
- *	This routine is only called by udf_filldir().
- *
  * PRE-CONDITIONS
  *	utf			Pointer to UTF-8 output buffer.
  *	ocu			Pointer to OSTA Compressed Unicode input buffer
@@ -99,43 +96,39 @@ static int udf_build_ustr_exact(struct ustr *dest, dstring *ptr, int exactsize)
  *	November 12, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-int udf_CS0toUTF8(struct ustr *utf_o, struct ustr *ocu_i)
+int udf_CS0toUTF8(struct ustr *utf_o, const struct ustr *ocu_i)
 {
-	uint8_t *ocu;
-	uint32_t c;
+	const uint8_t *ocu;
 	uint8_t cmp_id, ocu_len;
 	int i;
 
-	ocu = ocu_i->u_name;
-
 	ocu_len = ocu_i->u_len;
-	cmp_id = ocu_i->u_cmpID;
-	utf_o->u_len = 0;
-
 	if (ocu_len == 0) {
 		memset(utf_o, 0, sizeof(struct ustr));
-		utf_o->u_cmpID = 0;
-		utf_o->u_len = 0;
 		return 0;
 	}
 
-	if ((cmp_id != 8) && (cmp_id != 16)) {
+	cmp_id = ocu_i->u_cmpID;
+	if (cmp_id != 8 && cmp_id != 16) {
+		memset(utf_o, 0, sizeof(struct ustr));
 		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n",
 		       cmp_id, ocu_i->u_name);
 		return 0;
 	}
 
+	ocu = ocu_i->u_name;
+	utf_o->u_len = 0;
 	for (i = 0; (i < ocu_len) && (utf_o->u_len <= (UDF_NAME_LEN - 3));) {
 
 		/* Expand OSTA compressed Unicode to Unicode */
-		c = ocu[i++];
+		uint32_t c = ocu[i++];
 		if (cmp_id == 16)
 			c = (c << 8) | ocu[i++];
 
 		/* Compress Unicode to UTF-8 */
-		if (c < 0x80U) {
+		if (c < 0x80U)
 			utf_o->u_name[utf_o->u_len++] = (uint8_t)c;
-		} else if (c < 0x800U) {
+		else if (c < 0x800U) {
 			utf_o->u_name[utf_o->u_len++] =
 						(uint8_t)(0xc0 | (c >> 6));
 			utf_o->u_name[utf_o->u_len++] =
-- 
1.5.3.7

