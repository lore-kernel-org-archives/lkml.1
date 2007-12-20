Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXLTNPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXLTNPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760235AbXLTNP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:15:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:49185 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbXLTNP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:15:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,189,1196668800"; 
   d="scan'208";a="247601704"
Date: Thu, 20 Dec 2007 14:05:30 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 1/5] x86, ptrace: rlimit BTS buffer allocation
Message-ID: <20071220140530.A29536@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the rlimit of the tracing task for total and locked memory when allocating the BTS buffer.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2007-12-20 13:51:21.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2007-12-20 13:51:45.%N +0100
@@ -620,12 +620,80 @@
 	return i;
 }
 
+static int ptrace_bts_realloc(struct task_struct *child,
+			      int size, int reduce_size)
+{
+	unsigned long rlim, vm;
+	int ret, old_size;
+
+	if (size < 0)
+		return -EINVAL;
+
+	old_size = ds_get_bts_size((void *)child->thread.ds_area_msr);
+	if (old_size < 0)
+		return old_size;
+
+	ret = ds_free((void **)&child->thread.ds_area_msr);
+	if (ret < 0)
+		goto out;
+
+	size >>= PAGE_SHIFT;
+	old_size >>= PAGE_SHIFT;
+
+	current->mm->total_vm  -= old_size;
+	current->mm->locked_vm -= old_size;
+
+	if (size == 0)
+		goto out;
+
+	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
+	vm = current->mm->total_vm  + size;
+	if (rlim < vm) {
+		ret = -ENOMEM;
+
+		if (!reduce_size)
+			goto out;
+
+		size = rlim - current->mm->total_vm;
+		if (size <= 0)
+			goto out;
+	}
+
+	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	vm = current->mm->locked_vm  + size;
+	if (rlim < vm) {
+		ret = -ENOMEM;
+
+		if (!reduce_size)
+			goto out;
+
+		size = rlim - current->mm->locked_vm;
+		if (size <= 0)
+			goto out;
+	}
+
+	ret = ds_allocate((void **)&child->thread.ds_area_msr,
+			  size << PAGE_SHIFT);
+	if (ret < 0)
+		goto out;
+
+	current->mm->total_vm  += size;
+	current->mm->locked_vm += size;
+
+out:
+	if (child->thread.ds_area_msr)
+		set_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+	else
+		clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+
+	return ret;
+}
+
 static int ptrace_bts_config(struct task_struct *child,
 			     const struct ptrace_bts_config __user *ucfg)
 {
 	struct ptrace_bts_config cfg;
-	unsigned long debugctl_mask;
-	int bts_size, ret;
+	int bts_size, ret = 0;
 	void *ds;
 
 	if (copy_from_user(&cfg, ucfg, sizeof(cfg)))
@@ -638,59 +706,46 @@
 		if (bts_size < 0)
 			return bts_size;
 	}
+	cfg.size = PAGE_ALIGN(cfg.size);
 
 	if (bts_size != cfg.size) {
-		ret = ds_free((void **)&child->thread.ds_area_msr);
+		ret = ptrace_bts_realloc(child, cfg.size,
+					 cfg.flags & PTRACE_BTS_O_CUT_SIZE);
 		if (ret < 0)
-			return ret;
+			goto errout;
 
-		if (cfg.size > 0)
-			ret = ds_allocate((void **)&child->thread.ds_area_msr,
-					  cfg.size);
 		ds = (void *)child->thread.ds_area_msr;
-		if (ds)
-			set_tsk_thread_flag(child, TIF_DS_AREA_MSR);
-		else
-			clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
-
-		if (ret < 0)
-			return ret;
-
-		bts_size = ds_get_bts_size(ds);
-		if (bts_size <= 0)
-			return bts_size;
 	}
 
-	if (ds) {
-		if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
-			ret = ds_set_overflow(ds, DS_O_SIGNAL);
-		} else {
-			ret = ds_set_overflow(ds, DS_O_WRAP);
-		}
-		if (ret < 0)
-			return ret;
-	}
-
-	debugctl_mask = ds_debugctl_mask();
-	if (ds && (cfg.flags & PTRACE_BTS_O_TRACE)) {
-		child->thread.debugctlmsr |= debugctl_mask;
-		set_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-	} else {
-		/* there is no way for us to check whether we 'own'
-		 * the respective bits in the DEBUGCTL MSR, we're
-		 * about to clear */
-		child->thread.debugctlmsr &= ~debugctl_mask;
+	if (cfg.flags & PTRACE_BTS_O_SIGNAL)
+		ret = ds_set_overflow(ds, DS_O_SIGNAL);
+	else
+		ret = ds_set_overflow(ds, DS_O_WRAP);
+	if (ret < 0)
+		goto errout;
 
-		if (!child->thread.debugctlmsr)
-			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-	}
+	if (cfg.flags & PTRACE_BTS_O_TRACE)
+		child->thread.debugctlmsr |= ds_debugctl_mask();
+	else
+		child->thread.debugctlmsr &= ~ds_debugctl_mask();
 
-	if (ds && (cfg.flags & PTRACE_BTS_O_SCHED))
+	if (cfg.flags & PTRACE_BTS_O_SCHED)
 		set_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
 	else
 		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
 
-	return 0;
+out:
+	if (child->thread.debugctlmsr)
+		set_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+	else
+		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+
+	return ret;
+
+errout:
+	child->thread.debugctlmsr &= ~ds_debugctl_mask();
+	clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+	goto out;
 }
 
 static int ptrace_bts_status(struct task_struct *child,
@@ -726,7 +781,7 @@
 {
 	struct bts_struct rec = {
 		.qualifier = qualifier,
-		.variant.jiffies = jiffies
+		.variant.jiffies = jiffies_64
 	};
 
 	ptrace_bts_write_record(tsk, &rec);
@@ -743,10 +798,12 @@
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
-	ptrace_bts_config(child, /* options = */ 0);
 	if (child->thread.ds_area_msr) {
-	    ds_free((void **)&child->thread.ds_area_msr);
-	    clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+		ptrace_bts_realloc(child, 0, 0);
+		child->thread.debugctlmsr &= ~ds_debugctl_mask();
+		if (!child->thread.debugctlmsr)
+			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
 	}
 }
 
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

