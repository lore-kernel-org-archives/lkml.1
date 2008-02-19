Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYBSMET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYBSMET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYBSMEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:04:12 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:23370 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbYBSMEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:04:10 -0500
Date: Tue, 19 Feb 2008 15:03:52 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.25-rc1-sha1: WARNING: at lib/kref.c:43 kref_get+0x20/0x30()
Message-ID: <20080219120352.GA8367@localhost.sw.ru>
References: <20080215110853.GH6110@localhost.sw.ru> <20080218045925.40fc5ddb.akpm@linux-foundation.org> <3ae72650802190019u76857e61n4ee543d33fd3c5fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650802190019u76857e61n4ee543d33fd3c5fc@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:19:25AM +0100, Kay Sievers wrote:
> On Feb 18, 2008 1:59 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 15 Feb 2008 14:08:53 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> >
> > > Booting without SYSFS fills dmesg like this
> >
> > Does the system normally boot without sysfs?  Surprised.
> >
> >
> > > ------------[ cut here ]------------
> > > WARNING: at lib/kref.c:43 kref_get+0x20/0x30()
> > > Modules linked in: loop(+)
> > > Pid: 994, comm: modprobe Tainted: G   M     2.6.25-rc1 #6
> > >
> > > Call Trace:
> > >  [<ffffffff802317f4>] warn_on_slowpath+0x64/0x90
> > >  [<ffffffff8028db08>] init_object+0x88/0xa0
> > >  [<ffffffff8028f55e>] __slab_alloc+0xbe/0x550
> > >  [<ffffffff8031aa28>] kvasprintf+0x58/0x90
> > >  [<ffffffff8031874c>] vsnprintf+0x33c/0x6e0
> > >  [<ffffffff8031aa41>] kvasprintf+0x71/0x90
> > >  [<ffffffff8022c597>] hrtick_set+0x77/0x140
> > >  [<ffffffff80314860>] kref_get+0x20/0x30
> > >  [<ffffffff80313932>] kobject_get+0x12/0x20
> > >  [<ffffffff803139f9>] kobject_add_internal+0x49/0xf0
> > >  [<ffffffff80313bb3>] kobject_add_varg+0x73/0x80
> > >  [<ffffffff80313fa4>] kobject_add+0x54/0x80
> > >  [<ffffffff8028ec53>] check_object+0x103/0x230
> > >  [<ffffffff8028db08>] init_object+0x88/0xa0
> > >  [<ffffffff80313744>] kobject_create+0x14/0x40
> > >  [<ffffffff8028fbd3>] kmem_cache_alloc+0xd3/0xe0
> > >  [<ffffffff803136b4>] kobject_init+0x34/0xb0
> > >  [<ffffffff8031375b>] kobject_create+0x2b/0x40
> > >  [<ffffffff8031400c>] kobject_create_and_add+0x3c/0x80
> > >  [<ffffffff8025e137>] load_module+0x1847/0x1970
> > >  [<ffffffff80288800>] alloc_pages_current+0x0/0x90
> > >  [<ffffffff8025e2c2>] sys_init_module+0x62/0x1a0
> > >
> >
> > Is this a regression?
> 
> Alexey,
> do you always see these messages with every modprobe of a module?

Yep.

> Can you enable CONFIG_DEBUG_KOBJECT=y? It might give a hint where we
> miss to initialization of a kobject when sysfs is not compiled in.

It looks like this:

kobject: 'button' (ffff81017f307248): kobject_uevent_env
kobject: 'button' (ffff81017f307248): fill_kobj_path: path = '/bus/acpi/drivers/button'
------------[ cut here ]------------
WARNING: at lib/kref.c:43 kref_get+0x2d/0x30()
Modules linked in: battery(+) button dock thermal processor sbs ac sbshc af_packet loop
Pid: 1642, comm: modprobe Not tainted 2.6.25-rc2 #2

Call Trace:
 [<ffffffff8022a8cf>] warn_on_slowpath+0x5f/0x80
 [<ffffffff8024cb06>] ? mark_held_locks+0x56/0xa0
 [<ffffffff80282c00>] ? __slab_alloc+0xc0/0x4b0
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff802f7f87>] ? kvasprintf+0x57/0x90
 [<ffffffff802f5c18>] ? vsnprintf+0x328/0x6e0
 [<ffffffff802f7fa0>] ? kvasprintf+0x70/0x90
 [<ffffffff802f1ced>] kref_get+0x2d/0x30
 [<ffffffff802f0c4a>] kobject_get+0x1a/0x30
 [<ffffffff802f0d39>] kobject_add_internal+0x59/0x160
 [<ffffffff802f0f6e>] kobject_add_varg+0x6e/0x80
 [<ffffffff802f1399>] kobject_add+0x69/0x90
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff802f1c4e>] ? kref_init+0xe/0x10
 [<ffffffff802f0927>] ? kobject_init+0x37/0xa0
 [<ffffffff802f09c3>] ? kobject_create+0x33/0x40
 [<ffffffff802f13fe>] kobject_create_and_add+0x3e/0x80
 [<ffffffff80255adf>] sys_init_module+0x19df/0x1b30
 [<ffffffff8024d928>] ? __lock_acquire+0x748/0x10b0
 [<ffffffff803249a0>] ? acpi_bus_register_driver+0x0/0x40
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff80406122>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b57b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 033c2b23880cf02a ]---
kobject: 'notes' (ffff81017ec370a8): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
kobject: 'battery' (ffff81017f382db0): kobject_add_internal: parent: 'drivers', set: 'drivers'
kobject: 'battery' (ffff81017f382db0): kobject_uevent_env
kobject: 'battery' (ffff81017f382db0): fill_kobj_path: path = '/bus/acpi/drivers/battery'
------------[ cut here ]------------
WARNING: at lib/kref.c:43 kref_get+0x2d/0x30()
Modules linked in: bay(+) battery button dock thermal processor sbs ac sbshc af_packet loop
Pid: 1650, comm: modprobe Not tainted 2.6.25-rc2 #2

Call Trace:
 [<ffffffff8022a8cf>] warn_on_slowpath+0x5f/0x80
 [<ffffffff8024cb06>] ? mark_held_locks+0x56/0xa0
 [<ffffffff80282c00>] ? __slab_alloc+0xc0/0x4b0
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff802f7f87>] ? kvasprintf+0x57/0x90
 [<ffffffff802f5c18>] ? vsnprintf+0x328/0x6e0
 [<ffffffff802f7fa0>] ? kvasprintf+0x70/0x90
 [<ffffffff802f1ced>] kref_get+0x2d/0x30
 [<ffffffff802f0c4a>] kobject_get+0x1a/0x30
 [<ffffffff802f0d39>] kobject_add_internal+0x59/0x160
 [<ffffffff802f0f6e>] kobject_add_varg+0x6e/0x80
 [<ffffffff802f1399>] kobject_add+0x69/0x90
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff802f1c4e>] ? kref_init+0xe/0x10
 [<ffffffff802f0927>] ? kobject_init+0x37/0xa0
 [<ffffffff802f09c3>] ? kobject_create+0x33/0x40
 [<ffffffff802f13fe>] kobject_create_and_add+0x3e/0x80
 [<ffffffff80255adf>] sys_init_module+0x19df/0x1b30
 [<ffffffff8024d928>] ? __lock_acquire+0x748/0x10b0
 [<ffffffff80353510>] ? device_remove_file+0x0/0x10
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff80406122>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b57b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 033c2b23880cf02a ]---
kobject: 'notes' (ffff81017ec371f8): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
kobject: '<NULL>' (ffffffff88031350): kobject_cleanup
------------[ cut here ]------------
WARNING: at lib/kref.c:43 kref_get+0x2d/0x30()
Modules linked in: fan(+) battery button dock thermal processor sbs ac sbshc af_packet loop
Pid: 1659, comm: modprobe Not tainted 2.6.25-rc2 #2

Call Trace:
 [<ffffffff8022a8cf>] warn_on_slowpath+0x5f/0x80
 [<ffffffff8024cb06>] ? mark_held_locks+0x56/0xa0
 [<ffffffff80282c00>] ? __slab_alloc+0xc0/0x4b0
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff802f7f87>] ? kvasprintf+0x57/0x90
 [<ffffffff802f5c18>] ? vsnprintf+0x328/0x6e0
 [<ffffffff802f7fa0>] ? kvasprintf+0x70/0x90
 [<ffffffff802f1ced>] kref_get+0x2d/0x30
 [<ffffffff802f0c4a>] kobject_get+0x1a/0x30
 [<ffffffff802f0d39>] kobject_add_internal+0x59/0x160
 [<ffffffff802f0f6e>] kobject_add_varg+0x6e/0x80
 [<ffffffff802f1399>] kobject_add+0x69/0x90
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff802f1c4e>] ? kref_init+0xe/0x10
 [<ffffffff802f0927>] ? kobject_init+0x37/0xa0
 [<ffffffff802f09c3>] ? kobject_create+0x33/0x40
 [<ffffffff802f13fe>] kobject_create_and_add+0x3e/0x80
 [<ffffffff80255adf>] sys_init_module+0x19df/0x1b30
 [<ffffffff8024d928>] ? __lock_acquire+0x748/0x10b0
 [<ffffffff803249a0>] ? acpi_bus_register_driver+0x0/0x40
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff80406122>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b57b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 033c2b23880cf02a ]---
kobject: 'notes' (ffff81017ec372a0): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
kobject: 'fan' (ffff81017f307db0): kobject_add_internal: parent: 'drivers', set: 'drivers'
kobject: 'fan' (ffff81017f307db0): kobject_uevent_env
kobject: 'fan' (ffff81017f307db0): fill_kobj_path: path = '/bus/acpi/drivers/fan'
------------[ cut here ]------------
WARNING: at lib/kref.c:43 kref_get+0x2d/0x30()
Modules linked in: container(+) fan battery button dock thermal processor sbs ac sbshc af_packet loop
Pid: 1667, comm: modprobe Not tainted 2.6.25-rc2 #2

Call Trace:
 [<ffffffff8022a8cf>] warn_on_slowpath+0x5f/0x80
 [<ffffffff8024cb06>] ? mark_held_locks+0x56/0xa0
 [<ffffffff80282c00>] ? __slab_alloc+0xc0/0x4b0
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff802f7f87>] ? kvasprintf+0x57/0x90
 [<ffffffff802f5c18>] ? vsnprintf+0x328/0x6e0
 [<ffffffff802f7fa0>] ? kvasprintf+0x70/0x90
 [<ffffffff802f1ced>] kref_get+0x2d/0x30
 [<ffffffff802f0c4a>] kobject_get+0x1a/0x30
 [<ffffffff802f0d39>] kobject_add_internal+0x59/0x160
 [<ffffffff802f0f6e>] kobject_add_varg+0x6e/0x80
 [<ffffffff802f1399>] kobject_add+0x69/0x90
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff802f1c4e>] ? kref_init+0xe/0x10
 [<ffffffff802f0927>] ? kobject_init+0x37/0xa0
 [<ffffffff802f09c3>] ? kobject_create+0x33/0x40
 [<ffffffff802f13fe>] kobject_create_and_add+0x3e/0x80
 [<ffffffff80255adf>] sys_init_module+0x19df/0x1b30
 [<ffffffff8024d928>] ? __lock_acquire+0x748/0x10b0
 [<ffffffff803249a0>] ? acpi_bus_register_driver+0x0/0x40
 [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff80406122>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b57b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 033c2b23880cf02a ]---
kobject: 'notes' (ffff81017ec37498): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
kobject: 'container' (ffff81017f307000): kobject_add_internal: parent: 'drivers', set: 'drivers'
kobject: 'container' (ffff81017f307000): kobject_uevent_env
kobject: 'container' (ffff81017f307000): fill_kobj_path: path = '/bus/acpi/drivers/container'

