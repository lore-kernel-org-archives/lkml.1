Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZJVQeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZJVQeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbZJVQeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:34:06 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:21804 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756230AbZJVQeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:34:05 -0400
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2 -tip] perf: Don't generate events for the idle task when exclude_idle is set.
References: <ye8vdi7mluz.fsf@camel16.daimi.au.dk>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 22 Oct 2009 18:34:08 +0200
In-Reply-To: <ye8vdi7mluz.fsf@camel16.daimi.au.dk>
Message-ID: <ye8pr8fmlq7.fsf@camel16.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-NFIT-RelayAddr: 130.225.16.135
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting samples for the idle task is often not interesting, so don't
generate them when exclude_idle is set for the event in question.

Signed-off-by: Søren Sandmann Pedersen <sandmann@redhat.com>
---
 kernel/perf_event.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b492c55..7bc84cb 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3959,8 +3959,9 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 		regs = task_pt_regs(current);
 
 	if (regs) {
-		if (perf_event_overflow(event, 0, &data, regs))
-			ret = HRTIMER_NORESTART;
+		if (!(event->attr.exclude_idle && current->pid == 0))
+			if (perf_event_overflow(event, 0, &data, regs))
+				ret = HRTIMER_NORESTART;
 	}
 
 	period = max_t(u64, 10000, event->hw.sample_period);
-- 
1.6.5.rc2

