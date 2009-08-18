Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbZHRIC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbZHRIC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZHRICY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:02:24 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36341 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZHRICV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:02:21 -0400
Message-ID: <4A8A5FD4.5070908@ct.jp.nec.com>
Date: Tue, 18 Aug 2009 17:01:24 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] task_struct: stack_canary is not needed without CC_STACKPROTECTOR
References: <4A8A44CA.2020701@ct.jp.nec.com> <87ws51r2wh.fsf@basil.nowhere.org>
In-Reply-To: <87ws51r2wh.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> writes:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> The field stack_canary is only used with CC_STACKPROTECTOR.
>> This patch reduces task_struct size without CC_STACKPROTECTOR.
> 
> Adding a ifdef in the middle of a widely used structure is nasty.  It
> means that if someone changes the option then the newly loaded modules
> don't work anymore (yes that's not officially supported, but works
> most of the time and is often convenient in practice)
> 
> So when you add a ifdef please move the field to the end at least.

Thanks for the comment, that's reasonable.
Here's the update.

====
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The field stack_canary is only used with CC_STACKPROTECTOR.
This patch reduces task_struct size without CC_STACKPROTECTOR.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/sched.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index af1e328..9a1d68d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1247,9 +1247,6 @@ struct task_struct {
 	pid_t pid;
 	pid_t tgid;
 
-	/* Canary value for the -fstack-protector gcc feature */
-	unsigned long stack_canary;
-
 	/* 
 	 * pointers to (original) parent process, youngest child, younger sibling,
 	 * older sibling, respectively.  (p->father can be replaced with 
@@ -1494,6 +1491,10 @@ struct task_struct {
 	/* bitmask of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
+#ifdef CONFIG_CC_STACKPROTECTOR
+	/* Canary value for the -fstack-protector gcc feature */
+	unsigned long stack_canary;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
-- 
1.6.3.3

