Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbZH1QcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbZH1QcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZH1QcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:32:19 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48129 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbZH1QcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:32:18 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: memleaks, acpi + ext4 + tty
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 28 Aug 2009 17:32:10 +0100
In-Reply-To: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> (Luis R. Rodriguez's message of "Thu\, 27 Aug 2009 22\:25\:57 -0700")
Message-ID: <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Aug 2009 16:32:12.0750 (UTC) FILETIME=[18AA3EE0:01CA27FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
> I have an assorted collection of kmemleak reports for acpi, ext4 and
> tty, not sure how to read these yet to fix so figure I'd at least post
> them. To reproduce I can just dd=/dev/zero to some big file and played
> some video.

If you do a few echo scan > /sys/kernel/debug/kmemleak, do they
disappear (i.e. transient false positives)?

Which kernel version is this?

> unreferenced object 0xffff88003e0015c0 (size 64):
>   comm "swapper", pid 1, jiffies 4294892352
>   backtrace:
>     [<ffffffff81121fad>] create_object+0x13d/0x2d0
>     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
>     [<ffffffff81118a03>] kmem_cache_alloc_node+0x193/0x200
>     [<ffffffff8152509e>] process_zones+0x70/0x1cd
>     [<ffffffff81525230>] pageset_cpuup_callback+0x35/0x92
>     [<ffffffff8152c9b7>] notifier_call_chain+0x47/0x90
>     [<ffffffff81078549>] __raw_notifier_call_chain+0x9/0x10
>     [<ffffffff81523f25>] _cpu_up+0x75/0x130
>     [<ffffffff8152403a>] cpu_up+0x5a/0x6a
>     [<ffffffff8181969e>] kernel_init+0xcc/0x1ba
>     [<ffffffff810130ca>] child_rip+0xa/0x20
>     [<ffffffffffffffff>] 0xffffffffffffffff

Can't really tell. Maybe a false positive caused by kmemleak not
scanning the pgdata node_zones. Can you post your .config file?

> unreferenced object 0xffff88003cb5f700 (size 64):
>   comm "swapper", pid 1, jiffies 4294892459
>   backtrace:
>     [<ffffffff81121fad>] create_object+0x13d/0x2d0
>     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
>     [<ffffffff81119f3b>] __kmalloc+0x16b/0x250
>     [<ffffffff812bb549>] kzalloc+0xf/0x11
>     [<ffffffff812bbb53>] acpi_add_single_object+0x58e/0xd3c
>     [<ffffffff812bc51c>] acpi_bus_scan+0x125/0x1af
>     [<ffffffff81842361>] acpi_scan_init+0xc8/0xe9
>     [<ffffffff8184211c>] acpi_init+0x21f/0x265
>     [<ffffffff8100a05b>] do_one_initcall+0x4b/0x1b0
>     [<ffffffff81819736>] kernel_init+0x164/0x1ba
>     [<ffffffff810130ca>] child_rip+0xa/0x20
>     [<ffffffffffffffff>] 0xffffffffffffffff

I get ACPI reports as well and they may be real leaks. However, I
didn't have time to analyse the code (pretty complicated reference
counting).

> unreferenced object 0xffff880039571800 (size 1024):
>   comm "exe", pid 1168, jiffies 4294893410
>   backtrace:
>     [<ffffffff81121fad>] create_object+0x13d/0x2d0
>     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
>     [<ffffffff81119f3b>] __kmalloc+0x16b/0x250
>     [<ffffffff811e1d71>] ext4_mb_init+0x1a1/0x590
>     [<ffffffff811d2da3>] ext4_fill_super+0x1df3/0x26c0
>     [<ffffffff8112774f>] get_sb_bdev+0x16f/0x1b0
>     [<ffffffff811c8fd3>] ext4_get_sb+0x13/0x20
>     [<ffffffff81127216>] vfs_kern_mount+0x76/0x180
>     [<ffffffff8112738d>] do_kern_mount+0x4d/0x130
>     [<ffffffff8113fc57>] do_mount+0x307/0x8b0
>     [<ffffffff8114028f>] sys_mount+0x8f/0xe0
>     [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
>     [<ffffffffffffffff>] 0xffffffffffffffff

The ext4 reports are real leaks and patch was posted here -
http://lkml.org/lkml/2009/7/15/62. However, it hasn't been merged into
mainline yet (I cc'ed Aneesh).

The patch is merged in my "kmemleak-fixes" branch on
git://linux-arm.org/linux-2.6.git.

> unreferenced object 0xffff880006ce0400 (size 1024):
>   comm "mplayer", pid 5293, jiffies 4295366945
>   backtrace:
>     [<ffffffff81121fad>] create_object+0x13d/0x2d0
>     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
>     [<ffffffff81119f3b>] __kmalloc+0x16b/0x250
>     [<ffffffff813021b0>] tty_buffer_request_room+0xc0/0x190
>     [<ffffffff8130244c>] tty_insert_flip_string+0x3c/0xb0
>     [<ffffffff81302f49>] pty_write+0x49/0x70
>     [<ffffffff812fd3b0>] n_tty_write+0x1c0/0x450
>     [<ffffffff812f9ec1>] tty_write+0x1a1/0x290
>     [<ffffffff81124518>] vfs_write+0xb8/0x1a0
>     [<ffffffff81124fcc>] sys_write+0x4c/0x80
>     [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
>     [<ffffffffffffffff>] 0xffffffffffffffff

It could be a real leak as you get several of these. I cc'ed Greg KH
for any suggestions he may have. It looks like it only happens when
running mplayer.

Thanks.

-- 
Catalin
