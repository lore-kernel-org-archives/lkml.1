Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbZFVVVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbZFVVVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759230AbZFVVVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:21:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59707 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759274AbZFVVV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:21:29 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC][ PATCH -tip v2 2/7] kprobes: introducing generic insn_slot
	framework
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>
Date: Mon, 22 Jun 2009 17:23:07 -0400
Message-ID: <20090622212307.5384.41192.stgit@localhost.localdomain>
In-Reply-To: <20090622212255.5384.53732.stgit@localhost.localdomain>
References: <20090622212255.5384.53732.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make insn_slot framework support various size slots.
Current insn_slot just supports one-size instruction buffer slot. However,
kprobes jump optimization needs larger size buffers.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
---

 kernel/kprobes.c |   96 +++++++++++++++++++++++++++++++++---------------------
 1 files changed, 58 insertions(+), 38 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 0b68fdc..bc9cfd0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -100,26 +100,38 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
  * stepping on the instruction on a vmalloced/kmalloced/data page
  * is a recipe for disaster
  */
-#define INSNS_PER_PAGE	(PAGE_SIZE/(MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
-
 struct kprobe_insn_page {
 	struct list_head list;
 	kprobe_opcode_t *insns;		/* Page of instruction slots */
-	char slot_used[INSNS_PER_PAGE];
 	int nused;
 	int ngarbage;
+	char slot_used[1];
+};
+
+struct kprobe_insn_cache {
+	struct list_head pages;	/* list of kprobe_insn_page */
+	size_t insn_size;	/* size of instruction slot */
+	int nr_garbage;
 };
 
+static int slots_per_page(struct kprobe_insn_cache *c)
+{
+	return PAGE_SIZE/(c->insn_size * sizeof(kprobe_opcode_t));
+}
+
 enum kprobe_slot_state {
 	SLOT_CLEAN = 0,
 	SLOT_DIRTY = 1,
 	SLOT_USED = 2,
 };
 
-static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_pages */
-static LIST_HEAD(kprobe_insn_pages);
-static int kprobe_garbage_slots;
-static int collect_garbage_slots(void);
+static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_slots */
+static struct kprobe_insn_cache kprobe_insn_slots = {
+	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
+	.insn_size = MAX_INSN_SIZE,
+	.nr_garbage = 0,
+};
+static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c);
 
 static int __kprobes check_safety(void)
 {
@@ -149,32 +161,33 @@ loop_end:
  * __get_insn_slot() - Find a slot on an executable page for an instruction.
  * We allocate an executable page if there's no room on existing ones.
  */
-static kprobe_opcode_t __kprobes *__get_insn_slot(void)
+static kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip;
 
  retry:
-	list_for_each_entry(kip, &kprobe_insn_pages, list) {
-		if (kip->nused < INSNS_PER_PAGE) {
+	list_for_each_entry(kip, &c->pages, list) {
+		if (kip->nused < slots_per_page(c)) {
 			int i;
-			for (i = 0; i < INSNS_PER_PAGE; i++) {
+			for (i = 0; i < slots_per_page(c); i++) {
 				if (kip->slot_used[i] == SLOT_CLEAN) {
 					kip->slot_used[i] = SLOT_USED;
 					kip->nused++;
-					return kip->insns + (i * MAX_INSN_SIZE);
+					return kip->insns + (i * c->insn_size);
 				}
 			}
-			/* Surprise!  No unused slots.  Fix kip->nused. */
-			kip->nused = INSNS_PER_PAGE;
+			/* kip->nused is broken. */
+			BUG();
 		}
 	}
 
 	/* If there are any garbage slots, collect it and try again. */
-	if (kprobe_garbage_slots && collect_garbage_slots() == 0) {
+	if (c->nr_garbage && collect_garbage_slots(c) == 0)
 		goto retry;
-	}
+
 	/* All out of space.  Need to allocate a new page. Use slot 0. */
-	kip = kmalloc(sizeof(struct kprobe_insn_page), GFP_KERNEL);
+	kip = kmalloc(sizeof(struct kprobe_insn_page) + slots_per_page(c) - 1,
+		      GFP_KERNEL);
 	if (!kip)
 		return NULL;
 
@@ -189,19 +202,20 @@ static kprobe_opcode_t __kprobes *__get_insn_slot(void)
 		return NULL;
 	}
 	INIT_LIST_HEAD(&kip->list);
-	list_add(&kip->list, &kprobe_insn_pages);
-	memset(kip->slot_used, SLOT_CLEAN, INSNS_PER_PAGE);
+	memset(kip->slot_used, SLOT_CLEAN, slots_per_page(c));
 	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
 	kip->ngarbage = 0;
+	list_add(&kip->list, &c->pages);
 	return kip->insns;
 }
 
+
 kprobe_opcode_t __kprobes *get_insn_slot(void)
 {
-	kprobe_opcode_t *ret;
+	kprobe_opcode_t *ret = NULL;
 	mutex_lock(&kprobe_insn_mutex);
-	ret = __get_insn_slot();
+	ret = __get_insn_slot(&kprobe_insn_slots);
 	mutex_unlock(&kprobe_insn_mutex);
 	return ret;
 }
@@ -218,7 +232,7 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 		 * so as not to have to set it up again the
 		 * next time somebody inserts a probe.
 		 */
-		if (!list_is_singular(&kprobe_insn_pages)) {
+		if (!list_is_singular(&kip->list)) {
 			list_del(&kip->list);
 			module_free(NULL, kip->insns);
 			kfree(kip);
@@ -228,7 +242,7 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 	return 0;
 }
 
-static int __kprobes collect_garbage_slots(void)
+static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip, *next;
 	int safety;
@@ -240,42 +254,48 @@ static int __kprobes collect_garbage_slots(void)
 	if (safety != 0)
 		return -EAGAIN;
 
-	list_for_each_entry_safe(kip, next, &kprobe_insn_pages, list) {
+	list_for_each_entry_safe(kip, next, &c->pages, list) {
 		int i;
 		if (kip->ngarbage == 0)
 			continue;
 		kip->ngarbage = 0;	/* we will collect all garbages */
-		for (i = 0; i < INSNS_PER_PAGE; i++) {
+		for (i = 0; i < slots_per_page(c); i++) {
 			if (kip->slot_used[i] == SLOT_DIRTY &&
 			    collect_one_slot(kip, i))
 				break;
 		}
 	}
-	kprobe_garbage_slots = 0;
+	c->nr_garbage = 0;
 	return 0;
 }
 
-void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
+static void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
+				       kprobe_opcode_t *slot, int dirty)
 {
 	struct kprobe_insn_page *kip;
 
-	mutex_lock(&kprobe_insn_mutex);
-	list_for_each_entry(kip, &kprobe_insn_pages, list) {
-		if (kip->insns <= slot &&
-		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
-			int i = (slot - kip->insns) / MAX_INSN_SIZE;
+	list_for_each_entry(kip, &c->pages, list) {
+		long idx = ((long)slot - (long)kip->insns) / c->insn_size;
+		if (idx >= 0 && idx < slots_per_page(c)) {
+			WARN_ON(kip->slot_used[idx] != SLOT_USED);
 			if (dirty) {
-				kip->slot_used[i] = SLOT_DIRTY;
+				kip->slot_used[idx] = SLOT_DIRTY;
 				kip->ngarbage++;
+				if (++c->nr_garbage > slots_per_page(c))
+					collect_garbage_slots(c);
 			} else
-				collect_one_slot(kip, i);
-			break;
+				collect_one_slot(kip, idx);
+			return;
 		}
 	}
+	/* Could not free this slot. */
+	WARN_ON(1);
+}
 
-	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
-		collect_garbage_slots();
-
+void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
+{
+	mutex_lock(&kprobe_insn_mutex);
+	__free_insn_slot(&kprobe_insn_slots, slot, dirty);
 	mutex_unlock(&kprobe_insn_mutex);
 }
 #endif


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
