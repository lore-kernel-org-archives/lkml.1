Return-Path: <linux-kernel-owner+w=401wt.eu-S933910AbZKXTFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbZKXTFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 14:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933730AbZKXTFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 14:05:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:48790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbZKXTFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 14:05:19 -0500
Date: Tue, 24 Nov 2009 19:03:36 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4b0bdf36.1818d00a.07cc.25ae@mx.google.com>
References: <4b0bdf36.1818d00a.07cc.25ae@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Fix validate_event bug
Message-ID: <tip-1261a02a0c0ab8e643125705f0d1d83e5090e4d1@git.kernel.org>
Git-Commit-ID: 1261a02a0c0ab8e643125705f0d1d83e5090e4d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1261a02a0c0ab8e643125705f0d1d83e5090e4d1
Gitweb:     http://git.kernel.org/tip/1261a02a0c0ab8e643125705f0d1d83e5090e4d1
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 24 Nov 2009 05:27:18 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 19:23:48 +0100

perf_events, x86: Fix validate_event bug

The validate_event() was failing on valid event combinations. The
function was assuming that if x86_schedule_event() returned 0, it
meant error. But x86_schedule_event() returns the counter index and
0 is a perfectly valid value. An error is returned if the function
returns a negative value.

Furthermore, validate_event() was also failing for event groups
because the event->pmu was not set until after
hw_perf_event_init().

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: paulus@samba.org
Cc: perfmon2-devel@lists.sourceforge.net
Cc: eranian@gmail.com
LKML-Reference: <4b0bdf36.1818d00a.07cc.25ae@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
--
 arch/x86/kernel/cpu/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
---
 arch/x86/kernel/cpu/perf_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bd87430..c1bbed1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2229,10 +2229,10 @@ validate_event(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
 	struct hw_perf_event fake_event = event->hw;
 
-	if (event->pmu != &pmu)
+	if (event->pmu && event->pmu != &pmu)
 		return 0;
 
-	return x86_schedule_event(cpuc, &fake_event);
+	return x86_schedule_event(cpuc, &fake_event) >= 0;
 }
 
 static int validate_group(struct perf_event *event)
