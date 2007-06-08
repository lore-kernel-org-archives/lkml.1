Return-Path: <linux-kernel-owner+w=401wt.eu-S969805AbXFHQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969805AbXFHQH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbXFHQHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:07:13 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1825 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbXFHQHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:07:11 -0400
Message-ID: <46697EB4.5060003@shadowen.org>
Date: Fri, 08 Jun 2007 17:07:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Bob Picco <bob.picco@hp.com>
CC: john stultz <johnstul@us.ibm.com>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Sripathi Kodi <sripathik@in.ibm.com>, Bernhard Walle <bwalle@suse.de>,
       acme@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
       andi@firstfloor.org
Subject: Re: [BUG] sysrq-m oops
References: <1181176035.6275.13.camel@localhost.localdomain> <4668276E.4030504@redhat.com> <20070607182122.GE11999@localhost> <1181246081.7621.6.camel@localhost.localdomain> <20070608010056.GF11999@localhost>
In-Reply-To: <20070608010056.GF11999@localhost>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Picco wrote:
> john stultz wrote:	[Thu Jun 07 2007, 03:54:41PM EDT]
> [snip]
> john you are welcome.
> 
> We aren't sampling for holes in memory. Thus we encounter a section hole with
> empty section map pointer for SPARSEMEM and OOPs for show_mem. This issue
> has been seen in 2.6.21, current git and current mm. The patch below
> is for mainline and mm. It was boot tested for SPARSEMEM, current
> VMEMMAP of Andy's in mm ml and DISCONTIGMEM. A slightly different patch
> will be posted to stable for 2.6.21.
> 
> Previous to commit f0a5a58aa812b31fd9f197c4ba48245942364eae memory_present
> was called for node_start_pfn to node_end_pfn. This would cover the hole(s)
> with reserved pages and valid sections. Most SPARSEMEM supported arches
> do a pfn_valid check in show_mem before computing the page structure address.
> 
> This issue was brought to my attention on IRC by Arnaldo Carvalho de Melo at
> acme@redhat.com. Thanks to Arnaldo for testing.
> 
> Signed-off-by: Bob Picco <bob.picco@hp.com>
> 
>  arch/x86_64/mm/init.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.22-rc4-mm1/arch/x86_64/mm/init.c
> ===================================================================
> --- linux-2.6.22-rc4-mm1.orig/arch/x86_64/mm/init.c	2007-06-06 12:59:26.000000000 -0400
> +++ linux-2.6.22-rc4-mm1/arch/x86_64/mm/init.c	2007-06-07 11:14:31.000000000 -0400
> @@ -79,6 +79,8 @@ void show_mem(void)
>  			if (unlikely(i % MAX_ORDER_NR_PAGES == 0)) {
>  				touch_nmi_watchdog();
>  			}
> +			if (!pfn_valid(pgdat->node_start_pfn + i))
> +				continue;
>  			page = pfn_to_page(pgdat->node_start_pfn + i);
>  			total++;
>  			if (PageReserved(page))

Yes this is required with SPARSEMEM.  Good spot.

Acked-by: Andy Whitcroft <apw@shadowen.org>

-apw
