Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYDJXkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYDJXkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbYDJXjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:39:47 -0400
Received: from ozlabs.org ([203.10.76.45]:47365 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbYDJXjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:39:46 -0400
To: <linux-kernel@vger.kernel.org>
CC: Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       <takata@linux-m32r.org>, <linux-m32r@ml.linux-m32r.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@ozlabs.org>
Date: Fri, 11 Apr 2008 09:36:39 +1000
Subject: [PATCH 1/2] Add thread_info_cache_init() to all archs
Message-Id: <20080410233738.15C0EDE2C9@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architecture need to maintain a kmem cache for thread info
structures. (next patch adds that to powerpc to fix an alignment
problem).

There is no good arch callback to use to initialize that cache
that I can find, so this adds a new one and adds an empty macro
for when it's not implemented.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

So we have the choice here between:

 - the ifdef on the func name that I did, consistent with what
I did before for iomap, which iirc Linus liked

 - add some more ARCH_HAS_* or HAVE_* (yuck)

 - add an empty definition to all archs .h (pain in the neck but I
can do it, though it will be an annoying patch to keep around)

 - do a weak function (will slightly bloat everybody for no good reason)

So unless there is strong complaints, I'd like to stick to my
current approach.

(This one fixes a stupid typo, missing () in the macro def.)

 include/linux/sched.h |    4 ++++
 init/main.c           |    1 +
 2 files changed, 5 insertions(+)

--- linux-work.orig/init/main.c	2008-04-10 13:11:06.000000000 +1000
+++ linux-work/init/main.c	2008-04-10 13:11:19.000000000 +1000
@@ -623,6 +623,7 @@ asmlinkage void __init start_kernel(void
 	if (efi_enabled)
 		efi_enter_virtual_mode();
 #endif
+	thread_info_cache_init();
 	fork_init(num_physpages);
 	proc_caches_init();
 	buffer_init();
Index: linux-work/include/linux/sched.h
===================================================================
--- linux-work.orig/include/linux/sched.h	2008-04-10 13:11:44.000000000 +1000
+++ linux-work/include/linux/sched.h	2008-04-11 09:35:58.000000000 +1000
@@ -1893,6 +1893,10 @@ static inline unsigned long *end_of_stac
 
 #endif
 
+#ifndef thread_info_cache_init
+#define thread_info_cache_init()	do { } while(0)
+#endif
+
 /* set thread flags in other task's structures
  * - see asm/thread_info.h for TIF_xxxx flags available
  */
