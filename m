Return-Path: <linux-kernel-owner+w=401wt.eu-S1762524AbXK2QHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762524AbXK2QHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbXK2QHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:07:38 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36469 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756632AbXK2QHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:07:37 -0500
To: mingo@elte.hu
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <20071129105744.GI10577@elte.hu> (message from Ingo Molnar on
	Thu, 29 Nov 2007 11:57:44 +0100)
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu> <20071129105744.GI10577@elte.hu>
Message-Id: <E1Ixlv9-0001rb-U7@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Nov 2007 17:07:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I can't say I'm understading these traces very well, but here's a 
> > snippet that looks a bit strange.  I'm running 'while true; do date; 
> > done' in parallel with the dd.
> > 
> > For some time it is doing 100% CPU as expected, then it goes into a 
> > second or so of mosty idle (afaics), and then returns to the normal 
> > pattern again.
> 
> try:
> 
>   echo 1 > /proc/sys/kernel/stackframe_tracing
> 
> to get symbolic stack backdumps for the wakeup points, and add 
> trace_special_sym() calls to generate extra stackdump entries at 
> arbitrary places. schedule() does not have it right now - it might make 
> sense to add it.

OK, this helped.

It looks like the delays are caused by the page allocator, and not
UML.  Which is good news, because I'm supposed to understand memory
management better than scheduling.

Thanks,
Miklos



    bash-504   0.... 6312803us!: schedule <kswapd0-33> (-5 0)
    bash-504   0.... 6313820us : userspace()<-fork_handler()<-<2f0a3670>()<-(    0)()
    bash-504   0.... 6313821us+: (    0)()<-(    0)()<-(    0)()<-(    0)()
    date-5726  0.... 6315334us+: pipe_read()<-do_sync_read()<-vfs_read()<-sys_read()
    date-5726  0.... 6315336us : handle_syscall()<-handle_trap()<-userspace()<-fork_handler()
    bash-504   0.... 6315340us!: schedule <date-5726> (0 0)
    bash-504   0.... 6315731us+: io_schedule_timeout()<-congestion_wait()<-throttle_vm_writeout()<-shrink_zone()
    bash-504   0.... 6315733us : shrink_zones()<-try_to_free_pages()<-__alloc_pages()<-do_wp_page()
  <idle>-0     0.... 6315738us!: schedule <bash-504> (0 20)
  <idle>-0     0.Nh. 6476223us+: __trace_start_sched_wakeup <bash-504> (120 -1)
  <idle>-0     0.Nh. 6476228us+: __trace_start_sched_wakeup <kswapd0-33> (115 -1)
  <idle>-0     0.Nh. 6476232us+: __trace_start_sched_wakeup <dd-5155> (120 -1)
  <idle>-0     0.... 6476256us+: cpu_idle()<-rest_init()<-start_kernel()<-start_kernel_proc()
