Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbYDRG5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbYDRG5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYDRG53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:57:29 -0400
Received: from ozlabs.org ([203.10.76.45]:38766 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbYDRG52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:57:28 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 18 Apr 2008 16:56:15 +1000
Subject: [PATCH 1/3] Add thread_info_cache_init() weak hook
Message-Id: <20080418065726.C466EDE246@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architecture need to maintain a kmem cache for thread info
structures. (next patch adds that to powerpc to fix an alignment
problem).

There is no good arch callback to use to initialize that cache
that I can find, so this adds a new one in the form of a weak
function whose default is empty.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 include/linux/sched.h |    2 ++
 init/main.c           |    5 +++++
 2 files changed, 7 insertions(+)

--- linux-work.orig/init/main.c	2008-03-26 10:39:25.000000000 +1100
+++ linux-work/init/main.c	2008-04-18 16:43:53.000000000 +1000
@@ -504,6 +504,10 @@ void __init __attribute__((weak)) smp_se
 {
 }
 
+void __init __weak thread_info_cache_init(void)
+{
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -623,6 +627,7 @@ asmlinkage void __init start_kernel(void
 	if (efi_enabled)
 		efi_enter_virtual_mode();
 #endif
+	thread_info_cache_init();
 	fork_init(num_physpages);
 	proc_caches_init();
 	buffer_init();
Index: linux-work/include/linux/sched.h
===================================================================
--- linux-work.orig/include/linux/sched.h	2008-04-02 09:47:56.000000000 +1100
+++ linux-work/include/linux/sched.h	2008-04-18 13:11:10.000000000 +1000
@@ -1893,6 +1893,8 @@ static inline unsigned long *end_of_stac
 
 #endif
 
+extern void thread_info_cache_init(void);
+
 /* set thread flags in other task's structures
  * - see asm/thread_info.h for TIF_xxxx flags available
  */
