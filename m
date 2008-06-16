Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYFPLOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYFPLOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYFPLOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:14:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52001 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYFPLOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:14:32 -0400
To: Michael Halcrow <mhalcrow@us.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch] ecryptfs: string copy cleanup
Message-Id: <E1K8CfM-0006Wa-Mu@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 16 Jun 2008 13:14:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Clean up overcomplicated string copy, which also gets rid of this
bogus warning:

fs/ecryptfs/main.c: In function 'ecryptfs_parse_options':
include/asm/arch/string_32.h:75: warning: array subscript is above array bounds

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/main.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/main.c	2008-06-09 14:14:27.000000000 +0200
+++ linux-2.6/fs/ecryptfs/main.c	2008-06-13 13:04:04.000000000 +0200
@@ -314,7 +314,6 @@ static int ecryptfs_parse_options(struct
 	char *cipher_name_dst;
 	char *cipher_name_src;
 	char *cipher_key_bytes_src;
-	int cipher_name_len;
 
 	if (!options) {
 		rc = -EINVAL;
@@ -395,17 +394,12 @@ static int ecryptfs_parse_options(struct
 		goto out;
 	}
 	if (!cipher_name_set) {
-		cipher_name_len = strlen(ECRYPTFS_DEFAULT_CIPHER);
-		if (unlikely(cipher_name_len
-			     >= ECRYPTFS_MAX_CIPHER_NAME_SIZE)) {
-			rc = -EINVAL;
-			BUG();
-			goto out;
-		}
-		memcpy(mount_crypt_stat->global_default_cipher_name,
-		       ECRYPTFS_DEFAULT_CIPHER, cipher_name_len);
-		mount_crypt_stat->global_default_cipher_name[cipher_name_len]
-		    = '\0';
+		int cipher_name_len = strlen(ECRYPTFS_DEFAULT_CIPHER);
+
+		BUG_ON(cipher_name_len >= ECRYPTFS_MAX_CIPHER_NAME_SIZE);
+
+		strcpy(mount_crypt_stat->global_default_cipher_name,
+		       ECRYPTFS_DEFAULT_CIPHER);
 	}
 	if (!cipher_key_bytes_set) {
 		mount_crypt_stat->global_default_cipher_key_size = 0;
