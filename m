Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYA3VFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYA3VFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbYA3VFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:05:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:25275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbYA3VFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=HZ5t/Qo40pdQX9oxRbqVeW9DNr+ZiCLcMCQG12rv1pw4cNeLaKXhfyqoVMny692cwWgBXDYA/aObS/mS6Hpd+1wg5xpxiBgYwcVq/B/Obk8rv+1I7YaoEFl2hqOOEuBDRK1JBzB/c84Fh4OelJlB4qqep4YhBWLS2JrirmYj+ZI=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 02/10] udf: fix udf_build_ustr
Date: Wed, 30 Jan 2008 22:03:52 +0100
Message-Id: <1201727040-6769-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

udf_build_ustr was completely broken when
size >= UDF_NAME_LEN - 1 or size < 2

nobody noticed because all callers set size
to acceptable values (constants)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/unicode.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index f969617..f4e54e5 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -47,16 +47,16 @@ static int udf_char_to_ustr(struct ustr *dest, const uint8_t *src, int strlen)
  */
 int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
 {
-	int usesize;
+	u8 usesize;
 
-	if ((!dest) || (!ptr) || (!size))
+	if (!dest || !ptr || size < 2)
 		return -1;
 
-	memset(dest, 0, sizeof(struct ustr));
-	usesize = (size > UDF_NAME_LEN) ? UDF_NAME_LEN : size;
+	usesize = min_t(size_t, size - 2, sizeof(dest->u_name));
 	dest->u_cmpID = ptr[0];
-	dest->u_len = ptr[size - 1];
-	memcpy(dest->u_name, ptr + 1, usesize - 1);
+	dest->u_len = usesize;
+	memcpy(dest->u_name, ptr + 1, usesize);
+	memset(dest->u_name + usesize, 0, sizeof(dest->u_name) - usesize);
 
 	return 0;
 }
-- 
1.5.3.7

