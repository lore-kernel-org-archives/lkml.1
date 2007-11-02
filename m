Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbXKBUz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbXKBUz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 16:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXKBUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 16:55:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33763 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbXKBUzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 16:55:19 -0400
Date: Fri, 2 Nov 2007 15:51:46 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: phillip@hellewell.homeip.net, ecryptfs-devel@lists.sourceforge.net,
       Kazuki Ohta <kazuki.ohta@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptfs: Release mutex on hash error path
Message-ID: <20071102205145.GD30487@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <b82310160710282310v369cc6f9uf544fa3daadd2743@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b82310160710282310v369cc6f9uf544fa3daadd2743@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 03:10:09PM +0900, Kazuki Ohta wrote:
> When IS_ERR(desc.tfm) is true, unlocking
> crypt_stat->cs_hash_tfm_mutex is forgotten.

Thanks for reporting this, Kazuki.
---

Release the crypt_stat hash mutex on allocation error. Check for error
conditions when doing crypto hash calls.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index a0f53aa..70f7aab 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -115,11 +115,29 @@ static int ecryptfs_calculate_md5(char *dst,
 		}
 		crypt_stat->hash_tfm = desc.tfm;
 	}
-	crypto_hash_init(&desc);
-	crypto_hash_update(&desc, &sg, len);
-	crypto_hash_final(&desc, dst);
-	mutex_unlock(&crypt_stat->cs_hash_tfm_mutex);
+	rc = crypto_hash_init(&desc);
+	if (rc) {
+		printk(KERN_ERR
+		       "%s: Error initializing crypto hash; rc = [%d]\n",
+		       __FUNCTION__, rc);
+		goto out;
+	}
+	rc = crypto_hash_update(&desc, &sg, len);
+	if (rc) {
+		printk(KERN_ERR
+		       "%s: Error updating crypto hash; rc = [%d]\n",
+		       __FUNCTION__, rc);
+		goto out;
+	}
+	rc = crypto_hash_final(&desc, dst);
+	if (rc) {
+		printk(KERN_ERR
+		       "%s: Error finalizing crypto hash; rc = [%d]\n",
+		       __FUNCTION__, rc);
+		goto out;
+	}
 out:
+	mutex_unlock(&crypt_stat->cs_hash_tfm_mutex);
 	return rc;
 }
 
-- 
1.5.0.6

