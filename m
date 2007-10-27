Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbXJ0O6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbXJ0O6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbXJ0O6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:58:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:32449 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbXJ0O6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ji+Pf2988jpU+eVFx/hL4VLfBGmrJZaBuyGr27DbCDIKQIM9mwGg6CzzP7aTBqKa9/78qrO7MMmuX5ivth+R3SbAg/c9MB5oEgxs/U7YcOrBEiKr+pz5AdUULX5lv+vXHB2Cvanz1/QdJaLikCKuwVbso9PhMmVqErarYFT6eTo=
Date: Sat, 27 Oct 2007 05:00:10 +0200
To: casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071027030010.GA5450@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4720118C.5020906@schaufler-ca.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,

Casey <casey@schaufler-ca.com> wrote:
>
> This version is again aimed at addressing Al Viro's issues in
> smackfs. Ahmed Darwish has again contributed in the repair of the
> locking issues there. The move to 2.6.24 was also an important
> release incentive.
>

My patches mentiond above is not applied in this version. The same 
lock issues remain. Did you forget applying them ? In that case, 
here're the same patches again (on ver8):

==> 1:
cipso_seq_show should not be passed smack labels with no cipso
mapping. Omit non-cipso mapped labels in cipso_seq_start and 
BUG in case cipso_seq_show was passed a non-cipso label.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.coM>
---

smackv8-omit-noncipso-in-seq-start.patch

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 55ba2dc..b061cd0 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -297,14 +297,22 @@ void smk_cipso_doi(void)
 
 /*
  * Seq_file read operations for /smack/cipso
+ *
+ * Omit labels with no associated cipso values from being
+ * displayed in seq_show()
  */
 
 static void *cipso_seq_start(struct seq_file *s, loff_t *pos)
 {
+	struct smack_known *skp = smack_known;
+
 	if (*pos >= smack_cipso_count)
 		return NULL;
 
-	return smack_known;
+	while (skp && !skp->smk_cipso)
+		skp = skp->smk_next;
+
+	return skp;
 }
 
 static void *cipso_seq_next(struct seq_file *s, void *v, loff_t *pos)
@@ -313,9 +321,6 @@ static void *cipso_seq_next(struct seq_file *s, void *v, loff_t *pos)
 
 	(*pos)++;
 
-	/*
-	 * Omit labels with no associated cipso value
-	 */
 	while (skp && !skp->smk_cipso)
 		skp = skp->smk_next;
 
@@ -336,12 +341,11 @@ static int cipso_seq_show(struct seq_file *s, void *v)
 	int i;
 	unsigned char m;
 
-	if (scp == NULL)
-		return 0;
+	BUG_ON(!scp);
+	cbp = scp->smk_catset;
 
 	seq_printf(s, "%s %3d", (char *)&skp->smk_known, scp->smk_level);
 
-	cbp = scp->smk_catset;
 	for (i = 0; i < SMK_LABELLEN; i++)
 		for (m = 0x80; m != 0; m >>= 1) {
 			if (m & cbp[i]) {

==> 2:

Avoid racy use of smack_{list,cipso}_count in traversing lists.
Simple smack_list and smack_known lockless list traversal is all 
what's needed.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

smackv8-lockless-read.patch

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index b061cd0..e343827 100644
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
@@ -80,8 +81,12 @@ static void *load_seq_start(struct seq_file *s, loff_t *pos)
 
 static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	(*pos)++;
-	return ((struct smk_list_entry *) v)->smk_next;
+	struct smk_list_entry *skp = ((struct smk_list_entry *) v)->smk_next;
+
+	if (!skp)
+		*pos = SEQ_READ_FINISHED;
+
+	return skp;
 }
 
 static int load_seq_show(struct seq_file *s, void *v)
@@ -306,7 +311,7 @@ static void *cipso_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct smack_known *skp = smack_known;
 
-	if (*pos >= smack_cipso_count)
+	if (*pos == SEQ_READ_FINISHED)
 		return NULL;
 
 	while (skp && !skp->smk_cipso)
@@ -319,11 +324,12 @@ static void *cipso_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct smack_known *skp = ((struct smack_known *) v)->smk_next;
 
-	(*pos)++;
-
 	while (skp && !skp->smk_cipso)
 		skp = skp->smk_next;
 
+	if (!skp)
+		*pos = SEQ_READ_FINISHED;
+
 	return skp;
 }
 
@@ -488,7 +494,6 @@ static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
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
