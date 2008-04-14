Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbYDNXLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbYDNXLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbYDNXLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:11:22 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:12427 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755116AbYDNXLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FYbomuLWEZfSiPJVE+24k1wHVnbxCXwLjnBGl5t0K/Eq0icSTUnnE33u7EJ9jfMUoJEkBmQp/H5AOBU+wwUtWlQR4SVHOQcFWpdclPFZa07YQOyHtI1vBvOJsbdI4N45HFmMgLTdItfAPZ1q+Fp5PbqBIngunXQkCQdF6p3xUkI=
Subject: Re: [PATCH-mm 15/15] ncpfs: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080414230213.GC9785@ZenIV.linux.org.uk>
References: <1208213283.11920.46.camel@brick>
	 <20080414230213.GC9785@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 16:11:22 -0700
Message-Id: <1208214682.11920.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Thanks to Al Viro for pointing out I sent the wrong mbox.

 fs/ncpfs/ncplib_kernel.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/ncpfs/ncplib_kernel.c b/fs/ncpfs/ncplib_kernel.c
index df6d60b..476d980 100644
--- a/fs/ncpfs/ncplib_kernel.c
+++ b/fs/ncpfs/ncplib_kernel.c
@@ -102,48 +102,47 @@ static inline void ncp_init_request_s(struct ncp_server *server, int subfunction
 }
 
 static inline char *
- ncp_reply_data(struct ncp_server *server, int offset)
+ncp_reply_data(struct ncp_server *server, int offset)
 {
 	return &(server->packet[sizeof(struct ncp_reply_header) + offset]);
 }
 
-static inline __u8 BVAL(void* data)
+static inline u8 BVAL(void *data)
 {
-	return get_unaligned((__u8*)data);
+	return *(u8 *)data;
 }
 
-static __u8
- ncp_reply_byte(struct ncp_server *server, int offset)
+static u8 ncp_reply_byte(struct ncp_server *server, int offset)
 {
-	return get_unaligned((__u8 *) ncp_reply_data(server, offset));
+	return *(u8 *)ncp_reply_data(server, offset);
 }
 
-static inline __u16 WVAL_LH(void* data)
+static inline u16 WVAL_LH(void* data)
 {
-	return le16_to_cpu(get_unaligned((__le16*)data));
+	return get_unaligned_le16(data);
 }
 
-static __u16
- ncp_reply_le16(struct ncp_server *server, int offset)
+static u16
+ncp_reply_le16(struct ncp_server *server, int offset)
 {
-	return le16_to_cpu(get_unaligned((__le16 *) ncp_reply_data(server, offset)));
+	return get_unaligned_le16(ncp_reply_data(server, offset));
 }
 
-static __u16
- ncp_reply_be16(struct ncp_server *server, int offset)
+static u16
+ncp_reply_be16(struct ncp_server *server, int offset)
 {
-	return be16_to_cpu(get_unaligned((__be16 *) ncp_reply_data(server, offset)));
+	return get_unaligned_be16(ncp_reply_data(server, offset));
 }
 
-static inline __u32 DVAL_LH(void* data)
+static inline u32 DVAL_LH(void *data)
 {
-	return le32_to_cpu(get_unaligned((__le32*)data));
+	return get_unaligned_le32(data);
 }
 
 static __le32
- ncp_reply_dword(struct ncp_server *server, int offset)
+ncp_reply_dword(struct ncp_server *server, int offset)
 {
-	return get_unaligned((__le32 *) ncp_reply_data(server, offset));
+	return get_unaligned((__le32 *)ncp_reply_data(server, offset));
 }
 
 static inline __u32 ncp_reply_dword_lh(struct ncp_server* server, int offset) {
@@ -1006,8 +1005,8 @@ ncp_read_bounce(struct ncp_server *server, const char *file_id,
 	result = ncp_request2(server, 72, bounce, bufsize);
 	ncp_unlock_server(server);
 	if (!result) {
-		int len = be16_to_cpu(get_unaligned((__be16*)((char*)bounce + 
-			  sizeof(struct ncp_reply_header))));
+		int len = get_unaligned_be16((char *)bounce +
+			  sizeof(struct ncp_reply_header));
 		result = -EIO;
 		if (len <= to_read) {
 			char* source;
-- 
1.5.5.144.g3e42



