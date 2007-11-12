Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbXKLVSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbXKLVSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXKLVRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:17:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:46892 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXKLVRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:17:53 -0500
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on
	POWER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: paulmck@linux.vnet.ibm.com
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       tony@bakeyournoodle.com, paulus@samba.org, dino@in.ibm.com,
       tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com, antonb@us.ibm.com
In-Reply-To: <20071112191526.GC11113@linux.vnet.ibm.com>
References: <20071109181028.GA26800@linux.vnet.ibm.com>
	 <1194641524.21340.14.camel@pasglop>
	 <20071109220717.GJ8826@linux.vnet.ibm.com>
	 <1194753541.21340.26.camel@pasglop>
	 <Pine.LNX.4.58.0711110943510.12853@gandalf.stny.rr.com>
	 <1194814125.6510.14.camel@pasglop>
	 <20071112191526.GC11113@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 08:12:05 +1100
Message-Id: <1194901925.18185.65.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> And here is an updated patch.  There has to be a better way than the
> #ifdef, but I need the two local variables, and breaking the intervening
> code out into a separate function didn't quite seem right either.
> 
> Thoughts?

Nothing comes to mind right now...

> This one does only one oops during boot-up, which I will start looking
> at:
> 
> BUG: sleeping function called from invalid context ifconfig(994) at kernel/rtmutex.c:637
> in_atomic():1 [00000002], irqs_disabled():1
> Call Trace:
> [c0000000ff49f030] [c000000000010028] .show_stack+0x6c/0x1a0 (unreliable)
> [c0000000ff49f0d0] [c00000000004f8b4] .__might_sleep+0x11c/0x138
> [c0000000ff49f150] [c00000000039c920] .__rt_spin_lock+0x38/0xa0
> [c0000000ff49f1d0] [c0000000000cf8e8] .kmem_cache_alloc+0x68/0x184
> [c0000000ff49f270] [c0000000001f7534] .radix_tree_node_alloc+0x3c/0x104
> [c0000000ff49f300] [c0000000001f8418] .radix_tree_insert+0x19c/0x324
> [c0000000ff49f3c0] [c00000000000b758] .irq_radix_revmap+0x140/0x178
> [c0000000ff49f470] [c000000000044aec] .xics_startup+0x30/0x54
> [c0000000ff49f500] [c0000000000997f4] .setup_irq+0x254/0x320
> [c0000000ff49f5b0] [c000000000099984] .request_irq+0xc4/0x114
> [c0000000ff49f660] [d00000000079b194] .e1000_open+0xdc/0x1b8 [e1000]
> [c0000000ff49f6f0] [c00000000030a840] .dev_open+0x94/0x110
> [c0000000ff49f790] [c00000000030a69c] .dev_change_flags+0x110/0x220
> [c0000000ff49f830] [c00000000036a0a8] .devinet_ioctl+0x2cc/0x764
> [c0000000ff49f930] [c00000000036a6a8] .inet_ioctl+0xe8/0x138
> [c0000000ff49f9b0] [c0000000002f9acc] .sock_ioctl+0x2c8/0x314
> [c0000000ff49fa50] [c0000000000e6dec] .do_ioctl+0x5c/0xf0
> [c0000000ff49faf0] [c0000000000e731c] .vfs_ioctl+0x49c/0x4d4
> [c0000000ff49fba0] [c0000000000e73ec] .sys_ioctl+0x98/0xe0
> [c0000000ff49fc50] [c000000000117944] .dev_ifsioc+0x1e0/0x46c
> [c0000000ff49fd40] [c00000000011e1d4] .compat_sys_ioctl+0x40c/0x4a0
> [c0000000ff49fe30] [c00000000000852c] syscall_exit+0x0/0x40

The radix tree is used by the powerpc IRQ subsystem with some hand-made
locking that involves per-cpu variables among others, you may want to
have a look at arch/powerpc/kernel/irq.c ... It should all be GFP_ATOMIC
though, but if -rt can't cope with even GFP_ATOMIC when preempt is off,
then we have a deeper problem (the allocation of the page for RCU in
freeing page tables is another one that will GFP_ATOMIC in
non-preemptible context afaik).

Ben.


