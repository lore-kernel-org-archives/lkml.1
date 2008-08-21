Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYHUR7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYHUR7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbYHUR7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:59:21 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48552 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbYHUR7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:59:20 -0400
Date: Thu, 21 Aug 2008 22:03:43 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Max Krasnyanskiy <maxk@qualcomm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Message-ID: <20080821180343.GA14139@tv-sign.ru>
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com> <b647ffbd0808211038h686f9df3ud335efbc46242952@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0808211038h686f9df3ud335efbc46242952@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Dmitry Adamushko wrote:
> 
> however, I think there are 2 problems with handle_poweroff()
> [ kernel/power/poweroff.c ]
> 
> (1) it doesn't ensure that the 'cpu' it gets via
> first_cpu(cpu_online_map) can't disappear (race with cpu_down()) on
> the way to schedule_work_on()
> 
> [ I pressume, neither generic sysrq nor console layer takes care of
> it. They shoudn't of course ]
> 
> (2) run_workqueue() [ which in the end calls do_poweroff() ] takes the
> "cwq->lock" (which is lock-2 in our terminology)
> 
> well, actually it release it before calling "work->fun()" but is the
> 'lockdep' annotation right here? Peter?
> 
> (I admit, I never looked at lockdep and do make assumptions on its syntax here).
> 
> The lock-1 will be taken as a result of
> 
> then, do_poweroff() -> kernel_power_off() -> disable_nonboot_cpus()
> 
> which calls cpu_maps_update_begin() and takes "cpu_add_remove_lock"
> 
> and this looks dangerous. Due to the same reason as was before with
> the use of get_online_cpus() by workqueue handlers before
> CPU_POST_DEAD introduction
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3da1c84c00c7e5fa8348336bd8c342f9128b0f14)
> 
> I guess, it may deadlock as the lock-1 has been already taken before
> calling cleanup_workqueue_thread() -> flush_cpu_workqueue() and
> completion of the former chain depends in turn on being able to
> acquire the very same lock.

I apologize in advance if I missed something else in your message,
but I think you are very right. Please look at

	http://marc.info/?t=121580236300019

Oleg.

