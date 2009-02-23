Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZBWKqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZBWKqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZBWKqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:46:05 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:64640 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbZBWKqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:46:04 -0500
Subject: Re: How to analyze kmemleak message?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <84144f020902230140v83e153cr3a0c8195aab1b835@mail.gmail.com>
References: <200902230824.n1N8OV3P015018@www262.sakura.ne.jp>
	 <84144f020902230140v83e153cr3a0c8195aab1b835@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 23 Feb 2009 10:45:47 +0000
Message-Id: <1235385947.14987.41.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2009 10:45:55.0913 (UTC) FILETIME=[E7DF0390:01C995A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 11:40 +0200, Pekka Enberg wrote:
> On Mon, Feb 23, 2009 at 10:24 AM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > I got this message with linux-2.6.29-rc5-next-20090220 .

As Pekka said, they refer to the place where the object was allocated.
This object can no longer be found to be referred by other objects or
from the data section, hence it is assumed to be a leak (it could, as
well, be a false positive, transient or not). Basically, you need check
where the pointer returned by kmalloc/kmem_cache_alloc etc. should be
stored and whether it can still be referred from that place (or a
different one) later.

Kmemleak tries to avoid the reporting of transient leaks by only
reporting objects with a life time of more than 5 seconds. To make sure
the reports you got aren't transient leaks, you can read
the /sys/kernel/debug/kmemleak file a few times to see whether they
disappear.

There is a Documentation/kmemleak.txt file where you may find some
useful information.

Please note that the leaks are always reported in the order they were
allocated. You may find that some early leak triggers subsequent leaks
hence only one may need to be solved (this is because a leaked object
isn't scanned by kmemleak though it may contain pointers to other
objects - e.g. the alloc_vfsmnt leak below).

> > [   89.856902] unreferenced object 0xf7009180 (size 124):
> > [   89.857484]   comm "swapper", pid 0, jiffies 4294892306
> > [   89.857484]   backtrace:
> > [   89.857484]     [<c0230695>] create_object+0x155/0x2c0
> > [   89.857484]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> > [   89.857484]     [<c0228581>] kmem_cache_alloc+0x191/0x220
> > [   89.857484]     [<c025dc23>] alloc_vfsmnt+0x23/0x170
> > [   89.857484]     [<c023b632>] vfs_kern_mount+0x52/0x230
> > [   89.857484]     [<c023ba2a>] kern_mount_data+0x1a/0x20
> > [   89.857484]     [<c126a03e>] bdev_cache_init+0x6e/0xd0
> > [   89.857484]     [<c1268ce7>] vfs_caches_init+0x77/0x90
> > [   89.857484]     [<c1237e8d>] start_kernel+0x25d/0x380
> > [   89.857484]     [<c1237092>] __init_begin+0x92/0xe0
> > [   89.857484]     [<ffffffff>] 0xffffffff
> > [   89.886404] unreferenced object 0xf700d0e0 (size 8):
> > [   89.888384]   comm "swapper", pid 0, jiffies 4294892306
> > [   89.890117]   backtrace:
> > [   89.890393]     [<c0230695>] create_object+0x155/0x2c0
> > [   89.890393]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> > [   89.890393]     [<c022bb44>] __kmalloc_track_caller+0x234/0x2d0
> > [   89.890393]     [<c0200a95>] kstrdup+0x55/0xa0
> > [   89.890393]     [<c025dcf1>] alloc_vfsmnt+0xf1/0x170
> > [   89.890393]     [<c023b632>] vfs_kern_mount+0x52/0x230
> > [   89.890393]     [<c023ba2a>] kern_mount_data+0x1a/0x20
> > [   89.890393]     [<c126a03e>] bdev_cache_init+0x6e/0xd0
> > [   89.890393]     [<c1268ce7>] vfs_caches_init+0x77/0x90
> > [   89.890393]     [<c1237e8d>] start_kernel+0x25d/0x380
> > [   89.890393]     [<c1237092>] __init_begin+0x92/0xe0
> > [   89.890393]     [<ffffffff>] 0xffffffff

These are known to be leaks and I posted a patch some time ago:

http://lkml.org/lkml/2009/1/14/175

> > [   89.926356] unreferenced object 0xf60f6080 (size 16):
> > [   89.929082]   comm "swapper", pid 1, jiffies 4294897223
> > [   89.929480]   backtrace:
> > [   89.929480]     [<c0230695>] create_object+0x155/0x2c0
> > [   89.929480]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> > [   89.929480]     [<c0228581>] kmem_cache_alloc+0x191/0x220
> > [   89.929480]     [<c03c9ecd>] reserve_range+0x52d/0x630
> > [   89.929480]     [<c03ca103>] reserve_resources_of_dev+0x133/0x150
> > [   89.929480]     [<c03ca12d>] system_pnp_probe+0xd/0x30
> > [   89.929480]     [<c03bb52d>] pnp_device_probe+0xed/0x1c0
> > [   89.929480]     [<c040d798>] really_probe+0x358/0x490
> > [   89.929480]     [<c040dada>] driver_probe_device+0xaa/0x150
> > [   89.929480]     [<c040dd69>] __driver_attach+0xb9/0x110
> > [   89.929480]     [<c040acf5>] bus_for_each_dev+0x65/0x90
> > [   89.929480]     [<c040ddde>] driver_attach+0x1e/0x30
> > [   89.929480]     [<c040baa2>] bus_add_driver+0x1a2/0x830
> > [   89.929480]     [<c040e568>] driver_register+0xc8/0x180
> > [   89.929480]     [<c03bb97c>] pnp_register_driver+0x1c/0x20
> > [   89.929480]     [<c1274c4d>] pnp_system_init+0xd/0x10

Here, the regionid allocated in reserve_range() is reported as a leak.

> > [   89.978981] unreferenced object 0xf65205a0 (size 32):
> > [   89.981599]   comm "swapper", pid 1, jiffies 4294897223
> > [   89.982969]   backtrace:
> > [   89.982969]     [<c0230695>] create_object+0x155/0x2c0
> > [   89.982969]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> > [   89.982969]     [<c0228581>] kmem_cache_alloc+0x191/0x220
> > [   89.982969]     [<c016e29d>] __request_region+0x4cd/0x5d0
> > [   89.982969]     [<c03c9a6e>] reserve_range+0xce/0x630
> > [   89.982969]     [<c03ca103>] reserve_resources_of_dev+0x133/0x150
> > [   89.982969]     [<c03ca12d>] system_pnp_probe+0xd/0x30
> > [   89.982969]     [<c03bb52d>] pnp_device_probe+0xed/0x1c0
> > [   89.982969]     [<c040d798>] really_probe+0x358/0x490
> > [   89.982969]     [<c040dada>] driver_probe_device+0xaa/0x150
> > [   89.982969]     [<c040dd69>] __driver_attach+0xb9/0x110
> > [   89.982969]     [<c040acf5>] bus_for_each_dev+0x65/0x90
> > [   89.982969]     [<c040ddde>] driver_attach+0x1e/0x30
> > [   89.982969]     [<c040baa2>] bus_add_driver+0x1a2/0x830
> > [   89.982969]     [<c040e568>] driver_register+0xc8/0x180
> > [   89.982969]     [<c03bb97c>] pnp_register_driver+0x1c/0x20

The resource structure allocated in __request_region() cannot be found
to be referred either. It seems that the previous regionid leak may be
just a side effect of the above leak as the resource structure was
supposed to reference the regionid (via the name field).

For the above regionid and this one, you can dump the objects via
the /dev/kmem and get the name of the resource. You could also look
in /proc/iomem or /proc/ioports but if that's a real leak the resource
name shouldn't be there (but first check the reported leaks again via
the /sys/kernel/debug/kmemleak file).

Please keep me in the loop if you find any real leaks or they are just
false positives.

Thanks.

-- 
Catalin

