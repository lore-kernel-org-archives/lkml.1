Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZDFNaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZDFNaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbZDFN3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:29:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47225 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbZDFN3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:29:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: pm-hibernate : possible circular locking dependency detected
Date: Mon, 6 Apr 2009 15:29:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>, Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com> <20090405134454.GB25250@elte.hu> <20090406005515.GA28200@in.ibm.com>
In-Reply-To: <20090406005515.GA28200@in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061529.44780.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009, Gautham R Shenoy wrote:
> On Sun, Apr 05, 2009 at 03:44:54PM +0200, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Sunday 05 April 2009, Ming Lei wrote:
> > > > kernel version : one simple usb-serial patch against  commit
> > > > 6bb597507f9839b13498781e481f5458aea33620.
> > > > 
> > > > Thanks.
> > > 
> > > Hmm, CPU hotplug again, it seems.
> > > 
> > > I'm not sure who's the maintainer at the moment.  Andrew, is that 
> > > Gautham?
> > 
> > CPU hotplug tends to land on the scheduler people's desk normally.
> > 
> > But i'm not sure that's the real thing here - key appears to be this 
> > work_on_cpu() worklet by the cpufreq code:
> 
> Actually, there are two dependency chains here which can lead to a deadlock.
> The one we're seeing here is the longer of the two.
> 
> If the relevant locks are numbered as follows:
> [1]: cpu_policy_rwsem
> [2]: work_on_cpu
> [3]: cpu_hotplug.lock
> [4]: dpm_list_mtx
> 
> 
> The individual callpaths are:
> 
> 1) do_dbs_timer()[1] --> dbs_check_cpu() --> __cpufreq_driver_getavg()
>                                                                   |
>                       work_on_cpu()[2] <-- get_measured_perf() <--|
> 
> 
> 2) pci_device_probe() --> .. --> pci_call_probe() [3] --> work_on_cpu()[2]
>                                                                      |
>                   [4] device_pm_add() <-- ..<-- local_pci_probe() <--|

This should block on [4] held by hibernate().  That's why it calls
device_pm_lock() after all.

> 3) hibernate() --> hibernatioin_snapshot() --> create_image()
>                                                           |
>        disable_nonboot_cpus() <-- [4] device_pm_lock() <--|
>        |
>        |--> _cpu_down() [3] --> cpufreq_cpu_callback() [1]
> 
> 
> The two chains which can deadlock are
> 
> a) [1] --> [2] --> [4] --> [3] --> [1] (The one in this log)
> and
> b) [3] --> [2] --> [4] --> [3]

What exactly is the b) scenario?

> Ingo,
> do_dbs_timer() function of the ondemand governor is run from a per-cpu
> workqueue. Hence it is already running on the cpu whose perf counters
> we're interested in.
> 
> Does it make sense to introduce a get_this_measured_perf() API
> for users who are already running on the relevant CPU ?
> And have get_measured_perf(cpu) for other users (currently there are
> none) ?
> 
> Thus, do_dbs_timer() can avoid calling work_on_cpu() thereby preventing
> deadlock a) from occuring.
> 
> Rafael,
> Sorry, I am not well versed with the hibernation code. But does the
> following make sense:

Not really ->

> create_image()
> {
> 	device_pm_lock();
> 	 device_power_down(PMSG_FREEZE);
> 	 platform_pre_snapshot(platform_mode);
> 
>         device_pm_unlock();

-> because dpm_list is under control of the hibernation code at this point
and it should remain locked.

> 	disable_nonboot_cpus()

disable_nonboot_cpus() must not take dpm_list_mtx itself.

> 	device_pm_lock();
> 	.
> 	.
> 	.
> 	.
> }

Thanks,
Rafael
