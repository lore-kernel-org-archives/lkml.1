Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbYDVIvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbYDVIvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbYDVIvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:51:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:40658 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756834AbYDVIvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:51:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18L5fNeFVgLOVHU7b6C6JTLgJDoVLyeweO2g3nTGe
	Gw4Z0rWxj5CCdB
Subject: Re: [git pull] scheduler changes for v2.6.26
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080421194359.GD8770@elte.hu>
References: <20080419181304.GB21353@elte.hu>
	 <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu>
	 <200804211831.29976.elendil@planet.nl>  <20080421194359.GD8770@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 10:51:40 +0200
Message-Id: <1208854300.4695.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-21 at 21:43 +0200, Ingo Molnar wrote: 
> * Frans Pop <elendil@planet.nl> wrote:
> 
> > > It would be nice if you could try sched-devel/latest because it has 
> > > an improved ftrace "sched_switch" tracer where you can generate much 
> > > longer traces of this incident. Try the new /debug/trace_entries 
> > > runtime tunable.
> > 
> > I'll try to get the trace and will reply on the private thread we had. 
> > I may need additional instructions though.
> 
> you could also reply to this thread if you dont mind, so that others can 
> chime in too.
> 
> the 700-800 msecs of delays you see are very "brutal" so there must be 
> something fundamentally wrong going on here.

I'm seeing latency hits with 26.git, whereas 25 is hit free. 

   LatencyTOP version 0.3       (C) 2008 Intel Corporation

Cause                                                Maximum     Percentage
Scheduler: waiting for cpu                        436.0 msec         79.8 %
do_fork sys_vfork ptregscall_common                37.7 msec          1.5 %
blk_execute_rq scsi_execute scsi_execute_req sr_te 30.5 msec          0.2 %
blk_execute_rq scsi_execute scsi_execute_req sd_re 28.7 msec          0.6 %
msleep wakeup_rh uhci_rh_resume hcd_bus_resume gen 23.3 msec          0.3 %
blk_execute_rq scsi_execute scsi_execute_req scsi_ 23.0 msec          0.8 %
down tty_write vfs_write sys_write system_call_aft 21.9 msec          0.1 %
do_get_write_access journal_get_write_access __ext 21.8 msec          0.1 %
blk_execute_rq scsi_execute scsi_execute_req sr_te 16.5 msec          0.3 %
r_block_media_changed check_disk_change cdrom_open sr_block_open do_open




Process amarokapp (4645)
Scheduler: waiting for cpu                        436.0 msec         93.8 %
do_select core_sys_select sys_select system_call_a  4.8 msec          4.7 %
do_sys_poll sys_poll system_call_after_swapgs       4.7 msec          1.5 %

> 
> Could you first check (under sched-devel/latest) the quality of your 
> sched-clock, via running this script:
> 
>    http://people.redhat.com/mingo/cfs-scheduler/tools/watch-rq-clock.sh
> 
> if you run it, it should output ~1000 msecs periods every second:
> 
>  europe:~> watch-rq-clock.sh
>  1002.115042
>  1005.509851
>  1004.187275
>  1004.409980
>  1004.430264
>  1004.445508
> 
> if it's way too 'slow', say it only 100 msecs per second, then the 
> scheduler clock is mis-measuring time and what the scheduler thinks to 
> be a 40 msecs delay might become a 400 msecs delay.

Erm, should my Q6600 emit such?

2.6.25:
51.743501
124.292008
59.719506
268.016760
64.004011
144.113851
87.900658
116.007257
72.004509

On 26.git, I get numbers like yours, but with occasional dips down to
~700, though the latency hits don't _seem_ to be synchronous with
watch-rq-clock.sh glitchies.

	-Mike

