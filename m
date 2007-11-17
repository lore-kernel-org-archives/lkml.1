Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbXKQPCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbXKQPCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 10:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbXKQPCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 10:02:40 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:43300 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbXKQPCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 10:02:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAHORPkdMROHU/2dsb2JhbACBXw
Date: Sat, 17 Nov 2007 10:02:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linux-kernel@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [rfc-patch 07/11] Text Edit Lock - kprobes architecture
	independent support
Message-ID: <20071117150236.GA16091@Krystal>
References: <20071116195747.448703304@polymtl.ca> <20071116200139.134470826@polymtl.ca> <473EBFBA.7080705@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <473EBFBA.7080705@tiscali.nl>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:00:31 up 13 days, 20:05,  2 users,  load average: 0.81, 0.66,
	0.51
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin (12o3l@tiscali.nl) wrote:
[...]
> >  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
> >  		head = &kprobe_table[i];
> > +		kernel_text_lock();
> >  		hlist_for_each_entry_rcu(p, node, head, hlist)
> >  			arch_arm_kprobe(p);
> > +		kernel_text_unlock();
> >  	}
> 
> isn't it better to put the kernel_text_lock around the for loop?
> 
> >  
> >  	kprobe_enabled = true;
> > @@ -969,10 +974,12 @@ static void __kprobes disable_all_kprobe
> >  	printk(KERN_INFO "Kprobes globally disabled\n");
> >  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
> >  		head = &kprobe_table[i];
> > +		kernel_text_lock();
> >  		hlist_for_each_entry_rcu(p, node, head, hlist) {
> >  			if (!arch_trampoline_kprobe(p))
> >  				arch_disarm_kprobe(p);
> >  		}
> > +		kernel_text_unlock();
> >  	}
> 
> same question here
> 

Yes, you are right, although it does not have to be fast. Here is the
updated patch.

Text Edit Lock - kprobes architecture independent support

Use the mutual exclusion provided by the text edit lock in the kprobes code. It
allows coherent manipulation of the kernel code by other subsystems.

Changelog:

Move the kernel_text_lock/unlock out of the for loops.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
CC: Roel Kluin <12o3l@tiscali.nl>
---
 kernel/kprobes.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kprobes.c	2007-11-16 13:40:06.000000000 -0500
+++ linux-2.6-lttng/kernel/kprobes.c	2007-11-17 10:00:23.000000000 -0500
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
+#include <linux/memory.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -568,9 +569,10 @@ static int __kprobes __register_kprobe(s
 		goto out;
 	}
 
+	kernel_text_lock();
 	ret = arch_prepare_kprobe(p);
 	if (ret)
-		goto out;
+		goto out_unlock_text;
 
 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
@@ -578,7 +580,8 @@ static int __kprobes __register_kprobe(s
 
 	if (kprobe_enabled)
 		arch_arm_kprobe(p);
-
+out_unlock_text:
+	kernel_text_unlock();
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -621,8 +624,11 @@ valid_p:
 		 * enabled - otherwise, the breakpoint would already have
 		 * been removed. We save on flushing icache.
 		 */
-		if (kprobe_enabled)
+		if (kprobe_enabled) {
+			kernel_text_lock();
 			arch_disarm_kprobe(p);
+			kernel_text_unlock();
+		}
 		hlist_del_rcu(&old_p->hlist);
 		cleanup_p = 1;
 	} else {
@@ -644,9 +650,7 @@ valid_p:
 			list_del_rcu(&p->list);
 			kfree(old_p);
 		}
-		mutex_lock(&kprobe_mutex);
 		arch_remove_kprobe(p);
-		mutex_unlock(&kprobe_mutex);
 	} else {
 		mutex_lock(&kprobe_mutex);
 		if (p->break_handler)
@@ -717,7 +721,6 @@ static int __kprobes pre_handler_kretpro
 		ri->rp = rp;
 		ri->task = current;
 		arch_prepare_kretprobe(ri, regs);
-
 		/* XXX(hch): why is there no hlist_move_head? */
 		hlist_del(&ri->uflist);
 		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
@@ -938,11 +941,13 @@ static void __kprobes enable_all_kprobes
 	if (kprobe_enabled)
 		goto already_enabled;
 
+	kernel_text_lock();
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			arch_arm_kprobe(p);
 	}
+	kernel_text_unlock();
 
 	kprobe_enabled = true;
 	printk(KERN_INFO "Kprobes globally enabled\n");
@@ -967,6 +972,7 @@ static void __kprobes disable_all_kprobe
 
 	kprobe_enabled = false;
 	printk(KERN_INFO "Kprobes globally disabled\n");
+	kernel_text_lock();
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
@@ -974,6 +980,7 @@ static void __kprobes disable_all_kprobe
 				arch_disarm_kprobe(p);
 		}
 	}
+	kernel_text_unlock();
 
 	mutex_unlock(&kprobe_mutex);
 	/* Allow all currently running kprobes to complete */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
