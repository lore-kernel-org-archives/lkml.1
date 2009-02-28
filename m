Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZB1Sc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZB1Sc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZB1ScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:32:21 -0500
Received: from ppp-111-75.adsl.restena.lu ([158.64.111.75]:52236 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752574AbZB1ScT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:32:19 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Feb 2009 13:32:17 EST
Date: Sat, 28 Feb 2009 19:24:06 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Eric Anholt <eric@anholt.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       airlied@linux.ie, keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: i915 X lockup
Message-ID: <20090228192406.496257b2@neptune.home>
In-Reply-To: <1235811657.6992.77.camel@gaiman>
References: <49A7B253.906@gmail.com>
	<20090227023231.76e7c65f.akpm@linux-foundation.org>
	<20090227130440.GA24633@silver.sucs.org>
	<49A7EF52.8080105@gmail.com>
	<20090227231207.GA4687@silver.sucs.org>
	<1235780431.6992.14.camel@gaiman>
	<49A8F660.10604@gmail.com>
	<20090228004751.96d1ea8d.akpm@linux-foundation.org>
	<1235811657.6992.77.camel@gaiman>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 February 2009 Eric Anholt <eric@anholt.net> wrote:
> On Sat, 2009-02-28 at 00:47 -0800, Andrew Morton wrote:
> > The kernel deadlocked on struct_mutex, did it not?  That's a kernel
> > bug regardless of what userspace you're running.
> > 
> > Do we know why this happened?
> 
> Userland went stomping all over the device state that the kernel
> thinks it controls since you went and turned on the KMS option
> asserting "I'm not going to run old userland", so the GPU got hung,
> and further software using the GPU hung, and then somebody waiting
> for someone else finishing using the GPU (struct_mutex) got hung.
> 
> The only proposal to prevent it is to use the "don't let userland map
> my PCI device any more" support we now have available to us, which
> would make X fail early on.  The unfortunate side-effect of that is
> that we lose the ability to run incredibly useful userland debug
> tools that do read-only access to registers.  We're moving bits of
> those into debugfs for 2.6.30, but it's work that's not done even for
> the tools we have today.

I also saw/see Xorg lockup...

I'm running xf86-video-intel-2.6.1 (2.6.2 released only very recently)
and kernel with KMS disabled (KMS not capable of getting framebuffer
properly configured it seems, at least display remains black)

For me it's a deadlock between intel driver dispatching GEM requests
and events (see log below).
For me each time it happends was while interacting with a webbrowser,
though it does not happend very often.

Connecting to the notebook via ssh I can kill -KILL Xorg (kill -TERM
does not work).
When doing this GPU gets at least confused though in order to get
vesafb back working it's sufficient to start Xorg with vesa driver
(running with intel driver before rebooting leads to locked X and
need to retry the killing)

Bruno


Graphics card:
00:02.0 VGA compatible controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Acer Incorporated [ALI] Device 0035
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
        Region 1: Memory at e0000000 (32-bit, non-prefetchable) [size=512K]
        Region 2: I/O ports at 1800 [size=8]
        Capabilities: [d0] Power Management version 1
                Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
        Subsystem: Acer Incorporated [ALI] Device 0035
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
        Region 1: Memory at e0080000 (32-bit, non-prefetchable) [size=512K]
        Capabilities: [d0] Power Management version 1
                Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

drm debug output around lock time + sysreq+t task traces:
Feb 28 18:12:16 [kernel] [27945.376131] [drm:drm_agp_bind_pages] 
Feb 28 18:12:16 [kernel] [27945.376162] [drm:i915_add_request] 3688298
Feb 28 18:12:16 [kernel] [27945.376169] [drm:i915_add_request] 3688299
Feb 28 18:12:16 [kernel] [27945.376181] [drm:drm_ioctl] pid=6673, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
Feb 28 18:12:16 [kernel] [27945.376192] [drm:drm_ioctl] pid=6673, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
Feb 28 18:12:16 [kernel] [27945.376204] [drm:drm_ioctl] pid=6673, cmd=0x6458, nr=0x58, dev 0xe200, auth=1
Feb 28 18:12:16 [kernel] [27945.390764] [drm:drm_ioctl] ret = fffffe00
Feb 28 18:12:16 [kernel] [27945.390831] [drm:drm_ioctl] pid=6673, cmd=0x6458, nr=0x58, dev 0xe200, auth=1
Feb 28 18:12:16 [kernel] [27945.403653] [drm:drm_ioctl] ret = fffffe00
Feb 28 18:12:16 [kernel] [27945.403697] [drm:drm_ioctl] pid=6673, cmd=0x6458, nr=0x58, dev 0xe200, auth=1
Feb 28 18:12:16 [kernel] [27945.416451] [drm:drm_ioctl] ret = fffffe00
Feb 28 18:12:16 [kernel] [27945.416500] [drm:drm_ioctl] pid=6673, cmd=0x6458, nr=0x58, dev 0xe200, auth=1
Feb 28 18:12:16 [kernel] [27945.430630] [drm:drm_ioctl] ret = fffffe00
Feb 28 18:12:16 [kernel] [27945.430677] [drm:drm_ioctl] pid=6673, cmd=0x6458, nr=0x58, dev 0xe200, auth=1
... (same message repeating lots of time ...)
Feb 28 18:12:56 [kernel] [27986.140232] [drm:drm_ioctl] ret = fffffe00
Feb 28 18:12:56 [kernel] [27986.140274] [drm:drm_ioctl] pid=6673, cmd=0x6458, nr=0x58, dev 0xe200, auth=1
Feb 28 18:16:00 [kernel] [28169.605072] SysRq : Show State
Feb 28 18:16:00 [kernel] [28169.605085]   task                PC stack   pid father
Feb 28 18:16:00 [kernel] [28169.605092] init          S 00000000  1188     1      0
Feb 28 18:16:00 [kernel] [28169.605104]  dd814ae4 00000086 004c4b3e 00000000 00000296 dd82a000 00000286 00000000
Feb 28 18:16:00 [kernel] [28169.605120]  004c4b3e 004c4b3e 00000000 dd814b4c c036b4b7 004c4b3e 00000000 da6d3dfc
Feb 28 18:16:00 [kernel] [28169.605134]  dd2d1b94 da785b94 908c73bf 0000199f 90402881 0000199f c0133610 c046e72c
Feb 28 18:16:00 [kernel] [28169.605149] Call Trace:
Feb 28 18:16:00 [kernel] [28169.605170]  [<c036b4b7>] schedule_hrtimeout_range+0xb7/0x100
Feb 28 18:16:00 [kernel] [28169.605185]  [<c0133610>] ? hrtimer_wakeup+0x0/0x20
Feb 28 18:16:00 [kernel] [28169.605195]  [<c036b4a0>] ? schedule_hrtimeout_range+0xa0/0x100
Feb 28 18:16:00 [kernel] [28169.605207]  [<c0175b80>] poll_schedule_timeout+0x30/0x60
Feb 28 18:16:00 [kernel] [28169.605216]  [<c01762b8>] do_select+0x448/0x5b0
Feb 28 18:16:00 [kernel] [28169.605226]  [<c0175c50>] ? __pollwait+0x0/0xd0
Feb 28 18:16:00 [kernel] [28169.605234]  [<c0175d20>] ? pollwake+0x0/0x60
Feb 28 18:16:00 [kernel] [28169.605245]  [<c01e30e1>] ? cfq_insert_request+0x31/0x390
Feb 28 18:16:00 [kernel] [28169.605256]  [<c01d8f76>] ? elv_insert+0x116/0x180
Feb 28 18:16:00 [kernel] [28169.605266]  [<c01d9b4f>] ? part_round_stats+0x3f/0x50
Feb 28 18:16:00 [kernel] [28169.605274]  [<c01d9049>] ? __elv_add_request+0x69/0xb0
Feb 28 18:16:00 [kernel] [28169.605284]  [<c01db466>] ? __make_request+0xa6/0x300
Feb 28 18:16:00 [kernel] [28169.605294]  [<c01489fe>] ? mempool_alloc_slab+0xe/0x10
Feb 28 18:16:00 [kernel] [28169.605303]  [<c01489fe>] ? mempool_alloc_slab+0xe/0x10
Feb 28 18:16:00 [kernel] [28169.605311]  [<c0148adc>] ? mempool_alloc+0x2c/0xc0
Feb 28 18:16:00 [kernel] [28169.605323]  [<c028be95>] ? scsi_pool_alloc_command+0x45/0x70
Feb 28 18:16:00 [kernel] [28169.605334]  [<c0290467>] ? scsi_init_sgtable+0x47/0xa0
Feb 28 18:16:00 [kernel] [28169.605343]  [<c0291fc0>] ? scsi_sg_alloc+0x0/0x50
Feb 28 18:16:00 [kernel] [28169.605351]  [<c0290674>] ? scsi_init_io+0x14/0xa0
Feb 28 18:16:00 [kernel] [28169.605361]  [<c014a6ca>] ? __rmqueue+0x9a/0x1a0
Feb 28 18:16:00 [kernel] [28169.605371]  [<c0178b39>] ? __d_lookup+0xa9/0xe0
Feb 28 18:16:00 [kernel] [28169.605383]  [<c0171f40>] ? do_lookup+0x60/0x190
Feb 28 18:16:00 [kernel] [28169.605392]  [<c0163c8d>] ? shmem_permission+0xd/0x10
Feb 28 18:16:00 [kernel] [28169.605402]  [<c0176bca>] core_sys_select+0x1ba/0x2e0
Feb 28 18:16:00 [kernel] [28169.605412]  [<c0170cf0>] ? path_put+0x20/0x30
Feb 28 18:16:00 [kernel] [28169.605421]  [<c0172b4b>] ? path_walk+0x4b/0x90
Feb 28 18:16:00 [kernel] [28169.605431]  [<c01ea1e7>] ? __copy_to_user_ll+0x57/0x60
Feb 28 18:16:00 [kernel] [28169.605440]  [<c01ea61e>] ? copy_to_user+0x3e/0x60
Feb 28 18:16:00 [kernel] [28169.605449]  [<c016cc8b>] ? cp_new_stat64+0xeb/0x100
Feb 28 18:16:00 [kernel] [28169.605460]  [<c0115fed>] ? read_hpet+0xd/0x20
Feb 28 18:16:00 [kernel] [28169.605470]  [<c0136f9b>] ? getnstimeofday+0x4b/0x110
Feb 28 18:16:00 [kernel] [28169.605482]  [<c0123997>] ? timespec_add_safe+0x27/0x50
Feb 28 18:16:00 [kernel] [28169.605491]  [<c0176e9c>] sys_select+0x2c/0xb0
Feb 28 18:16:00 [kernel] [28169.605501]  [<c01030c5>] sysenter_do_call+0x12/0x25
Feb 28 18:16:00 [kernel] [28169.605508] kthreadd      S 00000286  3384     2      0
Feb 28 18:16:00 [kernel] [28169.605522]  dd81dfc0 00000046 da996bd8 00000286 000008b1 dd82a330 dd81dfc0 00000286
Feb 28 18:16:00 [kernel] [28169.605536]  c046e6d0 000008b1 da996bbc dd81dfe0 c0130a25 00000000 00000001 00000001
Feb 28 18:16:00 [kernel] [28169.605550]  c01309a0 00000000 00000000 00000000 c01037df 00000000 00000000 00000000
Feb 28 18:16:00 [kernel] [28169.605563] Call Trace:
Feb 28 18:16:00 [kernel] [28169.605573]  [<c0130a25>] kthreadd+0x85/0x120
Feb 28 18:16:00 [kernel] [28169.605582]  [<c01309a0>] ? kthreadd+0x0/0x120
Feb 28 18:16:00 [kernel] [28169.605590]  [<c01037df>] kernel_thread_helper+0x7/0x18
Feb 28 18:16:00 [kernel] [28169.605596] ksoftirqd/0   S 00000246  3764     3      2
Feb 28 18:16:00 [kernel] [28169.605611]  dd81ffc0 00000046 00000000 00000246 c0124040 dd82a660 00000246 dd81ffb8
Feb 28 18:16:00 [kernel] [28169.605625]  00000000 00000000 c0124040 dd81ffcc c01240bc fffffffc dd81ffe0 c0130972
Feb 28 18:16:00 [kernel] [28169.605639]  c0130930 00000000 00000000 00000000 c01037df dd814f00 00000000 00000000
Feb 28 18:16:00 [kernel] [28169.605652] Call Trace:
Feb 28 18:16:00 [kernel] [28169.605661]  [<c0124040>] ? ksoftirqd+0x0/0xb0
Feb 28 18:16:00 [kernel] [28169.605671]  [<c0124040>] ? ksoftirqd+0x0/0xb0
Feb 28 18:16:00 [kernel] [28169.605680]  [<c01240bc>] ksoftirqd+0x7c/0xb0
Feb 28 18:16:00 [kernel] [28169.605688]  [<c0130972>] kthread+0x42/0x70
Feb 28 18:16:00 [kernel] [28169.605697]  [<c0130930>] ? kthread+0x0/0x70
Feb 28 18:16:00 [kernel] [28169.605705]  [<c01037df>] kernel_thread_helper+0x7/0x18
Feb 28 18:16:00 [kernel] [28169.605711] events/0      D c011b912  2496     4      2
Feb 28 18:16:00 [kernel] [28169.605724]  dd830f34 00000046 dd830f34 c011b912 dd8c0cc0 dd82a990 2ad00b71 000007af
Feb 28 18:16:00 [kernel] [28169.605738]  dd914810 ffffffff dd914814 dd830f58 c036b22e dd82a990 dd914814 dd914814
Feb 28 18:16:00 [kernel] [28169.605752]  dd82a990 dd914810 dd822000 dd822ea8 dd830f68 c036b199 dd8e9828 dd914800
Feb 28 18:16:00 [kernel] [28169.605766] Call Trace:
Feb 28 18:16:00 [kernel] [28169.605797]  [<c036b199>] mutex_lock+0x19/0x20
Feb 28 18:16:00 [kernel] [28169.605808]  [<c0271998>] i915_gem_retire_work_handler+0x28/0x70
Feb 28 18:16:00 [kernel] [28169.605818]  [<c0271970>] ? i915_gem_retire_work_handler+0x0/0x70
Feb 28 18:16:00 [kernel] [28169.605827]  [<c012d937>] run_workqueue+0x67/0xe0
Feb 28 18:16:00 [kernel] [28169.605835]  [<c012dbf7>] worker_thread+0x97/0xf0
Feb 28 18:16:00 [kernel] [28169.605845]  [<c0130cf0>] ? autoremove_wake_function+0x0/0x50
Feb 28 18:16:00 [kernel] [28169.605854]  [<c012db60>] ? worker_thread+0x0/0xf0
Feb 28 18:16:00 [kernel] [28169.605862]  [<c0130972>] kthread+0x42/0x70
Feb 28 18:16:00 [kernel] [28169.605871]  [<c0130930>] ? kthread+0x0/0x70
Feb 28 18:16:00 [kernel] [28169.605879]  [<c01037df>] kernel_thread_helper+0x7/0x18
Feb 28 18:16:00 [kernel] [28169.605885] khelper       S c012d937  3300     5      2
Feb 28 18:16:00 [kernel] [28169.605899]  dd831fa4 00000046 dd831fa4 c012d937 dd845980 dd82acc0 c0464180 00000246
Feb 28 18:16:00 [kernel] [28169.605913]  dd808208 dd808200 dd831fac dd831fcc c012dc27 00000000 dd82acc0 c0130cf0
Feb 28 18:16:00 [kernel] [28169.605927]  dd808208 dd808208 fffffffc dd808200 c012db60 dd831fe0 c0130972 c0130930
Feb 28 18:16:00 [kernel] [28169.605941] Call Trace:
Feb 28 18:16:00 [kernel] [28169.605948]  [<c012d937>] ? run_workqueue+0x67/0xe0
Feb 28 18:16:00 [kernel] [28169.605957]  [<c012dc27>] worker_thread+0xc7/0xf0
Feb 28 18:16:00 [kernel] [28169.605966]  [<c0130cf0>] ? autoremove_wake_function+0x0/0x50
Feb 28 18:16:00 [kernel] [28169.605975]  [<c012db60>] ? worker_thread+0x0/0xf0
Feb 28 18:16:00 [kernel] [28169.605983]  [<c0130972>] kthread+0x42/0x70
Feb 28 18:16:00 [kernel] [28169.605992]  [<c0130930>] ? kthread+0x0/0x70
Feb 28 18:16:00 [kernel] [28169.606000]  [<c01037df>] kernel_thread_helper+0x7/0x18
  (... skipping over non-related processes ...)
Feb 28 18:16:00 [kernel] [28169.614590] agetty        S c0489794  1552  6664      1
Feb 28 18:16:00 [kernel] [28169.614590]  da94aea4 00000082 c1029ba0 c0489794 00000292 dd0ddcb0 00000292 00000001
Feb 28 18:16:00 [kernel] [28169.614590]  7fffffff 00000000 da8a5800 da94aeec c036adb5 00000202 da94aeb8 00000046
Feb 28 18:16:00 [kernel] [28169.614590]  da8a5800 da94aedc 00000246 00000246 000091c3 00000000 da8a5800 da8a5800
Feb 28 18:16:00 [kernel] [28169.614590] Call Trace:
Feb 28 18:16:00 [kernel] [28169.614590]  [<c036adb5>] schedule_timeout+0x75/0xc0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c024264b>] n_tty_read+0x1ab/0x5a0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c011d490>] ? default_wake_function+0x0/0x10
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0240156>] tty_read+0x76/0xb0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c02424a0>] ? n_tty_read+0x0/0x5a0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c016a000>] vfs_read+0x90/0x110
Feb 28 18:16:00 [kernel] [28169.614590]  [<c02400e0>] ? tty_read+0x0/0xb0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c016a4fd>] sys_read+0x3d/0x70
Feb 28 18:16:00 [kernel] [28169.614590]  [<c01030c5>] sysenter_do_call+0x12/0x25
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0360000>] ? __inet6_lookup_established+0x2e0/0x4d0
Feb 28 18:16:00 [kernel] [28169.614590] Xorg          S 000223f2  1588  6673      1
Feb 28 18:16:00 [kernel] [28169.614590]  dd082e74 00003082 00006d52 000223f2 00000000 dd8c0cc0 00000007 00003246
Feb 28 18:16:00 [kernel] [28169.614590]  00000000 dd914800 0038476b dd082ebc c0271891 5d343732 ffff0020 00000000
Feb 28 18:16:00 [kernel] [28169.614590]  80000000 0000bffc 00000000 dd822084 dd822000 00000000 dd8c0cc0 c0130cf0
Feb 28 18:16:00 [kernel] [28169.614590] Call Trace:
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0271891>] i915_wait_request+0x141/0x1a0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0130cf0>] ? autoremove_wake_function+0x0/0x50
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0271925>] i915_gem_throttle_ioctl+0x35/0x50
Feb 28 18:16:00 [kernel] [28169.614590]  [<c025e0f0>] drm_ioctl+0xe0/0x2b0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c02718f0>] ? i915_gem_throttle_ioctl+0x0/0x50
Feb 28 18:16:00 [kernel] [28169.614590]  [<c025e010>] ? drm_ioctl+0x0/0x2b0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0174b27>] vfs_ioctl+0x67/0x70
Feb 28 18:16:00 [kernel] [28169.614590]  [<c01750fa>] do_vfs_ioctl+0x1fa/0x520
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0109751>] ? restore_i387_xstate+0xd1/0x1d0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0115fed>] ? read_hpet+0xd/0x20
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0136f9b>] ? getnstimeofday+0x4b/0x110
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0102518>] ? restore_sigcontext+0xf8/0x120
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0175459>] sys_ioctl+0x39/0x60
Feb 28 18:16:00 [kernel] [28169.614590]  [<c01030c5>] sysenter_do_call+0x12/0x25
Feb 28 18:16:00 [kernel] [28169.614590] enlightenment S 0001579d  1544  6681      1
Feb 28 18:16:00 [kernel] [28169.614590]  dd23eb84 00000082 c01763e8 0001579d dd23ee68 da5e9cb0 c4e2db00 00000000
Feb 28 18:16:00 [kernel] [28169.614590]  00000000 00000000 00000000 dd23ebec c036b4df 00000000 00000001 00000000
Feb 28 18:16:00 [kernel] [28169.614590]  dd23ee70 dd23ee74 dd23ee78 dd23ee68 dd23ee6c dd23ee70 50008ab0 00000246
Feb 28 18:16:00 [kernel] [28169.614590] Call Trace:
Feb 28 18:16:00 [kernel] [28169.614590]  [<c01763e8>] ? do_select+0x578/0x5b0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c036b4df>] schedule_hrtimeout_range+0xdf/0x100
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0175cbf>] ? __pollwait+0x6f/0xd0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0175b80>] poll_schedule_timeout+0x30/0x60
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0176662>] do_sys_poll+0x242/0x3e0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0175c50>] ? __pollwait+0x0/0xd0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0175d20>] ? pollwake+0x0/0x60
                - Last output repeated 2 times -
Feb 28 18:16:00 [kernel] [28169.614590]  [<c014a6ca>] ? __rmqueue+0x9a/0x1a0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c014ad2b>] ? get_page_from_freelist+0x3db/0x450
Feb 28 18:16:00 [kernel] [28169.614590]  [<c01489fe>] ? mempool_alloc_slab+0xe/0x10
Feb 28 18:16:00 [kernel] [28169.614590]  [<c014b194>] ? __alloc_pages_internal+0x94/0x400
Feb 28 18:16:00 [kernel] [28169.614590]  [<c014b51c>] ? __get_free_pages+0x1c/0x40
Feb 28 18:16:00 [kernel] [28169.614590]  [<c016741b>] ? __kmalloc_track_caller+0xbb/0xe0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c02daf8b>] ? __alloc_skb+0x4b/0x100
Feb 28 18:16:00 [kernel] [28169.614590]  [<c036b18e>] ? mutex_lock+0xe/0x20
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0334cea>] ? unix_stream_recvmsg+0x1ea/0x450
Feb 28 18:16:00 [kernel] [28169.614590]  [<c02d6b36>] ? sock_aio_read+0xe6/0x110
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0169e7c>] ? do_sync_read+0xcc/0x110
Feb 28 18:16:00 [kernel] [28169.614590]  [<c033464e>] ? unix_ioctl+0x9e/0xd0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0130cf0>] ? autoremove_wake_function+0x0/0x50
Feb 28 18:16:00 [kernel] [28169.614590]  [<c016a07b>] ? vfs_read+0x10b/0x110
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0176964>] sys_poll+0x54/0xb0
Feb 28 18:16:00 [kernel] [28169.614590]  [<c01030c5>] sysenter_do_call+0x12/0x25
Feb 28 18:16:00 [kernel] [28169.614590]  [<c0360000>] ? __inet6_lookup_established+0x2e0/0x4d0
  (... skipping over unrelated processes ...)

