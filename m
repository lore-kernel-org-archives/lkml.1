Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZDFA4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZDFA4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 20:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZDFA4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 20:56:04 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:47146 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZDFA4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 20:56:02 -0400
Date: Mon, 6 Apr 2009 06:25:15 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>, Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: pm-hibernate : possible circular locking dependency detected
Message-ID: <20090406005515.GA28200@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com> <200904051212.53353.rjw@sisk.pl> <20090405134454.GB25250@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090405134454.GB25250@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 03:44:54PM +0200, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Sunday 05 April 2009, Ming Lei wrote:
> > > kernel version : one simple usb-serial patch against  commit
> > > 6bb597507f9839b13498781e481f5458aea33620.
> > > 
> > > Thanks.
> > 
> > Hmm, CPU hotplug again, it seems.
> > 
> > I'm not sure who's the maintainer at the moment.  Andrew, is that 
> > Gautham?
> 
> CPU hotplug tends to land on the scheduler people's desk normally.
> 
> But i'm not sure that's the real thing here - key appears to be this 
> work_on_cpu() worklet by the cpufreq code:

Actually, there are two dependency chains here which can lead to a deadlock.
The one we're seeing here is the longer of the two.

If the relevant locks are numbered as follows:
[1]: cpu_policy_rwsem
[2]: work_on_cpu
[3]: cpu_hotplug.lock
[4]: dpm_list_mtx


The individual callpaths are:

1) do_dbs_timer()[1] --> dbs_check_cpu() --> __cpufreq_driver_getavg()
                                                                  |
                      work_on_cpu()[2] <-- get_measured_perf() <--|


2) pci_device_probe() --> .. --> pci_call_probe() [3] --> work_on_cpu()[2]
                                                                     |
                  [4] device_pm_add() <-- ..<-- local_pci_probe() <--|



3) hibernate() --> hibernatioin_snapshot() --> create_image()
                                                          |
       disable_nonboot_cpus() <-- [4] device_pm_lock() <--|
       |
       |--> _cpu_down() [3] --> cpufreq_cpu_callback() [1]


The two chains which can deadlock are

a) [1] --> [2] --> [4] --> [3] --> [1] (The one in this log)
and
b) [3] --> [2] --> [4] --> [3]

Ingo,
do_dbs_timer() function of the ondemand governor is run from a per-cpu
workqueue. Hence it is already running on the cpu whose perf counters
we're interested in.

Does it make sense to introduce a get_this_measured_perf() API
for users who are already running on the relevant CPU ?
And have get_measured_perf(cpu) for other users (currently there are
none) ?

Thus, do_dbs_timer() can avoid calling work_on_cpu() thereby preventing
deadlock a) from occuring.

Rafael,
Sorry, I am not well versed with the hibernation code. But does the
following make sense:

create_image()
{
	device_pm_lock();
	 device_power_down(PMSG_FREEZE);
	 platform_pre_snapshot(platform_mode);

        device_pm_unlock();
	disable_nonboot_cpus()
	device_pm_lock();
	.
	.
	.
	.
}



> 
> > > [ 2276.033134] -> #1 (work_on_cpu){+.+.+.}:
> > > [ 2276.033138]        [<ffffffff80265579>] __lock_acquire+0x1402/0x178c
> > > [ 2276.033141]        [<ffffffff80265996>] lock_acquire+0x93/0xbf
> > > [ 2276.033145]        [<ffffffff80250885>] flush_work+0x60/0xeb
> > > [ 2276.033148]        [<ffffffff80250c49>] work_on_cpu+0x73/0x84
> > > [ 2276.033151]        [<ffffffffa02b4399>] get_cur_val+0xb6/0xe3 [acpi_cpufreq]
> > > [ 2276.033157]        [<ffffffffa02b443a>]
> > > get_cur_freq_on_cpu+0x74/0xc5 [acpi_cpufreq]
> > > [ 2276.033161]        [<ffffffffa02b4b69>]
> > > acpi_cpufreq_cpu_init+0x381/0x4c4 [acpi_cpufreq]
> > > [ 2276.033166]        [<ffffffff803db697>] cpufreq_add_dev+0x1bb/0x676
> 
> Connecting things the wrong way around. Have not looked deeply 
> though - Peter, Rusty, what's your take? (below is the message 
> again)
> 
> 	Ingo
> 
> > > [ 2276.031486] PM: Saving platform NVS memory
> > > [ 2276.032410] Disabling non-boot CPUs ...
> > > [ 2276.032879]
> > > [ 2276.032880] =======================================================
> > > [ 2276.032882] [ INFO: possible circular locking dependency detected ]
> > > [ 2276.032885] 2.6.29-08003-g8b58977 #84
> > > [ 2276.032886] -------------------------------------------------------
> > > [ 2276.032888] pm-hibernate/5061 is trying to acquire lock:
> > > [ 2276.032891]  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at:
> > > [<ffffffff803db46e>] lock_policy_rwsem_write+0x48/0x79
> > > [ 2276.032900]
> > > [ 2276.032900] but task is already holding lock:
> > > [ 2276.032902]  (&cpu_hotplug.lock){+.+.+.}, at: [<ffffffff80240d38>]
> > > cpu_hotplug_begin+0x22/0x50
> > > [ 2276.032908]
> > > [ 2276.032909] which lock already depends on the new lock.
> > > [ 2276.032910]
> > > [ 2276.032911]
> > > [ 2276.032912] the existing dependency chain (in reverse order) is:
> > > [ 2276.032913]
> > > [ 2276.032914] -> #6 (&cpu_hotplug.lock){+.+.+.}:
> > > [ 2276.032918]        [<ffffffff80265579>] __lock_acquire+0x1402/0x178c
> > > [ 2276.032922]        [<ffffffff80265996>] lock_acquire+0x93/0xbf
> > > [ 2276.032926]        [<ffffffff804763db>] mutex_lock_nested+0x6a/0x362
> > > [ 2276.032930]        [<ffffffff80240d38>] cpu_hotplug_begin+0x22/0x50
> > > [ 2276.032933]        [<ffffffff804728b0>] _cpu_up+0x58/0x12f
> > > [ 2276.032937]        [<ffffffff804729ea>] cpu_up+0x63/0x78
> > > [ 2276.032940]        [<ffffffff806585cb>] kernel_init+0xbd/0x189
> > > [ 2276.032944]        [<ffffffff8020c1fa>] child_rip+0xa/0x20
> > > [ 2276.032948]        [<ffffffffffffffff>] 0xffffffffffffffff
> > > [ 2276.032960]
> > > [ 2276.032961] -> #5 (cpu_add_remove_lock){+.+.+.}:
> > > [ 2276.032964]        [<ffffffff80265579>] __lock_acquire+0x1402/0x178c
> > > [ 2276.032968]        [<ffffffff80265996>] lock_acquire+0x93/0xbf
> > > [ 2276.032971]        [<ffffffff804763db>] mutex_lock_nested+0x6a/0x362
> > > [ 2276.032974]        [<ffffffff80240d02>] cpu_maps_update_begin+0x12/0x14
> > > [ 2276.032978]        [<ffffffff80250526>] __create_workqueue_key+0xdc/0x1a2
> > > [ 2276.032982]        [<ffffffff80276eaf>] stop_machine_create+0x3a/0x9b
> > > [ 2276.032987]        [<ffffffff8026d959>] load_module+0x58/0x18c8
> > > [ 2276.032990]        [<ffffffff8026f320>] sys_init_module+0x57/0x1cd
> > > [ 2276.032993]        [<ffffffff8020b0c2>] system_call_fastpath+0x16/0x1b
> > > [ 2276.032998]        [<ffffffffffffffff>] 0xffffffffffffffff
> > > [ 2276.033001]
> > > [ 2276.033001] -> #4 (setup_lock){+.+.+.}:
> > > [ 2276.033005]        [<ffffffff80265579>] __lock_acquire+0x1402/0x178c
> > > [ 2276.033008]        [<ffffffff80265996>] lock_acquire+0x93/0xbf
> > > [ 2276.033012]        [<ffffffff804763db>] mutex_lock_nested+0x6a/0x362
> > > [ 2276.033015]        [<ffffffff80276e87>] stop_machine_create+0x12/0x9b
> > > [ 2276.033018]        [<ffffffff80240d7c>] disable_nonboot_cpus+0x16/0x120
> > > [ 2276.033022]        [<ffffffff80271994>] hibernation_snapshot+0x99/0x1ac
> > > [ 2276.033025]        [<ffffffff80271b52>] hibernate+0xab/0x1cf
> > > [ 2276.033028]        [<ffffffff802705f0>] state_store+0x59/0xd7
> > > [ 2276.033032]        [<ffffffff8034788f>] kobj_attr_store+0x17/0x19
> > > [ 2276.033036]        [<ffffffff8030f7d0>] sysfs_write_file+0xe4/0x119
> > > [ 2276.033040]        [<ffffffff802c0d14>] vfs_write+0xae/0x137
> > > [ 2276.033044]        [<ffffffff802c0e61>] sys_write+0x47/0x6e
> > > [ 2276.033047]        [<ffffffff8020b0c2>] system_call_fastpath+0x16/0x1b
> > > [ 2276.033050]        [<ffffffffffffffff>] 0xffffffffffffffff
> > > [ 2276.033053]
> > > [ 2276.033054] -> #3 (dpm_list_mtx){+.+.+.}:
> > > [ 2276.033057]        [<ffffffff80265579>] __lock_acquire+0x1402/0x178c
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
> > > [ 2276.033111]
> > > [ 2276.033111] -> #2 (&wfc.work){+.+.+.}:
> > > [ 2276.033114]        [<ffffffff80265579>] __lock_acquire+0x1402/0x178c
> > > [ 2276.033118]        [<ffffffff80265996>] lock_acquire+0x93/0xbf
> > > [ 2276.033122]        [<ffffffff80250032>] worker_thread+0x1ac/0x2c9
> > > [ 2276.033125]        [<ffffffff80253d40>] kthread+0x49/0x76
> > > [ 2276.033128]        [<ffffffff8020c1fa>] child_rip+0xa/0x20
> > > [ 2276.033131]        [<ffffffffffffffff>] 0xffffffffffffffff
> > > [ 2276.033134]
> > > [ 2276.033134] -> #1 (work_on_cpu){+.+.+.}:
> > > [ 2276.033138]        [<ffffffff80265579>] __lock_acquire+0x1402/0x178c
> > > [ 2276.033141]        [<ffffffff80265996>] lock_acquire+0x93/0xbf
> > > [ 2276.033145]        [<ffffffff80250885>] flush_work+0x60/0xeb
> > > [ 2276.033148]        [<ffffffff80250c49>] work_on_cpu+0x73/0x84
> > > [ 2276.033151]        [<ffffffffa02b4399>] get_cur_val+0xb6/0xe3 [acpi_cpufreq]
> > > [ 2276.033157]        [<ffffffffa02b443a>]
> > > get_cur_freq_on_cpu+0x74/0xc5 [acpi_cpufreq]
> > > [ 2276.033161]        [<ffffffffa02b4b69>]
> > > acpi_cpufreq_cpu_init+0x381/0x4c4 [acpi_cpufreq]
> > > [ 2276.033166]        [<ffffffff803db697>] cpufreq_add_dev+0x1bb/0x676
> > > [ 2276.033169]        [<ffffffff803bea90>] sysdev_driver_register+0xc6/0x120
> > > [ 2276.033173]        [<ffffffff803da5c1>] cpufreq_register_driver+0xbc/0x1ae
> > > [ 2276.033177]        [<ffffffffa00c60c5>] 0xffffffffa00c60c5
> > > [ 2276.033180]        [<ffffffff80209076>] do_one_initcall+0x70/0x185
> > > [ 2276.033183]        [<ffffffff8026f374>] sys_init_module+0xab/0x1cd
> > > [ 2276.033187]        [<ffffffff8020b0c2>] system_call_fastpath+0x16/0x1b
> > > [ 2276.033190]        [<ffffffffffffffff>] 0xffffffffffffffff
> > > [ 2276.033197]
> > > [ 2276.033197] -> #0 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
> > > [ 2276.033201]        [<ffffffff80265296>] __lock_acquire+0x111f/0x178c
> > > [ 2276.033204]        [<ffffffff80265996>] lock_acquire+0x93/0xbf
> > > [ 2276.033208]        [<ffffffff80476d6c>] down_write+0x43/0x77
> > > [ 2276.033211]        [<ffffffff803db46e>] lock_policy_rwsem_write+0x48/0x79
> > > [ 2276.033215]        [<ffffffff80474678>] cpufreq_cpu_callback+0x52/0x7a
> > > [ 2276.033218]        [<ffffffff80257ebb>] notifier_call_chain+0x33/0x5b
> > > [ 2276.033222]        [<ffffffff80257f42>] __raw_notifier_call_chain+0x9/0xb
> > > [ 2276.033226]        [<ffffffff80465097>] _cpu_down+0x86/0x298
> > > [ 2276.033229]        [<ffffffff80240dde>] disable_nonboot_cpus+0x78/0x120
> > > [ 2276.033233]        [<ffffffff80271994>] hibernation_snapshot+0x99/0x1ac
> > > [ 2276.033236]        [<ffffffff80271b52>] hibernate+0xab/0x1cf
> > > [ 2276.033239]        [<ffffffff802705f0>] state_store+0x59/0xd7
> > > [ 2276.033242]        [<ffffffff8034788f>] kobj_attr_store+0x17/0x19
> > > [ 2276.033246]        [<ffffffff8030f7d0>] sysfs_write_file+0xe4/0x119
> > > [ 2276.033249]        [<ffffffff802c0d14>] vfs_write+0xae/0x137
> > > [ 2276.033252]        [<ffffffff802c0e61>] sys_write+0x47/0x6e
> > > [ 2276.033255]        [<ffffffff8020b0c2>] system_call_fastpath+0x16/0x1b
> > > [ 2276.033259]        [<ffffffffffffffff>] 0xffffffffffffffff
> > > [ 2276.033262]
> > > [ 2276.033262] other info that might help us debug this:
> > > [ 2276.033263]
> > > [ 2276.033265] 5 locks held by pm-hibernate/5061:
> > > [ 2276.033267]  #0:  (&buffer->mutex){+.+.+.}, at:
> > > [<ffffffff8030f724>] sysfs_write_file+0x38/0x119
> > > [ 2276.033273]  #1:  (pm_mutex){+.+.+.}, at: [<ffffffff80271abe>]
> > > hibernate+0x17/0x1cf
> > > [ 2276.033278]  #2:  (dpm_list_mtx){+.+.+.}, at: [<ffffffff803c35c5>]
> > > device_pm_lock+0x12/0x14
> > > [ 2276.033284]  #3:  (cpu_add_remove_lock){+.+.+.}, at:
> > > [<ffffffff80240d99>] disable_nonboot_cpus+0x33/0x120
> > > [ 2276.033289]  #4:  (&cpu_hotplug.lock){+.+.+.}, at:
> > > [<ffffffff80240d38>] cpu_hotplug_begin+0x22/0x50
> > > [ 2276.033294]
> > > [ 2276.033295] stack backtrace:
> > > [ 2276.033297] Pid: 5061, comm: pm-hibernate Not tainted
> > > 2.6.29-08003-g8b58977 #84
> > > [ 2276.033300] Call Trace:
> > > [ 2276.033304]  [<ffffffff80263cbf>] print_circular_bug_tail+0xc5/0xd0
> > > [ 2276.033307]  [<ffffffff80265296>] __lock_acquire+0x111f/0x178c
> > > [ 2276.033312]  [<ffffffff802382b0>] ? sub_preempt_count+0xdc/0xf1
> > > [ 2276.033315]  [<ffffffff80263470>] ? trace_hardirqs_on+0xd/0xf
> > > [ 2276.033319]  [<ffffffff80265996>] lock_acquire+0x93/0xbf
> > > [ 2276.033322]  [<ffffffff803db46e>] ? lock_policy_rwsem_write+0x48/0x79
> > > [ 2276.033326]  [<ffffffff80476d6c>] down_write+0x43/0x77
> > > [ 2276.033329]  [<ffffffff803db46e>] ? lock_policy_rwsem_write+0x48/0x79
> > > [ 2276.033333]  [<ffffffff803db46e>] lock_policy_rwsem_write+0x48/0x79
> > > [ 2276.033337]  [<ffffffff80474678>] cpufreq_cpu_callback+0x52/0x7a
> > > [ 2276.033340]  [<ffffffff80257ebb>] notifier_call_chain+0x33/0x5b
> > > [ 2276.033344]  [<ffffffff80257f42>] __raw_notifier_call_chain+0x9/0xb
> > > [ 2276.033347]  [<ffffffff80465097>] _cpu_down+0x86/0x298
> > > [ 2276.033350]  [<ffffffff80240dde>] disable_nonboot_cpus+0x78/0x120
> > > [ 2276.033350]  [<ffffffff80271994>] hibernation_snapshot+0x99/0x1ac
> > > [ 2276.033350]  [<ffffffff80271b52>] hibernate+0xab/0x1cf
> > > [ 2276.033350]  [<ffffffff802705f0>] state_store+0x59/0xd7
> > > [ 2276.033350]  [<ffffffff8034788f>] kobj_attr_store+0x17/0x19
> > > [ 2276.033350]  [<ffffffff8030f7d0>] sysfs_write_file+0xe4/0x119
> > > [ 2276.033350]  [<ffffffff802c0d14>] vfs_write+0xae/0x137
> > > [ 2276.033350]  [<ffffffff802c0e61>] sys_write+0x47/0x6e
> > > [ 2276.033350]  [<ffffffff8020b0c2>] system_call_fastpath+0x16/0x1b
> > > [ 2276.034478] Broke affinity for irq 21
> > > [ 2276.034478] Broke affinity for irq 22
> > > [ 2276.034478] Broke affinity for irq 29
> > > [ 2276.035812] CPU 1 is now offline
> > > [ 2276.035814] lockdep: fixing up alternatives.
> > > [ 2276.035816] SMP alternatives: switching to UP code
> > > [ 2276.158329] CPU0 attaching NULL sched-domain.
> > > [ 2276.158334] CPU1 attaching NULL sched-domain.
> > > [ 2276.158361] CPU0 attaching NULL sched-domain.
> > > [ 2276.158841] CPU1 is down
> > > [ 2276.158867] Checking wake-up interrupts
> > > [ 2276.158883] Suspending System Devices
> > > [ 2276.158885] Suspending type 'oprofile':
> > > [ 2276.158886]  oprofile0
> > > [ 2276.158888] Suspending type 'edac':
> > > [ 2276.158889] Suspending type 'irqrouter':
> > > [ 2276.158891]  irqrouter0
> > > [ 2276.158892] Suspending type 'clocksource':
> > > [ 2276.158894]  clocksource0
> > > [ 2276.158895] Suspending type 'timekeeping':
> > > [ 2276.158897]  timekeeping0
> > > [ 2276.158929] Extended CMOS year: 2000
> > > [ 2276.158937] Suspending type 'ioapic':
> > > [ 2276.158938]  ioapic0
> > > [ 2276.159007] Suspending type 'lapic':
> > > [ 2276.159007]  lapic0
> > > [ 2276.159007] Suspending type 'machinecheck':
> > > [ 2276.159007]  machinecheck0
> > > [ 2276.159007] Suspending type 'i8237':
> > > [ 2276.159007]  i82370
> > > [ 2276.159007] Suspending type 'i8259':
> > > [ 2276.159007]  i82590
> > > [ 2276.159007] Suspending type 'node':
> > > [ 2276.159007]  node0
> > > [ 2276.159007] Suspending type 'cpu':
> > > [ 2276.159007]  cpu0
> > > [ 2276.159007]  cpu1
> > > [ 2276.159007] PM: Creating hibernation image:
> > > [ 2276.159007] PM: Need to copy 112986 pages
> > > [ 2276.159007] PM: Restoring platform NVS memory
> > > [ 2276.159007] Resuming System Devices
> > > [ 2276.159007] Resuming type 'cpu':
> > > [ 2276.159007]  cpu0
> > > [ 2276.159007]  cpu1
> > > [ 2276.159007] Resuming type 'node':
> > > [ 2276.159007]  node0
> > > [ 2276.159007] Resuming type 'i8259':
> > > [ 2276.159007]  i82590
> > > [ 2276.159007] Resuming type 'i8237':
> > > [ 2276.159007]  i82370
> > > [ 2276.159007] Resuming type 'machinecheck':
> > > [ 2276.159007]  machinecheck0
> > > [ 2276.159007] CPU0: Thermal LVT vector (0xfa) already installed
> > > [ 2276.159007] Resuming type 'lapic':
> > > [ 2276.159007]  lapic0
> > > [ 2276.159007] Resuming type 'ioapic':
> > > [ 2276.159007]  ioapic0
> > > [ 2276.159007] Resuming type 'timekeeping':
> > > [ 2276.159007]  timekeeping0
> > > [ 2276.159007] Extended CMOS year: 2000
> > > [ 2276.159007] Resuming type 'clocksource':
> > > [ 2276.159007]  clocksource0
> > > [ 2276.159007] Resuming type 'irqrouter':
> > > [ 2276.159007]  irqrouter0
> > > [ 2276.159007] Resuming type 'edac':
> > > [ 2276.159007] Resuming type 'oprofile':
> > > [ 2276.159007]  oprofile0

-- 
Thanks and Regards
gautham
