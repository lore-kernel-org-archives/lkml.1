Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642Ab0AEAhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0AEAhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564Ab0AEAgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:36:24 -0500
Received: from kroah.org ([198.145.64.141]:42519 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab0AEAgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>,
       Siddha Suresh B <suresh.b.siddha@intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 93/97] sched: Sched_rt_periodic_timer vs cpu hotplug
Date: Mon,  4 Jan 2010 16:33:46 -0800
Message-Id: <1262651630-7354-93-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 047106adcc85e3023da210143a6ab8a55df9e0fc upstream.

Heiko reported a case where a timer interrupt managed to
reference a root_domain structure that was already freed by a
concurrent hot-un-plug operation.

Solve this like the regular sched_domain stuff is also
synchronized, by adding a synchronize_sched() stmt to the free
path, this ensures that a root_domain stays present for any
atomic section that could have observed it.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Gregory Haskins <ghaskins@novell.com>
Cc: Siddha Suresh B <suresh.b.siddha@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
LKML-Reference: <1258363873.26714.83.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 04144db..dd0dccd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7925,6 +7925,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 
 static void free_rootdomain(struct root_domain *rd)
 {
+	synchronize_sched();
+
 	cpupri_cleanup(&rd->cpupri);
 
 	free_cpumask_var(rd->rto_mask);
-- 
1.6.6

