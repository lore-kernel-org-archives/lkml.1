Return-Path: <linux-kernel-owner+w=401wt.eu-S1763879AbXJQKxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763879AbXJQKxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbXJQKxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:53:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54875 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753687AbXJQKxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:53:36 -0400
Date: Wed, 17 Oct 2007 03:53:27 -0700
From: Paul Jackson <pj@sgi.com>
To: ego@in.ibm.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, rusty@rustcorp.com.au,
       dipankar@in.ibm.com, oleg@tv-sign.ru, mingo@elte.hu, paulmck@us.ibm.com
Subject: Re: [RFC PATCH 1/4] Refcount Based Cpu-Hotplug Implementation
Message-Id: <20071017035327.ff1ed622.pj@sgi.com>
In-Reply-To: <20071016103417.GA16570@in.ibm.com>
References: <20071016103308.GA9907@in.ibm.com>
	<20071016103417.GA16570@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch dies on boot for me, using sn2_defconfig.  It is dies on
the kernel/cpu.c line:

  mutex_lock(&cpu_hotplug.lock);

This is in cpu_hotplug_begin(), called from _cpu_up(), called from
cpu_up().

I haven't finished verifying this yet, but it looks like the
initialization of the mutex cpu_hotplug.lock in cpu_hotplug_init()
only happens if CONFIG_HOTPLUG_CPU is enabled, but the use of that
mutex in the above mutex_lock() call happens on all configs.

In the sn2_defconfig I'm using, as well as in several other ia64,
mips and powerpc configs, CONFIG_HOTPLUG_CPU is, at present anyway,
disabled.

For the record, the kernel death messages are:

===

Unable to handle kernel NULL pointer dereference (address 0000000000000000)
swapper[1]: Oops 8804682956800 [1]
Modules linked in:

Pid: 1, CPU 0, comm:              swapper
psr : 00001010085a2010 ifs : 800000000000038b ip  : [<a00000010081e080>]    Not tainted
ip is at __mutex_lock_slowpath+0x280/0x660
unat: 0000000000000000 pfs : 000000000000038b rsc : 0000000000000003
rnat: 1fcc5c7d8b12a4b4 bsps: 000000000001003e pr  : 0000000000001041
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000010081e040 b6  : e0000030025bee60 b7  : a0000001005315c0
f6  : 1003e1111111111111111 f7  : 1003e20c49ba5e353f7cf
f8  : 1003e00000000000000c8 f9  : 10006c7fffffffd73ea5c
f10 : 100019ffffffff8a77fd5 f11 : 1003e0000000000000000
r1  : a000000101064760 r2  : a00000010118ef80 r3  : e00000b020377b20
r8  : e00000b020377d00 r9  : 0000000000004000 r10 : e00000b020370b58
r11 : e00000b020370000 r12 : e00000b020377cf0 r13 : e00000b020370000
r14 : 0000000000000001 r15 : e00000b020377d18 r16 : e00000b020377768
r17 : 00000000dead4ead r18 : a000000100d01380 r19 : a000000100e68300
r20 : 0000000000004000 r21 : 0000000000000010 r22 : 0000000000000000
r23 : 0000000000000000 r24 : 0000000000004000 r25 : ffffffffffffffff
r26 : e00000b020377d10 r27 : 0000000000000000 r28 : e00000b020377d00
r29 : e00000b020377d08 r30 : a00000010118efa0 r31 : a00000010118ef98

Call Trace:
 [<a000000100013a60>] show_stack+0x40/0xa0
                                sp=e00000b0203778c0 bsp=e00000b020370f80
 [<a000000100014360>] show_regs+0x840/0x880
                                sp=e00000b020377a90 bsp=e00000b020370f28
 [<a000000100036460>] die+0x220/0x300
                                sp=e00000b020377a90 bsp=e00000b020370ee0
 [<a000000100059cd0>] ia64_do_page_fault+0x910/0xa80
                                sp=e00000b020377a90 bsp=e00000b020370e90
 [<a00000010000b120>] ia64_leave_kernel+0x0/0x280
                                sp=e00000b020377b20 bsp=e00000b020370e90
 [<a00000010081e080>] __mutex_lock_slowpath+0x280/0x660
                                sp=e00000b020377cf0 bsp=e00000b020370e38
 [<a00000010081e4a0>] mutex_lock+0x40/0x60
                                sp=e00000b020377d20 bsp=e00000b020370e18
 [<a000000100a2c7e0>] cpu_up+0x220/0x6a0
                                sp=e00000b020377d20 bsp=e00000b020370dd0
 [<a000000100a044d0>] kernel_init+0x250/0x7e0
                                sp=e00000b020377d30 bsp=e00000b020370d88
 [<a000000100011fd0>] kernel_thread_helper+0xd0/0x100
                                sp=e00000b020377e30 bsp=e00000b020370d60
 [<a000000100008dc0>] start_kernel_thread+0x20/0x40
                                sp=e00000b020377e30 bsp=e00000b020370d60
Kernel panic - not syncing: Attempted to kill init!


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
