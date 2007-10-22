Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbXJVSN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbXJVSN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXJVSM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22173 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbXJVSMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:24 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 05/10] [SG] Update fs/ to use sg helpers
Date: Mon, 22 Oct 2007 20:10:59 +0200
Message-Id: <1193076664-13652-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/ecryptfs/crypto.c   |   16 +++++++++++-----
 fs/ecryptfs/keystore.c |    3 +++
 fs/nfsd/nfs4recover.c  |    8 +++-----
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 1ae90ef..0a9882e 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -283,7 +283,7 @@ int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
 		pg = virt_to_page(addr);
 		offset = offset_in_page(addr);
 		if (sg) {
-			sg[i].page = pg;
+			sg_set_page(&sg[i], pg);
 			sg[i].offset = offset;
 		}
 		remainder_of_page = PAGE_CACHE_SIZE - offset;
@@ -713,10 +713,13 @@ ecryptfs_encrypt_page_offset(struct ecryptfs_crypt_stat *crypt_stat,
 {
 	struct scatterlist src_sg, dst_sg;
 
-	src_sg.page = src_page;
+	sg_init_table(&src_sg, 1);
+	sg_init_table(&dst_sg, 1);
+
+	sg_set_page(&src_sg, src_page);
 	src_sg.offset = src_offset;
 	src_sg.length = size;
-	dst_sg.page = dst_page;
+	sg_set_page(&dst_sg, dst_page);
 	dst_sg.offset = dst_offset;
 	dst_sg.length = size;
 	return encrypt_scatterlist(crypt_stat, &dst_sg, &src_sg, size, iv);
@@ -742,10 +745,13 @@ ecryptfs_decrypt_page_offset(struct ecryptfs_crypt_stat *crypt_stat,
 {
 	struct scatterlist src_sg, dst_sg;
 
-	src_sg.page = src_page;
+	sg_init_table(&src_sg, 1);
+	sg_init_table(&dst_sg, 1);
+
+	sg_set_page(&src_sg, src_page);
 	src_sg.offset = src_offset;
 	src_sg.length = size;
-	dst_sg.page = dst_page;
+	sg_set_page(&dst_sg, dst_page);
 	dst_sg.offset = dst_offset;
 	dst_sg.length = size;
 	return decrypt_scatterlist(crypt_stat, &dst_sg, &src_sg, size, iv);
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 89d9710..263fed8 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1040,6 +1040,9 @@ decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	};
 	int rc = 0;
 
+	sg_init_table(&dst_sg, 1);
+	sg_init_table(&src_sg, 1);
+
 	if (unlikely(ecryptfs_verbosity > 0)) {
 		ecryptfs_printk(
 			KERN_DEBUG, "Session key encryption key (size [%d]):\n",
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index ebd03cc..6f03918 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -88,7 +88,7 @@ nfs4_make_rec_clidname(char *dname, struct xdr_netobj *clname)
 {
 	struct xdr_netobj cksum;
 	struct hash_desc desc;
-	struct scatterlist sg[1];
+	struct scatterlist sg;
 	__be32 status = nfserr_resource;
 
 	dprintk("NFSD: nfs4_make_rec_clidname for %.*s\n",
@@ -102,11 +102,9 @@ nfs4_make_rec_clidname(char *dname, struct xdr_netobj *clname)
 	if (cksum.data == NULL)
  		goto out;
 
-	sg[0].page = virt_to_page(clname->data);
-	sg[0].offset = offset_in_page(clname->data);
-	sg[0].length = clname->len;
+	sg_init_one(&sg, clname->data, clname->len);
 
-	if (crypto_hash_digest(&desc, sg, sg->length, cksum.data))
+	if (crypto_hash_digest(&desc, &sg, sg.length, cksum.data))
 		goto out;
 
 	md5_to_hex(dname, cksum.data);
-- 
1.5.3.GIT

