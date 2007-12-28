Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXL1MeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXL1MeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 07:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbXL1MeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 07:34:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbXL1MeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 07:34:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] Hibernation: Document __save_processor_state() on x86-64
Date: Fri, 28 Dec 2007 13:53:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712281353.37976.rjw@sisk.pl>
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
 1 file changed, 20 insertions(+)

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
