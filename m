Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZCFGbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZCFGbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZCFG3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:29:32 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49873 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbZCFG3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:29:31 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH V3 6/6] sched: Fix sd_parent_degenerate for
	SD_POWERSAVINGS_BALANCE.
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>
Cc: "Dipankar Sarma" <dipankar@in.ibm.com>, efault@gmx.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Fri, 06 Mar 2009 11:59:21 +0530
Message-ID: <20090306062921.9445.60671.stgit@sofia.in.ibm.com>
In-Reply-To: <20090306060513.9445.28732.stgit@sofia.in.ibm.com>
References: <20090306060513.9445.28732.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a sched_domain having a single group can be prevented from getting
degenerated if it contains a SD_POWERSAVINGS_BALANCE flag. But since it has
only one group, it won't have any scope for performing powersavings balance as
it does not have a sibling group to pull from.

Apart from not provide any powersavings, it also fails to participate
in normal load-balancing.

Fix this by allowing such a sched_domain to degenerate and pass on the
responsibility of performing the POWERSAVINGS_BALANCE to it's parent domain.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 35e1651..d27b8e3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6970,6 +6970,20 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_SHARE_PKG_RESOURCES);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
+
+		/*
+		 * If the only flag that is preventing us from degenerating
+		 * a domain with a single group is SD_POWERSAVINGS_BALANCE
+		 * check if it can be transferred to the new parent,
+		 * and degenerate this domain. With a single
+		 * group, it anyway can't contribute to power-aware load
+		 * balancing.
+		 */
+		if (pflags & SD_POWERSAVINGS_BALANCE && parent->parent) {
+			pflags &= ~SD_POWERSAVINGS_BALANCE;
+			parent->parent->flags |=
+				sd_power_saving_flags(parent->level);
+		}
 	}
 	if (~cflags & pflags)
 		return 0;

