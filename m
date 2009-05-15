Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbZEOIqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbZEOIqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760229AbZEOInl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:43:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:57193 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760723AbZEOInj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:43:39 -0400
Date: Fri, 15 May 2009 08:43:04 GMT
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
Subject: [tip:perfcounters/core] perf_counter: Fix perf_output_copy() WARN to account for overflow
Message-ID: <tip-53020fe81eecd0b7be295868ce5850ef8f41074e@git.kernel.org>
Git-Commit-ID: 53020fe81eecd0b7be295868ce5850ef8f41074e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:43:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53020fe81eecd0b7be295868ce5850ef8f41074e
Gitweb:     http://git.kernel.org/tip/53020fe81eecd0b7be295868ce5850ef8f41074e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 13 May 2009 21:26:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:46:59 +0200

perf_counter: Fix perf_output_copy() WARN to account for overflow

The simple reservation test in perf_output_copy() failed to take
unsigned int overflow into account, fix this.

[ Impact: fix false positive warning with more than 4GB of profiling data ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ff166c1..985be0b 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1927,7 +1927,11 @@ static void perf_output_copy(struct perf_output_handle *handle,
 
 	handle->offset = offset;
 
-	WARN_ON_ONCE(handle->offset > handle->head);
+	/*
+	 * Check we didn't copy past our reservation window, taking the
+	 * possible unsigned int wrap into account.
+	 */
+	WARN_ON_ONCE(((int)(handle->head - handle->offset)) < 0);
 }
 
 #define perf_output_put(handle, x) \
