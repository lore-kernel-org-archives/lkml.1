Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0BCWXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:23:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41138 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429Ab0BCWW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:22:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [linux-pm] Lokdep messages during resume from disk
Date: Wed, 3 Feb 2010 23:23:36 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <1265214694.18521.3.camel@maxim-laptop>
In-Reply-To: <1265214694.18521.3.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002032323.36310.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010, Maxim Levitsky wrote:
> Hi,
> 
> Since now, my notebook finally have the ability to do hibernate
> reliably, I want to report this, probably cosmetic issue.
> 
> This lockdep message shows up always in the kernel that does the resume.

This is a result of adding lockdep annotations to sysfs aimed at catching
situations where sysfs attributes are written to while removed (if understand
that correctly).

I don't think that happens in this particular case, though, so that looks like
a false-positive to me.

> 
> [    3.111118] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [    3.130340] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [    3.150375] PM: Reading hibernation image.
> [    3.160309] PM: Loading image data pages (128548 pages) ... done
> [   14.385776] PM: Read 514192 kbytes in 11.22 seconds (45.82 MB/s)
> [   14.385867] PM: Image successfully loaded
> [   14.386838] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [   14.470597] ata_piix 0000:00:1f.1: PCI INT A disabled
> [   14.470997] PM: quiesce of devices complete after 84.232 msecs
> [   14.472289] PM: late quiesce of devices complete after 1.200 msecs
> [   14.472399] Suspending EC transactions
> [   14.472850] Disabling non-boot CPUs ...
> [   14.591472] CPU 1 is now offline
> [   14.591555] lockdep: fixing up alternatives.
> [   14.591646] SMP alternatives: switching to UP code
> [   14.598663] 
> [   14.598665] =============================================
> [   14.598824] [ INFO: possible recursive locking detected ]
> [   14.598911] 2.6.33-rc5-wl #37
> [   14.598987] ---------------------------------------------
> [   14.599074] resume/1066 is trying to acquire lock:
> [   14.599170]  (s_active){++++.+}, at: [<ffffffff81172ae3>] sysfs_addrm_finish+0x43/0x70
> [   14.599483] 
> [   14.599485] but task is already holding lock:
> [   14.599656]  (s_active){++++.+}, at: [<ffffffff81172e35>] sysfs_get_active_two+0x45/0x60
> [   14.599967] 
> [   14.599969] other info that might help us debug this:
> [   14.600008] 6 locks held by resume/1066:
> [   14.600008]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81171004>] sysfs_write_file+0x44/0x170
> [   14.600008]  #1:  (s_active){++++.+}, at: [<ffffffff81172e35>] sysfs_get_active_two+0x45/0x60
> [   14.600008]  #2:  (s_active){++++.+}, at: [<ffffffff81172e17>] sysfs_get_active_two+0x27/0x60
> [   14.600008]  #3:  (pm_mutex/1){+.+.+.}, at: [<ffffffff8108bd84>] software_resume+0x34/0x210
> [   14.600008]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81046137>] cpu_maps_update_begin+0x17/0x20
> [   14.600008]  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8104618c>] cpu_hotplug_begin+0x2c/0x60
> [   14.600008] 
> [   14.600008] stack backtrace:
> [   14.600008] Pid: 1066, comm: resume Not tainted 2.6.33-rc5-wl #37
> [   14.600008] Call Trace:
> [   14.600008]  [<ffffffff8107aad0>] __lock_acquire+0xf40/0x1d00
> [   14.600008]  [<ffffffff81077cca>] ? add_lock_to_list+0x5a/0xe0
> [   14.600008]  [<ffffffff8107765e>] ? lockdep_init_map+0x5e/0x5b0
> [   14.600008]  [<ffffffff8107b92b>] lock_acquire+0x9b/0x160
> [   14.600008]  [<ffffffff81172ae3>] ? sysfs_addrm_finish+0x43/0x70
> [   14.600008]  [<ffffffff811721e7>] sysfs_deactivate+0xd7/0x130
> [   14.600008]  [<ffffffff81172ae3>] ? sysfs_addrm_finish+0x43/0x70
> [   14.600008]  [<ffffffff81172ae3>] sysfs_addrm_finish+0x43/0x70
> [   14.600008]  [<ffffffff81172bf8>] sysfs_remove_dir+0x88/0xd0
> [   14.600008]  [<ffffffff8122de86>] kobject_del+0x16/0x40
> [   14.600008]  [<ffffffff8122df1e>] kobject_release+0x6e/0x240
> [   14.600008]  [<ffffffff8122deb0>] ? kobject_release+0x0/0x240
> [   14.600008]  [<ffffffff8122f487>] kref_put+0x37/0x70
> [   14.600008]  [<ffffffff8122ddb7>] kobject_put+0x27/0x60
> [   14.600008]  [<ffffffff81400f39>] cacheinfo_cpu_callback+0xa2/0xdb
> [   14.600008]  [<ffffffff8106bb77>] notifier_call_chain+0x47/0x90
> [   14.600008]  [<ffffffff8106bc66>] raw_notifier_call_chain+0x16/0x20
> [   14.600008]  [<ffffffff813f7c40>] _cpu_down+0x140/0x2e0
> [   14.600008]  [<ffffffff81046270>] disable_nonboot_cpus+0xb0/0x120
> [   14.600008]  [<ffffffff8108bcc5>] hibernation_restore+0xa5/0x130
> [   14.600008]  [<ffffffff8108bf3f>] software_resume+0x1ef/0x210
> [   14.600008]  [<ffffffff8108c014>] resume_store+0xb4/0xc0
> [   14.600008]  [<ffffffff8122db07>] kobj_attr_store+0x17/0x20
> [   14.600008]  [<ffffffff811710a6>] sysfs_write_file+0xe6/0x170
> [   14.600008]  [<ffffffff811087f8>] vfs_write+0xb8/0x1a0
> [   14.600008]  [<ffffffff811089d1>] sys_write+0x51/0x90
> [   14.600008]  [<ffffffff8100305b>] system_call_fastpath+0x16/0x1b
> [   14.605822] Task events/1 (pid = 10) is on cpu 1				(state = 1, flags = 84208040) 
> [   14.605940] Task kblockd/1 (pid = 142) is on cpu 1				(state = 1, flags = 84208040) 
> <6>[ 3060.213061] PM: Restoring platform NVS memory
> 
> Everything works fine now though.

CCing Eric for expert advice.

Rafael
