Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbYKKU6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbYKKU6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYKKU5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:57:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39803 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbYKKU5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:57:21 -0500
Message-ID: <4919F188.1060900@redhat.com>
Date: Tue, 11 Nov 2008 15:56:40 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Srinivasa Ds <srinivasa@in.ibm.com>
Subject: [PATCH 3/7] kprobes: Add __kprobes to kprobe internal functions
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __kprobes to kprobes internal functions for protecting
from probing by kprobes itself.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/kprobes.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

This patch is required for the patch 5/7.

Index: 2.6.28-rc4/kernel/kprobes.c
===================================================================
--- 2.6.28-rc4.orig/kernel/kprobes.c
+++ 2.6.28-rc4/kernel/kprobes.c
@@ -410,7 +410,7 @@ void __kprobes recycle_rp_inst(struct kr
 		hlist_add_head(&ri->hlist, head);
 }

-void kretprobe_hash_lock(struct task_struct *tsk,
+void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
 			 struct hlist_head **head, unsigned long *flags)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
@@ -421,13 +421,15 @@ void kretprobe_hash_lock(struct task_str
 	spin_lock_irqsave(hlist_lock, *flags);
 }

-static void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
+static void __kprobes kretprobe_table_lock(unsigned long hash,
+	unsigned long *flags)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_lock_irqsave(hlist_lock, *flags);
 }

-void kretprobe_hash_unlock(struct task_struct *tsk, unsigned long *flags)
+void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
+	unsigned long *flags)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
 	spinlock_t *hlist_lock;
@@ -436,7 +438,7 @@ void kretprobe_hash_unlock(struct task_s
 	spin_unlock_irqrestore(hlist_lock, *flags);
 }

-void kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
+void __kprobes kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_unlock_irqrestore(hlist_lock, *flags);
@@ -762,7 +764,7 @@ static void __kprobes __unregister_kprob
 	}
 }

-static int __register_kprobes(struct kprobe **kps, int num,
+static int __kprobes __register_kprobes(struct kprobe **kps, int num,
 	unsigned long called_from)
 {
 	int i, ret = 0;
@@ -828,7 +830,7 @@ unsigned long __weak arch_deref_entry_po
 	return (unsigned long)entry;
 }

-static int __register_jprobes(struct jprobe **jps, int num,
+static int __kprobes __register_jprobes(struct jprobe **jps, int num,
 	unsigned long called_from)
 {
 	struct jprobe *jp;
@@ -990,7 +992,7 @@ static int __kprobes __register_kretprob
 	return ret;
 }

-static int __register_kretprobes(struct kretprobe **rps, int num,
+static int __kprobes __register_kretprobes(struct kretprobe **rps, int num,
 	unsigned long called_from)
 {
 	int ret = 0, i;

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

