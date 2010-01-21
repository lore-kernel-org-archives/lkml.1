Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566Ab0AUN4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0AUN4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701Ab0AUN4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:56:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:46428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0AUN4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:56:02 -0500
Date: Thu, 21 Jan 2010 13:55:30 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Change the is_software_event() definition
Message-ID: <tip-92b6759857ea3ad19bc6871044e373f6251841d3@git.kernel.org>
Git-Commit-ID: 92b6759857ea3ad19bc6871044e373f6251841d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:55:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92b6759857ea3ad19bc6871044e373f6251841d3
Gitweb:     http://git.kernel.org/tip/92b6759857ea3ad19bc6871044e373f6251841d3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 18 Jan 2010 14:02:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:40 +0100

perf: Change the is_software_event() definition

The is_software_event() definition always confuses me because its an
exclusive expression, make it an inclusive one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c66b34f..8fa7187 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -814,9 +814,14 @@ extern int perf_event_overflow(struct perf_event *event, int nmi,
  */
 static inline int is_software_event(struct perf_event *event)
 {
-	return (event->attr.type != PERF_TYPE_RAW) &&
-		(event->attr.type != PERF_TYPE_HARDWARE) &&
-		(event->attr.type != PERF_TYPE_HW_CACHE);
+	switch (event->attr.type) {
+	case PERF_TYPE_SOFTWARE:
+	case PERF_TYPE_TRACEPOINT:
+	/* for now the breakpoint stuff also works as software event */
+	case PERF_TYPE_BREAKPOINT:
+		return 1;
+	}
+	return 0;
 }
 
 extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
