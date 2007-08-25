Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbXHYCCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbXHYCCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 22:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXHYCCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 22:02:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40796 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbXHYCCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 22:02:12 -0400
Date: Fri, 24 Aug 2007 18:59:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>
Subject: Re: kernel BUG with 2.6.23-rc3-mm1: skb_over_panic
Message-Id: <20070824185952.5f02a2b2.randy.dunlap@oracle.com>
In-Reply-To: <20070824174450.70337f4f.akpm@linux-foundation.org>
References: <20070824224707.GA7275@Krystal>
	<20070824161029.6236a5f4.akpm@linux-foundation.org>
	<20070825001638.GB9811@Krystal>
	<20070824174450.70337f4f.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 17:44:50 -0700 Andrew Morton wrote:

> On Fri, 24 Aug 2007 20:16:38 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > On Fri, 24 Aug 2007 18:47:07 -0400
> > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > Hi Andrew,
> > > > 
> > > > I get the following BUG when booting 2.6.23-rc3-mm1 on i386. I wonder if
> > > > you would have some ideas about what is causing this problem. I'll start
> > > > bissecting it soon. I seems to be caused by an buggy skb_put call in
> > > > kobject_uevent_env.
> > > > 
> > > > Thanks,
> > > > 
> > > > Mathieu
> > > > 
> > > > 
> > > 
> > > hm, don't know, sorry.  Kay fixed a few things in there, but iirc pretty
> > > much all of the fixes were in rc3-mm1 anyway.
> > > 
> > > I doubt if bisection will tell us a lot: it'll probably point at
> > > gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.
> > > 
> > > What we _would_ like to know is which sysfs file is being written to.  We
> > > used to have a debug patch to exactly address this problem but it got
> > > transferred into Greg's tree from whence it mysteriously disappeared.
> > > 
> > 
> > Ok, here it is:
> > 
> > filename :
> > 
> > /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/rev
> 
> Bah.  I've never found a sane way of going from a sysfs pathname back to the
> code which implements that pathname :(
> 
> <greps the tree for '"rev"'>

Yeah, those sysfs attrib macros are not helpful when grepping.

drivers/scsi/scsi_sysfs.c, #444:

sdev_rd_attr (rev, "%.4s\n");

> <comes up with zilch>
> 
> > [   13.737735] ------------[ cut here ]------------
> > [   13.751544] Kernel BUG at c039e11c [verbose debug info unavailable]
> > [   13.770287] invalid opcode: 0000 [#1] PREEMPT SMP 
> > [   13.784736] last sysfs file: /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/rev
> > [   13.809714] Modules linked in:
> > [   13.818873] 
> > [   13.823330] Pid: 1038, comm: udevtrigger Not tainted (2.6.23-rc3-mm1-testssmp #283)
> > [   13.846218] EIP: 0060:[<c039e11c>] EFLAGS: 00010286 CPU: 1
> > [   13.862616] EIP is at skb_over_panic+0x5c/0x60
> > [   13.875894] EAX: 00000084 EBX: c2227e00 ECX: 10000000 EDX: 00000000
> > [   13.894632] ESI: 00000000 EDI: c2227e56 EBP: c2ea9eb4 ESP: c2ea9e88
> > [   13.913372]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > [   13.929516] Process udevtrigger (pid: 1038, ti=c2ea8000 task=c2baa070 task.ti=c2ea8000)
> > [   13.952918] Stack: c05010f0 c0252e3e 00000061 0000000b c2227e00 c2227e00 c2227e61 c2227e60 
> > [   13.978200]        c04d21c5 c2287c80 00000005 c2ea9efc c0252e43 c2227e00 c04d2168 c04ce0e4 
> > [   14.003471]        c20fc2a0 00000000 c04ce0e4 c20fc2a0 c04e2eaf c05401e0 c225a000 c2ea9f04 
> > [   14.028749] Call Trace:
> > [   14.036622]  [<c010971a>] show_trace_log_lvl+0x1a/0x30
> > [   14.052019]  [<c01097d8>] show_stack_log_lvl+0xa8/0xe0
> > [   14.067412]  [<c01098da>] show_registers+0xca/0x250
> > [   14.082028]  [<c0109b75>] die+0x115/0x280
> > [   14.094047]  [<c04187c1>] do_trap+0x91/0xc0
> > [   14.106586]  [<c0109fc9>] do_invalid_op+0x89/0xa0
> > [   14.120680]  [<c041857a>] error_code+0x72/0x78
> > [   14.134002]  [<c0252e43>] kobject_uevent_env+0x353/0x380
> > [   14.149915]  [<c0252e7a>] kobject_uevent+0xa/0x10
> > [   14.164012]  [<c02c523b>] store_uevent+0x2b/0x70
> > [   14.177851]  [<c02c4f5f>] dev_attr_store+0x2f/0x40
> > [   14.192207]  [<c01cd080>] sysfs_write_file+0xa0/0x100
> > [   14.207344]  [<c018cb89>] vfs_write+0x99/0x130
> > [   14.220661]  [<c018d26d>] sys_write+0x3d/0x70
> > [   14.233720]  [<c0108596>] syscall_call+0x7/0xb
> > [   14.247036]  =======================
> > [   14.257723] INFO: lockdep is turned off.
> > [   14.269448] Code: 00 00 89 5c 24 14 8b 98 8c 00 00 00 89 54 24 0c 89 5c 24 10 8b 40 50 89 4c 24 04 c7 04 24 f0 10 50 c0 89 44 24 08 e8 94 20 d9 ff <0f> 0b eb fe 55 89 e5 56 89 d6 53 89 c3 83 ec 0c 8b 40 50 39 
> > [   14.328022] EIP: [<c039e11c>] skb_over_panic+0x5c/0x60 SS:ESP 0068:c2ea9e88
> > /etc/rcS.d/S03udev: line 253:  1038 Segmentation fault      udevtrigger
> 
> I think I'll sit back and watch Greg and Kay solve this one ;)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
