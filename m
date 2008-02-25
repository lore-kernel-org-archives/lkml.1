Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbYBYF5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbYBYF5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYBYF5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:57:45 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:48634 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbYBYF5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:57:43 -0500
From: srinivasa <srinivasa@in.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com
Subject: [RFC] [PATCH] To refuse users from probing preempt_schedule()
Date: Mon, 25 Feb 2008 11:27:40 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251127.40579.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivasa Ds <srinivasa@in.ibm.com>

This patch prohibits user from probing preempt_schedule(). One way of
prohibiting the user from probing functions is by marking such 
functions with __kprobes. But this method doesn't work for those functions,
which are already marked to different section like preempt_schedule()
(belongs to __sched section). So we use blacklist approach to refuse user
from probing these functions.

In blacklist approach we populate the blacklisted function's starting
address and its size in kprobe_blacklist structure. Then we verify the user
specified address against start and end of the blacklisted function.
So any attempt to register probe on blacklisted functions will be rejected.

please let me know your comments.

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com> 
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com> 


---
 include/linux/kprobes.h |    7 ++++++
 kernel/kprobes.c        |   52 
++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

Index: linux-2.6.25-rc3/include/linux/kprobes.h
===================================================================
--- linux-2.6.25-rc3.orig/include/linux/kprobes.h
+++ linux-2.6.25-rc3/include/linux/kprobes.h
@@ -173,6 +173,13 @@ struct kretprobe_blackpoint {
 	const char *name;
 	void *addr;
 };
+
+struct kprobe_blackpoint {
+	const char *name;
+	unsigned long start_addr;
+	unsigned long range;
+};
+
 extern struct kretprobe_blackpoint kretprobe_blacklist[];
 
 static inline void kretprobe_assert(struct kretprobe_instance *ri,
Index: linux-2.6.25-rc3/kernel/kprobes.c
===================================================================
--- linux-2.6.25-rc3.orig/kernel/kprobes.c
+++ linux-2.6.25-rc3/kernel/kprobes.c
@@ -89,6 +89,18 @@ struct kprobe_insn_page {
 	int ngarbage;
 };
 
+/*
+ * Normally, functions that we'd want to prohibit kprobes in, are marked
+ * __kprobes. But, there are cases where such functions already belong to
+ * a different section (__sched for preempt_schedule)
+ *
+ * For such cases, we now have a blacklist
+ */
+struct kprobe_blackpoint kprobe_blacklist[] = {
+        {"preempt_schedule",},
+        {NULL}    /* Terminator */
+};
+
 enum kprobe_slot_state {
 	SLOT_CLEAN = 0,
 	SLOT_DIRTY = 1,
@@ -492,9 +504,22 @@ static int __kprobes register_aggr_kprob
 
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
+	struct kprobe_blackpoint *kb;
+
 	if (addr >= (unsigned long)__kprobes_text_start &&
 	    addr < (unsigned long)__kprobes_text_end)
 		return -EINVAL;
+	/*
+	 * If there exists a kprobe_blacklist, verify and
+	 * fail any probe registration in the prohibited area
+	 */
+	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
+		if (kb->start_addr) {
+			if (addr >= kb->start_addr &&
+			    addr < (kb->start_addr + kb->range))
+				return -EINVAL;
+		}
+	}
 	return 0;
 }
 
@@ -805,6 +830,11 @@ void __kprobes unregister_kretprobe(stru
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
+	unsigned long offset = 0, size = 0;
+	char *modname, namebuf[128];
+	const char *symbol_name;
+	void *addr;
+	struct kprobe_blackpoint *kb;
 
 	/* FIXME allocate the probe table, currently defined statically */
 	/* initialize all list heads */
@@ -813,6 +843,28 @@ static int __init init_kprobes(void)
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
 	}
 
+	/*
+	 * Lookup and populate the kprobe_blacklist.
+	 *
+	 * Unlike the kretprobe blacklist, we'll need to determine
+	 * the range of addresses that belong to the said functions,
+	 * since a kprobe need not necessarily be at the beginning
+	 * of a function.
+	 */
+	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
+		kprobe_lookup_name(kb->name, addr);
+		if (!addr)
+			continue;
+
+		kb->start_addr = (unsigned long)addr;
+		symbol_name = kallsyms_lookup(kb->start_addr,
+				&size, &offset, &modname, namebuf);
+		if (!symbol_name)
+			kb->range = 0;
+		else
+			kb->range = size;
+	}
+
 	if (kretprobe_blacklist_size) {
 		/* lookup the function address from its name */
 		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
