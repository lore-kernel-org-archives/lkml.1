Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbXFKP3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbXFKP3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXFKP26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:28:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23007 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXFKP25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:28:57 -0400
Date: Mon, 11 Jun 2007 08:27:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: mm: memory/cpu hotplug section mismatch.
Message-Id: <20070611082732.70018522.randy.dunlap@oracle.com>
In-Reply-To: <20070611050955.GA23215@linux-sh.org>
References: <20070611043543.GA22910@linux-sh.org>
	<20070611140145.05726c0f.kamezawa.hiroyu@jp.fujitsu.com>
	<20070611050955.GA23215@linux-sh.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007 14:09:55 +0900 Paul Mundt wrote:

> On Mon, Jun 11, 2007 at 02:01:45PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Mon, 11 Jun 2007 13:35:43 +0900
> > Paul Mundt <lethal@linux-sh.org> wrote:
> > 
> > > When building with memory hotplug enabled and cpu hotplug disabled, we
> > > end up with the following section mismatch:
> > > 
> > > WARNING: mm/built-in.o(.text+0x4e58): Section mismatch: reference to
> > > .init.text: (between 'free_area_init_node' and '__build_all_zonelists')
> > > 
> > > This happens as a result of:
> > > 
> > > 	-> free_area_init_node()
> > > 	  -> free_area_init_core()
> > > 	    -> zone_pcp_init() <-- all __meminit up to this point
> > > 	      -> zone_batchsize() <-- marked as __cpuinit
> > > 
> > > This happens because CONFIG_HOTPLUG_CPU=n sets __cpuinit to __init, but
> > > CONFIG_MEMORY_HOTPLUG=y unsets __meminit.
> > > 
> > > Changing zone_batchsize() to __init_refok fixes this.
> > > 
> > 
> > It seems this zone_batchsize() is called by cpu-hotplug and memory-hotplug.
> > So, __init_refok doesn't look good, here.
> > 
> > maybe we can use __devinit here. (Because HOTPLUG_CPU and MEMORY_HOTPLUG are
> > depend on CONFIG_HOTPLUG.)
> > 
> Yes, that's probably a more reasonable way to go. The __devinit name is a
> bit misleading, though..

__meminit does not fit/work here?


> --
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bd8e335..05ace44 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1968,7 +1968,7 @@ void zone_init_free_lists(struct pglist_data *pgdat, struct zone *zone,
>  	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
>  #endif
>  
> -static int __cpuinit zone_batchsize(struct zone *zone)
> +static int __devinit zone_batchsize(struct zone *zone)
>  {
>  	int batch;
>  


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
