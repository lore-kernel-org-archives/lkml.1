Return-Path: <linux-kernel-owner+w=401wt.eu-S968068AbXEHOUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968068AbXEHOUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967868AbXEHOUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:20:31 -0400
Received: from mail.screens.ru ([213.234.233.54]:40892 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967377AbXEHOUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:20:30 -0400
Date: Tue, 8 May 2007 18:20:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-mm1 hwsusp: BUG at workqueue.c:106
Message-ID: <20070508142025.GB1105@tv-sign.ru>
References: <46403B7F.1050009@gmail.com> <20070508021131.438cee31.akpm@linux-foundation.org> <20070508105528.GA86@tv-sign.ru> <46405A67.8020105@gmail.com> <46406656.9060504@gmail.com> <20070508134815.GA1074@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508134815.GA1074@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Oleg Nesterov wrote:
>
> On 05/08, Jiri Slaby wrote:
> >
> > vmstat_update+0x0/0x2b
> 
> Thanks a lot.
> 
> Right now,
> 
> > +static void vmstat_update(struct work_struct *w)
> > +{
> > +       refresh_cpu_vm_stats(smp_processor_id());
> > +       schedule_delayed_work(&__get_cpu_var(vmstat_work),
> > +               sysctl_stat_interval);
> > +}
> 
> This is not precisely correct. We cam schedule the wrong vmstat_work
> if this timer/work migrates to another CPU. I'd suggest
> 
> 	schedule_delayed_work(container_of(w, struct delayed_work, work))
> 
> This should not happen because we are doing cancel_rearming_delayed_work()
> below, however:
> 
> > +       case CPU_DOWN_PREPARE:
> > +       case CPU_DOWN_PREPARE_FROZEN:
> > +               cancel_rearming_delayed_work(&per_cpu(vmstat_work, cpu));
> > +               per_cpu(vmstat_work, cpu).work.func = NULL;
> > +       case CPU_DOWN_FAILED:
> > +       case CPU_DOWN_FAILED_FROZEN:
> > +               start_cpu_timer(cpu);
> 
> we need a "break;" before "case CPU_DOWN_FAILED", otherwise we re-start
> vmstat_update() immediately.
> 
> This is a bug, but I am not sure is this the only problem.

In case I was not clear, this _can_ explain the problem. Because an extra
start_cpu_timer() (due to missed "break;") re-initializes dwork, and clears
_PENDING.

Oleg.

