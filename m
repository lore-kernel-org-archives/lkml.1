Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbZDFVlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbZDFVlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZDFVlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:41:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45723 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZDFVlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:41:12 -0400
Message-ID: <49DA7710.7040008@redhat.com>
Date: Mon, 06 Apr 2009 17:41:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [RFC][PROTO][PATCH -tip 1/7] kprobes: use list instead of hlist for
 insn_pages
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct list instead of struct hlist for managing insn_pages, because
insn_pages doesn't use hash table.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 kernel/kprobes.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)


diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index a5e74dd..5a57abd 100644
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
@@ -235,8 +230,7 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)

 static int __kprobes collect_garbage_slots(void)
 {
-	struct kprobe_insn_page *kip;
-	struct hlist_node *pos, *next;
+	struct kprobe_insn_page *kip, *next;
 	int safety;

 	/* Ensure no-one is preepmted on the garbages */
@@ -246,7 +240,7 @@ static int __kprobes collect_garbage_slots(void)
 	if (safety != 0)
 		return -EAGAIN;

-	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
+	list_for_each_entry_safe(kip, next, &kprobe_insn_pages, list) {
 		int i;
 		if (kip->ngarbage == 0)
 			continue;
@@ -264,19 +258,17 @@ static int __kprobes collect_garbage_slots(void)
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
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

