Return-Path: <linux-kernel-owner+w=401wt.eu-S1946505AbXEAD6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946505AbXEAD6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946502AbXEAD6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:58:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:48997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933506AbXEAD61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:27 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: jan.kiszka@web.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [28/30] i386: avoid redundant preempt_disable in __unlazy_fpu
Message-Id: <20070501035826.F1D8713CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jan Kiszka <jan.kiszka@web.de>

There are two callers of __unlazy_fpu, unlazy_fpu and __switch_to, and
none of them appear to require additional preempt_disable/enable here.
Let's open-code save_init_fpu in __unlazy_fpu to save a few ops.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/i387.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux/include/asm-i386/i387.h
===================================================================
--- linux.orig/include/asm-i386/i387.h
+++ linux/include/asm-i386/i387.h
@@ -74,11 +74,12 @@ static inline void __save_init_fpu( stru
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
-#define __unlazy_fpu( tsk ) do { \
-	if (task_thread_info(tsk)->status & TS_USEDFPU) \
-		save_init_fpu( tsk ); 			\
-	else						\
-		tsk->fpu_counter = 0;			\
+#define __unlazy_fpu( tsk ) do {				\
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {	\
+		__save_init_fpu(tsk);				\
+		stts();						\
+	} else							\
+		tsk->fpu_counter = 0;				\
 } while (0)
 
 #define __clear_fpu( tsk )					\
