Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbYE3EBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbYE3EBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYE3EAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45435 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750764AbYE3EAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:14 -0400
Message-Id: <20080530040012.295482074@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:26 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 06/41] cpu alloc: crash_notes conversion
Content-Disposition: inline; filename=cpu_alloc_crash_notes_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert crash_notes access to use cpu alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/ia64/kernel/crash.c |    2 +-
 drivers/base/cpu.c       |    2 +-
 kernel/kexec.c           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/ia64/kernel/crash.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/crash.c	2008-05-28 17:25:23.000000000 -0700
+++ linux-2.6/arch/ia64/kernel/crash.c	2008-05-28 18:27:04.000000000 -0700
@@ -72,7 +72,7 @@
 	dst[46] = (unsigned long)ia64_rse_skip_regs((unsigned long *)dst[46],
 			sof - sol);
 
-	buf = (u64 *) per_cpu_ptr(crash_notes, cpu);
+	buf = (u64 *) CPU_PTR(crash_notes, cpu);
 	if (!buf)
 		return;
 	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS, prstatus,
Index: linux-2.6/drivers/base/cpu.c
===================================================================
--- linux-2.6.orig/drivers/base/cpu.c	2008-05-28 17:25:23.000000000 -0700
+++ linux-2.6/drivers/base/cpu.c	2008-05-28 18:27:04.000000000 -0700
@@ -95,7 +95,7 @@
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
--- linux-2.6.orig/kernel/kexec.c	2008-05-28 17:25:23.000000000 -0700
+++ linux-2.6/kernel/kexec.c	2008-05-28 18:27:05.000000000 -0700
@@ -1121,7 +1121,7 @@
 	 * squirrelled away.  ELF notes happen to provide
 	 * all of that, so there is no need to invent something new.
 	 */
-	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
+	buf = (u32 *)CPU_PTR(crash_notes, cpu);
 	if (!buf)
 		return;
 	memset(&prstatus, 0, sizeof(prstatus));
@@ -1135,7 +1135,7 @@
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
-	crash_notes = alloc_percpu(note_buf_t);
+	crash_notes = CPU_ALLOC(note_buf_t, GFP_KERNEL|__GFP_ZERO);
 	if (!crash_notes) {
 		printk("Kexec: Memory allocation for saving cpu register"
 		" states failed\n");

-- 
