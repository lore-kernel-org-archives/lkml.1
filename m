Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0CJNK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:10:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:59003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0CJNKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:10:53 -0500
Date: Wed, 10 Mar 2010 13:10:20 GMT
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
Subject: [tip:perf/urgent] perf: Optimize perf_disable
Message-ID: <tip-32975a4f114be52286f9a5bf6c230dbb8c0e1903@git.kernel.org>
Git-Commit-ID: 32975a4f114be52286f9a5bf6c230dbb8c0e1903
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:10:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32975a4f114be52286f9a5bf6c230dbb8c0e1903
Gitweb:     http://git.kernel.org/tip/32975a4f114be52286f9a5bf6c230dbb8c0e1903
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 6 Mar 2010 19:49:19 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:25 +0100

perf: Optimize perf_disable

Currently we always call hw_perf_disable(), even if its already disabled,
this seems superflous, esp. since it cannot be made NMI safe (see further
patches).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 73329de..d810846 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -93,25 +93,15 @@ void __weak perf_event_print_debug(void)	{ }
 
 static DEFINE_PER_CPU(int, perf_disable_count);
 
-void __perf_disable(void)
-{
-	__get_cpu_var(perf_disable_count)++;
-}
-
-bool __perf_enable(void)
-{
-	return !--__get_cpu_var(perf_disable_count);
-}
-
 void perf_disable(void)
 {
-	__perf_disable();
-	hw_perf_disable();
+	if (!__get_cpu_var(perf_disable_count)++)
+		hw_perf_disable();
 }
 
 void perf_enable(void)
 {
-	if (__perf_enable())
+	if (!--__get_cpu_var(perf_disable_count))
 		hw_perf_enable();
 }
 
