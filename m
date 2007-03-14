Return-Path: <linux-kernel-owner+w=401wt.eu-S932642AbXCNS7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbXCNS7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932645AbXCNS7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:59:37 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:45908 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642AbXCNS7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:59:36 -0400
Date: Wed, 14 Mar 2007 18:59:34 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
In-Reply-To: <200703141236.09599.bjorn.helgaas@hp.com>
Message-ID: <Pine.LNX.4.64.0703141855010.18468@skynet.skynet.ie>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
 <200703141052.19792.bjorn.helgaas@hp.com> <20070314172141.GA17891@skynet.ie>
 <200703141236.09599.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Bjorn Helgaas wrote:

> On Wednesday 14 March 2007 11:21, Mel Gorman wrote:
>> Can you tell me if the faulting line was at the check for PageBuddy?
>
> I don't know, sorry.
>

No problem, the fact the patch booted lets me know that calling 
PageBuddy() on an invalid page had the same problem as calling 
page_zone(). This is no real suprise as both need a valid struct page and 
virtual mem_map shows up these sort of suprises that don't occur 
elsewhere. Obvious now :/

>> Can you
>> also apply the following patch and boot with loglevel=8 please? The
>> patch moves the check for pfn_valid() before PageBuddy() is called.
>
> Boots fine with this patch:
>

Thanks for testing. A proper patch will be posted soon.

> <SNIP>
> Virtual mem_map starts at 0xa0007fffc7200000
> Zone PFN ranges:

Total aside, a message should have been printed out here with 
"sizeof(struct page) = ??" when loglevel was set to 8. I wanted it so I 
could work out PFNs from the faulting addresses. Can you find such a 
string in the output of dmesg?

> <SNIP>
>
> Please contribute if you find this software useful.
> For info, please visit http://www.isc.org/dhcp-contrib.html
>
> PM: Writing back config space on device 0000:20:02.0 at offset b (was 164514e4, writing 12a4103c)
> PM: Writing back config space on device 0000:20:02.0 at offset 3 (was 0, writing c020)
> PM: Writing back config space on device 0000:20:02.0 at offset 2 (was 2000000, writing 2000015)
> PM: Writing back config space on device 0000:20:02.0 at offset 1 (was 2b00000, writing 2b00146)
> BUG: at drivers/pci/pci.c:679 pci_restore_state()
>
> Call Trace:
> [<a000000100014980>] show_stack+0x40/0xa0
>                                sp=e000004063a5fb90 bsp=e000004063a58f98
> [<a0000001000152b0>] dump_stack+0x30/0x60
>                                sp=e000004063a5fd60 bsp=e000004063a58f80
> [<a0000001003f8800>] pci_restore_state+0x480/0x4a0
>                                sp=e000004063a5fd60 bsp=e000004063a58f38
> [<a00000010051a0b0>] tg3_chip_reset+0x6d0/0x1020
>                                sp=e000004063a5fd70 bsp=e000004063a58ef0
> [<a00000010051b190>] tg3_reset_hw+0xb0/0x3e20
>                                sp=e000004063a5fd80 bsp=e000004063a58e90
> [<a00000010051efb0>] tg3_init_hw+0xb0/0xe0
>                                sp=e000004063a5fdc0 bsp=e000004063a58e68
> [<a000000100523af0>] tg3_open+0x690/0xe00
>                                sp=e000004063a5fdc0 bsp=e000004063a58e10
> [<a000000100647f90>] dev_open+0xf0/0x1e0
>                                sp=e000004063a5fdd0 bsp=e000004063a58de0
> [<a000000100645c00>] dev_change_flags+0xc0/0x240
>                                sp=e000004063a5fdd0 bsp=e000004063a58da0
> [<a0000001006df200>] devinet_ioctl+0x5a0/0xfe0
>                                sp=e000004063a5fdd0 bsp=e000004063a58d40
> [<a0000001006dfdd0>] inet_ioctl+0x190/0x240
>                                sp=e000004063a5fe10 bsp=e000004063a58d10
> [<a00000010062cf00>] sock_ioctl+0x5c0/0x620
>                                sp=e000004063a5fe10 bsp=e000004063a58ce0
> [<a000000100172cb0>] do_ioctl+0x90/0x180
>                                sp=e000004063a5fe10 bsp=e000004063a58ca0
> [<a000000100173650>] vfs_ioctl+0x8b0/0x920
>                                sp=e000004063a5fe10 bsp=e000004063a58c58
> [<a000000100173720>] sys_ioctl+0x60/0xc0
>                                sp=e000004063a5fe20 bsp=e000004063a58bd8
> [<a00000010000c180>] ia64_ret_from_syscall+0x0/0x20
>                                sp=e000004063a5fe30 bsp=e000004063a58bd8
> [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
>                                sp=e000004063a60000 bsp=e000004063a58bd8

That doesn't look particularly healthy! Is this a known problem?

> Remainder snipped

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
