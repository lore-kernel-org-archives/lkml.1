Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbXERMRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbXERMRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 08:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbXERMRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 08:17:46 -0400
Received: from barclay.balt.net ([195.14.162.78]:32485 "EHLO barclay.balt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXERMRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 08:17:45 -0400
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux
	2.6.22-rc1 + CFS v12)
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20070516121538.7b108c10.akpm@linux-foundation.org>
References: <1179338441.4265.13.camel@zv.wilibox.com>
	 <20070516121538.7b108c10.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 May 2007 15:17:36 +0300
Message-Id: <1179490656.5512.3.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

Have found this in dmesg (well earlier because of initcall_debug) I've
never noticed that during boot (scrolls away too fast). Anyway -

[    7.841871] NetLabel: Initializing
[    7.841983] NetLabel:  domain hash size = 128
[    7.842095] NetLabel:  protocols = UNLABELED CIPSOv4
[    7.842219] NetLabel:  unlabeled traffic allowed by default
[    7.842338] BUG: at include/linux/slub_def.h:77 kmalloc_index()
[    7.842451] 
[    7.842452] Call Trace:
[    7.842677]  [<ffffffff8029215c>] get_slab+0x1cc/0x260
[    7.842791]  [<ffffffff8029229d>] __kmalloc+0xd/0x80
[    7.842907]  [<ffffffff802219ee>] cache_k8_northbridges+0x7e/0x100
[    7.843024]  [<ffffffff8062bd13>] gart_iommu_init+0x33/0x5b0
[    7.843140]  [<ffffffff8049f836>] netlbl_unlabel_acceptflg_set+0x86/0xf0
[    7.843255]  [<ffffffff80626f49>] pci_iommu_init+0x9/0x20
[    7.843370]  [<ffffffff806216d7>] kernel_init+0x157/0x330
[    7.843485]  [<ffffffff8020b0f8>] child_rip+0xa/0x12
[    7.843601]  [<ffffffff80373fd8>] acpi_ds_init_one_object+0x0/0x7c
[    7.843715]  [<ffffffff80621580>] kernel_init+0x0/0x330
[    7.843829]  [<ffffffff8020b0ee>] child_rip+0x0/0x12
[    7.843941] 
[    7.844056] PCI-GART: No AMD northbridge found.

Does this backtrace looks sane ? Hmm, netlabel code mixes with
acpi_ds_init_one_object() ... Strange.

On Wed, 2007-05-16 at 12:15 -0700, Andrew Morton wrote:
> On Wed, 16 May 2007 21:00:41 +0300
> Zilvinas Valinskas <zilvinas@wilibox.com> wrote:
> 
> > Hello, 
> > 
> > In short, on shutdown my laptop is always freezing now. I was able to
> > capture the 'sysrq-P' (hit that several times), sysrq-T outputs. Please
> > see .config and log messages at http://barclay.balt.net/~zilvinas/oops/ 
> > 
> > Kernel version I had built according git is :
> > 
> > zilvinas@zv:/projects/linux-amd64.git$ git describe HEAD
> > v2.6.22-rc1-29-gfaa8b6c
> > 
> > On top of that I have CFS v12 applied (no other changes otherwise).
> > Please note that there is ''fglrx.ko'' loaded and kernel is tainted
> > because of that (feel free to ignore the report ...).
> > 
> > Anyway, 'sysrq-P' always show that PC is stuck at (NFS lockd?) and it is
> > always the same backtrace is shown. 'sysrq-t' output is in
> > 'kernel-nfs-freeze.log' file (did not want to post it here).
> > 
> >  Pid: 3652, comm: lockd Tainted: P       2.6.22-rc1-cfs-v12 #1
> > 
> > [<ffffffff8024a5a0>] wq_barrier_func+0x0/0x10
> > [<ffffffff8024a7e5>] destroy_workqueue+0x75/0xa0
> > [<ffffffff8833cd34>] :sunrpc:rpciod_down+0xf4/0x170
> > [<ffffffff8836dd74>] :lockd:lockd+0x244/0x300
> > [<ffffffff80233e1f>] schedule_tail+0x3f/0xb0
> > [<ffffffff8020b0f8>] child_rip+0xa/0x12
> > [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> > [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> > [<ffffffff8020b0ee>] child_rip+0x0/0x12
> > 
> > Hope this helps. Thanks in advance for any advice how to solve problem !
> > For now I am back to '2.6.21.1-cfs-v10'.
> > 
> 
> Thanks for the report.   I'm thinking "Oleg".

