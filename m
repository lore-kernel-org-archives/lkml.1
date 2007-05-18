Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbXERJ40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbXERJ40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXERJ4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:56:19 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:19806 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbXERJ4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:56:18 -0400
Message-ID: <464D792F.3040500@sw.ru>
Date: Fri, 18 May 2007 14:00:15 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>, devel@openvz.org
Subject: [PATCH 11/15] Make some netfilter-related proc files use seq_list_xxx
 helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This includes /proc/net/ip_conntrack_expect file.

Although struct nf_conntrack_expect has list_head as
the very first element I use list_entry in .show callback
to emphasize the fact that *v is the list_head pointer.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 89f933e..bec843a 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -208,35 +208,15 @@ static const struct file_operations ct_f
 /* expects */
 static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct list_head *e = &nf_conntrack_expect_list;
-	loff_t i;
-
 	/* strange seq_file api calls stop even if we fail,
 	 * thus we need to grab lock since stop unlocks */
 	read_lock_bh(&nf_conntrack_lock);
-
-	if (list_empty(e))
-		return NULL;
-
-	for (i = 0; i <= *pos; i++) {
-		e = e->next;
-		if (e == &nf_conntrack_expect_list)
-			return NULL;
-	}
-	return e;
+	return seq_list_start(&nf_conntrack_expect_list, *pos);
 }
 
 static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct list_head *e = v;
-
-	++*pos;
-	e = e->next;
-
-	if (e == &nf_conntrack_expect_list)
-		return NULL;
-
-	return e;
+	return seq_list_next(v, &nf_conntrack_expect_list, pos);
 }
 
 static void exp_seq_stop(struct seq_file *s, void *v)
@@ -246,7 +226,8 @@ static void exp_seq_stop(struct seq_file
 
 static int exp_seq_show(struct seq_file *s, void *v)
 {
-	struct nf_conntrack_expect *exp = v;
+	struct nf_conntrack_expect *exp = list_entry(v,
+			struct nf_conntrack_expect, list);
 
 	if (exp->tuple.src.l3num != AF_INET)
 		return 0;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 117cbfd..7ea80e4 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -366,35 +366,15 @@ EXPORT_SYMBOL_GPL(nf_conntrack_expect_re
 #ifdef CONFIG_PROC_FS
 static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct list_head *e = &nf_conntrack_expect_list;
-	loff_t i;
-
 	/* strange seq_file api calls stop even if we fail,
 	 * thus we need to grab lock since stop unlocks */
 	read_lock_bh(&nf_conntrack_lock);
-
-	if (list_empty(e))
-		return NULL;
-
-	for (i = 0; i <= *pos; i++) {
-		e = e->next;
-		if (e == &nf_conntrack_expect_list)
-			return NULL;
-	}
-	return e;
+	return seq_list_start(&nf_conntrack_expect_list, *pos);
 }
 
 static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct list_head *e = v;
-
-	++*pos;
-	e = e->next;
-
-	if (e == &nf_conntrack_expect_list)
-		return NULL;
-
-	return e;
+	return seq_list_next(v, &nf_conntrack_expect_list, pos);
 }
 
 static void exp_seq_stop(struct seq_file *s, void *v)
@@ -404,7 +384,8 @@ static void exp_seq_stop(struct seq_file
 
 static int exp_seq_show(struct seq_file *s, void *v)
 {
-	struct nf_conntrack_expect *expect = v;
+	struct nf_conntrack_expect *expect = list_entry(v,
+			struct nf_conntrack_expect, list);
 
 	if (expect->timeout.function)
 		seq_printf(s, "%ld ", timer_pending(&expect->timeout)

