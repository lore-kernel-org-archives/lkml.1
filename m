Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbYHSJvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbYHSJvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbYHSJvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:51:17 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:16979 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbYHSJvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:51:15 -0400
X-BigFish: VPS5(zz7cf0izz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5UE0T-04-JMB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] fix build error in kernel/rcuclassic.c with latest tip/master
Date: Tue, 19 Aug 2008 11:50:52 +0200
Message-ID: <1219139452-7435-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Aug 2008 09:50:52.0993 (UTC) FILETIME=[11846B10:01C901E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error for me:

  CC      kernel/rcuclassic.o
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c: In function ‘__rcu_process_callbacks’:
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c:561: error: ‘flags’ undeclared (first use in this function)
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c:561: error: (Each undeclared identifier is reported only once
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c:561: error: for each function it appears in.)
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c:561: warning: type defaults to ‘int’ in declaration of ‘__dummy2’
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c:561: warning: comparison of distinct pointer types lacks a cast
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c:566: warning: type defaults to ‘int’ in declaration of ‘__dummy2’
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c:566: warning: comparison of distinct pointer types lacks a cast
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c: In function ‘rcu_init_percpu_data’:
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c:713: warning: comparison of distinct pointer types lacks a cast
/data2/repos/tip/linux.trees.git/kernel/rcuclassic.c:721: warning: comparison of distinct pointer types lacks a cast
make[2]: *** [kernel/rcuclassic.o] Error 1

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 kernel/rcuclassic.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index c6b6cf5..2f193e1 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -557,6 +557,8 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 		local_irq_enable();
 
 		if (rcu_batch_after(rdp->batch, rcp->pending)) {
+			unsigned long flags;
+
 			/* and start it/schedule start if it's a new batch */
 			spin_lock_irqsave(&rcp->lock, flags);
 			if (rcu_batch_after(rdp->batch, rcp->pending)) {
@@ -708,7 +710,7 @@ void rcu_check_callbacks(int cpu, int user)
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
-	long flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&rcp->lock, flags);
 	memset(rdp, 0, sizeof(*rdp));
-- 
1.5.3.7


