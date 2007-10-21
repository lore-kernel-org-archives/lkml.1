Return-Path: <linux-kernel-owner+w=401wt.eu-S1751310AbXJUC0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbXJUC0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 22:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXJUCZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 22:25:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:51525 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXJUCZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 22:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=aOxpeN+wMnb2RN40km8YC3Tvo2Yzu+JTTBOFGWIa7N5jMTq51cFK5XQdlzF3U5Zja276as3QNvRrXMEJwHcCVZlG3MpybwveL005acf4CUU6R4ikO5MVgoYsmaMXs8kTmAzMZG5dRgmKU/iID1Uz0SNzFF9VVW2ZV7QfdxepT50=
Date: Sun, 21 Oct 2007 04:25:43 +0200
To: Casey Schaufler <casey@schaufler-ca.com>, Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Smackv8: Safe lockless {cipso,load} read operation
Message-ID: <20071021022543.GB3091@Ahmed>
References: <47158CE4.30706@schaufler-ca.com> <20071021014021.GA3091@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021014021.GA3091@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Utilizing Al's concers about using smack_cipso_count without locking,
here's a patch that remove smack_cipso_count and uses simple list 
traversing in read() without any counting mechanism.

CC: Al Viro <viro@ftp.linux.org.uk>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

---

Please apply over omit-non-cipso-lables-in-cipso-seq-start.patch
Using smack_{list,cipso}_count in the read context was useless
anyway cause we were just traversing the list.

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index b061cd0..c38d0d0 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -63,16 +63,17 @@ int smack_cipso_direct = SMACK_CIPSO_DIRECT_DEFAULT;
 
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 static int smack_list_count;
-static int smack_cipso_count;
 struct smk_list_entry *smack_list;
 
+#define SEQ_READ_FINISHED	1
+
 /*
  * Seq_file read operations for /smack/load
  */
 
 static void *load_seq_start(struct seq_file *s, loff_t *pos)
 {
-	if (*pos >= smack_list_count)
+	if (*pos == SEQ_READ_FINISHED)
 		return NULL;
 
 	return smack_list;
@@ -80,8 +81,13 @@ static void *load_seq_start(struct seq_file *s, loff_t *pos)
 
 static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	(*pos)++;
-	return ((struct smk_list_entry *) v)->smk_next;
+	struct smk_list_entry *skp = ((struct smk_list_entry *) v)->smk_next;
+
+	if (skp)
+		return skp;
+
+	*pos = SEQ_READ_FINISHED;
+	return NULL;
 }
 
 static int load_seq_show(struct seq_file *s, void *v)
@@ -306,7 +312,7 @@ static void *cipso_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct smack_known *skp = smack_known;
 
-	if (*pos >= smack_cipso_count)
+	if (*pos == SEQ_READ_FINISHED)
 		return NULL;
 
 	while (skp && !skp->smk_cipso)
@@ -319,12 +325,14 @@ static void *cipso_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct smack_known *skp = ((struct smack_known *) v)->smk_next;
 
-	(*pos)++;
-
 	while (skp && !skp->smk_cipso)
 		skp = skp->smk_next;
 
-	return skp;
+	if (skp)
+		return skp;
+
+	*pos = SEQ_READ_FINISHED;
+	return NULL;
 }
 
 /*
@@ -488,7 +496,6 @@ static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
 				rc = -ENOMEM;
 				break;
 			}
-			++smack_cipso_count;
 		} else
 			scp = NULL;
 

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
