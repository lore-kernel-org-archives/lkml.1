Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZDFPZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZDFPZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZDFPZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:25:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZDFPZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:25:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: pm-hibernate : possible circular locking dependency detected
Date: Mon, 6 Apr 2009 17:25:12 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>, Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com> <200904061529.44780.rjw@sisk.pl> <20090406142452.GA17559@in.ibm.com>
In-Reply-To: <20090406142452.GA17559@in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061725.13606.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009, Gautham R Shenoy wrote:
> On Mon, Apr 06, 2009 at 03:29:43PM +0200, Rafael J. Wysocki wrote:
> > On Monday 06 April 2009, Gautham R Shenoy wrote:
> > > On Sun, Apr 05, 2009 at 03:44:54PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > 
> > > > > On Sunday 05 April 2009, Ming Lei wrote:
> > > > > > kernel version : one simple usb-serial patch against  commit
> > > > > > 6bb597507f9839b13498781e481f5458aea33620.
> > > > > > 
> > > > > > Thanks.
> > > > > 
> > > > > Hmm, CPU hotplug again, it seems.
> > > > > 
> > > > > I'm not sure who's the maintainer at the moment.  Andrew, is that 
> > > > > Gautham?
> > > > 
> > > > CPU hotplug tends to land on the scheduler people's desk normally.
> > > > 
> > > > But i'm not sure that's the real thing here - key appears to be this 
> > > > work_on_cpu() worklet by the cpufreq code:
> > > 
> > > Actually, there are two dependency chains here which can lead to a deadlock.
> > > The one we're seeing here is the longer of the two.
> > > 
> > > If the relevant locks are numbered as follows:
> > > [1]: cpu_policy_rwsem
> > > [2]: work_on_cpu
> > > [3]: cpu_hotplug.lock
> > > [4]: dpm_list_mtx
> > > 
> > > 
> > > The individual callpaths are:
> > > 
> > > 1) do_dbs_timer()[1] --> dbs_check_cpu() --> __cpufreq_driver_getavg()
> > >                                                                   |
> > >                       work_on_cpu()[2] <-- get_measured_perf() <--|
> > > 
> > > 
> > > 2) pci_device_probe() --> .. --> pci_call_probe() [3] --> work_on_cpu()[2]
> > >                                                                      |
> > >                   [4] device_pm_add() <-- ..<-- local_pci_probe() <--|
> > 
> > This should block on [4] held by hibernate().  That's why it calls
> > device_pm_lock() after all.
> 
> Agreed. But it does so holding the cpu_hotplug.lock at pci_call_probe().
> See below.
> 
> > 
> > > 3) hibernate() --> hibernatioin_snapshot() --> create_image()
> > >                                                           |
> > >        disable_nonboot_cpus() <-- [4] device_pm_lock() <--|
> > >        |
> > >        |--> _cpu_down() [3] --> cpufreq_cpu_callback() [1]
> > > 
> > > 
> > > The two chains which can deadlock are
> > > 
> > > a) [1] --> [2] --> [4] --> [3] --> [1] (The one in this log)
> > > and
> > > b) [3] --> [2] --> [4] --> [3]
> > 
> > What exactly is the b) scenario?
> 
> pci_call_probe() calls work_on_cpu() within
> get_online_cpus()/put_online_cpus(), the cpu hotplug read path.
> Thus we have a cpu_hotplug.lock --> work_on_cpu dependency here.
> 
> This work_on_cpu() calls local_pci_probe() which, in one of the
> registration paths calls pcie_portdrv_probe(). This would
> eventually end up calling device_pm_add() which takes the
> dpm_list_mtx. Thus we have a work_on_cpu --> dpm_list_mtx
> dependency here. This is reflected in the lockdep log for dpm_list_mtx:
> 
> > > [ 2276.033054] -> #3 (dpm_list_mtx){+.+.+.}:
> > > [ 2276.033057]        [<ffffffff80265579>]  __lock_acquire+0x1402/0x178c
> > > [ 2276.033061]        [<ffffffff80265996>] lock_acquire+0x93/0xbf
> > > [ 2276.033065]        [<ffffffff804763db>] mutex_lock_nested+0x6a/0x362
> > > [ 2276.033068]        [<ffffffff803c4339>] device_pm_add+0x46/0xed
> > > [ 2276.033073]        [<ffffffff803bdeee>] device_add+0x488/0x61a
> > > [ 2276.033077]        [<ffffffff803be099>] device_register+0x19/0x1d
> > > [ 2276.033080]        [<ffffffff8036031a>] pcie_port_device_register+0x450/0x4b6
> > > [ 2276.033085]        [<ffffffff80469999>] pcie_portdrv_probe+0x69/0x82
> > > [ 2276.033089]        [<ffffffff8035bf77>] local_pci_probe+0x12/0x16
> > > [ 2276.033093]        [<ffffffff8024fdf8>] do_work_for_cpu+0x13/0x1b
> > > [ 2276.033097]        [<ffffffff80250038>] worker_thread+0x1b2/0x2c9
> > > [ 2276.033100]        [<ffffffff80253d40>] kthread+0x49/0x76
> > > [ 2276.033104]        [<ffffffff8020c1fa>] child_rip+0xa/0x20
> > > [ 2276.033107]        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> The dependency chain on this device_registration path would be
> cpu_hotplug.lock --> work_on_cpu --> dpm_list_mtx.
> 
> On the hibernate path, we hold the dpm_list_mtx and call
> disable_nonboot_cpus() in create_image().
> disable_nonboot_cpus() calls _cpu_down() which again takes the
> cpu_hotplug.lock, this time the write-path. Thus we have a
> dpm_list_mtx --> cpu_hotplug.lock dependency here.
> 
> These two dependency chains being in reverse order can cause a
> dead-lock, right ? Or am I reading something wrong here?

Please read the Alan Stern's reply to my message.

In short, the two code paths that cause the lockdep violation to happen
cannot run siumltaneously, because the prepare() stage of hibernation blocks
device probing altogether.  So, this is a lockdep violation, but not a deadlock
scenario.

Thanks,
Rafael
