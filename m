Return-Path: <linux-kernel-owner+w=401wt.eu-S1759843AbYD2Hk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbYD2Hk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYD2HkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:40:17 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:61903 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYD2HkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:40:16 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Olof Johansson <olof@lixom.net>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH/resend] 2.6.25+: Fix cpu hotplug problem in softirq code
Date: Tue, 29 Apr 2008 09:40:12 +0200
User-Agent: KMail/1.9.9
Cc: "David S. Miller" <davem@davemloft.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org
References: <200804242113.11602.borntraeger@de.ibm.com>
In-Reply-To: <200804242113.11602.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804290940.12838.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of a patch, which fixes a bug in cpu hotplug introduced
after 2.6.25. Andrew, Olof, any opinions on this patch?

Christian


--- old mail ---

Hello Olof,

currently cpu hotplug (unplug) seems broken on s390 and likely others. On cpu 
unplug the system starts to behave very strange and hangs.

I bisected the problem to the following commit:

-----
commit 48f20a9a9488c432fc86df1ff4b7f4fa895d1183
Author: Olof Johansson <olof@lixom.net>
Date:   Tue Mar 4 15:23:25 2008 -0800
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
