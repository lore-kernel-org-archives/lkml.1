Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYHQPvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYHQPvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYHQPvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:51:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:8838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYHQPvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:51:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Nqnf/dv0PiGH5J20NY/34b7XfZmRNnabmrqnNrAKkt+MLusze8Y0JDf5l1oFlGC6w7
         1ICpIK35zF8UBYcp292nfE7eQLdujA5Dr+VlYkKxuydQovjApTZCSer0GkR4bAPQxFOF
         Z+xHCbnqoZQ4MXJXDxMSXZiQevsXwvPO5425w=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86/percpu: silence section mismatch warnings related to EARLY_PER_CPU variables
Date: Sun, 17 Aug 2008 17:50:50 +0200
Message-Id: <1218988252-17932-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mike Travis in "x86: cleanup early per cpu variables/accesses v4"
(23ca4bba3e20c6c3cb11c1bb0ab4770b724d39ac):

    The DEFINE macro defines the per_cpu variable as well as the early
    map and pointer.  It also initializes the per_cpu variable and map
    elements to "_initvalue".  The early_* macros provide access to
    the initial map (usually setup during system init) and the early
    pointer.  This pointer is initialized to point to the early map
    but is then NULL'ed when the actual per_cpu areas are setup.  After
    that the per_cpu variable is the correct access to the variable.

As these variables are NULL'ed before __init sections are dropped
(in setup_per_cpu_maps), they can be safely annotated as __ref.

This change silences following section mismatch warnings:

WARNING: vmlinux.o(.data+0x46c0): Section mismatch in reference from the variable x86_cpu_to_apicid_early_ptr to the variable .init.data:x86_cpu_to_apicid_early_map
The variable x86_cpu_to_apicid_early_ptr references
the variable __initdata x86_cpu_to_apicid_early_map
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x46c8): Section mismatch in reference from the variable x86_bios_cpu_apicid_early_ptr to the variable .init.data:x86_bios_cpu_apicid_early_map
The variable x86_bios_cpu_apicid_early_ptr references
the variable __initdata x86_bios_cpu_apicid_early_map
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x46d0): Section mismatch in reference from the variable x86_cpu_to_node_map_early_ptr to the variable .init.data:x86_cpu_to_node_map_early_map
The variable x86_cpu_to_node_map_early_ptr references
the variable __initdata x86_cpu_to_node_map_early_map
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/percpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/percpu.h b/include/asm-x86/percpu.h
index 4e91ee1..f643a3a 100644
--- a/include/asm-x86/percpu.h
+++ b/include/asm-x86/percpu.h
@@ -182,7 +182,7 @@ do {							\
 	DEFINE_PER_CPU(_type, _name) = _initvalue;			\
 	__typeof__(_type) _name##_early_map[NR_CPUS] __initdata =	\
 				{ [0 ... NR_CPUS-1] = _initvalue };	\
-	__typeof__(_type) *_name##_early_ptr = _name##_early_map
+	__typeof__(_type) *_name##_early_ptr __refdata = _name##_early_map
 
 #define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
 	EXPORT_PER_CPU_SYMBOL(_name)
-- 
1.5.4.5

