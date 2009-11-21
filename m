Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZKUNlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZKUNlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZKUNlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:41:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:60831 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbZKUNln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:41:43 -0500
Date: Sat, 21 Nov 2009 13:41:01 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212508.222339539@chello.nl>
References: <20091120212508.222339539@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Allow for custom overflow handlers
Message-ID: <tip-453f19eea7dbad837425e9b07d84568d14898794@git.kernel.org>
Git-Commit-ID: 453f19eea7dbad837425e9b07d84568d14898794
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  453f19eea7dbad837425e9b07d84568d14898794
Gitweb:     http://git.kernel.org/tip/453f19eea7dbad837425e9b07d84568d14898794
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:35 +0100

perf: Allow for custom overflow handlers

in-kernel perf users might wish to have custom actions on the
sample interrupt.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212508.222339539@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    6 ++++++
 kernel/perf_event.c        |    8 +++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b5cdac0..a430ac3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -567,6 +567,8 @@ struct perf_pending_entry {
 
 typedef void (*perf_callback_t)(struct perf_event *, void *);
 
+struct perf_sample_data;
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -658,6 +660,10 @@ struct perf_event {
 	struct pid_namespace		*ns;
 	u64				id;
 
+	void (*overflow_handler)(struct perf_event *event,
+			int nmi, struct perf_sample_data *data,
+			struct pt_regs *regs);
+
 #ifdef CONFIG_EVENT_PROFILE
 	struct event_filter		*filter;
 #endif
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3852e26..1dfb6cc 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3710,7 +3710,11 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 			perf_event_disable(event);
 	}
 
-	perf_event_output(event, nmi, data, regs);
+	if (event->overflow_handler)
+		event->overflow_handler(event, nmi, data, regs);
+	else
+		perf_event_output(event, nmi, data, regs);
+
 	return ret;
 }
 
@@ -4836,6 +4840,8 @@ inherit_event(struct perf_event *parent_event,
 	if (parent_event->attr.freq)
 		child_event->hw.sample_period = parent_event->hw.sample_period;
 
+	child_event->overflow_handler = parent_event->overflow_handler;
+
 	/*
 	 * Link it up in the child's context:
 	 */
