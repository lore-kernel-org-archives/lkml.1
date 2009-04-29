Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZD2LFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZD2LFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZD2LFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:05:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:49833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbZD2LFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:05:17 -0400
Date: Wed, 29 Apr 2009 11:04:38 GMT
From: tip-bot for Stuart Bennett <stuart@freedesktop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, pq@iki.fi, stuart@freedesktop.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, pq@iki.fi, stuart@freedesktop.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240946271-7083-3-git-send-email-stuart@freedesktop.org>
References: <1240946271-7083-3-git-send-email-stuart@freedesktop.org>
Subject: [tip:tracing/core] tracing: x86, mmiotrace: code consistency/legibility improvement
Message-ID: <tip-0492e1bb8fe7d122901c9f3af75e537d4129712e@git.kernel.org>
Git-Commit-ID: 0492e1bb8fe7d122901c9f3af75e537d4129712e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 11:04:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0492e1bb8fe7d122901c9f3af75e537d4129712e
Gitweb:     http://git.kernel.org/tip/0492e1bb8fe7d122901c9f3af75e537d4129712e
Author:     Stuart Bennett <stuart@freedesktop.org>
AuthorDate: Tue, 28 Apr 2009 20:17:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 11:33:33 +0200

tracing: x86, mmiotrace: code consistency/legibility improvement

kmmio_probe being *p and kmmio_fault_page being sometimes *f and
sometimes *p is not helpful.

[ Impact: cleanup ]

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Acked-by: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1240946271-7083-3-git-send-email-stuart@freedesktop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/kmmio.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 4f115e0..869181a 100644
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
 
