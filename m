Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbZGTRIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbZGTRIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZGTRIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:08:39 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:53625 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZGTRI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NJpcntn/Tt4TZKA12erRtP9s7J4exy2uqftfArRb/ossByZ12cYmiGR07tZiQg4Nli
         MFG3eOyGMJMXjd3NXbi19dQXB0UchG//ME0z4k5AsmdrGiUWaMcawGVg33l7lxf+woIG
         Tl1Fj+d+3qwz8Fy0Zu1OHnCSptfxkz+vRKbTU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 4/5] perfcounter: Grow the event number to 64 bits
Date: Mon, 20 Jul 2009 13:08:06 -0400
Message-Id: <1248109687-7808-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The event number are defined by the config attr of a counter. When it
is passed while adding a hit, it is compared against the initial
config attr, a 64 bits number, to retrieve the targetted counter.

But when we want to add a hit, this event is passed through 32 bits
parameters, which makes loosing the real event number if its storage
needs more (case of an address).

This patch changes the event parameter in some of the helpers which
add the event hits.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Thomas Gleixner <tglx@linuxtronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Anton Blanchard <anton@samba.org>
---
 kernel/perf_counter.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 5498890..33ffb5a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3435,7 +3435,7 @@ static int perf_swcounter_is_counting(struct perf_counter *counter)
 
 static int perf_swcounter_match(struct perf_counter *counter,
 				enum perf_type_id type,
-				u32 event, struct pt_regs *regs)
+				u64 event, struct pt_regs *regs)
 {
 	if (!perf_swcounter_is_counting(counter))
 		return 0;
@@ -3467,7 +3467,7 @@ static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
 
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     enum perf_type_id type,
-				     u32 event, u64 nr, int nmi,
+				     u64 event, u64 nr, int nmi,
 				     struct perf_sample_data *data)
 {
 	struct perf_counter *counter;
@@ -3497,7 +3497,7 @@ static int *perf_swcounter_recursion_context(struct perf_cpu_context *cpuctx)
 	return &cpuctx->recursion[0];
 }
 
-static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
+static void do_perf_swcounter_event(enum perf_type_id type, u64 event,
 				    u64 nr, int nmi,
 				    struct perf_sample_data *data)
 {
-- 
1.6.2.3

