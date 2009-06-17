Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZFQQlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZFQQlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZFQQkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:40:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:52066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbZFQQkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:40:51 -0400
Date: Wed, 17 Jun 2009 16:39:34 GMT
From: tip-bot for Christian Engelmayer 
	<christian.engelmayer@frequentis.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, christian.engelmayer@frequentis.com,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, christian.engelmayer@frequentis.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090616103512.0c846e51@frequentis.com>
References: <20090616103512.0c846e51@frequentis.com>
Subject: [tip:sched/urgent] sched: Fix out of scope variable access in sched_slice()
Message-ID: <tip-3104bf03a923c72043a9c5009d9cd56724304916@git.kernel.org>
Git-Commit-ID: 3104bf03a923c72043a9c5009d9cd56724304916
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 16:39:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3104bf03a923c72043a9c5009d9cd56724304916
Gitweb:     http://git.kernel.org/tip/3104bf03a923c72043a9c5009d9cd56724304916
Author:     Christian Engelmayer <christian.engelmayer@frequentis.com>
AuthorDate: Tue, 16 Jun 2009 10:35:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 18:37:54 +0200

sched: Fix out of scope variable access in sched_slice()

Access to local variable lw is aliased by usage of pointer load.
Access to pointer load in calc_delta_mine() happens when lw is
already out of scope.

[ Reported by static code analysis. ]

Signed-off-by: Christian Engelmayer <christian.engelmayer@frequentis.com>
LKML-Reference: <20090616103512.0c846e51@frequentis.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5f9650e..ba7fd6e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -430,12 +430,13 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	for_each_sched_entity(se) {
 		struct load_weight *load;
+		struct load_weight lw;
 
 		cfs_rq = cfs_rq_of(se);
 		load = &cfs_rq->load;
 
 		if (unlikely(!se->on_rq)) {
-			struct load_weight lw = cfs_rq->load;
+			lw = cfs_rq->load;
 
 			update_load_add(&lw, se->load.weight);
 			load = &lw;
