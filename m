Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZF3VF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZF3VF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbZF3VF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:05:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38795 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369AbZF3VF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:05:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/3] kprobes: cleanup: use list instead of hlist for
	insn_pages
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>
Date: Tue, 30 Jun 2009 17:08:14 -0400
Message-ID: <20090630210814.17851.64651.stgit@localhost.localdomain>
In-Reply-To: <20090630210757.17851.409.stgit@localhost.localdomain>
References: <20090630210757.17851.409.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct list instead of struct hlist for managing insn_pages, because
insn_pages doesn't use hash table.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
---

 kernel/kprobes.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 16b5739..6fe9dc6 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -103,7 +103,7 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 #define INSNS_PER_PAGE	(PAGE_SIZE/(MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
 
 struct kprobe_insn_page {
-	struct hlist_node hlist;
+	struct list_head list;
 	kprobe_opcode_t *insns;		/* Page of instruction slots */
 	char slot_used[INSNS_PER_PAGE];
 	int nused;
@@ -117,7 +117,7 @@ enum kprobe_slot_state {
 };
 
 static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_pages */
-static struct hlist_head kprobe_insn_pages;
+static LIST_HEAD(kprobe_insn_pages);
 static int kprobe_garbage_slots;
 static int collect_garbage_slots(void);
 
@@ -152,10 +152,9 @@ loop_end:
 static kprobe_opcode_t __kprobes *__get_insn_slot(void)
 {
 	struct kprobe_insn_page *kip;
-	struct hlist_node *pos;
 
  retry:
-	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
+	list_for_each_entry(kip, &kprobe_insn_pages, list) {
 		if (kip->nused < INSNS_PER_PAGE) {
 			int i;
 			for (i = 0; i < INSNS_PER_PAGE; i++) {
@@ -189,8 +188,8 @@ static kprobe_opcode_t __kprobes *__get_insn_slot(void)
 		kfree(kip);
 		return NULL;
 	}
-	INIT_HLIST_NODE(&kip->hlist);
-	hlist_add_head(&kip->hlist, &kprobe_insn_pages);
+	INIT_LIST_HEAD(&kip->list);
+	list_add(&kip->list, &kprobe_insn_pages);
 	memset(kip->slot_used, SLOT_CLEAN, INSNS_PER_PAGE);
 	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
@@ -219,12 +218,8 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 		 * so as not to have to set it up again the
 		 * next time somebody inserts a probe.
 		 */
-		hlist_del(&kip->hlist);
-		if (hlist_empty(&kprobe_insn_pages)) {
-			INIT_HLIST_NODE(&kip->hlist);
-			hlist_add_head(&kip->hlist,
-				       &kprobe_insn_pages);
-		} else {
+		if (!list_is_singular(&kprobe_insn_pages)) {
+			list_del(&kip->list);
 			module_free(NULL, kip->insns);
 			kfree(kip);
 		}
@@ -235,14 +230,13 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 
 static int __kprobes collect_garbage_slots(void)
 {
-	struct kprobe_insn_page *kip;
-	struct hlist_node *pos, *next;
+	struct kprobe_insn_page *kip, *next;
 
 	/* Ensure no-one is preepmted on the garbages */
 	if (check_safety())
 		return -EAGAIN;
 
-	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
+	list_for_each_entry_safe(kip, next, &kprobe_insn_pages, list) {
 		int i;
 		if (kip->ngarbage == 0)
 			continue;
@@ -260,19 +254,17 @@ static int __kprobes collect_garbage_slots(void)
 void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
 {
 	struct kprobe_insn_page *kip;
-	struct hlist_node *pos;
 
 	mutex_lock(&kprobe_insn_mutex);
-	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
+	list_for_each_entry(kip, &kprobe_insn_pages, list) {
 		if (kip->insns <= slot &&
 		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
 			int i = (slot - kip->insns) / MAX_INSN_SIZE;
 			if (dirty) {
 				kip->slot_used[i] = SLOT_DIRTY;
 				kip->ngarbage++;
-			} else {
+			} else
 				collect_one_slot(kip, i);
-			}
 			break;
 		}
 	}


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
