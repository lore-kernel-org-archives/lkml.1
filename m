Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZCaKwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZCaKwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZCaKuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:50:46 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:51148 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbZCaKup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:50:45 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v4 5/5] sched: Fix sd_parent_degenerate for
	SD_POWERSAVINGS_BALANCE.
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Date: Tue, 31 Mar 2009 16:20:38 +0530
Message-ID: <20090331105037.16414.86340.stgit@sofia.in.ibm.com>
In-Reply-To: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
References: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
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

So, fix this by allowing such a sched_domain to degenerate and pass on the
responsibility of performing the POWERSAVINGS_BALANCE to it's parent domain.

This patch also fixes the inconsistent behavior of
sched_smt_power_savings while running odd number of pairs of tasks.

Ideally, when sched_smt_power_savings is enabled, we would like to see
the tasks running on sibling threads to take advantage of the
cache-sharing. However, in the case when there
are only 2 threads running, and sched_smt_power_savings is enabled,
the current load balancer doesn't pull them from across packages
onto a single core. This is because of the way the sched_domains
are degenerated today, where the degenerating domain doesn't pass on
the power-savings balance related flag to the new parent.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 193bb67..5f3d16a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7489,6 +7489,20 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
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

