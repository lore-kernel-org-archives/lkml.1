Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZCRJYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZCRJYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbZCRJWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:22:55 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:37734 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbZCRJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:22:53 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 3 6/6] sched: Fix sd_parent_degenerate for
	SD_POWERSAVINGS_BALANCE.
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 18 Mar 2009 14:52:48 +0530
Message-ID: <20090318092248.24787.38811.stgit@sofia.in.ibm.com>
In-Reply-To: <20090318092054.24787.18730.stgit@sofia.in.ibm.com>
References: <20090318092054.24787.18730.stgit@sofia.in.ibm.com>
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
index 651550c..0e7882a 100644
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

