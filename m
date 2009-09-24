Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZIXSEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZIXSEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZIXSEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:04:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbZIXSEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:04:41 -0400
Subject: Re: [PATCH 1/2] itimers: fix racy writes to cpu_itimer fields
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090924195732.384bea26@dhcp-lab-109.englab.brq.redhat.com>
References: <1253802903-979-1-git-send-email-sgruszka@redhat.com>
	 <1253803687.18939.26.camel@laptop>
	 <20090924195732.384bea26@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 20:04:27 +0200
Message-Id: <1253815467.18939.168.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 19:57 +0200, Stanislaw Gruszka wrote:
> On Thu, 24 Sep 2009 16:48:07 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2009-09-24 at 16:35 +0200, Stanislaw Gruszka wrote:
> > > incr_error and error fields of struct cpu_itimer are used when calculating
> > > next timer tick in check_cpu_itimers() and should not be modified without
> > > tsk->sighand->siglock taken.
> > 
> > Won't it be all-round much better to convert these things to hrtimers
> > instead of adding more and more fuzz on top to make them deal with
> > jiffies?
> 
> Perhaps it would, but I don't know how to do it :{ . Especially how to
> precisely account user time. The only idea I have is make something like 
> microstate accounting (http://lwn.net/Articles/127296/), but this patch
> and whole idea was rejected long time ago. 

That patch does look a little painful indeed.

I was more thinking about about looking if an itimer was to expire less
than 1 tick away on either sched-in or the tick.

When we find it is indeed less than 1 tick away, program an hrtimer for
that cpu to expire at the required moment, see hrtick_start().

If we happen to de-schedule the task before the timer fires, we clear
the hrtimer again (or let it pend and ignore the fire), see
hrtick_clear().

[ there is no reason to rely on the tick though, we can program the
hrtimer on sched in to expire on at the right moment, and do so on each
schedule for as long as an itimer is active - re-setting whatever
pending timer the cpu still had. ]



