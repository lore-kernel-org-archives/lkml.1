Return-Path: <linux-kernel-owner+w=401wt.eu-S1760182AbZBLUIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182AbZBLUIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759080AbZBLUIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:08:30 -0500
Received: from gw.goop.org ([64.81.55.164]:57269 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZBLUI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:08:29 -0500
Message-ID: <499481B9.4090202@goop.org>
Date: Thu, 12 Feb 2009 12:08:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Can request_irq be called under spinlock?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relatively recently, I've started seeing this report from my code:

BUG: sleeping function called from invalid context at /home/jeremy/git/linux-2.6/mm/slab.c:2982
in_atomic(): 1, irqs_disabled(): 1, pid: 2249, name: xenstored
Pid: 2249, comm: xenstored Not tainted 2.6.29-rc4-tip #22
Call Trace:
 [<ffffffff80233e5d>] __might_sleep+0x113/0x115
 [<ffffffff802a6f8c>] __kmalloc+0x67/0xe2
 [<ffffffff802ebc85>] __proc_create+0x89/0x127
 [<ffffffff803f1c5f>] ? bind_evtchn_to_cpu+0x4f/0xa0
 [<ffffffff802ec0ad>] proc_mkdir_mode+0x2e/0x57
 [<ffffffff802ec0ec>] proc_mkdir+0x16/0x18
 [<ffffffff80270d99>] register_irq_proc+0x74/0xcf
 [<ffffffff8026f5ab>] __setup_irq+0x19b/0x200
 [<ffffffff8026f6e7>] request_irq+0xd7/0x100
 [<ffffffff803f7d8e>] ? evtchn_interrupt+0x0/0xc1
 [<ffffffff803f7d8e>] ? evtchn_interrupt+0x0/0xc1
 [<ffffffff803f2856>] bind_evtchn_to_irqhandler+0x3d/0x5f
 [<ffffffff803f7c8b>] evtchn_bind_to_user+0x54/0x72
 [<ffffffff803f81cc>] evtchn_ioctl+0x180/0x39c
 [<ffffffff802a8592>] ? __dentry_open+0x1a4/0x2a2
 [<ffffffff802a9513>] ? nameidata_to_filp+0x46/0x57
 [<ffffffff803f02ed>] ? pnpacpi_parse_allocated_resource+0x94/0x9b
 [<ffffffff8020e6d9>] ? xen_force_evtchn_callback+0xd/0xf
 [<ffffffff802b5f06>] vfs_ioctl+0x2f/0x7c
 [<ffffffff802b63fe>] do_vfs_ioctl+0x4ab/0x503
 [<ffffffff802aad0e>] ? __fput+0x1a1/0x1ae
 [<ffffffff802b649d>] sys_ioctl+0x47/0x6a
 [<ffffffff80212522>] system_call_fastpath+0x16/0x1b

because I'm calling request_irq() while holding a spinlock.

request_irq() itself looks like its OK with that (it allocates with 
GFP_ATOMIC, for example), but __setup_irq -> register_irq_proc -> 
proc_mkdir ends up doing a GFP_KERNEL allocation, which leads to this 
message.

I can rearrange this code to not do the call under lock, but it seems 
like there was an unintentional change in API here.

Thanks,
    J
