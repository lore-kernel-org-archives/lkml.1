Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbXKTBRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbXKTBRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXKTBNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:47 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36865 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753852AbXKTBNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:35 -0500
Message-Id: <20071120011334.564309282@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:44 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 12/45] cpu alloc: crash_notes conversion
Content-Disposition: inline; filename=0020-cpu-alloc-crash_notes-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/ia64/kernel/crash.c |    2 +-
 drivers/base/cpu.c       |    2 +-
 kernel/kexec.c           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/ia64/kernel/crash.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/crash.c	2007-11-15 21:18:10.647904573 -0800
+++ linux-2.6/arch/ia64/kernel/crash.c	2007-11-15 21:25:29.423155123 -0800
@@ -71,7 +71,7 @@ crash_save_this_cpu(void)
 	dst[46] = (unsigned long)ia64_rse_skip_regs((unsigned long *)dst[46],
 			sof - sol);
 
-	buf = (u64 *) per_cpu_ptr(crash_notes, cpu);
+	buf = (u64 *) CPU_PTR(crash_notes, cpu);
 	if (!buf)
 		return;
 	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS, prstatus,
Index: linux-2.6/drivers/base/cpu.c
===================================================================
--- linux-2.6.orig/drivers/base/cpu.c	2007-11-15 21:18:10.655904442 -0800
+++ linux-2.6/drivers/base/cpu.c	2007-11-15 21:25:29.423155123 -0800
@@ -95,7 +95,7 @@ static ssize_t show_crash_notes(struct s
 	 * boot up and this data does not change there after. Hence this
 	 * operation should be safe. No locking required.
 	 */
-	addr = __pa(per_cpu_ptr(crash_notes, cpunum));
+	addr = __pa(CPU_PTR(crash_notes, cpunum));
 	rc = sprintf(buf, "%Lx\n", addr);
 	return rc;
 }
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c	2007-11-15 21:18:10.663904549 -0800
+++ linux-2.6/kernel/kexec.c	2007-11-15 21:25:29.423155123 -0800
@@ -1122,7 +1122,7 @@ void crash_save_cpu(struct pt_regs *regs
 	 * squirrelled away.  ELF notes happen to provide
 	 * all of that, so there is no need to invent something new.
 	 */
-	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
+	buf = (u32*)CPU_PTR(crash_notes, cpu);
 	if (!buf)
 		return;
 	memset(&prstatus, 0, sizeof(prstatus));
@@ -1136,7 +1136,7 @@ void crash_save_cpu(struct pt_regs *regs
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
-	crash_notes = alloc_percpu(note_buf_t);
+	crash_notes = CPU_ALLOC(note_buf_t, GFP_KERNEL|__GFP_ZERO);
 	if (!crash_notes) {
 		printk("Kexec: Memory allocation for saving cpu register"
 		" states failed\n");

-- 
