Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZH3Qeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZH3Qeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 12:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZH3Qef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 12:34:35 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38603 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZH3Qee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 12:34:34 -0400
Date: Sun, 30 Aug 2009 22:04:17 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Theodore Tso <tytso@mit.edu>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: memleaks, acpi + ext4 + tty
Message-ID: <20090830163417.GA15183@skywalker.linux.vnet.ibm.com>
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 05:32:10PM +0100, Catalin Marinas wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
> > I have an assorted collection of kmemleak reports for acpi, ext4 and
> > tty, not sure how to read these yet to fix so figure I'd at least post
> > them. To reproduce I can just dd=/dev/zero to some big file and played
> > some video.
> 
> If you do a few echo scan > /sys/kernel/debug/kmemleak, do they
> disappear (i.e. transient false positives)?
> 
> Which kernel version is this?
> 
> > unreferenced object 0xffff88003e0015c0 (size 64):
> >   comm "swapper", pid 1, jiffies 4294892352
> >   backtrace:
> >     [<ffffffff81121fad>] create_object+0x13d/0x2d0
> >     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
> >     [<ffffffff81118a03>] kmem_cache_alloc_node+0x193/0x200
> >     [<ffffffff8152509e>] process_zones+0x70/0x1cd
> >     [<ffffffff81525230>] pageset_cpuup_callback+0x35/0x92
> >     [<ffffffff8152c9b7>] notifier_call_chain+0x47/0x90
> >     [<ffffffff81078549>] __raw_notifier_call_chain+0x9/0x10
> >     [<ffffffff81523f25>] _cpu_up+0x75/0x130
> >     [<ffffffff8152403a>] cpu_up+0x5a/0x6a
> >     [<ffffffff8181969e>] kernel_init+0xcc/0x1ba
> >     [<ffffffff810130ca>] child_rip+0xa/0x20
> >     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Can't really tell. Maybe a false positive caused by kmemleak not
> scanning the pgdata node_zones. Can you post your .config file?
> 
> > unreferenced object 0xffff88003cb5f700 (size 64):
> >   comm "swapper", pid 1, jiffies 4294892459
> >   backtrace:
> >     [<ffffffff81121fad>] create_object+0x13d/0x2d0
> >     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
> >     [<ffffffff81119f3b>] __kmalloc+0x16b/0x250
> >     [<ffffffff812bb549>] kzalloc+0xf/0x11
> >     [<ffffffff812bbb53>] acpi_add_single_object+0x58e/0xd3c
> >     [<ffffffff812bc51c>] acpi_bus_scan+0x125/0x1af
> >     [<ffffffff81842361>] acpi_scan_init+0xc8/0xe9
> >     [<ffffffff8184211c>] acpi_init+0x21f/0x265
> >     [<ffffffff8100a05b>] do_one_initcall+0x4b/0x1b0
> >     [<ffffffff81819736>] kernel_init+0x164/0x1ba
> >     [<ffffffff810130ca>] child_rip+0xa/0x20
> >     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> I get ACPI reports as well and they may be real leaks. However, I
> didn't have time to analyse the code (pretty complicated reference
> counting).
> 
> > unreferenced object 0xffff880039571800 (size 1024):
> >   comm "exe", pid 1168, jiffies 4294893410
> >   backtrace:
> >     [<ffffffff81121fad>] create_object+0x13d/0x2d0
> >     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
> >     [<ffffffff81119f3b>] __kmalloc+0x16b/0x250
> >     [<ffffffff811e1d71>] ext4_mb_init+0x1a1/0x590
> >     [<ffffffff811d2da3>] ext4_fill_super+0x1df3/0x26c0
> >     [<ffffffff8112774f>] get_sb_bdev+0x16f/0x1b0
> >     [<ffffffff811c8fd3>] ext4_get_sb+0x13/0x20
> >     [<ffffffff81127216>] vfs_kern_mount+0x76/0x180
> >     [<ffffffff8112738d>] do_kern_mount+0x4d/0x130
> >     [<ffffffff8113fc57>] do_mount+0x307/0x8b0
> >     [<ffffffff8114028f>] sys_mount+0x8f/0xe0
> >     [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
> >     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> The ext4 reports are real leaks and patch was posted here -
> http://lkml.org/lkml/2009/7/15/62. However, it hasn't been merged into
> mainline yet (I cc'ed Aneesh).
> 

The patch is part of ext4-patchqueue  http://repo.or.cz/w/ext4-patch-queue.git

Ted,

Any plans to push the patches to linus tree soon ?

-aneesh
