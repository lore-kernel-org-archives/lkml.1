Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbZJNNNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbZJNNNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760761AbZJNNNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:13:24 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58376 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760645AbZJNNNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:13:23 -0400
To: catalin.marinas@arm.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc3 kmemleak] WARNING:atkernel/lockdep.c:3161check_flags+0xbe/0x180()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200910130317.n9D3HTOH055400@www262.sakura.ne.jp>
	<1255435201.9987.22.camel@pc1117.cambridge.arm.com>
	<200910140025.CAJ82820.MOtOFOLVFFSHJQ@I-love.SAKURA.ne.jp>
	<200910142055.HJH56741.FLOFSJOQHtFVMO@I-love.SAKURA.ne.jp>
	<1255522972.15103.8.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1255522972.15103.8.camel@pc1117.cambridge.arm.com>
Message-Id: <200910142212.IEI69780.MOtQOJHVSLOFFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 14 Oct 2009 22:12:45 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> Until I manage to reproduce the problem, could you please try the patch
> below:
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 7dfa481..f8f671b 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2263,7 +2263,8 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>  	 * (bootstrapping cannot cope with offslab caches so don't do
>  	 * it too early on.)
>  	 */
> -	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init)
> +	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init &&
> +	    !(cachep->flags & SLAB_NOLEAKTRACE))
>  		/*
>  		 * Size is large, assume best to place the slab management obj
>  		 * off-slab (should allow better packing of objs).

It is "&& !(flags & SLAB_NOLEAKTRACE)" rather than
"&& !(cachep->flags & SLAB_NOLEAKTRACE)" because "cachep->flags = flags;" is
not yet done, isn't it?

After adding "&& !(flags & SLAB_NOLEAKTRACE)", I got out of memory error later.

[    0.000000] Linux version 2.6.32-rc4 (root@tomoyo) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-44)) #9 SMP Wed Oct 14 20:44:56 JST 2009
(...snipped...)
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: selftest passed
[    0.000000] TSC freq read from hypervisor : 2327.550 MHz
[    0.000000] Detected 2327.550 MHz processor.
[    0.008398] Calibrating delay loop (skipped), value calculated using timer frequency.. 4655.10 BogoMIPS (lpj=9310200)
[    0.022680] Mount-cache hash table entries: 512
(...snipped...)
[    7.578789] Initializing USB Mass Storage driver...
[    7.582655] usbcore: registered new interface driver usb-storage
[    7.584314] USB Mass Storage support registered.
[    7.590848] PNP: No PS/2 controller found. Probing ports directly.
[    8.295096] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.297408] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.312965] mice: PS/2 mouse device common for all mice
[    8.925040] Kernel panic - not syncing: Out of memory and no killable processes...
[    8.925045] 
[    8.927806] Pid: 139, comm: kseriod Not tainted 2.6.32-rc4 #9
[    8.930156] Call Trace:
[    8.930297] EISA: Probing bus 0 at eisa.0
[    8.934031]  [<c103bb1b>] panic+0x4b/0x110
[    8.935244]  [<c109dacf>] __out_of_memory+0x12f/0x130
[    8.936652]  [<c109db27>] out_of_memory+0x57/0xb0
[    8.937936]  [<c10a0730>] __alloc_pages_nodemask+0x5c0/0x600
[    8.938986] TCP cubic registered
[    8.939130] NET: Registered protocol family 17
[    8.940733] Using IPI No-Shortcut mode
[    8.944585]  [<c10c29a0>] cache_alloc_refill+0x340/0x700
[    8.946047]  [<c10c24ff>] ? kmem_cache_alloc+0x5f/0x1c0
[    8.948022]  [<c10c2614>] kmem_cache_alloc+0x174/0x1c0
[    8.949979]  [<c10c71a9>] ? create_object+0x29/0x240
[    8.951447]  [<c10676b5>] ? mark_held_locks+0x55/0x70
[    8.953261]  [<c10c71a9>] create_object+0x29/0x240
[    8.955636]  [<c10c1b29>] ? poison_obj+0x29/0x50
[    8.957248]  [<c10c1686>] ? dbg_redzone1+0x16/0x30
[    8.958518]  [<c13076ba>] kmemleak_alloc+0x6a/0xe0
[    8.959827]  [<c1067954>] ? trace_hardirqs_on_caller+0x104/0x170
[    8.961639]  [<c10c3e50>] __kmalloc+0x1c0/0x230
[    8.962890]  [<c1191200>] ? kobject_get_path+0x50/0xe0
[    8.964308]  [<c1191200>] kobject_get_path+0x50/0xe0
[    8.966717]  [<c10676b5>] ? mark_held_locks+0x55/0x70
[    8.968160]  [<c1191a2d>] kobject_uevent_env+0x2dd/0x670
[    8.969670]  [<c1067954>] ? trace_hardirqs_on_caller+0x104/0x170
[    8.971271]  [<c10679cb>] ? trace_hardirqs_on+0xb/0x10
[    8.972644]  [<c11ed38c>] ? device_pm_add+0x7c/0x130
[    8.973959]  [<c1191dca>] kobject_uevent+0xa/0x10
[    8.975240]  [<c11e5dd2>] device_add+0x3a2/0x5c0
[    8.977549]  [<c1199118>] ? kvasprintf+0x48/0x60
[    8.978781]  [<c1190fba>] ? kobject_set_name_vargs+0x4a/0x60
[    8.980303]  [<c1264348>] input_register_device+0x88/0x1f0
[    8.982355]  [<c126871b>] atkbd_connect+0x21b/0x280
[    8.983681]  [<c131a59a>] ? mutex_lock_nested+0x3a/0x50
[    8.985875]  [<c125f5a0>] serio_connect_driver+0x30/0x50
[    8.988324]  [<c125f5d8>] serio_driver_probe+0x18/0x20
[    8.990308]  [<c11e8a90>] driver_probe_device+0xa0/0x290
[    8.991910]  [<c11e8eea>] __driver_attach+0x7a/0x80
[    8.993823]  [<c11e7ef9>] bus_for_each_dev+0x49/0x70
[    8.995192]  [<c11e889e>] driver_attach+0x1e/0x20
[    8.998043]  [<c11e8e70>] ? __driver_attach+0x0/0x80
[    8.999406]  [<c1260363>] serio_thread+0x2b3/0x320
[    9.001158]  [<c1054e20>] ? autoremove_wake_function+0x0/0x50
[    9.002699]  [<c12600b0>] ? serio_thread+0x0/0x320
[    9.004027]  [<c1054bb4>] kthread+0x74/0x80
[    9.005492]  [<c1054b40>] ? kthread+0x0/0x80
[    9.006651]  [<c1003897>] kernel_thread_helper+0x7/0x10

> I don't think we should add SLAB_NOLEAKTRACE to slabmgmt since in theory
> it should work. Is there a slabmgmt allocated for each
> kmem_cache_alloc()? If yes, it will indeed get into infinite recursive
> calls. If not, kmemleak should be able to cope though in some situations
> it may still overflow.
Will you tell me how to check it? (Some /proc file?)

Regards.
