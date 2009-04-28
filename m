Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbZD1T2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbZD1T2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZD1T14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:27:56 -0400
Received: from relay.ptn-ipout01.plus.net ([212.159.7.35]:59195 "EHLO
	relay.ptn-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755774AbZD1T1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:27:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAM/y9knUnw4R/2dsb2JhbAC/MpAgg3MF
From: Stuart Bennett <stuart@freedesktop.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Stuart Bennett <stuart@freedesktop.org>
Subject: [PATCH] x86 mmiotrace: code consistency/legibility improvement
Date: Tue, 28 Apr 2009 20:17:49 +0100
Message-Id: <1240946271-7083-3-git-send-email-stuart@freedesktop.org>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1240946271-7083-2-git-send-email-stuart@freedesktop.org>
References: <1240946271-7083-1-git-send-email-stuart@freedesktop.org>
 <1240946271-7083-2-git-send-email-stuart@freedesktop.org>
X-Plusnet-Relay: fbea774489f848b9f85f3c4f4063cce2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmmio_probe being *p and kmmio_fault_page being sometimes *f and
sometimes *p is not helpful

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Acked-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 50dc802..6db840e 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -97,13 +97,13 @@ static struct kmmio_probe *get_kmmio_probe(unsigned long addr)
 static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 {
 	struct list_head *head;
-	struct kmmio_fault_page *p;
+	struct kmmio_fault_page *f;
 
 	page &= PAGE_MASK;
 	head = kmmio_page_list(page);
-	list_for_each_entry_rcu(p, head, list) {
-		if (p->page == page)
-			return p;
+	list_for_each_entry_rcu(f, head, list) {
+		if (f->page == page)
+			return f;
 	}
 	return NULL;
 }
@@ -439,12 +439,12 @@ static void rcu_free_kmmio_fault_pages(struct rcu_head *head)
 						head,
 						struct kmmio_delayed_release,
 						rcu);
-	struct kmmio_fault_page *p = dr->release_list;
-	while (p) {
-		struct kmmio_fault_page *next = p->release_next;
-		BUG_ON(p->count);
-		kfree(p);
-		p = next;
+	struct kmmio_fault_page *f = dr->release_list;
+	while (f) {
+		struct kmmio_fault_page *next = f->release_next;
+		BUG_ON(f->count);
+		kfree(f);
+		f = next;
 	}
 	kfree(dr);
 }
@@ -453,19 +453,19 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
 {
 	struct kmmio_delayed_release *dr =
 		container_of(head, struct kmmio_delayed_release, rcu);
-	struct kmmio_fault_page *p = dr->release_list;
+	struct kmmio_fault_page *f = dr->release_list;
 	struct kmmio_fault_page **prevp = &dr->release_list;
 	unsigned long flags;
 
 	spin_lock_irqsave(&kmmio_lock, flags);
-	while (p) {
-		if (!p->count) {
-			list_del_rcu(&p->list);
-			prevp = &p->release_next;
+	while (f) {
+		if (!f->count) {
+			list_del_rcu(&f->list);
+			prevp = &f->release_next;
 		} else {
-			*prevp = p->release_next;
+			*prevp = f->release_next;
 		}
-		p = p->release_next;
+		f = f->release_next;
 	}
 	spin_unlock_irqrestore(&kmmio_lock, flags);
 
-- 
1.5.4.4

