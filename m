Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZDKQY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZDKQY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZDKQYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:24:19 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54793 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755199AbZDKQYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:24:18 -0400
Date: Sat, 11 Apr 2009 11:24:16 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] Move calc_load call out from xtime_lock protection
Message-ID: <20090411162416.GC3496@sgi.com>
References: <20090410173437.GA23415@sgi.com> <alpine.LFD.2.00.0904110931240.21577@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904110931240.21577@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 11:51:36AM +0200, Thomas Gleixner wrote:
> On Fri, 10 Apr 2009, Dimitri Sivanich wrote:
> 
> > The xtime_lock is being held for long periods on larger systems due
> > to an extensive amount of time being spent in calc_load(),
> > specifically here:
> >   do_timer->update_times->calc_load->count_active_tasks->nr_active()
> > 
> > On a 64 cpu system I've seen this take approximately 55 usec.
> > Presumably it would be worse on larger systems.  This causes other
> > cpus to be held off in places such as
> > scheduler_tick->sched_clock_tick waiting for the xtime_lock to be
> > released.
> 
> I thought more about that. Why don't we move the calc_load() call into
> the timer softirq context and avoid fiddling with all the call sites ?
> Also moving calc_load out of the timer interrupt context reduces the
> interrupts off section as well.
> 
Sounds reasonable to me.
