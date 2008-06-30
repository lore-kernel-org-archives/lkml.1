Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYF3NN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYF3NN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbYF3NNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:13:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:47443 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbYF3NNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=HyMOX9r6qDseLmOND3ADpfs28FOqWoKlwDpsGKau09nAqPGbUnWlp8fCJzPHvhJubE
         mR6Pxp13VycEw8pVLC2VZJlD1dZ9m28GzlsewllCr6Ie3Jqcv5CJubI+htEVQef5lrJu
         OdOJqSp5hAZOb+33uwmTaH/ehhrSO2ThdaY1Y=
To: linux-kernel@vger.kernel.org
Subject: [patch 01/19] perfmon2 minimal v3:  generic headers
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:13:30 -0700 (PDT)
Message-ID: <4868dbfa.0637560a.6faf.091a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the generic perfmon2 headers including the public
head perfmon.h which can be used by applications. The other
headers are for kernel use only.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o/include/linux/perfmon.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o/include/linux/perfmon.h	2008-06-17 08:50:15.000000000 +0200
@@ -0,0 +1,65 @@
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
+#ifndef __LINUX_PERFMON_H__
+#define __LINUX_PERFMON_H__
+
+/*
+ * This file contains all the user visible generic definitions for the
+ * interface. Model-specific user-visible definitions are located in
+ * the asm/perfmon.h file.
+ */
+
+/*
+ * include arch-specific user interface definitions
+ */
+#include <asm/perfmon.h>
+
+/*
+ * defined by each arch
+ */
+#define PFM_MAX_PMCS	PFM_ARCH_MAX_PMCS
+#define PFM_MAX_PMDS	PFM_ARCH_MAX_PMDS
+
+/*
+ * number of elements for each type of bitvector
+ * all bitvectors use u64 fixed size type on all architectures.
+ */
+#define PFM_BVSIZE(x)	(((x)+(sizeof(__u64)<<3)-1) / (sizeof(__u64)<<3))
+#define PFM_PMD_BV	PFM_BVSIZE(PFM_MAX_PMDS)
+#define PFM_PMC_BV	PFM_BVSIZE(PFM_MAX_PMCS)
+
+/*
+ * default value for the user and group security parameters in
+ * /proc/sys/kernel/perfmon/sys_group
+ * /proc/sys/kernel/perfmon/task_group
+ */
+#define PFM_GROUP_PERM_ANY	-1	/* any user/group */
+
+/*
+ * perfmon version number
+ */
+#define PFM_VERSION_MAJ		 2U
+#define PFM_VERSION_MIN		 99U
+#define PFM_VERSION		 (((PFM_VERSION_MAJ&0xffff)<<16)|\
+				  (PFM_VERSION_MIN & 0xffff))
+#define PFM_VERSION_MAJOR(x)	 (((x)>>16) & 0xffff)
+#define PFM_VERSION_MINOR(x)	 ((x) & 0xffff)
+
+#endif /* __LINUX_PERFMON_H__ */
Index: o/include/linux/perfmon_kern.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o/include/linux/perfmon_kern.h	2008-06-17 08:33:20.000000000 +0200
@@ -0,0 +1,253 @@
+/*
+ * Copyright (c) 2001-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@gmail.com>
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
+#ifndef __LINUX_PERFMON_KERN_H__
+#define __LINUX_PERFMON_KERN_H__
+/*
+ * This file contains all the definitions of data structures, variables, macros
+ * that are to be shared between generic code and arch-specific code
+ *
+ * For generic only definitions, use perfmon/perfmon_priv.h
+ */
+#include <linux/file.h>
+#include <linux/sched.h>
+#include <linux/perfmon.h>
+
+#ifdef CONFIG_PERFMON
+
+/*
+ * system adminstrator configuration controls available via
+ * the /sys/kerne/perfmon interface
+ */
+struct pfm_controls {
+	u32	debug;		/* debugging control bitmask */
+	gid_t	task_group;	/* gid to create a per-task context */
+	size_t	arg_mem_max;	/* maximum vector argument size */
+};
+extern struct pfm_controls pfm_controls;
+
+/*
+ * software PMD
+ */
+struct pfm_pmd {
+	u64 value;			/* 64-bit value */
+	u64 lval;			/* last reset value */
+};
+
+/*
+ * event_set: encapsulates the full PMU state
+ */
+struct pfm_event_set {
+	u16 nused_pmds;			/* max number of used PMDs */
+	u16 nused_pmcs;			/* max number of used PMCs */
+	u32 priv_flags;			/* private flags (see below) */
+	u32 npend_ovfls;		/* number of pending PMD overflow */
+	u32 pad2;			/* padding */
+	u64 used_pmds[PFM_PMD_BV];	/* used PMDs */
+	u64 povfl_pmds[PFM_PMD_BV];	/* pending overflowed PMDs */
+	u64 used_pmcs[PFM_PMC_BV];	/* used PMCs */
+	u64 pmcs[PFM_MAX_PMCS];		/* PMC values */
+
+	struct pfm_pmd pmds[PFM_MAX_PMDS];
+};
+
+/*
+ * common private event set flags (priv_flags)
+ *
+ * upper 16 bits: for arch-specific use
+ * lower 16 bits: for common use
+ */
+#define PFM_SETFL_PRIV_MOD_PMDS 0x1 /* PMD register(s) modified */
+#define PFM_SETFL_PRIV_MOD_PMCS 0x2 /* PMC register(s) modified */
+#define PFM_SETFL_PRIV_MOD_BOTH	(PFM_SETFL_PRIV_MOD_PMDS \
+				| PFM_SETFL_PRIV_MOD_PMCS)
+
+
+/*
+ * context flags
+ */
+struct pfm_context_flags {
+	unsigned int started:1;		/* pfm_start() issued */
+	unsigned int is_self:1;		/* per-thread and self-montoring */
+	unsigned int work_type:2;	/* type of work for pfm_handle_work */
+	unsigned int reserved:28;	/* for future use */
+};
+/*
+ * values for work_type (TIF_PERFMON_WORK must be set)
+ */
+#define PFM_WORK_NONE	0	/* nothing to do */
+#define PFM_WORK_ZOMBIE	1	/* cleanup zombie context */
+
+
+/*
+ * perfmon context state
+ */
+#define PFM_CTX_UNLOADED	1 /* context is detached */
+#define PFM_CTX_LOADED		2 /* context is attached */
+#define PFM_CTX_ZOMBIE		3 /* context lost owner but still attached */
+
+/*
+ * context: contains all the state of a session
+ */
+struct pfm_context {
+	spinlock_t		lock;		/* context protection */
+
+	struct pfm_context_flags flags;
+	u32			state;		/* current state */
+	struct task_struct 	*task;		/* attached task */
+
+	u64 			last_act;	/* last activation */
+	u32			last_cpu;   	/* last CPU used (SMP only) */
+
+	struct pfm_event_set	*active_set;	/* active set */
+	struct pfm_event_set	_set0;		/* event set 0 */
+};
+
+/*
+ * logging
+ */
+#define PFM_ERR(f, x...)  printk(KERN_ERR     "perfmon: " f "\n", ## x)
+#define PFM_WARN(f, x...) printk(KERN_WARNING "perfmon: " f "\n", ## x)
+#define PFM_LOG(f, x...)  printk(KERN_NOTICE  "perfmon: " f "\n", ## x)
+#define PFM_INFO(f, x...) printk(KERN_INFO    "perfmon: " f "\n", ## x)
+
+/*
+ * debugging
+ *
+ * Printk rate limiting is enforced to avoid getting flooded with too many
+ * error messages on the console (which could render the machine unresponsive).
+ * To get full debug output (turn off ratelimit):
+ * 	$ echo 0 >/proc/sys/kernel/printk_ratelimit
+ *
+ * debug is a bitmask where bits are defined as follows:
+ * bit  0: enable non-interrupt code degbug messages
+ * bit  1: enable interrupt code debug messages
+ */
+#ifdef CONFIG_PERFMON_DEBUG
+#define _PFM_DBG(lm, f, x...) \
+	do { \
+		if (unlikely((pfm_controls.debug & lm) && printk_ratelimit())) { \
+			printk("perfmon: %s.%d: CPU%d [%d]: " f "\n", \
+			       __func__, __LINE__, \
+			       smp_processor_id(), current->pid , ## x); \
+		} \
+	} while (0)
+
+#define PFM_DBG(f, x...) _PFM_DBG(0x1, f, ##x)
+#define PFM_DBG_ovfl(f, x...) _PFM_DBG(0x2, f, ##x)
+#else
+#define PFM_DBG(f, x...)	do {} while (0)
+#define PFM_DBG_ovfl(f, x...)	do {} while (0)
+#endif
+
+extern struct pfm_pmu_config  *pfm_pmu_conf;
+extern int perfmon_disabled;
+
+static inline struct pfm_arch_context *pfm_ctx_arch(struct pfm_context *c)
+{
+	return (struct pfm_arch_context *)(c+1);
+}
+
+#include <linux/perfmon_pmu.h>
+
+extern const struct file_operations pfm_file_ops;
+
+#define cast_ulp(_x) ((unsigned long *)_x)
+
+void pfm_handle_work(struct pt_regs *regs);
+void __pfm_exit_thread(void);
+void __pfm_init_percpu(void *dummy);
+
+static inline void pfm_exit_thread(void)
+{
+	if (current->pfm_context)
+		__pfm_exit_thread();
+}
+
+/*
+ * include arch-specific kernel level definitions
+ */
+#include <asm/perfmon_kern.h>
+
+static inline void pfm_copy_thread(struct task_struct *task)
+{
+	/*
+	 * context or perfmon TIF state  is NEVER inherited
+	 * in child task. Holds for per-thread and system-wide
+	 */
+	task->pfm_context = NULL;
+	clear_tsk_thread_flag(task, TIF_PERFMON_CTXSW);
+}
+
+/*
+ * read a single PMD register.
+ */
+static inline u64 pfm_read_pmd(struct pfm_context *ctx, unsigned int cnum)
+{
+	return pfm_arch_read_pmd(ctx, cnum);
+}
+/*
+ * write a single PMD register.
+ */
+static inline void pfm_write_pmd(struct pfm_context *ctx, unsigned int cnum,
+				 u64 value)
+{
+	/*
+	 * PMD writes are ignored for read-only registers
+	 */
+	if (pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_RO)
+		return;
+
+	/*
+	 * clear unimplemented bits
+	 */
+	value &= ~pfm_pmu_conf->pmd_desc[cnum].rsvd_msk;
+
+	pfm_arch_write_pmd(ctx, cnum, value);
+}
+
+DECLARE_PER_CPU(struct pfm_context *, pmu_ctx);
+DECLARE_PER_CPU(struct task_struct *, pmu_owner);
+
+/*
+ * max vector argument elements for local storage (no kmalloc/kfree)
+ * The PFM_ARCH_PM*_ARG should be defined in perfmon_kern.h.
+ * If not, default (conservative) values are used
+ */
+#ifndef PFM_ARCH_PMC_STK_ARG
+#define PFM_ARCH_PMC_STK_ARG	1
+#endif
+
+#ifndef PFM_ARCH_PMD_STK_ARG
+#define PFM_ARCH_PMD_STK_ARG	1
+#endif
+
+#define PFM_PMC_STK_ARG	PFM_ARCH_PMC_STK_ARG
+#define PFM_PMD_STK_ARG	PFM_ARCH_PMD_STK_ARG
+
+#else /* !CONFIG_PERFMON */
+/*
+ * perfmon hooks are nops when CONFIG_PERFMON is undefined
+ */
+#define pfm_exit_thread(_t)  		do { } while (0)
+#define pfm_handle_work(_t)    		do { } while (0)
+#define pfm_copy_thread(_t)		do { } while (0)
+
+#endif /* CONFIG_PERFMON */
+#endif /* __LINUX_PERFMON_KERN_H__ */
Index: o/include/linux/perfmon_pmu.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o/include/linux/perfmon_pmu.h	2008-06-17 10:27:48.000000000 +0200
@@ -0,0 +1,155 @@
+/*
+ * Copyright (c) 2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * Interface for PMU description modules
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
+#ifndef __PERFMON_PMU_H__
+#define __PERFMON_PMU_H__ 1
+
+/*
+ * generic information about a PMC or PMD register
+ */
+struct pfm_regmap_desc {
+	u16  type;		/* register infos */
+	u16  reserved1;		/* for future use */
+	u32  reserved2;		/* for future use */
+	u64  dfl_val;		/* power-on default value (quiescent) */
+	u64  rsvd_msk;		/* reserved bits: 1 means reserved */
+	u64  no_emul64_msk;	/* bits to clear for PFM_REGFL_NO_EMUL64 */
+	unsigned long hw_addr;	/* HW register address or index */
+	struct kobject	kobj;	/* for internal use only */
+	char *desc;		/* HW register description string */
+};
+
+/*
+ * pfm_reg_desc helper macros
+ */
+#define PMC_D(t, d, v, r, n, h) \
+	{ .type = t,          \
+	  .desc = d,          \
+	  .dfl_val = v,       \
+	  .rsvd_msk = r,      \
+	  .no_emul64_msk = n, \
+	  .hw_addr = h	      \
+	}
+
+#define PMD_D(t, d, h)        \
+	{ .type = t,          \
+	  .desc = d,          \
+	  .rsvd_msk = 0,      \
+	  .no_emul64_msk = 0, \
+	  .hw_addr = h	      \
+	}
+
+#define PMD_DR(t, d, h, r)    \
+	{ .type = t,          \
+	  .desc = d,          \
+	  .rsvd_msk = r,      \
+	  .no_emul64_msk = 0, \
+	  .hw_addr = h	      \
+	}
+
+#define PMX_NA \
+	{ .type = PFM_REG_NA }
+
+/*
+ * type of a PMU register (16-bit bitmask) for use with pfm_reg_desc.type
+ */
+#define PFM_REG_NA	0x00  /* not avail. (not impl.,no access) must be 0 */
+#define PFM_REG_I	0x01  /* PMC/PMD: implemented */
+#define PFM_REG_WC	0x02  /* PMC: has write_checker */
+#define PFM_REG_C64	0x04  /* PMD: 64-bit virtualization */
+#define PFM_REG_RO	0x08  /* PMD: read-only (writes ignored) */
+#define PFM_REG_INTR	0x20  /* PMD: register can generate interrupt */
+#define PFM_REG_NO64	0x100 /* PMC: supports PFM_REGFL_NO_EMUL64 */
+
+/*
+ * define some shortcuts for common types
+ */
+#define PFM_REG_W	(PFM_REG_WC|PFM_REG_I)
+#define PFM_REG_W64	(PFM_REG_WC|PFM_REG_NO64|PFM_REG_I)
+#define PFM_REG_C	(PFM_REG_C64|PFM_REG_INTR|PFM_REG_I)
+#define PFM_REG_I64	(PFM_REG_NO64|PFM_REG_I)
+#define PFM_REG_IRO	(PFM_REG_I|PFM_REG_RO)
+
+typedef int (*pfm_pmc_check_t)(struct pfm_context *ctx,
+			       struct pfm_event_set *set,
+			       struct pfarg_pmc *req);
+
+typedef int (*pfm_pmd_check_t)(struct pfm_context *ctx,
+			       struct pfm_event_set *set,
+			       struct pfarg_pmd *req);
+
+/*
+ * registers description
+ */
+struct pfm_regdesc {
+	u64 pmcs[PFM_PMC_BV];		/* available PMC */
+	u64 pmds[PFM_PMD_BV];		/* available PMD */
+	u64 rw_pmds[PFM_PMD_BV];	/* available RW PMD */
+	u64 intr_pmds[PFM_PMD_BV];	/* PMD generating intr */
+	u64 cnt_pmds[PFM_PMD_BV];	/* PMD counters */
+	u16 max_pmc;			/* highest+1 avail PMC */
+	u16 max_pmd;			/* highest+1 avail PMD */
+	u16 max_rw_pmd;			/* highest+1 avail RW PMD */
+	u16 max_intr_pmd;		/* highest+1 intr PMD */
+	u16 num_rw_pmd;			/* number of avail RW PMD */
+	u16 num_pmcs;			/* number of logical PMCS */
+	u16 num_pmds;			/* number of logical PMDS */
+	u16 num_counters;		/* number of counting PMD */
+};
+
+/*
+ * structure used by pmu description modules
+ *
+ * probe_pmu() routine return value:
+ * 	- 1 means recognized PMU
+ * 	- 0 means not recognized PMU
+ */
+struct pfm_pmu_config {
+	char *pmu_name;				/* PMU family name */
+	char *version;				/* config module version */
+
+	int counter_width;			/* width of hardware counter */
+
+	struct pfm_regmap_desc	*pmc_desc;	/* PMC register descriptions */
+	struct pfm_regmap_desc	*pmd_desc;	/* PMD register descriptions */
+
+	pfm_pmc_check_t		pmc_write_check;/* write checker (optional) */
+	pfm_pmd_check_t		pmd_write_check;/* write checker (optional) */
+	pfm_pmd_check_t		pmd_read_check;	/* read checker (optional) */
+	u16			num_pmc_entries;/* #entries in pmc_desc */
+	u16			num_pmd_entries;/* #entries in pmd_desc */
+	void			*pmu_info;	/* model-specific infos */
+	/*
+	 * fields computed internally, do not set in module
+	 */
+	struct pfm_regdesc	regs;		/* registers available */
+	u64			ovfl_mask;	/* overflow mask */
+};
+
+static inline void *pfm_pmu_info(void)
+{
+	return pfm_pmu_conf->pmu_info;
+}
+
+int pfm_pmu_register(struct pfm_pmu_config *cfg);
+
+int pfm_sysfs_add_pmu(struct pfm_pmu_config *pmu);
+
+#endif /* __PERFMON_PMU_H__ */

-- 

