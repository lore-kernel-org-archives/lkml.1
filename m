Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYKKVAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYKKVAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYKKU6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:58:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbYKKU6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:58:23 -0500
Message-ID: <4919F1C6.4030106@redhat.com>
Date: Tue, 11 Nov 2008 15:57:42 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 7/7] kprobes: Support probing module __init function
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow kprobes to probe module __init routines.
When __init functions are freed, kprobes which probe those functions
are set to "Gone" flag. These "Gone" probes are disarmed from the code
and never be enabled.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/kprobes.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

Index: 2.6.28-rc4/kernel/kprobes.c
===================================================================
--- 2.6.28-rc4.orig/kernel/kprobes.c
+++ 2.6.28-rc4/kernel/kprobes.c
@@ -676,6 +676,16 @@ int __kprobes register_kprobe(struct kpr
 			preempt_enable();
 			return -EINVAL;
 		}
+		/*
+		 * If the module freed .init.text, we couldn't insert
+		 * kprobes in there.
+		 */
+		if (within_module_init((unsigned long)p->addr, probed_mod) &&
+		    probed_mod->state != MODULE_STATE_COMING) {
+			module_put(probed_mod);
+			preempt_enable();
+			return -EINVAL;
+		}
 	}
 	preempt_enable();

@@ -1072,19 +1082,24 @@ static int __kprobes kprobes_module_call
 	struct hlist_node *node;
 	struct kprobe *p;
 	unsigned int i;
+	int checkcore = (val == MODULE_STATE_GOING);

-	if (val != MODULE_STATE_GOING)
+	if (val != MODULE_STATE_GOING && val != MODULE_STATE_LIVE)
 		return NOTIFY_DONE;

 	/*
-	 * module .text section will be freed. We need to
-	 * disable kprobes which have been inserted in the section.
+	 * When MODULE_STATE_GOING was notified, both of module .text and
+	 * .init.text sections would be freed. When MODULE_STATE_LIVE was
+	 * notified, only .init.text section would be freed. We need to
+	 * disable kprobes which have been inserted in the sections.
 	 */
 	mutex_lock(&kprobe_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
-			if (within_module_core((unsigned long)p->addr, mod)) {
+			if (within_module_init((unsigned long)p->addr, mod) ||
+			    (checkcore &&
+			     within_module_core((unsigned long)p->addr, mod))) {
 				/*
 				 * The vaddr this probe is installed will soon
 				 * be vfreed buy not synced to disk. Hence,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

