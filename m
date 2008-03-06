Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbYCFXNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbYCFXNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 18:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbYCFXNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 18:13:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:4877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbYCFXNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 18:13:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,458,1199692800"; 
   d="scan'208";a="261206819"
Date: Thu, 6 Mar 2008 15:13:31 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, g.liakhovetski@gmx.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       bunk@kernel.org, gregkh@suse.de
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-ID: <20080306231331.GJ28006@linux-os.sc.intel.com>
References: <200803030316.07165.rjw@sisk.pl> <20080306072704.GA28518@elte.hu> <Pine.LNX.4.64.0803062054110.8669@axis700.grange> <20080306121127.42ac0682.akpm@linux-foundation.org> <20080306125153.d95db2b9.akpm@linux-foundation.org> <20080306205951.GA23989@elte.hu> <20080306133632.34d77bbc.akpm@linux-foundation.org> <20080306145739.817dea8e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306145739.817dea8e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 02:57:39PM -0800, Andrew Morton wrote:
> On Thu, 6 Mar 2008 13:36:32 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 6 Mar 2008 21:59:51 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > I'd love to poke around in kgdb (what does kthread_stop_info.k point 
> > > > at?) but it seems that -mm's copy of kgdb got taken away when I wasn't 
> > > > looking. Can I have it back please?
> > > 
> > > it's in the full x86.git or you can pick up the kgdb-light tree:
> > > 
> > >   http://people.redhat.com/mingo/kgdb-light.git/README
> > > 
> > 
> > We'll see.
> > 
> > Meanwhile, further investigation show that cpu_callback() (the one in
> > kernel/softlockup.c) is waiting on this thread:
> > 
> > watchdog/1    R  running task        0     8      2 task_struct:ffff81025f1089e0
> 
> Note the "/1".
> 
> >  ffff81025f10deb0 0000000000000046 0000000000000000 0000000000000246
> >  ffff81025f10de20 ffff81025f1089e0 ffff81025f1080c0 ffff81025f108d30
> >  000000015f10de50 00000000ffff2adf ffffffffffffffff ffffffffffffffff
> > Call Trace:
> >  [<ffffffff80263290>] ? watchdog+0x0/0x1dc
> >  [<ffffffff802632d6>] watchdog+0x46/0x1dc
> >  [<ffffffff80263290>] ? watchdog+0x0/0x1dc
> >  [<ffffffff8024704d>] kthread+0x44/0x6b
> >  [<ffffffff8020cd88>] child_rip+0xa/0x12
> >  [<ffffffff80247009>] ? kthread+0x0/0x6b
> >  [<ffffffff8020cd7e>] ? child_rip+0x0/0x12
> > 
> > kthread_stop_info.k=ffff81025f1089e0
> > 
> > (gdb) l *0xffffffff802632d6
> > 0xffffffff802632d6 is in watchdog (kernel/softlockup.c:229).
> > 224              */
> > 225             while (!kthread_should_stop()) {
> > 226                     touch_softlockup_watchdog();
> > 227                     schedule();
> > 228     
> > 229                     if (kthread_should_stop())
> > 230                             break;
> > 231     
> > 232                     if (this_cpu == check_cpu) {
> > 233                             if (sysctl_hung_task_timeout_secs)
> > 
> > so this watchdog thread seems to be runnable, but not running.  What would
> > cause this?  
> 
> At the start of the sysrq-T trace we have:
> 
> sd 1:0:0:0: [sdb] Stopping disk
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Stopping disk
> ACPI: PCI interrupt for device 0000:05:00.1 disabled
> ACPI: PCI interrupt for device 0000:05:00.0 disabled
> ACPI: Preparing to enter system sleep state S5
> Disabling non-boot CPUs ...
> CPU 1 is now offline
> SysRq : Show State
>   task                        PC stack   pid father

I have been looking into a similar issue, which stops my system going into
standy.

> 
> So CPU 1 is offline.  But the comatose watchdog thread is pinned to CPU 1. 
> Could this be related to the problem?  By what means is a task which is
> pinned to a going-away CPU handled?  How is this guy supposed to ever run
> again?

move_task_off_dead_cpu() should move that thread to another online cpu. But
for some reason it isn't running.

thanks,
suresh
