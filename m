Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZKEOQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZKEOQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbZKEOQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:16:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918AbZKEOQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:16:51 -0500
Date: Thu, 5 Nov 2009 15:10:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - lockdep whinge during early boot
Message-ID: <20091105141055.GA17350@redhat.com>
References: <6417.1257351084@turing-police.cc.vt.edu> <200911051941.03401.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911051941.03401.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05, Rusty Russell wrote:
>
> On Thu, 5 Nov 2009 02:41:24 am Valdis.Kletnieks@vt.edu wrote:
>  [    0.344147] swapper/1 is trying to acquire lock:
> > [    0.344154]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103c222>] cpu_maps_update_begin+0x12/0x14
> > [    0.344174]
> > [    0.344175] but task is already holding lock:
> > [    0.344183]  (setup_lock){+.+.+.}, at: [<ffffffff81078755>] stop_machine_create+0x12/0x9b
> > [    0.344200]
> > [    0.344201] which lock already depends on the new lock.
>
> Hi Vladis!
>
>     Sigh.  I always find reading these a complete mindfuck.
>
> stop_machine_create: setup_lock then cpu_add_remove_lock
> 	(in create_workqueue_key() -> cpu_maps_update_begin())
> clocksource_done_booting: clocksource_mutex then setup_lock
> 	(in stop_machine_create(), as above)
> cpu_up: cpu_add_remove_lock then clocksource_mutex
> 	(in mark_tsc_unstable() -> clocksource_change_rating())
>
> AFAICT this is our circular dependency.  But I'm no closer to knowing how to
> solve it.

Not sure I understand this correctly, but afaics this dependency is
even simpler:

	cpu_up()->clocksource_change_rating() path takes clocksource_mutex
	under CPU hotplug locks.

	clocksource_done_booting()->create_workueue() path takes CPU hotplug
	locks under clocksource_mutex.

> Oleg (CC'd) made workqueues use cpu_maps_update_begin() instead of the
> more obvious get_online_cpus() in 3da1c84c00c7e5f.  Reverting that seems like
> a bad idea.

Even if create_workueue() used get_online_cpus() instead of cpu_add_remove_lock,
we have the same problem: _cpu_up() takes cpu_hotplug.lock which is needed for
get_online_cpus(). The dependency above becomes:

	cpu_up()->clocksource_change_rating() takes clocksource_mutex under
	cpu_hotplug.lock (cpu_hotplug_begin)

	clocksource_done_booting()->create_workueue() takes cpu_hotplug.lock
	(get_online_cpus) under clocksource_mutex

Oleg.

