Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab0BCRmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:42:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685Ab0BCRm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:42:29 -0500
Date: Wed, 3 Feb 2010 09:42:16 -0800
From: Brandon Philips <bphilips@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       YinghaiLu@suse.de, Suresh Siddha <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: x86: fix race in create_irq_nr on irq_desc
Message-ID: <20100203174216.GB17985@jenkins.home.ifup.org>
References: <20100203033109.GA17985@jenkins.home.ifup.org>
 <4B694DEF.70301@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B694DEF.70301@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02:20 Wed 03 Feb 2010, Yinghai Lu wrote:
> On 02/02/2010 07:31 PM, Brandon Philips wrote:
> > Race in create_irq_nr():
> > 
> > - Thread 1 loops through and calls irq_to_desc_alloc_node with new=0x66.
> > 
> > - Thread 2 has exited the loop with irq=0x66 and calls dynamic_irq_init(0x66)
> >   setting desc->chip_data = NULL
> > 
> > - Thread 1 then dereferences NULL via desc_new->chip_data->vector
> 
> two threads get same irq?

This race happened when two drivers were setting up MSI-X at the same
time via pci_enable_msix(). See this dmesg excerpt:

[   85.170610] ixgbe 0000:02:00.1: irq 97 for MSI/MSI-X
[   85.170611]   alloc irq_desc for 99 on node -1
[   85.170613] igb 0000:08:00.1: irq 98 for MSI/MSI-X
[   85.170614]   alloc kstat_irqs on node -1
[   85.170616] alloc irq_2_iommu on node -1
[   85.170617]   alloc irq_desc for 100 on node -1
[   85.170619]   alloc kstat_irqs on node -1
[   85.170621] alloc irq_2_iommu on node -1
[   85.170625] ixgbe 0000:02:00.1: irq 99 for MSI/MSI-X
[   85.170626]   alloc irq_desc for 101 on node -1
[   85.170628] igb 0000:08:00.1: irq 100 for MSI/MSI-X
[   85.170630]   alloc kstat_irqs on node -1
[   85.170631] alloc irq_2_iommu on node -1
[   85.170635]   alloc irq_desc for 102 on node -1
[   85.170636]   alloc kstat_irqs on node -1
[   85.170639] alloc irq_2_iommu on node -1
[   85.170646] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000088

As you can see igb and ixgbe are both alternating on create_irq_nr()
via pci_enable_msix() in their probe function. So, let me rewrite my
explanation using this example:

ixgbe: While looping through irq_desc_ptrs[] via create_irq_nr() ixgbe
choses irq_desc_ptrs[102] and exits the loop, drops vector_lock and
calls dynamic_irq_init. Then it sets irq_desc_ptrs[102]->chip_data =
NULL via dynamic_irq_init().

igb: Grabs the vector_lock now and starts looping over irq_desc_ptrs[]
via create_irq_nr(). It gets to irq_desc_ptrs[102] and does this:

	cfg_new = irq_desc_ptrs[102]->chip_data;
	if (cfg_new->vector != 0)
		continue;

This hits the NULL deref.

Does that make sense? It is sort of a rare thing to reproduce- took
40+ reboots.

Thanks,

	Brandon
