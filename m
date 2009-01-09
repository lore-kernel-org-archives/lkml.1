Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZAICFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZAICFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZAICF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:05:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZAICFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:05:25 -0500
Date: Thu, 8 Jan 2009 18:05:15 -0800
From: Dirk Hohndel <hohndel@infradead.org>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "'Grant Grundler'" <grundler@parisc-linux.org>,
       "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Arjan van de Ven'" <arjan@infradead.org>
Subject: Re: git-latest: kernel oops in IOMMU setup
Message-ID: <20090108180515.2f279671@infradead.org>
In-Reply-To: <715D42877B251141A38726ABF5CABF2C018E8FEA77@pdsmsx503.ccr.corp.intel.com>
References: <20090108120538.0176d348@infradead.org>
	<20090108214116.GB20506@colo.lackof.org>
	<715D42877B251141A38726ABF5CABF2C018E8FEA77@pdsmsx503.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 08:58:46 +0800 "Han, Weidong"
<weidong.han@intel.com> wrote:
> >> 
> >> The oops happens very early during boot in device_to_iommu (called
> >> from domain_context_mapping_one).
> >> 
> >> Looking at the code dump and the disassembled function here's where
> >> the error happens: 
> >> 
> >> static struct intel_iommu *device_to_iommu(u8 bus, u8 devfn) {
> >>         struct dmar_drhd_unit *drhd = NULL;
> >>         int i;
> >> 
> >>         for_each_drhd_unit(drhd) {
> >>                 if (drhd->ignored)
> >>                         continue;
> >> 
> >>                 for (i = 0; i < drhd->devices_cnt; i++)
> >>                         if (drhd->devices[i]->bus->number == bus &&
> >>                             --> drhd->devices[0] is NULL
> >>                                 drhd->devices[i]->devfn == devfn)
> >> return drhd->iommu; 
> >> 
> >> 
> >> Given how early this happens it's a little hard to provide logs,
> >> etc. I literally used delay_boot=100 and wrote things down by hand
> >> (forgot my digital camera) and then added printk's to verify).
> >> 
> >> please let me know what other data I should collect.
> > 
> yes, pls get the call trace. When device_to_iommu() is called, DMAR
> should be already parsed from acpi table and registered, so
> device_to_iommu() should not fail unless it's called earlier than
> DMAR is parsed and registered.

I updated to Linus' latest git (as your description made me wonder if
the async stuff might play a role here). I still get an oops - but at
a different spot and the system no longer hangs - it partly recovers
(but things aren't too well - for example my USB keyboard / mouse don't
work anymore). 

Here's the oops:

Jan  8 17:51:00 dhohndel-mobl4 kernel: [   12.359578] ------------[ cut here ]------------
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   12.410579] WARNING: at arch/x86/mm/ioremap.c:240 __ioremap_caller+0x150/0x2bd()
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   12.461578] Hardware name: 7465CTO
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   12.512578] Modules linked in:
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   12.614579] Pid: 1, comm: swapper Not tainted 2.6.28 #12
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   12.665578] Call Trace:
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   12.767581]  [<ffffffff81038b49>] warn_slowpath+0xb1/0xed
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   12.869580]  [<ffffffff81028319>] ? change_page_attr_set_clr+0x13e/0x2e6
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   12.971580]  [<ffffffff810275b2>] __ioremap_caller+0x150/0x2bd
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.073581]  [<ffffffff81158363>] ? alloc_iommu+0x140/0x181
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.175580]  [<ffffffff810277f2>] ioremap_nocache+0x12/0x14
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.277580]  [<ffffffff81158363>] alloc_iommu+0x140/0x181
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.379581]  [<ffffffff8166a5d6>] dmar_table_init+0x115/0x265
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.481580]  [<ffffffff8165687b>] ? pci_iommu_init+0x0/0x17
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.583580]  [<ffffffff8166abb1>] intel_iommu_init+0x16/0x8f3
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.685581]  [<ffffffff813ce372>] ? mutex_lock+0x11/0x23
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.787581]  [<ffffffff813bb9d1>] ? sysctl_net_init+0x1b/0x1f
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.889580]  [<ffffffff8165687b>] ? pci_iommu_init+0x0/0x17
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   13.991580]  [<ffffffff81656884>] pci_iommu_init+0x9/0x17
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.093581]  [<ffffffff81009056>] _stext+0x56/0x12b
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.195581]  [<ffffffff81071220>] ? register_irq_proc+0xa3/0xbf
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.297582]  [<ffffffff810e0000>] ? proc_coredump_filter_write+0xe0/0xfe
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.399581]  [<ffffffff8164e673>] kernel_init+0x139/0x191
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.501581]  [<ffffffff8100d27a>] child_rip+0xa/0x20
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.603581]  [<ffffffff8164e53a>] ? kernel_init+0x0/0x191
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.705581]  [<ffffffff8100d270>] ? child_rip+0x0/0x20
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.756580] ---[ end trace 4eaa2a86a8e2da22 ]---
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.807580] IOMMU: can't map the region
Jan  8 17:51:00 dhohndel-mobl4 kernel: [   14.858580] DMAR:parse DMAR table failure.

later in the log file I find lots of these:

Jan  8 17:51:00 dhohndel-mobl4 kernel: [   40.403251] nommu_map_single: overflow 13a08b248+8 of device mask ffffffff

and finally

Jan  8 17:51:00 dhohndel-mobl4 kernel: [   66.777166] hub 4-0:1.0: unable to enumerate USB device on port 2

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center

