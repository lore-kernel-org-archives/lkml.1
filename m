Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYCZXMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYCZXMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYCZXMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:12:09 -0400
Received: from gw.goop.org ([64.81.55.164]:51820 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbYCZXMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:12:06 -0400
Message-ID: <47EAD83A.2000000@goop.org>
Date: Wed, 26 Mar 2008 16:11:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Trying to make use of hotplug memory for xen balloon driver
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to make use of hotplug memory in the Xen balloon driver.  If 
you want to expand a domain to be larger than its initial size, it must 
add new page structures to describe the new memory.

The platform is x86-32, with CONFIG_SPARSEMEM and 
CONFIG_HOTPLUG_MEMORY.  Because the new memory is only pseudo-physical, 
the physical address within the domain is arbitrary, and I added a 
add_memory_resource() function so I could use allocate_resource() to 
find an appropriate address to put the new memory at.

When I want to expand the domain's memory, I do (error checking edited 
out for brevity):

        res = kzalloc(sizeof(*res), GFP_KERNEL);

        res->name = "Xen Balloon";
        res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;

        ret = allocate_resource(&iomem_resource, res, size, 0, -1,
                                PAGE_SIZE, NULL, NULL);

        ret = add_memory_resource(0, res);

        start_pfn = res->start >> PAGE_SHIFT;
        end_pfn = (res->end + 1) >> PAGE_SHIFT;

        ret = xen_resize_phys_to_mach(end_pfn);

        for(pfn = start_pfn; pfn < end_pfn; pfn++) {
                struct page *page = pfn_to_page(pfn);

                if (PageReserved(page))
                        continue;

                set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
                balloon_append(page);
        }

at this point the pages have no underlying machine (physical) memory, 
but are added to the list of potentially usable pages.  This all works fine.

However, when I actually want to use one of these pages, I do:

                page = balloon_retrieve();

                pfn = page_to_pfn(page);

                set_phys_to_machine(pfn, frame_list[i]);

                /* Relinquish the page back to the allocator. */
                online_page(page);

                /* Link back into the page tables if not highmem. */
                if (pfn < max_low_pfn) {	/* !PageHighMem(page) ? */
                        int ret;
                        ret = HYPERVISOR_update_va_mapping(
                                (unsigned long)__va(pfn << PAGE_SHIFT),
                                mfn_pte(frame_list[i], PAGE_KERNEL),
                                0);
                        BUG_ON(ret);
                }

This has two problems:

   1. the online_page() raises an error:

      Bad page state in process 'events/0'
      page:c16fa0cc flags:0x00000000 mapping:00000000 mapcount:1 count:0
      Trying to fix it up, but a reboot is needed
      Backtrace:
      Pid: 9, comm: events/0 Not tainted 2.6.25-rc7-x86-latest.git-dirty #353
       [<c015643a>] bad_page+0x55/0x82
       [<c0156be6>] free_hot_cold_page+0x60/0x1f1
       [<c0103069>] ? xen_restore_fl+0x2e/0x52
       [<c0156dae>] free_hot_page+0xa/0xc
       [<c0156dcb>] __free_pages+0x1b/0x26
       [<c0466e8c>] free_new_highpage+0x11/0x19
       [<c0466ea1>] online_page+0xd/0x1b
       [<c02809ac>] balloon_process+0x1e6/0x4d3
       [<c014671a>] ? lock_acquire+0x90/0x9d
       [<c0137720>] run_workqueue+0xbb/0x186
       [<c01376e5>] ? run_workqueue+0x80/0x186
       [<c02807c6>] ? balloon_process+0x0/0x4d3
       [<c0137fe6>] ? worker_thread+0x0/0xbe
       [<c0138099>] worker_thread+0xb3/0xbe
       [<c013a635>] ? autoremove_wake_function+0x0/0x33
       [<c013a56a>] kthread+0x3b/0x61
       [<c013a52f>] ? kthread+0x0/0x61
       [<c0108b67>] kernel_thread_helper+0x7/0x10
       =======================
          

      I can solve this by putting an explicit reset_page_mapcount(page)
      before online_page(), but I can't see any other hotplug memory
      code which does this.

   2. The new pages don't appear to be in the right zone.  When I boot a
      256M domain I get an initial setup of:

      Zone PFN ranges:
        DMA             0 ->     4096
        Normal       4096 ->    65536
        HighMem     65536 ->    65536
      Movable zone start PFN for each node
      early_node_map[1] active PFN ranges
          0:        0 ->    65536
      On node 0 totalpages: 65536
        DMA zone: 52 pages used for memmap
        DMA zone: 0 pages reserved
        DMA zone: 4044 pages, LIFO batch:0
        Normal zone: 780 pages used for memmap
        Normal zone: 60660 pages, LIFO batch:15
        HighMem zone: 0 pages used for memmap
        Movable zone: 0 pages used for memmap
          

      which presumably means that new pages above pfn 65536 should be in
      the highmem zone?  But PageHighMem() returns false for those pages.

What am I missing here?

Thanks,
    J
