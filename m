Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbXGYJYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbXGYJYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXGYJYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:24:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59837 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687AbXGYJYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:24:05 -0400
Date: Wed, 25 Jul 2007 11:23:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070725092342.GA29814@elte.hu>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070725014912.35c7e325.akpm@linux-foundation.org> <20070725085204.GA22067@elte.hu> <20070725020003.63144fd6.akpm@linux-foundation.org> <20070725090439.GA26286@elte.hu> <20070725021730.a9a624b3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725021730.a9a624b3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> >   * 2^30ns == 1.074s.
> >   */
> > -static unsigned long get_timestamp(void)
> > +static unsigned long get_timestamp(int this_cpu)
> >  {
> > -	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
> > +	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
> >  }
> >  
> >  void touch_softlockup_watchdog(void)
> >  {
> > -	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
> > +	int this_cpu = raw_smp_processor_id();
> > +
> > +	per_cpu(touch_timestamp, this_cpu) = get_timestamp(this_cpu);
> >  }
> >  EXPORT_SYMBOL(touch_softlockup_watchdog);
> >  
> > @@ -95,7 +97,7 @@ void softlockup_tick(void)
> >  		return;
> 
> argh.  afacit this was never sent, except as part of some jumbopatch 
> called "sched: implement cpu_clock(cpu) high-speed time source".
> 
> That patch helped.
> 
> It's all a plot.

sorry, it's really my fault: i decoupled it from the jumbopatch (so that 
the new API could go in first) but forgot to re-send that crutial bit. 
There's also the patch below (Jens Cc:-ed) to update blktrace. I guess i 
should do a softlockup.git tree to avoid such foul-ups in the future.

	Ingo

----------------------->
Subject: blktrace: use cpu_clock() instead of sched_clock()
From: Ingo Molnar <mingo@elte.hu>

use cpu_clock() instead of sched_clock(). (the latter is not a proper
clock-source)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 block/blktrace.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux/block/blktrace.c
===================================================================
--- linux.orig/block/blktrace.c
+++ linux/block/blktrace.c
@@ -41,7 +41,7 @@ static void trace_note(struct blk_trace 
 		const int cpu = smp_processor_id();
 
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
-		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
+		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
 		t->device = bt->dev;
 		t->action = action;
 		t->pid = pid;
@@ -159,7 +159,7 @@ void __blk_add_trace(struct blk_trace *b
 
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
 		t->sequence = ++(*sequence);
-		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
+		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
 		t->sector = sector;
 		t->bytes = bytes;
 		t->action = what;
@@ -488,17 +488,17 @@ void blk_trace_shutdown(request_queue_t 
 }
 
 /*
- * Average offset over two calls to sched_clock() with a gettimeofday()
+ * Average offset over two calls to cpu_clock() with a gettimeofday()
  * in the middle
  */
-static void blk_check_time(unsigned long long *t)
+static void blk_check_time(unsigned long long *t, int this_cpu)
 {
 	unsigned long long a, b;
 	struct timeval tv;
 
-	a = sched_clock();
+	a = cpu_clock(this_cpu);
 	do_gettimeofday(&tv);
-	b = sched_clock();
+	b = cpu_clock(this_cpu);
 
 	*t = tv.tv_sec * 1000000000 + tv.tv_usec * 1000;
 	*t -= (a + b) / 2;
@@ -510,16 +510,16 @@ static void blk_check_time(unsigned long
 static void blk_trace_check_cpu_time(void *data)
 {
 	unsigned long long *t;
-	int cpu = get_cpu();
+	int this_cpu = get_cpu();
 
-	t = &per_cpu(blk_trace_cpu_offset, cpu);
+	t = &per_cpu(blk_trace_cpu_offset, this_cpu);
 
 	/*
 	 * Just call it twice, hopefully the second call will be cache hot
 	 * and a little more precise
 	 */
-	blk_check_time(t);
-	blk_check_time(t);
+	blk_check_time(t, this_cpu);
+	blk_check_time(t, this_cpu);
 
 	put_cpu();
 }
