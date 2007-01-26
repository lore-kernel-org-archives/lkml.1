Return-Path: <linux-kernel-owner+w=401wt.eu-S1030869AbXAZQwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030869AbXAZQwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030874AbXAZQvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:51:52 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58775 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030870AbXAZQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:51:39 -0500
Date: Fri, 26 Jan 2007 17:51:36 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Small barrier() and cpu_relax() cleanup.
Message-ID: <20070126165136.GO11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Small barrier() and cpu_relax() cleanup.

cpu_relax() has barrier() semantics hence there is no need to use both
of them in conjunction in sclp_sync_wait(). Also change cpu_relax()
so it's more obvious that it has barrier semantics.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/sclp.c     |    1 -
 include/asm-s390/processor.h |    5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/drivers/s390/char/sclp.c linux-2.6-patched/drivers/s390/char/sclp.c
--- linux-2.6/drivers/s390/char/sclp.c	2007-01-26 17:27:59.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp.c	2007-01-26 17:28:00.000000000 +0100
@@ -433,7 +433,6 @@ sclp_sync_wait(void)
 		    get_clock() > timeout &&
 		    del_timer(&sclp_request_timer))
 			sclp_request_timer.function(sclp_request_timer.data);
-		barrier();
 		cpu_relax();
 	}
 	local_irq_disable();
diff -urpN linux-2.6/include/asm-s390/processor.h linux-2.6-patched/include/asm-s390/processor.h
--- linux-2.6/include/asm-s390/processor.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/processor.h	2007-01-26 17:28:00.000000000 +0100
@@ -201,9 +201,8 @@ unsigned long get_wchan(struct task_stru
 static inline void cpu_relax(void)
 {
 	if (MACHINE_HAS_DIAG44)
-		asm volatile("diag 0,0,68" : : : "memory");
-	else
-		barrier();
+		asm volatile("diag 0,0,68");
+	barrier();
 }
 
 /*
