Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbXETVHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbXETVHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbXETVGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:06:53 -0400
Received: from mail.screens.ru ([213.234.233.54]:48877 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570AbXETVGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:06:52 -0400
Date: Mon, 21 May 2007 01:06:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: Freezeable workqueues [Was: 2.6.22-rc1: Broken suspend on SMP with tifm]
Message-ID: <20070520210642.GA342@tv-sign.ru>
References: <200705132132.08546.rjw@sisk.pl> <200705152254.34402.rjw@sisk.pl> <20070520195417.GB83@tv-sign.ru> <200705202248.05857.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705202248.05857.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Rafael J. Wysocki wrote:
>
> On Sunday, 20 May 2007 21:54, Oleg Nesterov wrote:
> > 
> > I am a bit afraid of too many yes/no options for the freezer, a couple of naive
> > questions.
> > 
> > 1. Can't we make all wqs freezable? I still can't see the reason to have both
> >    freezable and not freezable wqs.
> 
> The reason might be the same as for having freezable and nonfreezable kernel
> threads in general.  For example, there are some kernel threads that we need
> for saving the image and I don't see why there shouldn't be any such
> workqueues.

OK, I see.

> > 2. Why do we need CPU_TASKS_FROZEN? Can't we change cpu-hotplug to always
> >    freeze tasks right now, without any additional changes?
> 
> In principle, we can, but for this purpose we'd have to modify all NOFREEZE
> tasks.

Why?

>        That wouldn't fly, I'm afraid.
> 
> >    Any subsystem should handle correctly the case when _cpu_down() (say)
> >    is called with tasks_frozen == 1 anyway. So, why can't we simplify
> >    things and do
> > 
> >    	_cpu_down(int tasks_frozen)
> > 
> >  		if (!tasks_frozen)
> >  			freeze_processes();
> >  		...
> > 
> >   right now?
> 
> But we call _cpu_down() after device_suspend(), so many tasks are already
> frozen at this point.  We'd only need to freeze those that are not frozen and
> in _cpu_up() we'd have to thaw them.

Not sure I understand. When we call _cpu_down() after device_suspend(), we
check tasks_frozen == 1, and do not call freeze_processes(). If the task
could be frozen, it is already frozen.

When _cpu_down() sees tasks_frozen = 0, it does freeze_processes() itself,
and thaw_tasks() on return.

IOW, we never send (say) CPU_DEAD, always CPU_DEAD_FROZEN.

Wouldn't fly?

Oleg.

