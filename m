Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbXKFTxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbXKFTxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbXKFTwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45374 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755488AbXKFTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:00 -0500
Message-Id: <20071106195159.706290209@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:53 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 09/28] cpu alloc: crash_notes conversion
Content-Disposition: inline; filename=cpu_alloc_kexec
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/ia64/kernel/crash.c |    2 +-
 drivers/base/cpu.c       |    3 ++-
 kernel/kexec.c           |    5 +++--
 3 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c	2007-10-26 17:52:21.593476581 -0700
+++ linux-2.6/kernel/kexec.c	2007-11-05 11:32:23.422191793 -0800
@@ -24,6 +24,7 @@
 #include <linux/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
+#include <linux/cpu_alloc.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1122,7 +1123,7 @@ void crash_save_cpu(struct pt_regs *regs
 	 * squirrelled away.  ELF notes happen to provide
 	 * all of that, so there is no need to invent something new.
 	 */
-	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
+	buf = (u32*)CPU_PTR(crash_notes, cpu);
 	if (!buf)
 		return;
 	memset(&prstatus, 0, sizeof(prstatus));
@@ -1136,7 +1137,7 @@ void crash_save_cpu(struct pt_regs *regs
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
-	crash_notes = alloc_percpu(note_buf_t);
+	crash_notes = CPU_ALLOC(note_buf_t, GFP_KERNEL|__GFP_ZERO);
 	if (!crash_notes) {
 		printk("Kexec: Memory allocation for saving cpu register"
 		" states failed\n");
Index: linux-2.6/drivers/base/cpu.c
===================================================================
--- linux-2.6.orig/drivers/base/cpu.c	2007-10-26 17:52:00.852693291 -0700
+++ linux-2.6/drivers/base/cpu.c	2007-11-05 11:32:50.005821748 -0800
@@ -10,6 +10,7 @@
 #include <linux/topology.h>
 #include <linux/device.h>
 #include <linux/node.h>
+#include <linux/cpu_alloc.h>
 
 #include "base.h"
 
@@ -95,7 +96,7 @@ static ssize_t show_crash_notes(struct s
 	 * boot up and this data does not change there after. Hence this
 	 * operation should be safe. No locking required.
 	 */
-	addr = __pa(per_cpu_ptr(crash_notes, cpunum));
+	addr = __pa(CPU_PTR(crash_notes, cpunum));
 	rc = sprintf(buf, "%Lx\n", addr);
 	return rc;
 }
Index: linux-2.6/arch/ia64/kernel/crash.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/crash.c	2007-10-26 17:51:57.652573158 -0700
+++ linux-2.6/arch/ia64/kernel/crash.c	2007-11-05 11:26:27.323321824 -0800
@@ -71,7 +71,7 @@ crash_save_this_cpu(void)
 	dst[46] = (unsigned long)ia64_rse_skip_regs((unsigned long *)dst[46],
 			sof - sol);
 
-	buf = (u64 *) per_cpu_ptr(crash_notes, cpu);
+	buf = (u64 *) CPU_PTR(crash_notes, cpu);
 	if (!buf)
 		return;
 	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS, prstatus,

-- 
