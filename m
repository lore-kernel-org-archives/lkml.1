Return-Path: <linux-kernel-owner+w=401wt.eu-S1762686AbXEVJtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686AbXEVJtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbXEVJtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:49:01 -0400
Received: from www.osadl.org ([213.239.205.134]:46034 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756243AbXEVJtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:49:00 -0400
Subject: [PATCH] i386: fix early usage of atomic_add_return and
	local_add_return on real i386
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Content-Type: text/plain
Date: Tue, 22 May 2007 11:48:58 +0200
Message-Id: <1179827338.12708.110.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The check (boot_cpu_data.x86 == 3) in atomic_add_return() and
local_add_return() fails, when those operations are used before
boot_cpu_data is filled in.

Change the check to (boot_cpu_data.x86 <= 3) to fix this.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


Index: linux-2.6/include/asm-i386/atomic.h
===================================================================
--- linux-2.6.orig/include/asm-i386/atomic.h
+++ linux-2.6/include/asm-i386/atomic.h
@@ -182,7 +182,7 @@ static __inline__ int atomic_add_return(
 	int __i;
 #ifdef CONFIG_M386
 	unsigned long flags;
-	if(unlikely(boot_cpu_data.x86==3))
+	if(unlikely(boot_cpu_data.x86 <= 3))
 		goto no_xadd;
 #endif
 	/* Modern 486+ processor */
Index: linux-2.6/include/asm-i386/local.h
===================================================================
--- linux-2.6.orig/include/asm-i386/local.h
+++ linux-2.6/include/asm-i386/local.h
@@ -135,7 +135,7 @@ static __inline__ long local_add_return(
 	long __i;
 #ifdef CONFIG_M386
 	unsigned long flags;
-	if(unlikely(boot_cpu_data.x86==3))
+	if(unlikely(boot_cpu_data.x86 <= 3))
 		goto no_xadd;
 #endif
 	/* Modern 486+ processor */


