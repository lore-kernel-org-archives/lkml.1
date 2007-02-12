Return-Path: <linux-kernel-owner+w=401wt.eu-S965363AbXBLUWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363AbXBLUWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXBLUWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:22:19 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:35992 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965364AbXBLUWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:22:18 -0500
Date: Mon, 12 Feb 2007 21:22:00 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 11/14] nfnetlink_log: iterator functions need iter_state * only
Message-ID: <20070212202200.GB28704@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl> <20070212202052.GA28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070212202052.GA28704@rere.qmqm.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

get_*() don't need access to seq_file - iter_state is enough for them.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.9	2007-02-12 00:19:16.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:05:14.000000000 +0100
@@ -929,10 +929,8 @@ struct iter_state {
 	unsigned int bucket;
 };
 
-static struct hlist_node *get_first(struct seq_file *seq)
+static struct hlist_node *get_first(struct iter_state *st)
 {
-	struct iter_state *st = seq->private;
-
 	if (!st)
 		return NULL;
 
@@ -943,10 +941,8 @@ static struct hlist_node *get_first(stru
 	return NULL;
 }
 
-static struct hlist_node *get_next(struct seq_file *seq, struct hlist_node *h)
+static struct hlist_node *get_next(struct iter_state *st, struct hlist_node *h)
 {
-	struct iter_state *st = seq->private;
-
 	h = h->next;
 	while (!h) {
 		if (++st->bucket >= INSTANCE_BUCKETS)
@@ -957,13 +953,13 @@ static struct hlist_node *get_next(struc
 	return h;
 }
 
-static struct hlist_node *get_idx(struct seq_file *seq, loff_t pos)
+static struct hlist_node *get_idx(struct iter_state *st, loff_t pos)
 {
 	struct hlist_node *head;
-	head = get_first(seq);
+	head = get_first(st);
 
 	if (head)
-		while (pos && (head = get_next(seq, head)))
+		while (pos && (head = get_next(st, head)))
 			pos--;
 	return pos ? NULL : head;
 }
@@ -971,13 +967,13 @@ static struct hlist_node *get_idx(struct
 static void *seq_start(struct seq_file *seq, loff_t *pos)
 {
 	read_lock_bh(&instances_lock);
-	return get_idx(seq, *pos);
+	return get_idx(seq->private, *pos);
 }
 
 static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	(*pos)++;
-	return get_next(s, v);
+	return get_next(s->private, v);
 }
 
 static void seq_stop(struct seq_file *s, void *v)
