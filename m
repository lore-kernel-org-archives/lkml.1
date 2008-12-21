Return-Path: <linux-kernel-owner+w=401wt.eu-S1751367AbYLUUz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbYLUUz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYLUUyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:54:53 -0500
Received: from www.tglx.de ([62.245.132.106]:49009 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbYLUUyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:54:50 -0500
Date: Sun, 21 Dec 2008 21:54:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0812212140020.3739@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu> <200812182319.57235.rjw@sisk.pl> <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008, Thomas Gleixner wrote:
> On Thu, 18 Dec 2008, Rafael J. Wysocki wrote:
> Also we need to investigate whether sched_clock is referencing gtod
> values _before_ timekeeping is resume.

It does. I added a check into __update_sched_clock() and it triggers
on every resume:

WARNING: at /home/tglx/work/kernel/git/linux-2.6/kernel/sched_clock.c:117 __update_sched_clock+0x31/0xad()
Modules linked in: fuse i915 drm bridge stp bnep sco l2cap bluetooth coretemp sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_region_hash dm_log dm_multipath uinput joydev thinkpad_acpi hwmon snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device pcspkr i2c_i801 snd_pcm_oss firewire_ohci i2c_core firewire_core yenta_socket iwlagn iTCO_wdt snd_mixer_oss rsrc_nonstatic crc_itu_t iTCO_vendor_support snd_pcm iwlcore snd_timer snd_page_alloc snd_hwdep rfkill snd soundcore e1000e wmi video output battery ac [last unloaded: microcode]
Pid: 3212, comm: pm-hibernate Not tainted 2.6.28-rc9 #80
Call Trace:
 [<ffffffff8103ef04>] warn_on_slowpath+0x5d/0x82
 [<ffffffff8117becf>] ? vsnprintf+0x669/0x6ba
 [<ffffffff81099c38>] ? __mod_zone_page_state+0x9/0x5a
 [<ffffffff810900b7>] ? __rmqueue+0x24/0x1fa
 [<ffffffff81057689>] __update_sched_clock+0x31/0xad
 [<ffffffff81090004>] ? __rmqueue_smallest+0xb7/0x146
 [<ffffffff81057809>] sched_clock_cpu+0x104/0x120
 [<ffffffff811b5030>] ? acpi_ns_search_one_scope+0xc/0x4b
 [<ffffffff81367d14>] ? _spin_lock+0xe/0x11
 [<ffffffff81038e17>] try_to_wake_up+0xff/0x1b1
 [<ffffffff8128e4ca>] ? cpufreq_debug_printk+0x17/0x124
 [<ffffffff81038ed6>] default_wake_function+0xd/0xf
 [<ffffffff81052d94>] autoremove_wake_function+0x16/0x3d
 [<ffffffff8103262f>] __wake_up_common+0x46/0x75
 [<ffffffff81032c7c>] __wake_up+0x38/0x50
 [<ffffffff8104f378>] insert_work+0x68/0x70
 [<ffffffff8104fb94>] __queue_work+0x2f/0x42
 [<ffffffff8104fc2f>] queue_work_on+0x47/0x50
 [<ffffffff8104fdc1>] queue_work+0x1f/0x21
 [<ffffffff8104fdde>] schedule_work+0x1b/0x1d
 [<ffffffff8128f0c8>] cpufreq_resume+0x157/0x16c
 [<ffffffff811fe436>] __sysdev_resume+0x3d/0x55
 [<ffffffff811fe484>] sysdev_resume+0x36/0x77
 [<ffffffff81203e28>] device_power_up+0x15/0x20
 [<ffffffff810670c9>] hibernation_snapshot+0x181/0x210
 [<ffffffff81067220>] hibernate+0xc8/0x1a6
 [<ffffffff81065f75>] state_store+0x5e/0xdd
 [<ffffffff81176f83>] kobj_attr_store+0x17/0x19
 [<ffffffff811106db>] sysfs_write_file+0xe4/0x119
 [<ffffffff810c1856>] vfs_write+0xb0/0x10a
 [<ffffffff810c197e>] sys_write+0x4c/0x74
 [<ffffffff8100c1fa>] system_call_fastpath+0x16/0x1b

