Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbXLNIaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbXLNIaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXLNIaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:30:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:63849 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbXLNIaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:30:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,165,1196668800"; 
   d="scan'208";a="238018937"
Subject: Re: [PATCH]Avoid the overflow when calculate the proportion of bdi
	quota
From: zhejiang <zhe.jiang@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
In-Reply-To: <1197582871.3430.1.camel@lappy>
References: <1197516632.18076.5.camel@localhost.localdomain>
	 <1197582871.3430.1.camel@lappy>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 16:26:43 +0800
Message-Id: <1197620803.22733.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 22:54 +0100, Peter Zijlstra wrote:
> On Thu, 2007-12-13 at 11:30 +0800, zhejiang wrote:
> > __percpu_counter_add() cache the result in percpu variable until it
> > exceeds the batch.
> > The prop_norm_percpu() use the percpu_counter_read(&pl->events) to read
> > the counter ,and use percpu_counter_add(&pl->events, -half) to half the
> > counter.
> > 
> > There are potential problems:
> > 1.The counter may be negative 
> > 2.After some calculation, it may be converted to a big positive number.
> > 
> > 1.
> > For example, the batch is 32, when the bdi add 32 to the pl->events,
> > the pl->events->count will be 32.Suppose one of the percpu counter is 1.
> > 
> > In the prop_norm_percpu(),the half will be 16.Because it is under the
> > batch, the pl->events->count won't be modified and one of the percpu
> > counter may be -15. If call the prop_norm_percpu() again, the half will
> > still be 16,though it should be 8.The percpu counter may be -31.
> > Now, there pl->events->count is still 32.
> > If do the third calculation, the percpu counter will be -47, it will
> > be merged into the pl->evnets->count.Then pl->events->count will be
> > negative.
> > 
> > 2.When the pl->events->count is negative,
> > unsigned long val = percpu_counter_read(&pl->events);
> > This statement may return a negative number, so the val would be a big
> > number.Because of the overflow, the pl->events->count will be converted
> > into a big positive number after some calculation.
> > 
> > Because of the overflow, I catch some very big numerators when call the
> > prop_fraction_percpu().
> > 
> > I think that it should use percpu_counter_sum() instead of the
> > percpu_counter_read() to be more robust.
> > 
> > diff -Nur a/proportions.c b/proportions.c
> > --- a/proportions.c     2007-12-12 11:05:59.000000000 +0800
> > +++ b/proportions.c     2007-12-13 11:05:40.000000000 +0800
> > @@ -241,7 +241,7 @@
> >          * can never result in a negative number.
> >          */
> >         while (pl->period != global_period) {
> > -               unsigned long val = percpu_counter_read(&pl->events);
> > +               unsigned long val = percpu_counter_sum(&pl->events);
> >                 unsigned long half = (val + 1) >> 1;
> >  
> >                 /*
> > 
> 
> _sum is unacceptably slow here. I'm thinking something like
> bdi_stat_error() as used in balance_dirty_pages() would also solve this
> issue, no?

_sum is slow, but it can avoid over-subtraction when the counter is less
than 2 * BDI_STAT_BATCH.

How about do the calculation like this patch?

Change the val and half into long type, if we found the val is negative,
it means that we did subtraction too much.
So we actually add some value to it.

diff -Nur a/proportions.c b/proportions.c
--- a/proportions.c     2007-12-12 11:05:59.000000000 +0800
+++ b/proportions.c     2007-12-14 16:21:08.000000000 +0800
@@ -241,8 +241,18 @@
         * can never result in a negative number.
         */
        while (pl->period != global_period) {
-               unsigned long val = percpu_counter_read(&pl->events);
-               unsigned long half = (val + 1) >> 1;
+               long val = percpu_counter_read(&pl->events);
+               long half;
+
+               if (val >= 0) {
+                       half = (val + 1) >> 1;
+               } else {
+                       /*
+                        *If val is negative, the counter has been
subtracted too much.
+                        *Do some compensation here.
+                        */
+                       half = (val - 1) / 2;
+               }
 
                /*
                 * Half of zero won't be much less, break out.


