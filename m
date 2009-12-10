Return-Path: <linux-kernel-owner+w=401wt.eu-S1760719AbZLJHue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbZLJHue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbZLJHu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:50:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:46519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760723AbZLJHuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:50:25 -0500
Date: Thu, 10 Dec 2009 07:50:00 GMT
From: "tip-bot for Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tony.luck@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tony.luck@intel.com,
       mingo@elte.hu
In-Reply-To: <4b2024d085302c2a2@agluck-desktop.sc.intel.com>
References: <4b2024d085302c2a2@agluck-desktop.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Avoid out of bounds array reference in save_trace()
Message-ID: <tip-ea5b41f9d595be354f7a50e56b28c2d72e6e88a5@git.kernel.org>
Git-Commit-ID: ea5b41f9d595be354f7a50e56b28c2d72e6e88a5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea5b41f9d595be354f7a50e56b28c2d72e6e88a5
Gitweb:     http://git.kernel.org/tip/ea5b41f9d595be354f7a50e56b28c2d72e6e88a5
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Wed, 9 Dec 2009 14:29:36 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:29:33 +0100

lockdep: Avoid out of bounds array reference in save_trace()

ia64 found this the hard way (because we currently have a stub
for save_stack_trace() that does nothing). But it would be a
good idea to  be cautious in case a real save_stack_trace()
bailed out with an error before it set trace->nr_entries.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: luming.yu@intel.com
LKML-Reference: <4b2024d085302c2a2@agluck-desktop.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7a3ae56..4f8df01 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -386,7 +386,8 @@ static int save_trace(struct stack_trace *trace)
 	 * complete trace that maxes out the entries provided will be reported
 	 * as incomplete, friggin useless </rant>
 	 */
-	if (trace->entries[trace->nr_entries-1] == ULONG_MAX)
+	if (trace->nr_entries != 0 &&
+	    trace->entries[trace->nr_entries-1] == ULONG_MAX)
 		trace->nr_entries--;
 
 	trace->max_entries = trace->nr_entries;
