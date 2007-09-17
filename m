Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbXIQS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbXIQS1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbXIQS1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59362 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbXIQS1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=iRVqfddCcsD39snLZCi17zmQC7ShjdD9IrGv8YZpwFFOFT0Pga8XBbGlz5X3oLOZs
	t2ty8BszdvkBSDNXyS4xQ==
Message-ID: <6599ad830709171126l7f178404tbb37e916767a3956@mail.gmail.com>
Date: Mon, 17 Sep 2007 11:26:51 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: task containersv11 kernel BUG at include/linux/dcache.h:323
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070916045438.9585.46625.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070916045438.9585.46625.sendpatchset@jackhammer.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is already fixed in -mm - see

task-containersv11-basic-task-container-framework-containers-fix-refcount-bug.patch
task-containersv11-add-container_clone-interface-containers-fix-refcount-bug.patch

Paul

On 9/15/07, Paul Jackson <pj@sgi.com> wrote:
> Paul Menage,
>
> When I run a cpuset creation/destruction stress test I have
> against the 2.6.23-rc4-mm1 kernel with the task-containersv11-*
> patches, I get an BUG or similar within a couple of seconds,
> apparently over some fs lock or count confusions.
>
> When I add Andrew Morton's (Thanks, Andrew!) very recent patch:
>
> --- 2.6.23-rc4-mm1.orig/fs/dcache.c     2007-09-14 21:30:19.504902465 -0700
> +++ 2.6.23-rc4-mm1/fs/dcache.c  2007-09-15 09:48:40.306230196 -0700
> @@ -176,6 +176,7 @@ void dput(struct dentry *dentry)
>         if (!dentry)
>                 return;
>
> +       WARN_ON_ONCE(!atomic_read(&dentry->d_count));
>  repeat:
>         if (atomic_read(&dentry->d_count) == 1)
>                 might_sleep();
>
> ... then I get a warning first from the above line, resulting
> in the following messages, showing the warning and then the
> subsequent BUG:
>
> Sep 15 21:41:45 margin kernel: WARNING: at fs/dcache.c:179 dput()
> Sep 15 21:41:45 margin kernel:
> Sep 15 21:41:45 margin kernel: Call Trace:
> Sep 15 21:41:45 margin kernel:  [<a0000001000139c0>] show_stack+0x40/0xa0
> Sep 15 21:41:45 margin kernel:                                 sp=e00000b05003fbd0 bsp=e00000b050038e20
> Sep 15 21:41:45 margin kernel:  [<a000000100013a50>] dump_stack+0x30/0x60
> Sep 15 21:41:45 margin kernel:                                 sp=e00000b05003fda0 bsp=e00000b050038e08
> Sep 15 21:41:45 margin kernel:  [<a0000001001a60c0>] dput+0xa0/0x420
> Sep 15 21:41:45 margin kernel:                                 sp=e00000b05003fda0 bsp=e00000b050038dd8
> Sep 15 21:41:45 margin kernel:  [<a000000100193f00>] do_rmdir+0x160/0x200
> Sep 15 21:41:45 margin kernel:                                 sp=e00000b05003fda0 bsp=e00000b050038da0
> Sep 15 21:41:45 margin kernel:  [<a000000100194070>] sys_rmdir+0x30/0x60
> Sep 15 21:41:45 margin kernel:                                 sp=e00000b05003fe30 bsp=e00000b050038d48
> Sep 15 21:41:45 margin kernel:  [<a00000010000af80>] ia64_ret_from_syscall+0x0/0x20
> Sep 15 21:41:45 margin kernel:                                 sp=e00000b05003fe30 bsp=e00000b050038d48
> Sep 15 21:41:45 margin kernel:  [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
> Sep 15 21:41:45 margin kernel:                                 sp=e00000b050040000 bsp=e00000b050038d48
> Sep 15 21:41:46 margin kernel: kernel BUG at include/linux/dcache.h:323!
> Sep 15 21:41:46 margin kernel: cpuset_creation[5590]: bugcheck! 0 [1]
> Sep 15 21:41:46 margin kernel: Modules linked in:
> Sep 15 21:41:46 margin kernel:
> Sep 15 21:41:46 margin kernel: Pid: 5590, CPU 0, comm:      cpuset_creation
> Sep 15 21:41:46 margin kernel: psr : 00001010085a6010 ifs : 800000000000048c ip  : [<a000000100193280>]    Not tainted
> Sep 15 21:41:46 margin kernel: ip is at do_path_lookup+0x480/0x540
> Sep 15 21:41:46 margin kernel: unat: 0000000000000000 pfs : 000000000000048c rsc : 0000000000000003
> Sep 15 21:41:46 margin kernel: rnat: 0000000000000000 bsps: 0000000000000000 pr  : 000000000055a959
> Sep 15 21:41:46 margin kernel: ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
> Sep 15 21:41:46 margin kernel: csd : 0000000000000000 ssd : 0000000000000000
> Sep 15 21:41:46 margin kernel: b0  : a000000100193280 b6  : a000000100093960 b7  : a00000010000f0b0
> Sep 15 21:41:46 margin kernel: f6  : 1003e0000000000000000 f7  : 000000000000000000000
> Sep 15 21:41:46 margin kernel: f8  : 000000000000000000000 f9  : 1003e000000000001c000
> Sep 15 21:41:46 margin kernel: f10 : 1003e0000000000000070 f11 : 1003e0000000000000400
> Sep 15 21:41:46 margin kernel: r1  : a000000101074460 r2  : e000003016fa0ce0 r3  : 0000000000000002
> Sep 15 21:41:46 margin kernel: r8  : 000000000000002d r9  : 0000000000004000 r10 : e000003003105619
> Sep 15 21:41:46 margin kernel: r11 : e000003003110000 r12 : e000003016fa7d80 r13 : e000003016fa0000
> Sep 15 21:41:46 margin kernel: r14 : 0000000000000000 r15 : e000003016fa0cf0 r16 : e000003016fa0d08
> Sep 15 21:41:46 margin kernel: r17 : e00001b008397e18 r18 : 0000000000000001 r19 : e00000300310561b
> Sep 15 21:41:46 margin kernel: r20 : 0000000000004000 r21 : 0000000000004000 r22 : e000003003110000
> Sep 15 21:41:46 margin kernel: r23 : ffffffffffff0428 r24 : 0000018110000380 r25 : 0000018000000000
> Sep 15 21:41:46 margin kernel: r26 : e000003016fa0cf0 r27 : e000003016fa0ce0 r28 : e000003016fa0d08
> Sep 15 21:41:46 margin kernel: r29 : 0000000000000001 r30 : 0000000000000002 r31 : 0000000000001060
> Sep 15 21:41:46 margin kernel:
> Sep 15 21:41:46 margin kernel: Call Trace:
> Sep 15 21:41:46 margin kernel:  [<a0000001000139c0>] show_stack+0x40/0xa0
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7950 bsp=e000003016fa10d0
> Sep 15 21:41:47 margin kernel:  [<a0000001000142c0>] show_regs+0x840/0x880
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7b20 bsp=e000003016fa1078
> Sep 15 21:41:47 margin kernel:  [<a0000001000362a0>] die+0x220/0x300
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7b20 bsp=e000003016fa1030
> Sep 15 21:41:47 margin kernel:  [<a0000001000363d0>] die_if_kernel+0x50/0x80
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7b20 bsp=e000003016fa1000
> Sep 15 21:41:47 margin kernel:  [<a000000100037af0>] ia64_bad_break+0x230/0x480
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7b20 bsp=e000003016fa0fd0
> Sep 15 21:41:47 margin kernel:  [<a00000010000b120>] ia64_leave_kernel+0x0/0x280
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7bb0 bsp=e000003016fa0fd0
> Sep 15 21:41:47 margin kernel:  [<a000000100193280>] do_path_lookup+0x480/0x540
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7d80 bsp=e000003016fa0f70
> Sep 15 21:41:47 margin kernel:  [<a000000100194ac0>] __path_lookup_intent_open+0x80/0x120
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7d90 bsp=e000003016fa0f18
> Sep 15 21:41:47 margin kernel:  [<a000000100194c60>] path_lookup_open+0x40/0x60
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7d90 bsp=e000003016fa0ed8
> Sep 15 21:41:47 margin kernel:  [<a000000100194f30>] open_namei+0xb0/0xf80
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7d90 bsp=e000003016fa0e70
> Sep 15 21:41:47 margin kernel:  [<a000000100177a10>] do_filp_open+0x50/0xc0
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7da0 bsp=e000003016fa0e38
> Sep 15 21:41:47 margin kernel:  [<a000000100177b00>] do_sys_open+0x80/0x1c0
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7e30 bsp=e000003016fa0de0
> Sep 15 21:41:47 margin kernel:  [<a000000100177d10>] sys_open+0x50/0x80
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7e30 bsp=e000003016fa0d88
> Sep 15 21:41:47 margin kernel:  [<a00000010000af80>] ia64_ret_from_syscall+0x0/0x20
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa7e30 bsp=e000003016fa0d88
> Sep 15 21:41:47 margin kernel:  [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
> Sep 15 21:41:47 margin kernel:                                 sp=e000003016fa8000 bsp=e000003016fa0d88
> Sep 15 21:41:47 margin kernel: note: cpuset_creation[5590] exited with preempt_count 1
>
> ===
>
> Can you figure out where this is coming from?  It is not
> in code that I understand all that well, so I am hoping
> that I don't have to spend hours poking around in it to
> make sense of the problem.
>
> --
>                           I won't rest till it's the best ...
>                           Programmer, Linux Scalability
>                           Paul Jackson <pj@sgi.com> 1.650.933.1373
>
