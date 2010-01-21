Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547Ab0AUN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0AUN4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426Ab0AUN4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:56:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:46427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0AUN4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:56:00 -0500
Date: Thu, 21 Jan 2010 13:55:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1263459187.4244.265.camel@laptop>
References: <1263459187.4244.265.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Honour event state for aux stream data
Message-ID: <tip-22e190851f8709c48baf00ed9ce6144cdc54d025@git.kernel.org>
Git-Commit-ID: 22e190851f8709c48baf00ed9ce6144cdc54d025
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:55:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22e190851f8709c48baf00ed9ce6144cdc54d025
Gitweb:     http://git.kernel.org/tip/22e190851f8709c48baf00ed9ce6144cdc54d025
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 18 Jan 2010 09:12:32 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:40 +0100

perf: Honour event state for aux stream data

Anton reported that perf record kept receiving events even after calling
ioctl(PERF_EVENT_IOC_DISABLE). It turns out that FORK,COMM and MMAP
events didn't respect the disabled state and kept flowing in.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Anton Blanchard <anton@samba.org>
LKML-Reference: <1263459187.4244.265.camel@laptop>
CC: stable@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 603c0d8..d27746b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3268,6 +3268,9 @@ static void perf_event_task_output(struct perf_event *event,
 
 static int perf_event_task_match(struct perf_event *event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
@@ -3377,6 +3380,9 @@ static void perf_event_comm_output(struct perf_event *event,
 
 static int perf_event_comm_match(struct perf_event *event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
@@ -3494,6 +3500,9 @@ static void perf_event_mmap_output(struct perf_event *event,
 static int perf_event_mmap_match(struct perf_event *event,
 				   struct perf_mmap_event *mmap_event)
 {
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return 0;
+
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
