Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZKKEg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZKKEg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 23:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZKKEg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 23:36:28 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:36603 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbZKKEg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 23:36:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UPJBkGepnsYV7DGZPVSoFzMhgbaRUDr55t3P6aL73myQ+KeCCD0mjPIM97TE7e9XkA
         kUkKGinzo3ogCeiatYRHALLidFagJa/uEydKqJn0HRNy4D3NpdEXysZNQYSdf7nlrIS0
         ji+yrwpzvtqwzjK8Mbi5jo+MNkkN2so309GOk=
From: Jupyung Lee <jupyung@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jupyung Lee <jupyung@gmail.com>
Subject: [PATCH-rt 1/1] softirqs: add preempt_check_resched() in ksoftirqd()
Date: Wed, 11 Nov 2009 13:35:22 +0900
Message-Id: <1257914122-9637-1-git-send-email-jupyung@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In its current preempt-rt kernel, ksoftirq() includes a series of primitives
related with kernel preemption and irq on/off, in the following order:

preempt_disable()		... (1)
local_irq_disable()		... (2)
__preempt_enable_no_resched()	... (3)
local_irq_enable()		... (4)

A problem arises if a process is awakened between (1) and (2) because
it is not given a chance to preempt the currently running process
for a while since (4): since (4), the kernel is preemptible, but there
is no explicit reschedule point.

A simple suggestion to resolve the problem is to add a reschedule point,
preempt_check_resched(), just after (4).

Signed-off-by: Jupyung Lee <jupyung@gmail.com>
---
 kernel/softirq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 590049c..7c1b041 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -1037,6 +1037,7 @@ sleep_more:
 			set_softirq_pending(local_softirq_pending() & ~softirq_mask);
 			local_bh_disable();
 			local_irq_enable();
+			preempt_check_resched();
 
 			h = &softirq_vec[data->nr];
 			if (h)
-- 
1.5.4.3

