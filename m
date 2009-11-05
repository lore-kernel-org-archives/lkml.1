Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZKEP3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZKEP3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 10:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZKEP3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 10:29:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZKEP3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:29:08 -0500
Date: Thu, 5 Nov 2009 16:22:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - lockdep whinge during early boot
Message-ID: <20091105152241.GA24690@redhat.com>
References: <6417.1257351084@turing-police.cc.vt.edu> <200911051941.03401.rusty@rustcorp.com.au> <20091105141055.GA17350@redhat.com> <alpine.LFD.2.00.0911051547110.12138@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911051547110.12138@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05, Thomas Gleixner wrote:
>
> On Thu, 5 Nov 2009, Oleg Nesterov wrote:
> > > Oleg (CC'd) made workqueues use cpu_maps_update_begin() instead of the
> > > more obvious get_online_cpus() in 3da1c84c00c7e5f.  Reverting that seems like
> > > a bad idea.
> >
> > Even if create_workueue() used get_online_cpus() instead of cpu_add_remove_lock,
> > we have the same problem: _cpu_up() takes cpu_hotplug.lock which is needed for
> > get_online_cpus(). The dependency above becomes:
> >
> > 	cpu_up()->clocksource_change_rating() takes clocksource_mutex under
> > 	cpu_hotplug.lock (cpu_hotplug_begin)
> >
> > 	clocksource_done_booting()->create_workueue() takes cpu_hotplug.lock
> > 	(get_online_cpus) under clocksource_mutex
>
> Hmm, we fixed all this lock madness in mainline already.
> clocksource_done_booting() does not longer call
> create_workqueue(). How got this code reverted in motm ?

I don't understand this code at all. But this is what I see
in Linus's tree:

	clocksource_done_booting
	    clocksource_select
	        timekeeping_notify
	            stop_machine
	                 stop_machine_create


OTOH, I don't see where native_cpu_up() path calls clocksource_change_rating(),
perhaps this was changed in -mm.

Oleg.

