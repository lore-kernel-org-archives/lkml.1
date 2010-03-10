Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0CJNNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:13:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:43055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0CJNNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:13:45 -0500
Date: Wed, 10 Mar 2010 13:12:55 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix double disable calls
Message-ID: <tip-19925ce778f9fc371b9607625de3bff04c60121e@git.kernel.org>
Git-Commit-ID: 19925ce778f9fc371b9607625de3bff04c60121e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:12:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19925ce778f9fc371b9607625de3bff04c60121e
Gitweb:     http://git.kernel.org/tip/19925ce778f9fc371b9607625de3bff04c60121e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 6 Mar 2010 13:20:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:33 +0100

perf, x86: Fix double disable calls

hw_perf_enable() would disable events that were not yet enabled.

This causes problems with code that assumes that ->enable/->disable calls
are balanced (like the LBR code does).

What happens is that we disable newly added counters that match their
previous assignment, even though they are not yet programmed on the
hardware.

Avoid this by only doing the first pass over the existing events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 071c840..045cc0b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -802,6 +802,7 @@ void hw_perf_enable(void)
 		return;
 
 	if (cpuc->n_added) {
+		int n_running = cpuc->n_events - cpuc->n_added;
 		/*
 		 * apply assignment obtained either from
 		 * hw_perf_group_sched_in() or x86_pmu_enable()
@@ -809,7 +810,7 @@ void hw_perf_enable(void)
 		 * step1: save events moving to new counters
 		 * step2: reprogram moved events into new counters
 		 */
-		for (i = 0; i < cpuc->n_events; i++) {
+		for (i = 0; i < n_running; i++) {
 
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
