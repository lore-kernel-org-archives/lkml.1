Return-Path: <linux-kernel-owner+w=401wt.eu-S1751794AbXJUBkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbXJUBkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbXJUBkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:40:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:13386 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbXJUBka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=YlTV0Wk9lNmskYVYGHgmqr/7GkkuVej+NHOHar+b9J8FGrEIJ4xZwA90iKqLZc8wXOYQtHpBDmoVTl7JtAjpm70t1Ir37F/7UjwpdzNQ0/Y5qvkxcg14MXkNLOv0ThSQpq/kSpQbWJaQ+LoSG03YtMXQniTEdGt1DwN0xSFF+Dk=
Date: Sun, 21 Oct 2007 03:40:21 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Smackv8: Omit non-cipso labels in cipso_seq_start
Message-ID: <20071021014021.GA3091@Ahmed>
References: <47158CE4.30706@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47158CE4.30706@schaufler-ca.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!,

[Casey, sending patches in public to get an early review]

Omit non-cipso labels in cipso_seq_start().

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
stopping seq_show() if smk_cipso = NULL only fixes the bug 
symptom. We'll issue a BUG() in that case cause it signals a
serious misbehavior in the list entries.

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


-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
