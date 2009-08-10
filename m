Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbZHJJh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbZHJJh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZHJJh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:37:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:43086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZHJJhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:37:25 -0400
Date: Mon, 10 Aug 2009 09:36:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1249896452.17467.75.camel@twins>
References: <1249896452.17467.75.camel@twins>
Subject: [tip:perfcounters/urgent] perf_counter: Require CAP_SYS_ADMIN for raw tracepoint data
Message-ID: <tip-a4e95fc2cbb31d70a65beffeaf8773f881328c34@git.kernel.org>
Git-Commit-ID: a4e95fc2cbb31d70a65beffeaf8773f881328c34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 09:36:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4e95fc2cbb31d70a65beffeaf8773f881328c34
Gitweb:     http://git.kernel.org/tip/a4e95fc2cbb31d70a65beffeaf8773f881328c34
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 10 Aug 2009 11:20:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 11:33:09 +0200

perf_counter: Require CAP_SYS_ADMIN for raw tracepoint data

Raw tracepoint data contains various kernel internals and
data from other users, so restrict this to CAP_SYS_ADMIN.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1249896452.17467.75.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 5229d16..b0b20a0 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3787,6 +3787,14 @@ static void tp_perf_counter_destroy(struct perf_counter *counter)
 
 static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
+	/*
+	 * Raw tracepoint data is a severe data leak, only allow root to
+	 * have these.
+	 */
+	if ((counter->attr.sample_type & PERF_SAMPLE_RAW) &&
+			!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
 	if (ftrace_profile_enable(counter->attr.config))
 		return NULL;
 
