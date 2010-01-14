Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970Ab0ANKWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab0ANKWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622Ab0ANKWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:22:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42435 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab0ANKWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:22:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: [PATCH] oom: OOM-Killed process don't invoke pagefault-oom
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100114191940.6749.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 19:22:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick, I've found this issue by code review. I'm glad if you review this
patch.

Thanks.

=============================
commit 1c0fe6e3 (invoke oom-killer from page fault) created
page fault specific oom handler.

But If OOM occur, alloc_pages() in page fault might return
NULL. It mean page fault return VM_FAULT_OOM. But OOM Killer
itself sholdn't invoke next OOM Kill. it is obviously strange.

Plus, process exiting itself makes some free memory. we
don't need kill another process.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/oom_kill.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4f167b8..86cecdf 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -596,6 +596,15 @@ void pagefault_out_of_memory(void)
 {
 	unsigned long freed = 0;
 
+	/*
+	 * If the task was received SIGKILL while memory allocation, alloc_pages
+	 * might return NULL and it cause page fault return VM_FAULT_OOM. But
+	 * in such case, the task don't need kill any another task, it need
+	 * just die.
+	 */
+	if (fatal_signal_pending(current))
+		return;
+
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
 		/* Got some memory back in the last second. */
-- 
1.6.5.2



