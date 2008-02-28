Return-Path: <linux-kernel-owner+w=401wt.eu-S1762247AbYB1AVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762247AbYB1AVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760757AbYB1AVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:21:35 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35403 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbYB1AVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:21:34 -0500
Date: Wed, 27 Feb 2008 16:21:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: hidave.darkstar@gmail.com, akpm@linux-foundation.org,
       fzu@wemgehoertderstaat.de, mingo@elte.hu, ego@in.ibm.com,
       dipankar@in.ibm.com, niv@us.ibm.com, dvhltc@us.ibm.com
Subject: [PATCH] Fix hibernate/resume in presence of PREEMPT_RCU and hotplug
Message-ID: <20080228002110.GA20091@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This fixes a oops encountered when doing hibernate/resume in presence
of PREEMPT_RCU.  The problem was that the code failed to disable preemption
when accessing a per-CPU variable.  This is OK when called from code
that already has preemption disabled, but such is not the case from
the suspend/resume code path.

Reported-by: Dave Young <hidave.darkstar@gmail.com>
Tested-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupreempt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.25-rc3/kernel/rcupreempt.c linux-2.6.25-rc3-rcuoffline/kernel/rcupreempt.c
--- linux-2.6.25-rc3/kernel/rcupreempt.c	2008-02-26 16:58:43.000000000 -0800
+++ linux-2.6.25-rc3-rcuoffline/kernel/rcupreempt.c	2008-02-26 17:04:17.000000000 -0800
@@ -702,8 +702,9 @@ void rcu_offline_cpu(int cpu)
 	 * fix.
 	 */
 
+	local_irq_save(flags);
 	rdp = RCU_DATA_ME();
-	spin_lock_irqsave(&rdp->lock, flags);
+	spin_lock(&rdp->lock);
 	*rdp->nexttail = list;
 	if (list)
 		rdp->nexttail = tail;
