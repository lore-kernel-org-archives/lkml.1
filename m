Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbXHBPqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbXHBPqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXHBPqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:46:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbXHBPqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:46:39 -0400
Date: Thu, 2 Aug 2007 17:46:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070802154626.GA13929@elte.hu>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708010439050.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> [...] With the increased text comes increased runtime memory usage, 
> e.g. task_struct increased so that only 5 of them instead 6 fit now 
> into 8KB.

yeah, thanks for the reminder, this is on my todo list. As i suspect you 
noticed it too, much of the task_struct size increase is not fundamental 
and not related to 64-bit math at all - it's simply debug and 
instrumentation overhead.

Look at the following table (i386, nodebug):

                         size 
                         ----
    pre-CFS              1328
        CFS              1472
        CFS+patch        1376 

the very small patch below gets rid of 96 bytes. And that's only the
beginning.

	Ingo

-------------------------------------------------->
---
 include/linux/sched.h |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -905,23 +905,28 @@ struct sched_entity {
 	struct rb_node		run_node;
 	unsigned int		on_rq;
 
+	u64			exec_start;
+	u64			sum_exec_runtime;
 	u64			wait_start_fair;
+	u64			sleep_start_fair;
+
+#ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
-	u64			exec_start;
+	u64			wait_max;
+	s64			sum_wait_runtime;
+
 	u64			sleep_start;
-	u64			sleep_start_fair;
-	u64			block_start;
 	u64			sleep_max;
+	s64			sum_sleep_runtime;
+
+	u64			block_start;
 	u64			block_max;
 	u64			exec_max;
-	u64			wait_max;
-	u64			last_ran;
 
-	u64			sum_exec_runtime;
-	s64			sum_wait_runtime;
-	s64			sum_sleep_runtime;
 	unsigned long		wait_runtime_overruns;
 	unsigned long		wait_runtime_underruns;
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct sched_entity	*parent;
 	/* rq on which this entity is (to be) queued: */
