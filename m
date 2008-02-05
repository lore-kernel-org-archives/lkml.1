Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbYBEUa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbYBEUa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbYBEUau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:30:50 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:47386 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbYBEUat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:30:49 -0500
Date: Tue, 5 Feb 2008 22:30:46 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86 mmiotrace: fix relay-buffer-full flag for SMP
Message-ID: <20080205223046.668309be@daedalus.pq.iki.fi>
In-Reply-To: <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relay has per-cpu buffers, but mmiotrace was using only a single flag
for detecting buffer full/not-full transitions. The new code makes
this per-cpu and actually counts missed events.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/kernel/mmiotrace/mmio-mod.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/mmiotrace/mmio-mod.c b/arch/x86/kernel/mmiotrace/mmio-mod.c
index 82ae920..f492b65 100644
--- a/arch/x86/kernel/mmiotrace/mmio-mod.c
+++ b/arch/x86/kernel/mmiotrace/mmio-mod.c
@@ -29,6 +29,7 @@
 #include <asm/pgtable.h>
 #include <linux/mmiotrace.h>
 #include <asm/e820.h> /* for ISA_START_ADDRESS */
+#include <asm/atomic.h>
 
 #include "kmmio.h"
 #include "pf_in.h"
@@ -47,9 +48,13 @@ struct trap_reason {
 	int active_traces;
 };
 
+/* Accessed per-cpu. */
 static struct trap_reason pf_reason[NR_CPUS];
 static struct mm_io_header_rw cpu_trace[NR_CPUS];
 
+/* Access to this is not per-cpu. */
+static atomic_t dropped[NR_CPUS];
+
 static struct file_operations mmio_fops = {
 	.owner = THIS_MODULE,
 };
@@ -57,7 +62,6 @@ static struct file_operations mmio_fops = {
 static const size_t subbuf_size = 256*1024;
 static struct rchan *chan;
 static struct dentry *dir;
-static int suspended;      /* XXX should this be per cpu? */
 static struct proc_dir_entry *proc_marker_file;
 
 /* module parameters */
@@ -269,19 +273,21 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 static int subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
 					void *prev_subbuf, size_t prev_padding)
 {
+	unsigned int cpu = buf->cpu;
+	atomic_t *drop = &dropped[cpu];
+	int count;
 	if (relay_buf_full(buf)) {
-		if (!suspended) {
-			suspended = 1;
-			printk(KERN_ERR MODULE_NAME
-						": cpu %d buffer full!!!\n",
-						smp_processor_id());
+		if (atomic_inc_return(drop) == 1) {
+			printk(KERN_ERR MODULE_NAME ": cpu %d buffer full!\n",
+									cpu);
 		}
 		return 0;
-	} else if (suspended) {
-		suspended = 0;
+	} else if ((count = atomic_read(drop))) {
 		printk(KERN_ERR MODULE_NAME
-					": cpu %d buffer no longer full.\n",
-					smp_processor_id());
+					": cpu %d buffer no longer full, "
+					"missed %d events.\n",
+					cpu, count);
+		atomic_sub(count, drop);
 	}
 
 	return 1;
-- 
1.5.3.7

