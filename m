Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZIPKYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZIPKYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZIPKYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:24:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:46620 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758749AbZIPKX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:23:59 -0400
Date: Wed, 16 Sep 2009 10:23:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Feature to disable APERF/MPERF cpu_power
Message-ID: <tip-8e6598af3f35629c37249a610cf13e73f70db279@git.kernel.org>
Git-Commit-ID: 8e6598af3f35629c37249a610cf13e73f70db279
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:23:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e6598af3f35629c37249a610cf13e73f70db279
Gitweb:     http://git.kernel.org/tip/8e6598af3f35629c37249a610cf13e73f70db279
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 3 Sep 2009 13:20:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:51:28 +0200

sched: Feature to disable APERF/MPERF cpu_power

I suspect a feed-back loop between cpuidle and the aperf/mperf
cpu_power bits, where when we have idle C-states lower the ratio,
which leads to lower cpu_power and then less load, which generates
more idle time, etc..

Put in a knob to disable it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c          |   12 ++++++++++--
 kernel/sched_features.h |    5 +++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c210321..e8e603b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3602,11 +3602,19 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	power *= arch_scale_freq_power(sd, cpu);
+	if (sched_feat(ARCH_POWER))
+		power *= arch_scale_freq_power(sd, cpu);
+	else
+		power *= default_scale_freq_power(sd, cpu);
+
 	power >>= SCHED_LOAD_SHIFT;
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-		power *= arch_scale_smt_power(sd, cpu);
+		if (sched_feat(ARCH_POWER))
+			power *= arch_scale_smt_power(sd, cpu);
+		else
+			power *= default_scale_smt_power(sd, cpu);
+
 		power >>= SCHED_LOAD_SHIFT;
 	}
 
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index e98c2e8..294e10e 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -82,6 +82,11 @@ SCHED_FEAT(LAST_BUDDY, 1)
  */
 SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 
+/*
+ * Use arch dependent cpu power functions
+ */
+SCHED_FEAT(ARCH_POWER, 0)
+
 SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(LB_BIAS, 1)
