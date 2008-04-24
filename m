Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbYDXTN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbYDXTN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758535AbYDXTNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:13:16 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:34257 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523AbYDXTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:13:15 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Olof Johansson <olof@lixom.net>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] 2.6.25+: Fix cpu hotplug in softirq code
Date: Thu, 24 Apr 2008 21:13:11 +0200
User-Agent: KMail/1.9.9
Cc: "David S. Miller" <davem@davemloft.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200804242113.11602.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Olof,

currently cpu hotplug (unplug) seems broken on s390 and likely others. On cpu 
unplug the system starts to behave very strange and hangs.

I bisected the problem to the following commit:

-----
commit 48f20a9a9488c432fc86df1ff4b7f4fa895d1183
Author: Olof Johansson <olof@lixom.net>
Date:   Tue Mar 4 15:23:25 2008 -0800
    tasklets: execute tasklets in the same order they were queued
-----

Reverting this patch seems to fix the problem. I looked into takeover_tasklet
and it seems that there is a way to corrupt the tail pointer of the current 
cpu. If the tasklet list of the frozen cpu is empty, the tail pointer of the
current cpu points to the address of the head pointer of the stopped cpu and 
not to the next pointer of a tasklet_struct.

This patch avoids the list splice of the list is empty and cpu hotplug seems
to work as the tail pointer is not corrupted.
Olof, can you look into that patch and ACK/NACK it so Andrew can push this to
Linus, if appropriate?
Please note that some lines are longer than 80 chars, but line-wrapping looked
worse that this version.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 kernel/softirq.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: kvm/kernel/softirq.c
===================================================================
--- kvm.orig/kernel/softirq.c
+++ kvm/kernel/softirq.c
@@ -589,16 +589,20 @@ static void takeover_tasklets(unsigned i
 	local_irq_disable();
 
 	/* Find end, append list for that CPU. */
-	*__get_cpu_var(tasklet_vec).tail = per_cpu(tasklet_vec, cpu).head;
-	__get_cpu_var(tasklet_vec).tail = per_cpu(tasklet_vec, cpu).tail;
-	per_cpu(tasklet_vec, cpu).head = NULL;
-	per_cpu(tasklet_vec, cpu).tail = &per_cpu(tasklet_vec, cpu).head;
+	if (&per_cpu(tasklet_vec, cpu).head != per_cpu(tasklet_vec, cpu).tail) {
+		*(__get_cpu_var(tasklet_vec).tail) = per_cpu(tasklet_vec, cpu).head;
+		__get_cpu_var(tasklet_vec).tail = per_cpu(tasklet_vec, cpu).tail;
+		per_cpu(tasklet_vec, cpu).head = NULL;
+		per_cpu(tasklet_vec, cpu).tail = &per_cpu(tasklet_vec, cpu).head;
+	}
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
 
-	*__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).head;
-	__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).tail;
-	per_cpu(tasklet_hi_vec, cpu).head = NULL;
-	per_cpu(tasklet_hi_vec, cpu).tail = &per_cpu(tasklet_hi_vec, cpu).head;
+	if (&per_cpu(tasklet_hi_vec, cpu).head != per_cpu(tasklet_hi_vec, cpu).tail) {
+		*__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).head;
+		__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).tail;
+		per_cpu(tasklet_hi_vec, cpu).head = NULL;
+		per_cpu(tasklet_hi_vec, cpu).tail = &per_cpu(tasklet_hi_vec, cpu).head;
+	}
 	raise_softirq_irqoff(HI_SOFTIRQ);
 
 	local_irq_enable();
