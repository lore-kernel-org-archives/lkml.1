Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbYD3UKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbYD3UKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbYD3UKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:10:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:19462 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbYD3UKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Rweot+nJKcAE8yEBH1KFA5HaWhsF49Xnfogv8O2cAphvITb7nWa4jJjYtef/LeAaXs9lm+GxqJnaP6I1Tly2NvEeFKX+NVlB/l5ogp1MMy98OCQKaoFaju8LszFoAN65OFGG6jDMHJhN9fKHcrqxw7RNRns+fbCcS+bLY10NqmM=
Date: Wed, 30 Apr 2008 21:51:10 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] smp alternatives: sleeping function called from invalid
	context
Message-ID: <20080430195110.GA28743@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
with git current I'm seeing these warnings when bringing CPUs down:

[13794.108805] CPU0 attaching NULL sched-domain.
[13794.108815] CPU1 attaching NULL sched-domain.
[13794.124695] Broke affinity for irq 22
[13794.192376] CPU 1 is now offline
[13794.192381] lockdep: fixing up alternatives.
[13794.192389] SMP alternatives: switching to UP code
[13794.192395] BUG: sleeping function called from invalid context at /home/kronos/src/linux-2.6.git/mm/slab.c:3049
[13794.192398] in_atomic():1, irqs_disabled():0
[13794.192401] 4 locks held by bash/11413:
[13794.192404]  #0:  (&buffer->mutex){--..}, at: [<ffffffff802c638c>] sysfs_write_file+0x36/0x10c
[13794.192417]  #1:  (cpu_add_remove_lock){--..}, at: [<ffffffff80253479>] cpu_down+0x12/0x32
[13794.192427]  #2:  (&cpu_hotplug.lock){--..}, at: [<ffffffff80253024>] cpu_hotplug_begin+0x36/0xa6
[13794.192435]  #3:  (smp_alt){--..}, at: [<ffffffff8021182f>] alternatives_smp_switch+0x63/0x1a5
[13794.192446] Pid: 11413, comm: bash Not tainted 2.6.25-64-05976-ge31a94e-dirty #68
[13794.192449]
[13794.192450] Call Trace:
[13794.192681]  [<ffffffff80280f61>] __kmalloc+0x29/0x7d
[13794.192695]  [<ffffffff80276415>] __get_vm_area_node+0x9a/0x1b1
[13794.192703]  [<ffffffff80209391>] clear_ti_thread_flag+0xc/0x12
[13794.192709]  [<ffffffff80276585>] get_vm_area_caller+0x2b/0x2e
[13794.192715]  [<ffffffff8021159d>] text_poke+0xdd/0x156
[13794.192719]  [<ffffffff80276cc5>] vmap+0x2d/0x5a
[13794.192727]  [<ffffffff8021159d>] text_poke+0xdd/0x156
[13794.192736]  [<ffffffff80446f1b>] _etext+0x0/0x5
[13794.192742]  [<ffffffff80211666>] alternatives_smp_unlock+0x50/0x65
[13794.192752]  [<ffffffff80211934>] alternatives_smp_switch+0x168/0x1a5
[13794.192758]  [<ffffffff80219439>] __cpus_weight+0x3f/0x41
[13794.192767]  [<ffffffff802532b4>] _cpu_down+0x18f/0x264
[13794.192796]  [<ffffffff8025348b>] cpu_down+0x24/0x32
[13794.192805]  [<ffffffff8043259d>] store_online+0x29/0x67
[13794.192812]  [<ffffffff802c642b>] sysfs_write_file+0xd5/0x10c
[13794.192824]  [<ffffffff80283cba>] vfs_write+0xa5/0xde
[13794.192832]  [<ffffffff80283da5>] sys_write+0x45/0x6b
[13794.192842]  [<ffffffff80221ed2>] ia32_sysret+0x0/0xa
[13794.192857]
[13794.208799] CPU0 attaching NULL sched-domain.

...and up:

[13803.369635] lockdep: fixing up alternatives.
[13803.369640] SMP alternatives: switching to SMP code
[13803.369645] BUG: sleeping function called from invalid context at /home/kronos/src/linux-2.6.git/mm/slab.c:3049
[13803.369648] in_atomic():1, irqs_disabled():0
[13803.369651] 4 locks held by bash/11413:
[13803.369654]  #0:  (&buffer->mutex){--..}, at: [<ffffffff802c638c>] sysfs_write_file+0x36/0x10c
[13803.369666]  #1:  (cpu_add_remove_lock){--..}, at: [<ffffffff8044115e>] cpu_up+0x40/0x64
[13803.369676]  #2:  (&cpu_hotplug.lock){--..}, at: [<ffffffff80253024>] cpu_hotplug_begin+0x36/0xa6
[13803.369686]  #3:  (smp_alt){--..}, at: [<ffffffff8021182f>] alternatives_smp_switch+0x63/0x1a5
[13803.369697] Pid: 11413, comm: bash Not tainted 2.6.25-64-05976-ge31a94e-dirty #68
[13803.369700]
[13803.369701] Call Trace:
[13803.369712]  [<ffffffff80280f61>] __kmalloc+0x29/0x7d
[13803.369721]  [<ffffffff80276415>] __get_vm_area_node+0x9a/0x1b1
[13803.369731]  [<ffffffff80209391>] clear_ti_thread_flag+0xc/0x12
[13803.369738]  [<ffffffff80446f1b>] _etext+0x0/0x5
[13803.369743]  [<ffffffff80276585>] get_vm_area_caller+0x2b/0x2e
[13803.369749]  [<ffffffff8021159d>] text_poke+0xdd/0x156
[13803.369753]  [<ffffffff80276cc5>] vmap+0x2d/0x5a
[13803.369763]  [<ffffffff8021159d>] text_poke+0xdd/0x156
[13803.369773]  [<ffffffff802118c5>] alternatives_smp_switch+0xf9/0x1a5
[13803.369795]  [<ffffffff8043f29e>] native_cpu_up+0x224/0x7fc
[13803.369804]  [<ffffffff8043ee95>] do_fork_idle+0x0/0x20
[13803.369833]  [<ffffffff80441098>] _cpu_up+0x91/0x117
[13803.369842]  [<ffffffff80441175>] cpu_up+0x57/0x64
[13803.369849]  [<ffffffff804325b7>] store_online+0x43/0x67
[13803.369856]  [<ffffffff802c642b>] sysfs_write_file+0xd5/0x10c
[13803.369867]  [<ffffffff80283cba>] vfs_write+0xa5/0xde
[13803.369875]  [<ffffffff80283da5>] sys_write+0x45/0x6b
[13803.369886]  [<ffffffff80221ed2>] ia32_sysret+0x0/0xa
[13803.369898]
[13803.380408] Booting processor 1/1 ip 6000
[13803.389154] Initializing CPU#1
[13803.389154] masked ExtINT on CPU#1

The bug has been introduced (assuming that I'm using git blame correctly) by this commit:

commit e587cadd8f47e202a30712e2906a65a0606d5865
Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date:   Thu Mar 6 08:48:49 2008 -0500

    x86: enhance DEBUG_RODATA support - alternatives


In both code paths - cpu_up() and cpud_down() - alternatives_smp_switch ends up
calling text_poke() (via alternatives_smp_{,un}lock) with smp_alt held;
then text_poke does a vmap which might sleep!

Luca
-- 
Windows NT crashed.
I'm the Blue Screen of Death.
No one hears your screams.
