Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZKWRoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZKWRoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZKWRo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:44:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:41612 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZKWRo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:44:26 -0500
Date: Mon, 23 Nov 2009 17:43:35 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1258987355-8751-2-git-send-email-fweisbec@gmail.com>
References: <1258987355-8751-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Check the breakpoint params from perf tools
Message-ID: <tip-fdf6bc95229821e3d9405eba28925b76e92b74d0@git.kernel.org>
Git-Commit-ID: fdf6bc95229821e3d9405eba28925b76e92b74d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fdf6bc95229821e3d9405eba28925b76e92b74d0
Gitweb:     http://git.kernel.org/tip/fdf6bc95229821e3d9405eba28925b76e92b74d0
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 23 Nov 2009 15:42:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 18:18:30 +0100

hw-breakpoints: Check the breakpoint params from perf tools

Perf tools create perf events as disabled in the beginning.
Breakpoints are then considered like ptrace temporary
breakpoints, only meant to reserve a breakpoint slot until we
get all the necessary informations from the user.

In this case, we don't check the address that is breakpointed as
it is NULL in the ptrace case.

But perf tools don't have the same purpose, events are created
disabled to wait for all events to be created before enabling
all of them. We want to check the breakpoint parameters in this
case.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1258987355-8751-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hw_breakpoint.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index c166622..06d372f 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -267,7 +267,16 @@ int __register_perf_hw_breakpoint(struct perf_event *bp)
 	if (ret)
 		return ret;
 
-	if (!bp->attr.disabled)
+	/*
+	 * Ptrace breakpoints can be temporary perf events only
+	 * meant to reserve a slot. In this case, it is created disabled and
+	 * we don't want to check the params right now (as we put a null addr)
+	 * But perf tools create events as disabled and we want to check
+	 * the params for them.
+	 * This is a quick hack that will be removed soon, once we remove
+	 * the tmp breakpoints from ptrace
+	 */
+	if (!bp->attr.disabled || bp->callback == perf_bp_event)
 		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
 
 	return ret;
