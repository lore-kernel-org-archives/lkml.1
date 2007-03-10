Return-Path: <linux-kernel-owner+w=401wt.eu-S933511AbXCJHPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbXCJHPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933513AbXCJHPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:15:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44200
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933511AbXCJHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:15:43 -0500
Date: Fri, 09 Mar 2007 23:15:41 -0800 (PST)
Message-Id: <20070309.231541.112624204.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
CC: linux-kernel@vger.kernel.org
Subject: sparc atomicity patches reverted
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The sparc64 one doesn't even compile, please fix this up and resubmit,
thank you.  I'd like you to redo the 32-bit sparc patch too.

Please, I recommend that you use {sec,clear,etc.}_ti_thread_flag() in
this and the 32-bit sparc TI_USEDFPU patch, instead of the task
versions which could add an unnecessary pointer dereference to go from
tsk to the thread_info.

It is likely that had you used the thread based flag helpers from the
start, you would not have created this build failure.

Thanks again.

--------------------
arch/sparc64/kernel/process.c: In function $,1rx(Bflush_thread$,1ry(B:
arch/sparc64/kernel/process.c:416: error: $,1rx(Btsk$,1ry(B undeclared (first use in this function)
arch/sparc64/kernel/process.c:416: error: (Each undeclared identifier is reported only once
arch/sparc64/kernel/process.c:416: error: for each function it appears in.)
--------------------
diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index 7d75cd4..646ace4 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -413,8 +413,13 @@ void flush_thread(void)
 	struct thread_info *t = current_thread_info();
 	struct mm_struct *mm;
 
-	if (t->flags & _TIF_ABI_PENDING)
-		t->flags ^= (_TIF_ABI_PENDING | _TIF_32BIT);
+	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
+		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
+		if (test_tsk_thread_flag(tsk, TIF_32BIT))
+			clear_tsk_thread_flag(tsk, TIF_32BIT);
+		else
+			set_tsk_thread_flag(tsk, TIF_32BIT);
+	}
 
 	mm = t->task->mm;
 	if (mm)
-- 
1.5.0

