Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZHUSdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZHUSdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZHUSdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:33:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58637 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZHUSdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:33:15 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>, Roland Kletzing <devzero@web.de>,
       "<David Safford" <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 2/2] ima: hashing large files bug fix
Date: Fri, 21 Aug 2009 14:32:49 -0400
Message-Id: <3fa4204e315c0bc33ae378d4f01a53eab2e5e4bc.1250871856.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <df9691ba169503565c2e3b71c593f9c43a6b3eb2.1250871856.git.zohar@linux.vnet.ibm.com>
References: <df9691ba169503565c2e3b71c593f9c43a6b3eb2.1250871856.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <df9691ba169503565c2e3b71c593f9c43a6b3eb2.1250871856.git.zohar@linux.vnet.ibm.com>
References: <df9691ba169503565c2e3b71c593f9c43a6b3eb2.1250871856.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hashing files larger than INT_MAX causes process to loop.
Dependent on redefining kernel_read() offset type to loff_t.

(http://bugzilla.kernel.org/show_bug.cgi?id=13909)

Cc: stable@kernel.org
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/ima/ima_crypto.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 63003a6..46642a1 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -45,9 +45,9 @@ int ima_calc_hash(struct file *file, char *digest)
 {
 	struct hash_desc desc;
 	struct scatterlist sg[1];
-	loff_t i_size;
+	loff_t i_size, offset = 0;
 	char *rbuf;
-	int rc, offset = 0;
+	int rc;
 
 	rc = init_desc(&desc);
 	if (rc != 0)
@@ -67,6 +67,8 @@ int ima_calc_hash(struct file *file, char *digest)
 			rc = rbuf_len;
 			break;
 		}
+		if (rbuf_len == 0)
+			break;
 		offset += rbuf_len;
 		sg_init_one(sg, rbuf, rbuf_len);
 
-- 
1.6.0.6

