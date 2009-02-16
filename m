Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbZBPQwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbZBPQwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZBPQvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:51:23 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:46911 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbZBPQvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:51:22 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 3/3] sched: Fix sd_parent_degenerate for
	SD_POWERSAVINGS_BALANCE.
To: linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, ego@in.ibm.com
Cc: balbir@in.ibm.com, dipankar@in.ibm.com, efault@gmx.de, andi@firstfloor.org,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Mon, 16 Feb 2009 22:21:16 +0530
Message-ID: <20090216165116.12804.90036.stgit@sofia.in.ibm.com>
In-Reply-To: <20090216164719.12804.37013.stgit@sofia.in.ibm.com>
References: <20090216164719.12804.37013.stgit@sofia.in.ibm.com>
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
---

 kernel/sched.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index af88f5a..32858fd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6934,6 +6934,17 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_SHARE_PKG_RESOURCES);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
+
+		/*
+		 * If the only flag that is preventing us from degenerating
+		 * a domain with a single group is power_savings balance,
+		 * see if we can transfer that responsibility to the new parent
+		 */
+		if (pflags & SD_POWERSAVINGS_BALANCE && parent->parent) {
+			pflags &= ~SD_POWERSAVINGS_BALANCE;
+			parent->parent->flags |=
+				sd_power_saving_flags(parent->level);
+		}
 	}
 	if (~cflags & pflags)
 		return 0;

