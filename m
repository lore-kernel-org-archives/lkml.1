Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYA3VGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYA3VGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbYA3VFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:05:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:25275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891AbYA3VF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=GHVBKujTHhsqjNyd6YFkMNDO2GgGwmIezyFmreQ7IWp4SKx62QAGyobrE5HqwCqCVir4a3KnyPD0PnkVA2UDNHKKC0h84soqRO1c34IWfxop9fsKUr197MgNi/l/OYLKLBoAiE9bgXIv5z/gs41FsgWOPMkrx/BrcMkus0tFV/k=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 03/10] udf: udf_CS0toNLS cleanup
Date: Wed, 30 Jan 2008 22:03:53 +0100
Message-Id: <1201727040-6769-4-git-send-email-marcin.slusarz@gmail.com>
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

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/unicode.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index f4e54e5..d068d33 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -248,35 +248,32 @@ error_out:
 }
 
 static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
-			struct ustr *ocu_i)
+			const struct ustr *ocu_i)
 {
-	uint8_t *ocu;
-	uint32_t c;
+	const uint8_t *ocu;
 	uint8_t cmp_id, ocu_len;
 	int i;
 
-	ocu = ocu_i->u_name;
 
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
 
-- 
1.5.3.7

