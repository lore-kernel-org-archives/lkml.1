Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbZLLLvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbZLLLvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 06:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbZLLLvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 06:51:45 -0500
Received: from relay3.sgi.com ([192.48.152.1]:51621 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753124AbZLLLvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 06:51:44 -0500
Date: Sat, 12 Dec 2009 05:51:48 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] Expose the irq_desc node in proc/irq
Message-ID: <20091212115148.GA13122@sgi.com>
References: <20091211162532.GA2716@sgi.com> <20091211141158.5da226a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211141158.5da226a8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the irq_desc node as /proc/irq/*/node.

This file provides device hardware locality information for apps desiring to
include hardware locality in irq mapping decisions.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 Documentation/filesystems/proc.txt |    4 ++++
 kernel/irq/proc.c                  |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

Index: linux/kernel/irq/proc.c
===================================================================
--- linux.orig/kernel/irq/proc.c	2009-12-11 10:09:31.000000000 -0600
+++ linux/kernel/irq/proc.c	2009-12-12 05:25:51.000000000 -0600
@@ -146,6 +146,26 @@ static const struct file_operations defa
 	.release	= single_release,
 	.write		= default_affinity_write,
 };
+
+static int irq_node_proc_show(struct seq_file *m, void *v)
+{
+	struct irq_desc *desc = irq_to_desc((long) m->private);
+
+	seq_printf(m, "%d\n", desc->node);
+	return 0;
+}
+
+static int irq_node_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_node_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations irq_node_proc_fops = {
+	.open		= irq_node_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 static int irq_spurious_proc_show(struct seq_file *m, void *v)
@@ -230,6 +250,9 @@ void register_irq_proc(unsigned int irq,
 	/* create /proc/irq/<irq>/smp_affinity */
 	proc_create_data("smp_affinity", 0600, desc->dir,
 			 &irq_affinity_proc_fops, (void *)(long)irq);
+
+	proc_create_data("node", 0444, desc->dir,
+			 &irq_node_proc_fops, (void *)(long)irq);
 #endif
 
 	proc_create_data("spurious", 0444, desc->dir,
Index: linux/Documentation/filesystems/proc.txt
===================================================================
--- linux.orig/Documentation/filesystems/proc.txt	2009-12-09 09:42:46.000000000 -0600
+++ linux/Documentation/filesystems/proc.txt	2009-12-12 05:39:52.000000000 -0600
@@ -558,6 +558,10 @@ The default_smp_affinity mask applies to
 IRQs which have not yet been allocated/activated, and hence which lack a
 /proc/irq/[0-9]* directory.
 
+The node file on an SMP system shows the node to which the device using the IRQ
+reports itself as being attached.  This hardware locality information does not
+include information about any possible driver locality preference.
+
 prof_cpu_mask specifies which CPUs are to be profiled by the system wide
 profiler. Default value is ffffffff (all cpus).
 
