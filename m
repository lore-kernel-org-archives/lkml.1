Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbZHDSMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbZHDSMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbZHDSMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:12:25 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:49043 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010AbZHDSMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:12:24 -0400
Date: Tue, 4 Aug 2009 20:12:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Ingo Molnar <mingo@elte.hu>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] Virtual Machine Time Accounting
Message-ID: <20090804201220.4f71a4b0@skybase>
In-Reply-To: <1249407194.4762.28.camel@laptop>
References: <46C99371.7070705@bull.net>
	<1249395398.7924.223.camel@twins>
	<20090804170747.11801f0a@skybase>
	<1249403202.4762.12.camel@laptop>
	<20090804192924.217930fc@skybase>
	<1249407194.4762.28.camel@laptop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Aug 2009 19:33:14 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-08-04 at 19:29 +0200, Martin Schwidefsky wrote:
> 
> > > So its going to split user time into user and guest. Does that really
> > > make sense? For the host kernel it really is just another user process,
> > > no?
> > 
> > The code (at least in parts) is already upstream. Look at the
> > account_guest_time function:
> > 
> > static void account_guest_time(struct task_struct *p, cputime_t cputime,
> >                                cputime_t cputime_scaled)
> > {
> >         cputime64_t tmp;
> >         struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> > 
> >         tmp = cputime_to_cputime64(cputime);
> > 
> >         /* Add guest time to process. */
> >         p->utime = cputime_add(p->utime, cputime);
> >         p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
> >         account_group_user_time(p, cputime);
> >         p->gtime = cputime_add(p->gtime, cputime);
> > 
> >         /* Add guest time to cpustat. */
> >         cpustat->user = cputime64_add(cpustat->user, tmp);
> >         cpustat->guest = cputime64_add(cpustat->guest, tmp);
> > }
> > 
> > The cpu time for a guest is added to p->utime AND p->gtime. That is
> > done not to break existing tools that know nothing about guest time.
> > A guest time aware tool can subtract the p->gtime from p->utime to
> > get the time spent by the process outside of the guest context.
> 
> But why? How a vcpu anything other than yet another userspace process?

Because you have two different contexts where you spent time, the
"normal" process context and the "guest" process context. To know how
much of your cpu time is spent on virtualization overhead is an
interesting number.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

