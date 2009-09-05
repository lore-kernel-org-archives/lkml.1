Return-Path: <linux-kernel-owner+w=401wt.eu-S934531AbZIEAcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934531AbZIEAcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934580AbZIEAUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:44 -0400
Received: from kroah.org ([198.145.64.141]:42069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934528AbZIEAUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:49 2009
Message-Id: <20090905001449.036498401@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>
Subject: [patch 11/71] ima: hashing large files bug fix
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=ima-hashing-large-files-bug-fix.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 16bfa38b1936212428cb38fbfbbb8f6c62b8d81f upstream.

Hashing files larger than INT_MAX causes process to loop.
Dependent on redefining kernel_read() offset type to loff_t.

(http://bugzilla.kernel.org/show_bug.cgi?id=13909)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/integrity/ima/ima_crypto.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -45,9 +45,9 @@ int ima_calc_hash(struct file *file, cha
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
@@ -67,6 +67,8 @@ int ima_calc_hash(struct file *file, cha
 			rc = rbuf_len;
 			break;
 		}
+		if (rbuf_len == 0)
+			break;
 		offset += rbuf_len;
 		sg_init_one(sg, rbuf, rbuf_len);
 


