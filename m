Return-Path: <linux-kernel-owner+w=401wt.eu-S934936AbXFGSVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936AbXFGSVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760597AbXFGSV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:21:29 -0400
Received: from mailhub.hp.com ([192.151.27.10]:42408 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069AbXFGSV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:21:28 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Thu, 7 Jun 2007 14:21:22 -0400
To: Chuck Ebbert <cebbert@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Sripathi Kodi <sripathik@in.ibm.com>, Bernhard Walle <bwalle@suse.de>,
       "Eric W. Biederman"@redhat.com, acme@redhat.com, apw@shadowen.org
Subject: Re: [BUG] sysrq-m oops
Message-ID: <20070607182122.GE11999@localhost>
References: <1181176035.6275.13.camel@localhost.localdomain> <4668276E.4030504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4668276E.4030504@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:	[Thu Jun 07 2007, 11:42:38AM EDT]
> On 06/06/2007 08:27 PM, john stultz wrote:
> > Hey All,
> > 	With 2.6.21 and the current -git, we're seeing the following oops when
> > we try sysrq-m:
> > 
> 
> It's here in arch/x86_64/mm/init.c::show_mem():
> 
>         for_each_online_pgdat(pgdat) {
>                for (i = 0; i < pgdat->node_spanned_pages; ++i) {
This is probably with sparsemem? I'm working with acme@redhat.com to
test a patch. Basically you need to validate the pfn because it
could be in a hole. Most arches which support sparsemem perform this
check.

			if (!pfn_valid(pgdat->node_start_pfn + i))
				continue;
bob
>                         page = pfn_to_page(pgdat->node_start_pfn + i);
>                         total++;
>  ======>                if (PageReserved(page))
>                                 reserved++;
>                         else if (PageSwapCache(page))
>                                 cached++;
>                         else if (page_count(page))
>                                 shared += page_count(page) - 1;
>                }
>         }
> 
> page is completely bogus (it's 0x0000000003480000)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
