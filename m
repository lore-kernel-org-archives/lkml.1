Return-Path: <linux-kernel-owner+w=401wt.eu-S1764980AbYEFT0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764980AbYEFT0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbYEFT0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:26:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54065 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752386AbYEFT0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:26:18 -0400
Date: Tue, 6 May 2008 12:26:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: Spinlocks waiting with interrupts disabled / preempt disabled.
Message-ID: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We just had a couple of cases of systems failing because interrrupts were 
not serviced. Turned out that we were trying to acquire the treelock for 
write while lots of readers where starving the writer a bit. A device 
timed out before the write lock was acquired.

If interrupts would be enabled while busy waiting then such scenarios 
could be avoided.

Could we make the wait cases more interrupt / preempt friendly by 
reenabling interrupts / preempt while waiting? We had this interrupt 
friendly behavior for a long time on IA64. If we have a special busy case 
then we can also not use atomic ops and thus acquire the cacheline only 
for read.

F.e.

Index: linux/kernel/spinlock.c
===================================================================
--- linux.orig/kernel/spinlock.c	2008-05-05 12:22:16.000000000 -0500
+++ linux/kernel/spinlock.c	2008-05-06 14:05:43.953016660 -0500
@@ -132,10 +132,14 @@ unsigned long __lockfunc _write_lock_irq
 {
 	unsigned long flags;
 
+retry:
 	local_irq_save(flags);
-	preempt_disable();
-	_raw_write_lock(lock);
-	return flags;
+	if (_write_trylock(lock))
+		return flags;
+	local_irq_restore(flags);
+	while (!write_can_lock(lock))
+		cpu_relax();
+	goto retry;
 }
 EXPORT_SYMBOL(_write_lock_irqsave);
 
