Return-Path: <linux-kernel-owner+w=401wt.eu-S1764974AbYB1T4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764974AbYB1T4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763967AbYB1TvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:51:16 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59318 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764163AbYB1TvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:51:14 -0500
Date: Thu, 28 Feb 2008 11:51:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: hidave.darkstar@gmail.com, akpm@linux-foundation.org,
       fzu@wemgehoertderstaat.de, mingo@elte.hu, ego@in.ibm.com,
       dipankar@in.ibm.com, niv@us.ibm.com, dvhltc@us.ibm.com
Subject: [PATCH] Remove never-migrates assumption from rcu_process_callbacks()
Message-ID: <20080228195107.GA31203@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080228002110.GA20091@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228002110.GA20091@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again!

This patch fixes a potentially invalid access to a per-CPU variable in
rcu_process_callbacks().  This per-CPU access needs to be done in such
a way as to guarantee that the code using it cannot move to some other
CPU before all uses of the value accessed have completed.  Even though
this code is currently only invoked from softirq context, which currrently
cannot migrate to some other CPU, life would be better if this
code did not silently make such an assumption.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupreempt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25-rc3-rcuoffline/kernel/rcupreempt.c linux-2.6.25-rc3-rcuoffline-fp/kernel/rcupreempt.c
--- linux-2.6.25-rc3-rcuoffline/kernel/rcupreempt.c	2008-02-26 17:04:17.000000000 -0800
+++ linux-2.6.25-rc3-rcuoffline-fp/kernel/rcupreempt.c	2008-02-27 23:04:18.000000000 -0800
@@ -736,9 +736,11 @@ static void rcu_process_callbacks(struct
 {
 	unsigned long flags;
 	struct rcu_head *next, *list;
-	struct rcu_data *rdp = RCU_DATA_ME();
+	struct rcu_data *rdp;
 
-	spin_lock_irqsave(&rdp->lock, flags);
+	local_irq_save(flags);
+	rdp = RCU_DATA_ME();
+	spin_lock(&rdp->lock);
 	list = rdp->donelist;
 	if (list == NULL) {
 		spin_unlock_irqrestore(&rdp->lock, flags);
