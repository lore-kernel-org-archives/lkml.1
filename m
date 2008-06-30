Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbYF3NRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbYF3NRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762114AbYF3NOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:14:22 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:57975 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762058AbYF3NOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=sKY9bUvxLazB+ligvjqTjRXC814UnNW9qzZ2fLrR0bnELql/PsuLPqqEKv32HZ/l0i
         QxoFoc9lINIM+Vtc9fJbuLPx+9Km/pxcN73x/hfP49/qMF9K8lMtudKq4WV059ujerK2
         kVPYYmDwU3h+SIxUnr8pV2ju7W4JoV4xNHmr4=
To: linux-kernel@vger.kernel.org
Subject: [patch 12/19] perfmon2 minimal v3:  monitoring activation
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:14:18 -0700 (PDT)
Message-ID: <4868dc2a.0c135e0a.6864.fffff367@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds perfmon_activate.c which implements the start and stop monitoring
functions.

Signed-off-by: Stephane Eranian <eranian@gmail.com>

--

Index: o/perfmon/perfmon_activate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o/perfmon/perfmon_activate.c	2008-06-23 13:14:52.000000000 +0200
@@ -0,0 +1,136 @@
+/*
+ * perfmon_activate.c: perfmon2 start/stop functions
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
+/**
+ * __pfm_start - activate monitoring
+ * @ctx: context to operate on
+ * @start: pfarg_start as passed by user
+ *
+ * When operating in per-thread mode and not self-monitoring, the monitored
+ * thread must be stopped. Activation will be effective next time the thread
+ * is context switched in.
+ *
+ * The pfarg_start argument is optional and may be used to designate
+ * the initial event set to activate. When not provided, the last active
+ * set is used. For the first activation, set0 is used when start is NULL.
+ *
+ * On some architectures, e.g., IA-64, it may be possible to start monitoring
+ * without calling this function under certain conditions (per-thread and self
+ * monitoring). In this case, either set0 or the last active set is used.
+ *
+ * the context is locked and interrupts are disabled.
+ */
+int __pfm_start(struct pfm_context *ctx)
+{
+	struct task_struct *task;
+	struct pfm_event_set *set;
+
+	task = ctx->task;
+
+	/*
+	 * UNLOADED: error
+	 * LOADED  : normal start, nop if started unless set is different
+	 * ZOMBIE  : cannot happen
+	 */
+	if (ctx->state == PFM_CTX_UNLOADED)
+		return -EINVAL;
+
+	set = ctx->active_set;
+
+	/*
+	 * mark as started
+	 * must be done before calling pfm_arch_start()
+	 */
+	ctx->flags.started = 1;
+
+	pfm_arch_start(task, ctx);
+
+	/*
+	 * we check whether we had a pending ovfl before restarting.
+	 * If so we need to regenerate the interrupt to make sure we
+	 * keep recorded samples. For non-self monitoring this check
+	 * is done in the pfm_ctxswin_thread() routine.
+	 *
+	 * we check new_set/old_set because pfm_switch_sets() already
+	 * takes care of replaying the pending interrupts
+	 */
+	if (task == current && set->npend_ovfls)
+		pfm_arch_resend_irq(ctx);
+
+	return 0;
+}
+
+/**
+ * __pfm_stop - stop monitoring
+ * @ctx: context to operate on
+ *
+ * When operating in per-thread* mode and when not self-monitoring,
+ * the monitored thread must be stopped.
+ *
+ * the context is locked and interrupts are disabled.
+ */
+int __pfm_stop(struct pfm_context *ctx)
+{
+	struct task_struct *task;
+
+	/*
+	 * context must be attached (zombie cannot happen)
+	 */
+	if (ctx->state == PFM_CTX_UNLOADED)
+		return -EINVAL;
+
+	task = ctx->task;
+
+	PFM_DBG("ctx_task=[%d] ctx_state=%d is_system=%d",
+		task ? task->pid : -1,
+		ctx->state,
+		!task);
+
+	pfm_arch_stop(task, ctx);
+
+	ctx->flags.started = 0;
+	/*
+	 * starting now, in-flight PMU interrupt for this context
+	 * are treated as spurious
+	 */
+	return 0;
+}
Index: o/perfmon/Makefile
===================================================================
--- o.orig/perfmon/Makefile	2008-06-23 13:14:11.000000000 +0200
+++ o/perfmon/Makefile	2008-06-23 13:15:07.000000000 +0200
@@ -6,4 +6,5 @@
 	perfmon_attach.o perfmon_res.o \
 	perfmon_init.o perfmon_ctxsw.o \
 	perfmon_intr.o perfmon_pmu.o \
-	perfmon_sysfs.o perfmon_rw.o
+	perfmon_sysfs.o perfmon_rw.o \
+	perfmon_activate.o
Index: o/perfmon/perfmon_priv.h
===================================================================
--- o.orig/perfmon/perfmon_priv.h	2008-06-23 13:13:55.000000000 +0200
+++ o/perfmon/perfmon_priv.h	2008-06-23 13:14:52.000000000 +0200
@@ -57,6 +57,9 @@
 
 void pfm_free_context(struct pfm_context *ctx);
 
+int __pfm_stop(struct pfm_context *ctx);
+int __pfm_start(struct pfm_context *ctx);
+
 ssize_t pfm_sysfs_res_show(char *buf, size_t sz, int what);
 
 int pfm_pmu_acquire(void);

-- 

