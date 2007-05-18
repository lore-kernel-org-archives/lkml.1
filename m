Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbXERJau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbXERJau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXERJao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:30:44 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:22830 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbXERJan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:30:43 -0400
Message-ID: <464D731F.1010101@sw.ru>
Date: Fri, 18 May 2007 13:34:23 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herbert@gondor.apana.org.au, devel@openvz.org
Subject: [PATCH 5/15] Make crypto API use seq_list_xxx helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simple and stupid - just use the same code from another
place in the kernel.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/crypto/proc.c b/crypto/proc.c
index 102c751..3d73323 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -23,24 +23,13 @@
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
-	struct list_head *v;
-	loff_t n = *pos;
-
 	down_read(&crypto_alg_sem);
-	list_for_each(v, &crypto_alg_list)
-		if (!n--)
-			return list_entry(v, struct crypto_alg, cra_list);
-	return NULL;
+	return seq_list_start(&crypto_alg_list, *pos);
 }
 
 static void *c_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	struct list_head *v = p;
-	
-	(*pos)++;
-	v = v->next;
-	return (v == &crypto_alg_list) ?
-		NULL : list_entry(v, struct crypto_alg, cra_list);
+	return seq_list_next(p, &crypto_alg_list, pos);
 }
 
 static void c_stop(struct seq_file *m, void *p)
@@ -50,7 +39,7 @@ static void c_stop(struct seq_file *m, v
 
 static int c_show(struct seq_file *m, void *p)
 {
-	struct crypto_alg *alg = (struct crypto_alg *)p;
+	struct crypto_alg *alg = list_entry(p, struct crypto_alg, cra_list);
 	
 	seq_printf(m, "name         : %s\n", alg->cra_name);
 	seq_printf(m, "driver       : %s\n", alg->cra_driver_name);

