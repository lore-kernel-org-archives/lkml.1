Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbZBLWdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbZBLWdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZBLWdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:33:04 -0500
Received: from www.tglx.de ([62.245.132.106]:58803 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbZBLWdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:33:03 -0500
Date: Thu, 12 Feb 2009 23:28:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can request_irq be called under spinlock?
In-Reply-To: <499481B9.4090202@goop.org>
Message-ID: <alpine.LFD.2.00.0902122326100.16972@localhost.localdomain>
References: <499481B9.4090202@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009, Jeremy Fitzhardinge wrote:
> Relatively recently, I've started seeing this report from my code:
> 
> BUG: sleeping function called from invalid context at
> /home/jeremy/git/linux-2.6/mm/slab.c:2982
> in_atomic(): 1, irqs_disabled(): 1, pid: 2249, name: xenstored
> Pid: 2249, comm: xenstored Not tainted 2.6.29-rc4-tip #22
> Call Trace:
> [<ffffffff80233e5d>] __might_sleep+0x113/0x115
> [<ffffffff802a6f8c>] __kmalloc+0x67/0xe2
> [<ffffffff802ebc85>] __proc_create+0x89/0x127
> [<ffffffff803f1c5f>] ? bind_evtchn_to_cpu+0x4f/0xa0
> [<ffffffff802ec0ad>] proc_mkdir_mode+0x2e/0x57
> [<ffffffff802ec0ec>] proc_mkdir+0x16/0x18
> [<ffffffff80270d99>] register_irq_proc+0x74/0xcf
> [<ffffffff8026f5ab>] __setup_irq+0x19b/0x200
> [<ffffffff8026f6e7>] request_irq+0xd7/0x100
> [<ffffffff803f7d8e>] ? evtchn_interrupt+0x0/0xc1
> [<ffffffff803f7d8e>] ? evtchn_interrupt+0x0/0xc1
> [<ffffffff803f2856>] bind_evtchn_to_irqhandler+0x3d/0x5f
> [<ffffffff803f7c8b>] evtchn_bind_to_user+0x54/0x72
> [<ffffffff803f81cc>] evtchn_ioctl+0x180/0x39c
> [<ffffffff802a8592>] ? __dentry_open+0x1a4/0x2a2
> [<ffffffff802a9513>] ? nameidata_to_filp+0x46/0x57
> [<ffffffff803f02ed>] ? pnpacpi_parse_allocated_resource+0x94/0x9b
> [<ffffffff8020e6d9>] ? xen_force_evtchn_callback+0xd/0xf
> [<ffffffff802b5f06>] vfs_ioctl+0x2f/0x7c
> [<ffffffff802b63fe>] do_vfs_ioctl+0x4ab/0x503
> [<ffffffff802aad0e>] ? __fput+0x1a1/0x1ae
> [<ffffffff802b649d>] sys_ioctl+0x47/0x6a
> [<ffffffff80212522>] system_call_fastpath+0x16/0x1b
> 
> because I'm calling request_irq() while holding a spinlock.
> 
> request_irq() itself looks like its OK with that (it allocates with
> GFP_ATOMIC, for example), but __setup_irq -> register_irq_proc -> proc_mkdir
> ends up doing a GFP_KERNEL allocation, which leads to this message.
> 
> I can rearrange this code to not do the call under lock, but it seems like
> there was an unintentional change in API here.

I dont think that proc_mkdir conventions have changed
recently. According to git blame fs/proc/generic.c:

^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700 580)     ent = kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);

Thanks,

	tglx
