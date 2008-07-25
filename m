Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYGYNjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYGYNjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYGYNji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:39:38 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:42727 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbYGYNji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:39:38 -0400
X-SourceIP: 62.163.52.83
Subject: Re: [patch, rfc: 2/2] sched, hotplug: ensure a task is on the
	valid cpu after set_cpus_allowed_ptr()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0807250620k2e7caa47pa81388c808d9eda7@mail.gmail.com>
References: <1216937730.5368.16.camel@earth>
	 <1216989649.7257.381.camel@twins>
	 <b647ffbd0807250620k2e7caa47pa81388c808d9eda7@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 15:39:44 +0200
Message-Id: <1216993184.7257.388.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 15:20 +0200, Dmitry Adamushko wrote:
> 2008/7/25 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Fri, 2008-07-25 at 00:15 +0200, Dmitry Adamushko wrote:
> >>
> >> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> >> Subject: sched, hotplug: ensure a task is on the valid cpu after
> >> set_cpus_allowed_ptr()
> >>
> >> ---
> >>     sched, hotplug: ensure a task is on the valid cpu after set_cpus_allowed_ptr()
> >>
> >>     The 'new_mask' may not include task_cpu(p) so we migrate 'p' on another 'cpu'.
> >>     In case it can't be placed on this 'cpu' immediately, we submit a request
> >>     to the migration thread and wait for its completion.
> >>
> >>     Now, by the moment this request gets handled by the migration_thread,
> >>     'cpu' may well be offline/non-active. As a result, 'p' continues
> >>     running on its old cpu which is not in the 'new_mask'.
> >>
> >>     Fix it: ensure 'p' ends up on a valid cpu.
> >>
> >>     Theoreticaly (but unlikely), we may get an endless loop if someone cpu_down()'s
> >>     a new cpu we have choosen on each iteration.
> >>
> >>     Alternatively, we may introduce a special type of request to migration_thread,
> >>     namely "move_to_any_allowed_cpu" (e.g. by specifying dest_cpu == -1).
> >>
> >>     Note, any_active_cpu() instead of any_online_cpu() would be better here.
> >
> > Hrmm,.. this is all growing into something of a mess.. defeating the
> > whole purpose of introducing that cpu_active_map stuff.
> >
> > Would the suggested SRCU logic simplify all this?
> 
> Ah, wait a second.
> 
> sched_setaffinity() -> set_cpus_allowed_ptr() is ok vs. cpu_down() as
> it does use get_online_cpus(). So none of the cpus can become offline
> while we are in set_cpus_allowed_ptr().
> 
> but there are numerous calls to set_cpus_allowed_ptr() from other
> places and not all of them seem to call get_online_cpus()...
> 
> yeah, I should check this issue again..
> 
> btw., indeed all these different sync. cases are a bit of mess.

Will ponder it a bit more, but my brain can't seem to let go of SRCU
now.. I'll go concentrate on making the swap-over-nfs patches prettier,
maybe that will induce a brainwave ;-)

> ---
> 
> btw., I was wondering about this change:
> 
> ba42059fbd0aa1ac91b582412b5fedb1258f241f
> 
> sched: hrtick_enabled() should use cpu_active()
> 
> Peter pointed out that hrtick_enabled() should use cpu_active().

What exactly were you wondering about?

It seemed a good idea to stop starting hrtimers before we migrate them
to another cpu (one of the things done later in cpu_down), thereby
avoiding spurious fires on remote cpus.

