Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbXL3VyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbXL3VyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbXL3Vx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:53:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758463AbXL3Vxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:53:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] Hibernation: Document __save_processor_state() on x86-64 (rev. 2)
Date: Sun, 30 Dec 2007 23:13:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712302313.52483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Document the fact that __save_processor_state() has to save all CPU
registers referred to by the kernel in case a different kernel is
used to load and restore a hibernation image containing it. 

Sigend-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/suspend_64.c |   20 ++++++++++++++++++++
 include/asm-x86/suspend_64.h |    9 ++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/suspend_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/suspend_64.c
+++ linux-2.6/arch/x86/kernel/suspend_64.c
@@ -19,6 +19,21 @@ extern const void __nosave_begin, __nosa
 
 struct saved_context saved_context;
 
+/**
+ *	__save_processor_state - save CPU registers before creating a
+ *		hibernation image and before restoring the memory state from it
+ *	@ctxt - structure to store the registers contents in
+ *
+ *	NOTE: If there is a CPU register the modification of which by the
+ *	boot kernel (ie. the kernel used for loading the hibernation image)
+ *	might affect the operations of the restored target kernel (ie. the one
+ *	saved in the hibernation image), then its contents must be saved by this
+ *	function.  In other words, if kernel A is hibernated and different
+ *	kernel B is used for loading the hibernation image into memory, the
+ *	kernel A's __save_processor_state() function must save all registers
+ *	needed by kernel A, so that it can operate correctly after the resume
+ *	regardless of what kernel B does in the meantime.
+ */
 void __save_processor_state(struct saved_context *ctxt)
 {
 	kernel_fpu_begin();
@@ -69,6 +84,11 @@ static void do_fpu_end(void)
 	kernel_fpu_end();
 }
 
+/**
+ *	__restore_processor_state - restore the contents of CPU registers saved
+ *		by __save_processor_state()
+ *	@ctxt - structure to load the registers contents from
+ */
 void __restore_processor_state(struct saved_context *ctxt)
 {
 	/*
Index: linux-2.6/include/asm-x86/suspend_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/suspend_64.h
+++ linux-2.6/include/asm-x86/suspend_64.h
@@ -15,7 +15,14 @@ arch_prepare_suspend(void)
 	return 0;
 }
 
-/* Image of the saved processor state. If you touch this, fix acpi/wakeup.S. */
+/*
+ * Image of the saved processor state, used by the low level ACPI suspend to
+ * RAM code and by the low level hibernation code.
+ *
+ * If you modify it, fix arch/x86/kernel/acpi/wakeup_64.S and make sure that
+ * __save/__restore_processor_state(), defined in arch/x86/kernel/suspend_64.c,
+ * still work as required.
+ */
 struct saved_context {
 	struct pt_regs regs;
   	u16 ds, es, fs, gs, ss;
