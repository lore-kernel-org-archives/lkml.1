Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYKPSDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYKPSDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYKPSDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:03:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:7849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbYKPSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:03:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jdzWWEx+s7wKKdRp+JMA+1xJkxHRKrmcN6gYJkH6AM+Sv4+GTPCMj0FDjmI7wWEsfx
         rxvhSxoeyLnidj2qOuR7T6wltowtlzLH1ZXunh9xHyVhRvhCuri1ZG3w7Yza6yQa/Gn1
         mNw14zbf/zRVINFjSXxE66zFot73pYl7cpuIw=
Date: Sun, 16 Nov 2008 19:02:45 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] udf: reduce stack usage of udf_get_filename
Message-ID: <20081116180240.GB6282@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate strings with kmalloc.

Checkstack output:
Before: udf_get_filename:          600
After:  udf_get_filename:          136

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/unicode.c |   41 +++++++++++++++++++++++++----------------
 1 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 9fdf8c9..a3bbdbd 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -324,34 +324,43 @@ try_again:
 int udf_get_filename(struct super_block *sb, uint8_t *sname, uint8_t *dname,
 		     int flen)
 {
-	struct ustr filename, unifilename;
-	int len;
+	struct ustr *filename, *unifilename;
+	int len = 0;
 
-	if (udf_build_ustr_exact(&unifilename, sname, flen))
+	filename = kmalloc(sizeof(struct ustr), GFP_NOFS);
+	if (!filename)
 		return 0;
 
+	unifilename = kmalloc(sizeof(struct ustr), GFP_NOFS);
+	if (!unifilename)
+		goto out1;
+
+	if (udf_build_ustr_exact(unifilename, sname, flen))
+		goto out2;
+
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
-		if (!udf_CS0toUTF8(&filename, &unifilename)) {
+		if (!udf_CS0toUTF8(filename, unifilename)) {
 			udf_debug("Failed in udf_get_filename: sname = %s\n",
 				  sname);
-			return 0;
+			goto out2;
 		}
 	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, &filename,
-				  &unifilename)) {
+		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, filename,
+				  unifilename)) {
 			udf_debug("Failed in udf_get_filename: sname = %s\n",
 				  sname);
-			return 0;
+			goto out2;
 		}
 	} else
-		return 0;
-
-	len = udf_translate_to_linux(dname, filename.u_name, filename.u_len,
-				     unifilename.u_name, unifilename.u_len);
-	if (len)
-		return len;
-
-	return 0;
+		goto out2;
+
+	len = udf_translate_to_linux(dname, filename->u_name, filename->u_len,
+				     unifilename->u_name, unifilename->u_len);
+out2:
+	kfree(unifilename);
+out1:
+	kfree(filename);
+	return len;
 }
 
 int udf_put_filename(struct super_block *sb, const uint8_t *sname,
-- 
1.5.6.4

