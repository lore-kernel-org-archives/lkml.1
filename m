Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYC0ArK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYC0ArK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 20:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbYC0Aq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 20:46:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47506 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYC0Aqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 20:46:55 -0400
Date: Thu, 27 Mar 2008 09:50:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
Message-Id: <20080327095059.5d2759a3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47EAD83A.2000000@goop.org>
References: <47EAD83A.2000000@goop.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 16:11:54 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi,
> 
> I'm trying to make use of hotplug memory in the Xen balloon driver.  If 
> you want to expand a domain to be larger than its initial size, it must 
> add new page structures to describe the new memory.
> 
> The platform is x86-32, with CONFIG_SPARSEMEM and 
> CONFIG_HOTPLUG_MEMORY.  Because the new memory is only pseudo-physical, 
> the physical address within the domain is arbitrary, and I added a 
> add_memory_resource() function so I could use allocate_resource() to 
> find an appropriate address to put the new memory at.
> 
welcome to chaos of memory hotplug :)

>    1. the online_page() raises an error:
> 
>       Bad page state in process 'events/0'
>       page:c16fa0cc flags:0x00000000 mapping:00000000 mapcount:1 count:0
>       Trying to fix it up, but a reboot is needed

Hmm, this seems memmap is not initialized correctly...
page->flags == 0 means page is in ZONE_DMA.(it's only 16MB range on x86)
I think memmap is not initilalized.

Calling path to memmap initailization is.
==
  add_memory()
	-> arch_add_memory()
		->  __add_page()
			-> __add_section()
				-> __add_zone()
					-> memmap_init_zone() 
==
Please check what arch_add_memory() is called, at first.



>    2. The new pages don't appear to be in the right zone.  When I boot a
>       256M domain I get an initial setup of:
> 
>       Zone PFN ranges:
>         DMA             0 ->     4096
>         Normal       4096 ->    65536
>         HighMem     65536 ->    65536
>       Movable zone start PFN for each node
>       early_node_map[1] active PFN ranges
>           0:        0 ->    65536
>       On node 0 totalpages: 65536
>         DMA zone: 52 pages used for memmap
>         DMA zone: 0 pages reserved
>         DMA zone: 4044 pages, LIFO batch:0
>         Normal zone: 780 pages used for memmap
>         Normal zone: 60660 pages, LIFO batch:15
>         HighMem zone: 0 pages used for memmap
>         Movable zone: 0 pages used for memmap
>           
> 
>       which presumably means that new pages above pfn 65536 should be in
>       the highmem zone?  But PageHighMem() returns false for those pages.
> 
See x86-32's arch_add_memory(). It's now designed that "all new memory will go into
ZONE_HIGHMEM".
(Because added memory is tend to be removed later.)

Thanks,
-Kame


