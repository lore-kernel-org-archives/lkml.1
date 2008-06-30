Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbYF3NOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbYF3NOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759914AbYF3NNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:13:40 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63631 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561AbYF3NNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:13:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=dv+kAmsVXtIafeFIF+0tvuTTquLbO9YfGQn8SnfLSW0A8ni9Lho+cDuMIv6nd5eQZj
         Ojt21D+uL7gxGmLfWVwv8V5hAE29ycVs12RehJfjCZdssrtzNX0Z0zaDLeMGSCIB6R+A
         x8UASBpPgG4qQgvbuIOHHhE6yQD0VCto1GJvs=
To: linux-kernel@vger.kernel.org
Subject: [patch 02/19] perfmon2 minimal v3:  base code
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:13:34 -0700 (PDT)
Message-ID: <4868dbfe.0aec660a.170f.521e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the core functions of the perfmon2 subsystem.
It creates the toplevel perfmon subdirectory where all perfmon2
generic code lives. Core functions implements initialization,
session allocation and terminations.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: linux-next/perfmon/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/perfmon/Makefile	2008-06-26 19:47:05.000000000 +0200
@@ -0,0 +1,7 @@
+#
+# Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
+# Contributed by Stephane Eranian <eranian@gmail.com>
+#
+obj-y =	perfmon_ctx.o perfmon_file.o \
+	perfmon_attach.o perfmon_res.o \
+	perfmon_init.o
Index: linux-next/perfmon/perfmon_attach.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/perfmon/perfmon_attach.c	2008-06-26 19:47:05.000000000 +0200
@@ -0,0 +1,86 @@
+/*
+ * perfmon_attach.c: perfmon2 load/unload functions
+ *
+ * This file implements the perfmon2 interface which
+ * provides access to the hardware performance counters
+ * of the host processor.
+ *
+ *
+ * The initial version of perfmon.c was written by
+ * Ganesh Venkitachalam, IBM Corp.
+ *
+ * Then it was modified for perfmon-1.x by Stephane Eranian and
+ * David Mosberger, Hewlett Packard Co.
+ *
+ * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
+ * by Stephane Eranian, Hewlett Packard Co.
+ *
+ * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *                David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * More information about perfmon available at:
+ * 	http://www.hpl.hp.com/research/linux/perfmon
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+/**
+ * __pfm_exit_thread - detach and free context on thread exit
+ */
+void __pfm_exit_thread(void)
+{
+	struct pfm_context *ctx;
+	unsigned long flags;
+	int free_ok = 0, ret = -1;
+
+	ctx  = current->pfm_context;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	PFM_DBG("state=%d is_self=%d", ctx->state, ctx->flags.is_self);
+
+	/*
+	 * __pfm_unload_context() cannot fail
+	 * in the context states we are interested in
+	 */
+	switch (ctx->state) {
+	case PFM_CTX_LOADED:
+		ret = __pfm_unload_context(ctx);
+		break;
+	case PFM_CTX_ZOMBIE:
+		ret = __pfm_unload_context(ctx);
+		free_ok = 1;
+		break;
+	default:
+		BUG_ON(ctx->state != PFM_CTX_LOADED);
+		break;
+	}
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	if (!ret)
+		pfm_session_release();
+
+	/*
+	 * All memory free operations (especially for vmalloc'ed memory)
+	 * MUST be done with interrupts ENABLED.
+	 */
+	if (free_ok)
+		pfm_free_context(ctx);
+}
Index: linux-next/perfmon/perfmon_ctx.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/perfmon/perfmon_ctx.c	2008-06-26 19:47:05.000000000 +0200
@@ -0,0 +1,164 @@
+/*
+ * perfmon_ctx.c: perfmon2 context functions
+ *
+ * This file implements the perfmon2 interface which
+ * provides access to the hardware performance counters
+ * of the host processor.
+ *
+ *
+ * The initial version of perfmon.c was written by
+ * Ganesh Venkitachalam, IBM Corp.
+ *
+ * Then it was modified for perfmon-1.x by Stephane Eranian and
+ * David Mosberger, Hewlett Packard Co.
+ *
+ * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
+ * by Stephane Eranian, Hewlett Packard Co.
+ *
+ * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *                David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * More information about perfmon available at:
+ * 	http://www.hpl.hp.com/research/linux/perfmon
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+/*
+ * context memory pool pointer
+ */
+static struct kmem_cache *pfm_ctx_cachep;
+
+/*
+ * This function is called when we need to perform asynchronous
+ * work on a context. This function is called ONLY when about to
+ * return to user mode (very much like with signal handling).
+ *
+ * we come here if:
+ *
+ *  - we are zombie and we need to cleanup our state
+ *
+ * pfm_handle_work() can be called with interrupts enabled
+ * (TIF_NEED_RESCHED) or disabled.
+ */
+void pfm_handle_work(struct pt_regs *regs)
+{
+	struct pfm_context *ctx;
+	unsigned long flags;
+	int type;
+
+	if (!user_mode(regs))
+		return;
+
+	clear_thread_flag(TIF_PERFMON_WORK);
+
+	ctx = current->pfm_context;
+	if (ctx == NULL) {
+		PFM_DBG("[%d] has no ctx", current->pid);
+		return;
+	}
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	type = ctx->flags.work_type;
+	ctx->flags.work_type = PFM_WORK_NONE;
+
+	PFM_DBG("work_type=%d", type);
+
+	switch (type) {
+	case PFM_WORK_ZOMBIE:
+		goto do_zombie;
+	default:
+		PFM_DBG("unkown type=%d", type);
+		goto nothing_todo;
+	}
+nothing_todo:
+	/*
+	 * restore flags as they were upon entry
+	 */
+	spin_unlock_irqrestore(&ctx->lock, flags);
+	return;
+
+do_zombie:
+	PFM_DBG("context is zombie, bailing out");
+
+	/* always returns 0 in this case */
+	 __pfm_unload_context(ctx);
+
+	/*
+	 * keep the spinlock check happy
+	 */
+	spin_unlock(&ctx->lock);
+
+	/*
+	 * enable interrupt for vfree()
+	 */
+	local_irq_enable();
+
+	/*
+	 * actual context free
+	 */
+	pfm_free_context(ctx);
+
+	/*
+	 * restore interrupts as they were upon entry
+	 */
+	local_irq_restore(flags);
+
+	/*
+	 * pfm_unload always successful, so can release
+	 * session safely
+	 */
+	pfm_session_release();
+}
+
+/**
+ * pfm_free_context - de-allocate context and associated resources
+ * @ctx: context to free
+ */
+void pfm_free_context(struct pfm_context *ctx)
+{
+	pfm_arch_context_free(ctx);
+
+	PFM_DBG("free ctx @0x%p", ctx);
+	kmem_cache_free(pfm_ctx_cachep, ctx);
+	/*
+	 * decrease refcount on:
+	 * 	- PMU description table
+	 */
+	pfm_pmu_release();
+}
+
+/**
+ * pfm_init_ctx -- initialize context SLAB
+ *
+ * called from pfm_init
+ */
+int __init pfm_init_ctx(void)
+{
+	pfm_ctx_cachep = kmem_cache_create("pfm_context",
+				   sizeof(struct pfm_context)+PFM_ARCH_CTX_SIZE,
+				   SLAB_HWCACHE_ALIGN, 0, NULL);
+	if (!pfm_ctx_cachep) {
+		PFM_ERR("cannot initialize context slab");
+		return -ENOMEM;
+	}
+	return 0;
+}
Index: linux-next/perfmon/perfmon_file.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/perfmon/perfmon_file.c	2008-06-26 19:47:05.000000000 +0200
@@ -0,0 +1,94 @@
+/*
+ * perfmon_file.c: perfmon2 file input/output functions
+ *
+ * This file implements the perfmon2 interface which
+ * provides access to the hardware performance counters
+ * of the host processor.
+ *
+ * The initial version of perfmon.c was written by
+ * Ganesh Venkitachalam, IBM Corp.
+ *
+ * Then it was modified for perfmon-1.x by Stephane Eranian and
+ * David Mosberger, Hewlett Packard Co.
+ *
+ * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
+ * by Stephane Eranian, Hewlett Packard Co.
+ *
+ * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *                David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * More information about perfmon available at:
+ * 	http://perfmon2.sf.net
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/vfs.h>
+#include <linux/mount.h>
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+#define PFMFS_MAGIC 0xa0b4d889	/* perfmon filesystem magic number */
+
+struct pfm_controls pfm_controls = {
+	.task_group = PFM_GROUP_PERM_ANY,
+	.arg_mem_max = PAGE_SIZE,
+};
+
+static int __init enable_debug(char *str)
+{
+	pfm_controls.debug = 1;
+	PFM_INFO("debug output enabled\n");
+	return 1;
+}
+__setup("perfmon_debug", enable_debug);
+
+static int pfmfs_get_sb(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "pfm:", NULL, PFMFS_MAGIC, mnt);
+}
+
+static struct file_system_type pfm_fs_type = {
+	.name     = "pfmfs",
+	.get_sb   = pfmfs_get_sb,
+	.kill_sb  = kill_anon_super,
+};
+
+/*
+ * pfmfs should _never_ be mounted by userland - too much of security hassle,
+ * no real gain from having the whole whorehouse mounted. So we don't need
+ * any operations on the root directory. However, we need a non-trivial
+ * d_name - pfm: will go nicely and kill the special-casing in procfs.
+ */
+static struct vfsmount *pfmfs_mnt;
+
+int __init pfm_init_fs(void)
+{
+	int err = register_filesystem(&pfm_fs_type);
+	if (!err) {
+		pfmfs_mnt = kern_mount(&pfm_fs_type);
+		err = PTR_ERR(pfmfs_mnt);
+		if (IS_ERR(pfmfs_mnt))
+			unregister_filesystem(&pfm_fs_type);
+		else
+			err = 0;
+	}
+	return err;
+}
Index: linux-next/perfmon/perfmon_init.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/perfmon/perfmon_init.c	2008-06-26 19:47:05.000000000 +0200
@@ -0,0 +1,87 @@
+/*
+ * perfmon.c: perfmon2 global initialization functions
+ *
+ * This file implements the perfmon2 interface which
+ * provides access to the hardware performance counters
+ * of the host processor.
+ *
+ *
+ * The initial version of perfmon.c was written by
+ * Ganesh Venkitachalam, IBM Corp.
+ *
+ * Then it was modified for perfmon-1.x by Stephane Eranian and
+ * David Mosberger, Hewlett Packard Co.
+ *
+ * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
+ * by Stephane Eranian, Hewlett Packard Co.
+ *
+ * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *                David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * More information about perfmon available at:
+ * 	http://www.hpl.hp.com/research/linux/perfmon
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/kernel.h>
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+/*
+ * external variables
+ */
+DEFINE_PER_CPU(struct task_struct *, pmu_owner);
+DEFINE_PER_CPU(struct pfm_context  *, pmu_ctx);
+DEFINE_PER_CPU(u64, pmu_activation_number);
+
+int perfmon_disabled;	/* >0 if perfmon is disabled */
+
+/*
+ * global initialization routine, executed only once
+ */
+int __init pfm_init(void)
+{
+	PFM_LOG("version %u.%u", PFM_VERSION_MAJ, PFM_VERSION_MIN);
+
+	if (pfm_init_ctx())
+		goto error_disable;
+
+	if (pfm_init_fs())
+		goto error_disable;
+
+	/* not critical, so no error checking */
+	pfm_init_debugfs();
+
+	/*
+	 * one time, arch-specific global initialization
+	 */
+	if (pfm_arch_init())
+		goto error_disable;
+
+	return 0;
+
+error_disable:
+	PFM_ERR("perfmon is disabled due to initialization error");
+	perfmon_disabled = 1;
+	return -1;
+}
+
+/*
+ * must use subsys_initcall() to ensure that the perfmon2 core
+ * is initialized before any PMU description module when they are
+ * compiled in.
+ */
+subsys_initcall(pfm_init);
Index: linux-next/perfmon/perfmon_priv.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/perfmon/perfmon_priv.h	2008-06-26 19:47:05.000000000 +0200
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2001-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+
+#ifndef __PERFMON_PRIV_H__
+#define __PERFMON_PRIV_H__
+/*
+ * This file contains all the definitions of data structures, variables, macros
+ * that are to private to the generic code, i.e., not shared with any code that
+ * lives under arch/ or include/asm-XX
+ *
+ * For shared definitions, use include/linux/perfmon_kern.h
+ */
+
+#ifdef CONFIG_PERFMON
+
+/*
+ * context lazy save/restore activation count
+ */
+#define PFM_INVALID_ACTIVATION	((u64)~0)
+
+DECLARE_PER_CPU(u64, pmu_activation_number);
+
+static inline void pfm_set_pmu_owner(struct task_struct *task,
+				     struct pfm_context *ctx)
+{
+	__get_cpu_var(pmu_owner) = task;
+	__get_cpu_var(pmu_ctx) = ctx;
+}
+
+int pfm_init_ctx(void);
+
+int pfm_session_acquire(void);
+void pfm_session_release(void);
+
+int  pfm_init_sysfs(void);
+
+void pfm_free_context(struct pfm_context *ctx);
+
+void pfm_save_pmds(struct pfm_context *ctx);
+
+/*
+ * check_mask bitmask values for pfm_check_task_state()
+ */
+#define PFM_CMD_STOPPED		0x01	/* command needs thread stopped */
+#define PFM_CMD_UNLOADED	0x02	/* command needs ctx unloaded */
+#define PFM_CMD_UNLOAD		0x04	/* command is unload */
+
+/**
+ * pfm_save_prev_ctx - check if previous context exists and save state
+ *
+ * called from pfm_load_ctx_thread() and __pfm_ctxsin_thread() to
+ * check if previous context exists. If so saved its PMU state. This is used
+ * only for UP kernels.
+ *
+ * PMU ownership is not cleared because the function is always called while
+ * trying to install a new owner.
+ */
+static inline void pfm_check_save_prev_ctx(void)
+{
+#ifdef CONFIG_SMP
+	struct pfm_context *ctxp;
+
+	ctxp = __get_cpu_var(pmu_ctx);
+	if (!ctxp)
+		return;
+	/*
+	 * in UP per-thread, due to lazy save
+	 * there could be a context from another
+	 * task. We need to push it first before
+	 * installing our new state
+	 */
+	pfm_save_pmds(ctxp);
+	/*
+	 * do not clear ownership because we rewrite
+	 * right away
+	 */
+#endif
+}
+
+int pfm_init_fs(void);
+
+static inline void pfm_post_work(struct task_struct *task,
+				 struct pfm_context *ctx, int type)
+{
+	ctx->flags.work_type = type;
+	set_tsk_thread_flag(task, TIF_PERFMON_WORK);
+}
+
+#ifdef CONFIG_PERFMON_DEBUG_FS
+int  pfm_init_debugfs(void);
+#else
+static inline int pfm_init_debugfs(void)
+{
+	return 0;
+}
+#endif
+
+#define PFM_PMC_STK_ARG	PFM_ARCH_PMC_STK_ARG
+#define PFM_PMD_STK_ARG	PFM_ARCH_PMD_STK_ARG
+
+#endif /* CONFIG_PERFMON */
+
+#endif /* __PERFMON_PRIV_H__ */
Index: linux-next/perfmon/perfmon_res.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/perfmon/perfmon_res.c	2008-06-26 19:47:05.000000000 +0200
@@ -0,0 +1,105 @@
+/*
+ * perfmon_res.c:  perfmon2 resource allocations
+ *
+ * This file implements the perfmon2 interface which
+ * provides access to the hardware performance counters
+ * of the host processor.
+ *
+ * The initial version of perfmon.c was written by
+ * Ganesh Venkitachalam, IBM Corp.
+ *
+ * Then it was modified for perfmon-1.x by Stephane Eranian and
+ * David Mosberger, Hewlett Packard Co.
+ *
+ * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
+ * by Stephane Eranian, Hewlett Packard Co.
+ *
+ * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *                David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * More information about perfmon available at:
+ * 	http://perfmon2.sf.net
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/kernel.h>
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+/*
+ * global information about all sessions
+ */
+struct pfm_resources {
+	cpumask_t	sys_cpumask;     /* bitmask of used cpus */
+	u32		thread_sessions; /* #num loaded per-thread sessions */
+};
+
+static struct pfm_resources pfm_res;
+
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(pfm_res_lock);
+
+/**
+ * pfm_session_acquire - reserve a per-thread session
+ *
+ * return:
+ * 	 0    : success
+ * 	-EBUSY: if conflicting session exist
+ */
+int pfm_session_acquire(void)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	/*
+	 * validy checks on cpu_mask have been done upstream
+	 */
+	spin_lock_irqsave(&pfm_res_lock, flags);
+
+	PFM_DBG("in  thread=%u",
+		pfm_res.thread_sessions);
+
+	pfm_res.thread_sessions++;
+
+	PFM_DBG("out thread=%u ret=%d",
+		pfm_res.thread_sessions,
+		ret);
+
+	spin_unlock_irqrestore(&pfm_res_lock, flags);
+
+	return ret;
+}
+
+/**
+ * pfm_session_release - release a per-thread session
+ *
+ * called from __pfm_unload_context()
+ */
+void pfm_session_release(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pfm_res_lock, flags);
+
+	PFM_DBG("in thread=%u",
+		pfm_res.thread_sessions);
+
+	pfm_res.thread_sessions--;
+
+	PFM_DBG("out thread=%u",
+		pfm_res.thread_sessions);
+
+	spin_unlock_irqrestore(&pfm_res_lock, flags);
+}
Index: linux-next/Makefile
===================================================================
--- linux-next.orig/Makefile	2008-06-26 17:46:23.000000000 +0200
+++ linux-next/Makefile	2008-06-26 19:47:05.000000000 +0200
@@ -619,6 +619,8 @@
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
 core-$(CONFIG_KERNEL_TESTS) += tests/
 
+core-$(CONFIG_PERFMON) += perfmon/
+
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
 		     $(net-y) $(net-m) $(libs-y) $(libs-m)))
Index: linux-next/include/linux/sched.h
===================================================================
--- linux-next.orig/include/linux/sched.h	2008-06-26 17:46:27.000000000 +0200
+++ linux-next/include/linux/sched.h	2008-06-26 19:47:05.000000000 +0200
@@ -1287,6 +1287,9 @@
 	int latency_record_count;
 	struct latency_record latency_record[LT_SAVECOUNT];
 #endif
+#ifdef CONFIG_PERFMON
+	struct pfm_context *pfm_context;
+#endif
 };
 
 /*

-- 

