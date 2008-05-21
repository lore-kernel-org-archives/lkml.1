Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbYEUL33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbYEUL33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbYEUL3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:29:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57951 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYEUL3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:29:16 -0400
Subject: Re: /proc/lock_stat "stuck"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <483402CE.9000706@hp.com>
References: <483313DD.2020904@hp.com>
	 <1211361380.6463.63.camel@lappy.programming.kicks-ass.net>
	 <483402CE.9000706@hp.com>
Content-Type: text/plain
Date: Wed, 21 May 2008 13:29:02 +0200
Message-Id: <1211369342.6463.93.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 07:09 -0400, Alan D. Brunelle wrote:
> Peter Zijlstra wrote:
> > On Tue, 2008-05-20 at 14:09 -0400, Alan D. Brunelle wrote:
> >> I'm attempting to use /proc/lock_stat to gather some information during
> >> some benchmarking runs, but what I find happens is as follows:
> >>
> >> 1. I boot the system - 2.6.26-rc3 kernel + CONFIG_LOCK_STAT=y
> >>
> >> 2. I can then look at /proc/lock_stat, and it has valid-looking values
> >>
> >> 3. I wait a while, do some stuff, but when I look at /proc/lock_stat
> >> again the values have not changed.
> >>
> >> 4. If I clear the counters - echo 0 > /proc/lock_stat - the counters
> >> never increase, and no information besides the headers are output when I
> >> cat /proc/lock_stat.
> >>
> >>
> >> Is there something that one needs to do to get counter updates?
> > 
> > Did you get lockdep warnings? Those disable all lock debugging,
> > including lockstat.
> 
> Hi Peter -
> 
> Yesterday, during boots I /was/ getting a problem with NVIDIA ck804xrom
> registration problems -  "Unable to register resource" - it did produce
> a stack trace w/ lock calls in the stack. Since then I've cut /way/ back
> on my .config, and I don't see that problem anymore, and the lock stats
> seem to be updating correctly with this new .config. [If I have time
> later today, I'll go back to the old .config and try to track down the
> ck804xrom issue.]
> 
> Thanks for the hint about watching for lockdep issues,
> Alan

You might like to 'test' these two patches :-)


Subject: lockstat: warn about disabled lock debugging
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Avoid confusion and clearly state lock debugging got disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep_proc.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -516,6 +516,10 @@ static void seq_stats(struct seq_file *m
 static void seq_header(struct seq_file *m)
 {
 	seq_printf(m, "lock_stat version 0.2\n");
+
+	if (unlikely(!debug_locks))
+		seq_printf(m, "*WARNING* lock debugging disabled!! - possibly due to a lockdep warning\n");
+
 	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
 	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
 			"%14s %14s\n",



Subject: lockstat: fix contention points
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

blatantly stupid bug..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2791,7 +2791,7 @@ found_it:
 
 	stats = get_lock_stats(hlock->class);
 	if (point < ARRAY_SIZE(stats->contention_point))
-		stats->contention_point[i]++;
+		stats->contention_point[point]++;
 	if (lock->cpu != smp_processor_id())
 		stats->bounces[bounce_contended + !!hlock->read]++;
 	put_lock_stats(stats);


