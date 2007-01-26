Return-Path: <linux-kernel-owner+w=401wt.eu-S1030863AbXAZQvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030863AbXAZQvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030848AbXAZQvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:51:10 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:59359 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030863AbXAZQun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:50:43 -0500
Date: Fri, 26 Jan 2007 17:50:40 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] sclp: don't call local_bh_disable/_local_bh_enable if in_interrupt()
Message-ID: <20070126165040.GM11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] sclp: don't call local_bh_disable/_local_bh_enable if in_interrupt()

local_bh_disable/_local_bh_enable must not be called if in_irq() is
true. Besides that if in_interrupt() is true bottom halves are
disabled anyway.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/sclp.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/char/sclp.c linux-2.6-patched/drivers/s390/char/sclp.c
--- linux-2.6/drivers/s390/char/sclp.c	2007-01-26 17:27:54.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp.c	2007-01-26 17:27:58.000000000 +0100
@@ -402,6 +402,7 @@ sclp_sync_wait(void)
 	unsigned long flags;
 	unsigned long cr0, cr0_sync;
 	u64 timeout;
+	int irq_context;
 
 	/* We'll be disabling timer interrupts, so we need a custom timeout
 	 * mechanism */
@@ -414,7 +415,9 @@ sclp_sync_wait(void)
 	}
 	local_irq_save(flags);
 	/* Prevent bottom half from executing once we force interrupts open */
-	local_bh_disable();
+	irq_context = in_interrupt();
+	if (!irq_context)
+		local_bh_disable();
 	/* Enable service-signal interruption, disable timer interrupts */
 	trace_hardirqs_on();
 	__ctl_store(cr0, 0, 0);
@@ -435,7 +438,8 @@ sclp_sync_wait(void)
 	}
 	local_irq_disable();
 	__ctl_load(cr0, 0, 0);
-	_local_bh_enable();
+	if (!irq_context)
+		_local_bh_enable();
 	local_irq_restore(flags);
 }
 
