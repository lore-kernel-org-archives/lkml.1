Return-Path: <linux-kernel-owner+w=401wt.eu-S1761571AbZEOIpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761571AbZEOIpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757558AbZEOIna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:43:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:57182 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760523AbZEOIn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:43:29 -0400
Date: Fri, 15 May 2009 08:42:53 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: x86: Allow unpriviliged use of NMIs
Message-ID: <tip-a026dfecc035f213c1cfa0bf6407ce3155f6a9df@git.kernel.org>
Git-Commit-ID: a026dfecc035f213c1cfa0bf6407ce3155f6a9df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:42:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a026dfecc035f213c1cfa0bf6407ce3155f6a9df
Gitweb:     http://git.kernel.org/tip/a026dfecc035f213c1cfa0bf6407ce3155f6a9df
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 13 May 2009 10:02:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:46:57 +0200

perf_counter: x86: Allow unpriviliged use of NMIs

Apply sysctl_perf_counter_priv to NMIs. Also, fail the counter
creation instead of silently down-grading to regular interrupts.

[ Impact: allow wider perf-counter usage ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 88ae8ce..c19e927 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -280,8 +280,11 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	 * If privileged enough, allow NMI events:
 	 */
 	hwc->nmi = 0;
-	if (capable(CAP_SYS_ADMIN) && hw_event->nmi)
+	if (hw_event->nmi) {
+		if (sysctl_perf_counter_priv && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		hwc->nmi = 1;
+	}
 
 	hwc->irq_period	= hw_event->irq_period;
 	if ((s64)hwc->irq_period <= 0 || hwc->irq_period > x86_pmu.max_period)
