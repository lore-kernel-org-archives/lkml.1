Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYFZCrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYFZCrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYFZCrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:47:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbYFZCrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:47:07 -0400
Message-ID: <4862F9B3.5030300@cn.fujitsu.com>
Date: Thu, 26 Jun 2008 10:06:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH]rcu classic: update qlen when cpu offline
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When callbacks are moved from offline cpu to this cpu,
the qlen field of this rdp should be updated.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index f4ffbd0..42aead6 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -373,6 +373,10 @@ static void __rcu_offline_cpu(struct rcu_data *this_rdp,
 	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
 	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
 	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
+
+	local_irq_disable();
+	this_rdp->qlen += rdp->qlen;
+	local_irq_enable();
 }
 
 static void rcu_offline_cpu(int cpu)


