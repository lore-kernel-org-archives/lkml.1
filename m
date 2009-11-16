Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZKPLTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZKPLTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 06:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZKPLTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 06:19:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:45655 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbZKPLTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 06:19:39 -0500
Date: Mon, 16 Nov 2009 11:18:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
In-Reply-To: <1258363873.26714.83.camel@laptop>
References: <1258363873.26714.83.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Sched_rt_periodic_timer vs cpu hotplug
Message-ID: <tip-047106adcc85e3023da210143a6ab8a55df9e0fc@git.kernel.org>
Git-Commit-ID: 047106adcc85e3023da210143a6ab8a55df9e0fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  047106adcc85e3023da210143a6ab8a55df9e0fc
Gitweb:     http://git.kernel.org/tip/047106adcc85e3023da210143a6ab8a55df9e0fc
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 16 Nov 2009 10:28:09 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 10:46:27 +0100

sched: Sched_rt_periodic_timer vs cpu hotplug

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
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cea2bea..3c91f11 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7912,6 +7912,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 
 static void free_rootdomain(struct root_domain *rd)
 {
+	synchronize_sched();
+
 	cpupri_cleanup(&rd->cpupri);
 
 	free_cpumask_var(rd->rto_mask);
