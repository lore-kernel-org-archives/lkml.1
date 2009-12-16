Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbZLPEwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbZLPEwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 23:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbZLPEwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 23:52:50 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50849 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbZLPEwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 23:52:49 -0500
Date: Wed, 16 Dec 2009 13:52:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20091216045245.GC31265@linux-sh.org>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org> <20090624142828.7c6a2337@skybase> <20090624123416.GB9510@linux-sh.org> <20090624145406.7f0f579b@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624145406.7f0f579b@skybase>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Wed, Jun 24, 2009 at 02:54:06PM +0200, Martin Schwidefsky wrote:
> On Wed, 24 Jun 2009 21:34:16 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> > On Wed, Jun 24, 2009 at 02:28:28PM +0200, Martin Schwidefsky wrote:
> > > On Wed, 24 Jun 2009 20:29:29 +0900
> > > Paul Mundt <lethal@linux-sh.org> wrote:
> > > > No. oprofile_timer_init() is only entered if the performance counters
> > > > fail to register in the SH7750 case, so there is only one timer hook user
> > > > at a time:
> > > > 
> > > > static int __init oprofile_init(void)
> > > > {
> > > >         int err;
> > > > 
> > > >         err = oprofile_arch_init(&oprofile_ops);
> > > > 
> > > >         if (err < 0 || timer) {
> > > >                 printk(KERN_INFO "oprofile: using timer interrupt.\n");
> > > >                 oprofile_timer_init(&oprofile_ops);
> > > >         }
> > > > ...
> > > 
> > > Oh, I see. That is the reason why the s390 version of
> > > oprofile_arch_init returns -ENODEV. It does so to trigger the fallback
> > > to the timer_hook. That should work for sh as well, no?
> > > 
> > It would, yes, but it would also disable access to the SH7750 counters at
> > the same time, so we don't really want to do that. The sh7750 counters
> > are more like timer based profiling with some extra events that can be
> > set and read, so reverting to oprofile_timer_init() would reduce
> > functionality.
> > 
> > My current plan is to migrate things over to the perf_counter API and
> > annoy Ingo with my interrupt deprived counters ;-)
> > 
> > Given that hrtimers are already generically supported there, it should
> > tie in much cleaner there than in the oprofile case at least.
> 
> Ok, that makes sense. So I guess for now I should stop trying to get
> rid of the timer_hook and concentrate to convert the fallback code
> in timer_int.c to hrtimer. Then after sh is fully converted to the
> perf_counter API we can do the cleanup.
> 

This is just a follow-up to let you know that the first-step transition
to the perf_counter API is done. There's still more work to do, but we're
already more functional on the perf_counter side than we ever were on
oprofile. As such, I've subsequently killed off the bitrotted oprofile
bits, which includes the timer hook references.

There is now nothing remaining on the SH side blocking the timer hook
removal.
