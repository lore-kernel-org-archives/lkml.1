Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbXHXXuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbXHXXuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbXHXXuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:50:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36970 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbXHXXuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:50:21 -0400
Date: Fri, 24 Aug 2007 16:46:26 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: kernel BUG with 2.6.23-rc3-mm1: skb_over_panic
Message-ID: <20070824234626.GB19595@kroah.com>
References: <20070824224707.GA7275@Krystal> <20070824161029.6236a5f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824161029.6236a5f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 04:10:29PM -0700, Andrew Morton wrote:
> On Fri, 24 Aug 2007 18:47:07 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi Andrew,
> > 
> > I get the following BUG when booting 2.6.23-rc3-mm1 on i386. I wonder if
> > you would have some ideas about what is causing this problem. I'll start
> > bissecting it soon. I seems to be caused by an buggy skb_put call in
> > kobject_uevent_env.
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > 
> > Synthesizing the initial hotplug events...[   13.738308] skb_over_panic: text:c0252ede len:97 put:11 head:c2237e00 data:c2237e00 tail:0xc2237e61 end:0xc2237e60 dev:<NULL>
> > [   13.772252] ------------[ cut here ]------------
> > [   13.786057] Kernel BUG at c039e27c [verbose debug info unavailable]
> > [   13.804788] invalid opcode: 0000 [#1] PREEMPT SMP 
> > [   13.819195] Modules linked in:
> > [   13.828350] 
> > [   13.832805] Pid: 1038, comm: udevtrigger Not tainted (2.6.23-rc3-mm1-testssmp #281)
> > [   13.855695] EIP: 0060:[<c039e27c>] EFLAGS: 00010286 CPU: 0
> > [   13.872090] EIP is at skb_over_panic+0x5c/0x60
> > [   13.885368] EAX: 00000084 EBX: c2237e00 ECX: 10000000 EDX: 00000000
> > [   13.904093] ESI: 00000000 EDI: c2237e56 EBP: c2243eb4 ESP: c2243e88
> > [   13.922820]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > [   13.938951] Process udevtrigger (pid: 1038, ti=c2242000 task=c22a94f0 task.ti=c2242000)
> > [   13.962348] Stack: c05010ac c0252ede 00000061 0000000b c2237e00 c2237e00 c2237e61 c2237e60 
> > [   13.987584]        c04d2181 c2bc1e80 00000005 c2243efc c0252ee3 c2237e00 c04d2124 c04ce0b8 
> > [   14.012823]        c2b9ed20 00000000 c04ce0b8 c2b9ed20 c04e2e6b c05401a0 c2ac9000 c2243f04 
> > [   14.038065] Call Trace:
> > [   14.045931]  [<c010971a>] show_trace_log_lvl+0x1a/0x30
> > [   14.061321]  [<c01097d8>] show_stack_log_lvl+0xa8/0xe0
> > [   14.076707]  [<c01098da>] show_registers+0xca/0x250
> > [   14.091312]  [<c0109b70>] die+0x110/0x280
> > [   14.103323]  [<c04187c1>] do_trap+0x91/0xc0
> > [   14.115857]  [<c0109fc9>] do_invalid_op+0x89/0xa0
> > [   14.129944]  [<c041857a>] error_code+0x72/0x78
> > [   14.143252]  [<c0252ee3>] kobject_uevent_env+0x353/0x380
> > [   14.159155]  [<c0252f1a>] kobject_uevent+0xa/0x10
> > [   14.173244]  [<c02c524b>] store_uevent+0x2b/0x70
> > [   14.187076]  [<c02c4f6f>] dev_attr_store+0x2f/0x40
> > [   14.201425]  [<c01cd0e0>] sysfs_write_file+0xa0/0x100
> > [   14.216553]  [<c018cbf9>] vfs_write+0x99/0x130
> > [   14.229862]  [<c018d2dd>] sys_write+0x3d/0x70
> > [   14.242911]  [<c0108596>] syscall_call+0x7/0xb
> > [   14.256223]  =======================
> > [   14.266906] INFO: lockdep is turned off.
> > [   14.278624] Code: 00 00 89 5c 24 14 8b 98 8c 00 00 00 89 54 24 0c 89 5c 24 10 8b 40 50 89 4c 24 04 c7 04 24 ac 10 50 c0 89 44 24 08 e8 64 1f d9 ff <0f> 0b eb fe 55 89 e5 56 89 d6 53 89 c3 83 ec  
> > [   14.336986] EIP: [<c039e27c>] skb_over_panic+0x5c/0x60 SS:ESP 0068:c2243e88
> > 
> 
> hm, don't know, sorry.  Kay fixed a few things in there, but iirc pretty
> much all of the fixes were in rc3-mm1 anyway.
> 
> I doubt if bisection will tell us a lot: it'll probably point at
> gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.

I've now updated my copy of this with the "correct" one from Kay :)

> What we _would_ like to know is which sysfs file is being written to.  We
> used to have a debug patch to exactly address this problem but it got
> transferred into Greg's tree from whence it mysteriously disappeared.

I think this patch got dropped a while ago when things were just
reworked too much in this area.  If this patch now works properly, I
have no objection to taking it in my tree again.

thanks,

greg k-h
