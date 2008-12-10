Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYLJN6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYLJN6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYLJN6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:58:22 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:62701 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbYLJN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:58:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEANlUP0lMROB9/2dsb2JhbACBbM5Bgwc
Date: Wed, 10 Dec 2008 08:58:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@hpl.hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Performance counter in-kernel virtualization API
Message-ID: <20081210135802.GA2297@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:46:40 up 23 days, 14:27,  4 users,  load average: 0.84, 1.21,
	1.05
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

I finally found some code I've written 1.5 year ago which aimed at
providing an in-kernel virtualization API which would be useful for
tracers, and eventually a layer on top of it could be done to
save/restore per-thread offset values so it makes sense for userspace
too.

The state of these patches is : really really far from completeness.
Actually, I think that at this stage, they can only be used as API and
data structures ideas to represent some of the "features" inherent to
performance counter handling (e.g. mapping control registers to physical
counter registers...)

Sadly I don't have much time to put on PMC, given tracing is my focus.
Also, I did not go through any of the recent PMC code, so the approach I
propose here might be completely wrong. The only thing I want people to
keep in mind is that an in-kernel API for performance counters is good.

And.. the code style is imperfect, it's not documented and it does not
compile. ;) So feel free to ignore it. It's provided "as-is".

Mathieu


pmc-low-level-api

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/pmc.h |   31 +++++++++++++++++++++++++++++++
 kernel/Makefile     |    1 +
 kernel/pmc.c        |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)

Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2007-06-29 22:21:44.000000000 -0400
+++ linux-2.6-lttng/kernel/Makefile	2007-06-29 22:22:02.000000000 -0400
@@ -60,6 +60,7 @@
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_IMMEDIATE) += immediate.o
 obj-$(CONFIG_MARKERS) += marker.o
+obj-$(CONFIG_PMC) += pmc.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: linux-2.6-lttng/include/linux/pmc.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/pmc.h	2007-06-30 20:19:24.000000000 -0400
@@ -0,0 +1,31 @@
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <asm/pmc.h>
+
+/*
+ * Two PMC modes : simply count or call a callback whenever the counter reach
+ * the "interval" value.
+ */
+enum pmc_mode { PMC_COUNT, PMC_SIGNAL };
+
+#define PMC_FLAG_DISABLED	0
+
+typedef void (*pmc_callback)(struct pmc_client *handle);
+
+struct pmc_client {
+				/* bitfield of usable logical PMCs */
+	unsigned long allowed[NR_LOGICAL_PMC/(8*sizeof(unsigned long))];
+	uint64_t interval;	/* Interval between signals (pmc increments) */
+	uint64_t count;		/* Current count updated by PMC (internal) */
+	uint64_t offset;	/* offset of count (internal) */
+	struct list_head node[NR_PHYSICAL_PMC];	/* List node (internal) */
+	pmc_callback *cb;	/* Callback to call when signal is ready */
+	void *private_data;	/* Private data, for the callback */
+	enum pmc_mode mode;	/* PMC mode : count or signal */
+	int prio;		/* Priority: highest have precedence */
+	int assigned;		/* Logical PMC assigned (internal) */
+	int control;		/* Control PMC assigned (internal) */
+};
+
+
Index: linux-2.6-lttng/kernel/pmc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/pmc.c	2007-06-30 11:42:04.000000000 -0400
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) 2007 Mathieu Desnoyers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/list.h>
+#include <linux/percpu.h>
+
+int pmc_register_client(struct pmc_client *client)
+{
+	return arch_pmc_register_client(client);
+}
+EXPORT_SYMBOL_GPL(pmc_register_client);
+
+void pmc_unregister_client(struct pmc_client *client)
+{
+	return arch_pmc_unregister_client(client);
+}
+EXPORT_SYMBOL_GPL(pmc_unregister_client);
+
+/*
+ * May fail.
+ */
+int pmc_read(struct pmc_client *client, uint64_t *count)
+{
+	return arch_pmc_read(client, count);
+}
+EXPORT_SYMBOL_GPL(pmc_read);
+
+/*
+ * May fail.
+ */
+int pmc_write(struct pmc_client *client, uint64_t count)
+{
+	return arch_pmc_write(client, count);
+}
+EXPORT_SYMBOL_GPL(pmc_write);



pmc-low-level-api-i386.patch

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/Kconfig.debug |    5 +
 arch/i386/kernel/pmc.c  |  198 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/pmc.h  |   50 ++++++++++++
 3 files changed, 253 insertions(+)

Index: linux-2.6-lttng/arch/i386/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/arch/i386/Kconfig.debug	2007-06-30 01:29:27.000000000 -0400
+++ linux-2.6-lttng/arch/i386/Kconfig.debug	2007-06-30 01:29:43.000000000 -0400
@@ -84,5 +84,10 @@
           would otherwise cause a system to silently reboot. Disabling this
           option saves about 4k and might cause you much additional grey
           hair.
+config PMC
+	default y
+	bool "Enable Performance Monitoring Counter Abstraction"
+	help
+	  This option enables abstracted PMCs.
 
 endmenu
Index: linux-2.6-lttng/include/asm-i386/pmc.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-i386/pmc.h	2007-06-30 13:00:36.000000000 -0400
@@ -0,0 +1,50 @@
+
+#define PHYSICAL_PMC_W	0
+#define PHYSICAL_PMC_X	1
+#define PHYSICAL_PMC_Y	2
+#define PHYSICAL_PMC_Z	3
+#define NR_PHYSICAL_PMC	4
+
+#if 0
+#define C0	0
+#define C1	1
+#define C2	2
+#define C3	3
+#define C4	4
+#define C5	5
+#define C6	6
+
+#define _C0	(1<<C0)
+#define _C1	(1<<C1)
+#define _C2	(1<<C2)
+#define _C3	(1<<C3)
+#define _C4	(1<<C4)
+#define _C5	(1<<C5)
+#define _C6	(1<<C6)
+
+#define NR_CONTROL	7
+#endif //0
+
+/*
+ * Architecture dependant PMCs
+ */
+#define LOGICAL_ARCH_PMC_A	0
+#define LOGICAL_ARCH_PMC_B	1
+#define LOGICAL_ARCH_PMC_C	2
+#define NR_LOGICAL_ARCH_PMC	3
+
+#define _LOGICAL_ARCH_PMC_A	(1<<LOGICAL_ARCH_PMC_A)
+#define _LOGICAL_ARCH_PMC_B	(1<<LOGICAL_ARCH_PMC_B)
+#define _LOGICAL_ARCH_PMC_C	(1<<LOGICAL_ARCH_PMC_C)
+
+/*
+ * Architecture independent performance counters
+ */
+
+#define LOGICAL_PMC_ABC		\
+		(_LOGICAL_ARCH_PMC_A|_LOGICAL_ARCH_PMC_B|_LOGICAL_ARCH_PMC_C)
+#define LOGICAL_PMC_AB		\
+		(_LOGICAL_ARCH_PMC_A|_LOGICAL_ARCH_PMC_B)
+#define LOGICAL_PMC_BC		\
+		(_LOGICAL_ARCH_PMC_B|_LOGICAL_ARCH_PMC_C)
+
Index: linux-2.6-lttng/arch/i386/kernel/pmc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/i386/kernel/pmc.c	2007-06-30 13:03:49.000000000 -0400
@@ -0,0 +1,198 @@
+
+#include <linux/list.h>
+#include <linux/percpu.h>
+
+#include <linux/pmc.h>
+#include <linux/mutex.h>
+#include <asm/pmc.h>
+
+/*
+ * L A -> ( W & X & Y & Z ) | ( X & Z ) | ( W & Z ) | ( Y & Z )
+ *
+ * L B -> X & Y
+ *
+ * L C -> Y | Z
+ */
+
+static DECLARE_MUTEX(pmc_lock);
+static DEFINE_PER_CPU(struct list_head[NR_PHYSICAL_PMC], pmc_table);
+
+				/* P0    P1     P2     P3 */
+static char pmc_phys_mapping[NR_LOGICAL_PMC][NR_PHYSICAL_PMC] = {
+	/* LOGICAL_ARCH_PMC_A */	{ _C0|_C2, _C0|_C3, _C0|_C3, _C0|_C1|_C2|_C3, },
+	/* LOGICAL_ARCH_PMC_B */	{ 0, _C4, _C4, 0, },
+	/* LOGICAL_ARCH_PMC_C */	{ 0, 0, _C5, _C6, },
+};
+
+static int pmc_control_use[NR_CONTROL];
+
+static unsigned int pmc_phys_to_msr_mapping[NR_PHYSICAL_PMC] =
+{ 0xa, 0xb, 0xc, 0xd }
+
+static int do_start_pmc(int logical_pmc, int physical_pmc)
+{
+	unsigned int msrid;
+
+	msrid = pmc_phys_to_msr_mapping[physical_pmc];
+
+
+	switch (control_pmc) {
+		case C0:/* Set bit X pos 4 */
+			/* msb write */
+			break;
+		case C1:
+			break;
+		case C2:
+			break;
+		case C3:
+			break;
+		case C4:
+			break;
+		case C5:
+			break;
+		case C6:
+			break;
+	}
+}
+
+/*
+ * test if physical pmc is available or used by the same logical pmc.
+ */
+static int test_pmc_avail(struct list_head *head, int logical)
+{
+	struct pmc_client *client_iter;
+
+	list_for_each_entry_rcu(client_iter, head, node) {
+		if (client_iter.assigned != logical
+				&& client_iter.assigned >= 0)
+			return 0;
+	}
+	return 1;
+}
+
+static int start_pmc(int control_pmc, struct pmc_client *client)
+{
+	client.control = control_pmc;
+	if (pmc_control_use[control_pmc]++ == 0)
+		do_start_pmc(control_pmc);
+	return pmc_read(client, &client.offset);
+}
+
+static void stop_pmc(int control_pmc, struct pmc_client *client)
+{
+	if (--pmc_control_use[control_pmc] == 0)
+		do_stop_pmc(control_pmc);
+}
+
+//FIXME: add relocation of ressources if other ressources can be assigned to
+//different physical/logical IDs.
+//FIXME: report conflicting lower priority clients so they can be disabled
+//(assigned value would be set to -1).
+int arch_pmc_register_client(struct pmc_client *client)
+{
+	int l, p, c;
+	struct list_head *head;
+	int control_members, control_fail;
+	int ret = -EBUSY;
+
+	mutex_lock(&pmc_mutex);
+	for (l=0; l<NR_LOGICAL_PMC; l++) {
+		if (!test_bit(l, &client.allowed))
+			continue;
+		for (c=0; c<NR_CONTROL; c++) {
+			control_members = control_fail = 0;
+			for (p=0; p<NR_PHYSICAL_PMC; p++) {
+				head = &get_cpu_var(pmc_table[p]);
+				if (pmc_phys_mapping[l][p] & (1<<c)) {
+					if (test_pmc_avail(head, l))
+						control_members++;
+					else
+						control_fail++;
+				}
+				put_cpu_var(pmc_table[p]);
+			}
+			if (control_members > 0 && control_fail == 0) {
+				for (p=0; p<NR_PHYSICAL_PMC; p++) {
+					head = &get_cpu_var(pmc_table[p]);
+					list_add_rcu(&client.node[p], head);
+					put_cpu_var(pmc_table[p]);
+				}
+				start_pmc(l, p);
+				ret = 0;
+				goto end;
+			}
+		}
+	}
+end:
+	mutex_unlock(&pmc_mutex);
+	return ret;
+}
+
+int arch_pmc_unregister_client(struct pmc_client *client)
+{
+	int p;
+	struct pmc_client *client_iter;
+	struct list_head *head;
+	int ret = 0;
+
+	/* TODO Unregister IRQ handler. */
+	mutex_lock(&pmc_mutex);
+	//stop_pmc(client.control_pmc, );
+	for (p=0; p<NR_PHYSICAL_PMC; p++) {
+		head = &get_cpu_var(pmc_table[p]);
+		list_for_each_entry_safe_rcu(client_iter, head, node) {
+			if (client_iter == client) {
+				list_del_rcu(&client.node[p]);
+				break;
+			}
+
+		}
+		put_cpu_var(pmc_table[p]);
+	}
+	mutex_unlock(&pmc_mutex);
+	synchronize_rcu();	/* Wait before client can be freed */
+	return ret;
+}
+
+/*
+ * TODO : setup this IRQ handler
+ * Must be NMI reentrant.
+ */
+void pmc_signal(unsigned int pmc_physical_id)
+{
+	struct list_head *head;
+	struct pmc_client *client;
+	uint64_t count;
+
+	head = &get_cpu_var(pmc_table[pmc_physical_id]);
+	list_for_each_entry_rcu(client, head, node) {
+		if (client.assigned < 0)
+			continue;
+		ret = pmc_read(client, &count);
+		if (!ret) {
+			if (client.interval < count) {
+				if (client.cb)
+					client.cb(client);
+			}
+		}
+	}
+	put_cpu_var(pmc_table[pmc_physical_id]);
+}
+
+
+int arch_pmc_read(struct pmc_client *client, uint64_t *count)
+{
+	if (client.assigned < 0)
+		return -EBUSY;
+	switch (client.control) {
+
+
+	}
+	*count = client.count - client.offset;
+}
+
+int arch_pmc_write(struct pmc_client *client, uint64_t count)
+{
+
+
+}


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
