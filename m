Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZL1RPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZL1RPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 12:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZL1RPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 12:15:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:46574 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZL1RPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 12:15:30 -0500
Message-ID: <4B38E794.7000204@windriver.com>
Date: Mon, 28 Dec 2009 11:15:00 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, mort@sgi.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH 05/37] kdb: core for kgdb back end
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> <1261603190-5036-2-git-send-email-jason.wessel@windriver.com> <1261603190-5036-3-git-send-email-jason.wessel@windriver.com> <1261603190-5036-4-git-send-email-jason.wessel@windriver.com> <1261603190-5036-5-git-send-email-jason.wessel@windriver.com> <1261603190-5036-6-git-send-email-jason.wessel@windriver.com> <1261652672.4937.189.camel@laptop>  <4B38DDC5.4080202@windriver.com> <1262019353.7135.127.camel@laptop>
In-Reply-To: <1262019353.7135.127.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Dec 2009 17:15:00.0862 (UTC) FILETIME=[49C689E0:01CA87E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-12-28 at 10:33 -0600, Jason Wessel wrote:
>>  The reason we need the attached patch is to be able to call
>> curr_task() for kdb to perform some basic per cpu task analysis while
>> the system is stopped.
> 
> Right, so this set_curr_task() thing is way scary, maybe we can simplify
> things to only expose curr_task()?


I am not sure what you had in mind for a simplification.  Is it simply to only expose the function to kdb that we use, as follows in the patch below, or something else?

There are no calls to set_curr_task() from kdb.  The curr_task() was only needed because there was no way to get at cpu_curr() outside of kernel/sched.c.  I had just assumed curr_task() was the "official" helper function.

Jason.

diff --git a/kernel/sched.c b/kernel/sched.c
index c535cc4..76fa8e1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9784,9 +9784,9 @@ void normalize_rt_tasks(void)
 
 #endif /* CONFIG_MAGIC_SYSRQ */
 
-#ifdef CONFIG_IA64
+#if defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB)
 /*
- * These functions are only useful for the IA64 MCA handling.
+ * These functions are only useful for the IA64 MCA handling, or kdb.
  *
  * They can only be called when the whole system has been
  * stopped - every CPU needs to be quiescent, and no scheduling
@@ -9806,6 +9806,9 @@ struct task_struct *curr_task(int cpu)
 	return cpu_curr(cpu);
 }
 
+#endif /* defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB) */
+
+#ifdef CONFIG_IA64
 /**
  * set_curr_task - set the current task for a given cpu.
  * @cpu: the processor in question.

