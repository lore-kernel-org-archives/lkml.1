Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZHSOUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZHSOUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZHSOUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:20:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48045 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751942AbZHSOUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:20:10 -0400
Date: Wed, 19 Aug 2009 10:20:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Xiaotian Feng <dfeng@redhat.com>, <gregkh@suse.de>, <pavel@ucw.cz>,
       <len.brown@intel.com>, <damm@igel.co.jp>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/base/power: reset transition_started at
 dpm_resume_noirq
In-Reply-To: <200908190053.24651.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908191009330.3001-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009, Rafael J. Wysocki wrote:

> On Monday 17 August 2009, Xiaotian Feng wrote:
> > transition_started should be set once the preparation of devices for
> > a PM has started, reset before starting to resume devices. When resuming
> > devices, kernel calls dpm_resume_noirq then dpm_resume_end(dpm_resume).
> > Thus we should reset transition_started at dpm_resume_noirq.
> > 
> > This patch fixes acpi warning when resuming from suspend/hibernate:
> > 
> > ACPI: \_SB_.PCI0.IDE1.PRI1.MAS1 - docking
> > ------------[ cut here ]------------
> > WARNING: at drivers/base/power/main.c:87 device_pm_add+0x8b/0xcc()
> > Hardware name: OptiPlex 760
> > Device: acpi
> > Parentless device registered during a PM transaction
> > Modules linked in: fuse sco bridge stp llc bnep l2cap bluetooth sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath uinput snd_hda_codec_analog radeon ppdev parport_pc snd_hda_intel ttm snd_hda_codec serio_raw snd_hwdep iTCO_wdt drm i2c_i801 parport iTCO_vendor_support pcspkr snd_pcm snd_timer i2c_algo_bit i2c_core snd dcdbas wmi e1000e soundcore snd_page_alloc ata_generic pata_acpi [last unloaded: speedstep_lib]
> > Pid: 33, comm: kacpi_hotplug Not tainted 2.6.31-rc5 #51
> > Call Trace:
> >  [<ffffffff8104ece1>] warn_slowpath_common+0x7c/0x94
> >  [<ffffffff8104ed50>] warn_slowpath_fmt+0x41/0x43
> >  [<ffffffff812ae827>] device_pm_add+0x8b/0xcc
> >  [<ffffffff812a820b>] device_add+0x36f/0x519
> >  [<ffffffff812a83d3>] device_register+0x1e/0x22
> >  [<ffffffff81245c86>] acpi_add_single_object+0xb48/0xd68
> >  [<ffffffff810750d6>] ? trace_hardirqs_on_caller+0x1f/0x159
> >  [<ffffffff8107521d>] ? trace_hardirqs_on+0xd/0xf
> >  [<ffffffff812461cb>] acpi_bus_add+0x2a/0x40
> >  [<ffffffff81244128>] ? acpi_bus_get_device+0x47/0x66
> >  [<ffffffff81247c52>] hotplug_dock_devices+0x109/0x133
> >  [<ffffffff812423b1>] ? acpi_os_execute_hp_deferred+0x0/0x43
> >  [<ffffffff81248013>] acpi_dock_deferred_cb+0xbf/0x192
> >  [<ffffffff812423e7>] acpi_os_execute_hp_deferred+0x36/0x43
> >  [<ffffffff8106099a>] worker_thread+0x215/0x31d
> >  [<ffffffff81060945>] ? worker_thread+0x1c0/0x31d
> >  [<ffffffff81415f34>] ? thread_return+0x3e/0xaf
> >  [<ffffffff810739bb>] ? lock_release_holdtime+0x2c/0x11d
> >  [<ffffffff8106549e>] ? autoremove_wake_function+0x0/0x39
> >  [<ffffffff81060785>] ? worker_thread+0x0/0x31d
> >  [<ffffffff8106513c>] kthread+0x8a/0x92
> >  [<ffffffff81012d4a>] child_rip+0xa/0x20
> >  [<ffffffff810126d0>] ? restore_args+0x0/0x30
> >  [<ffffffff810650b2>] ? kthread+0x0/0x92
> >  [<ffffffff81012d40>] ? child_rip+0x0/0x20
> > ---[ end trace 6f4892372e7d9f1a ]---
> > 
> > Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> 
> OK, we can do this IMO.
> 
> Alan, what do you think?

I suppose so.  The difference between dpm_resume() and 
dpm_resume_noirq() is minimal.

But at the same time, I wonder if this isn't really a bug in ACPI.  
Why does it want to register a new top-level device during the 
resume_noirq phase?

The stack trace indicates that the registration occurred from within a
workqueue.  Maybe it should be moved to a freezable workqueue; that
would prevent it from happening too early.

Alan Stern

