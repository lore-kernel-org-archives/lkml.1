Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbZE3NCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbZE3NCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZE3NC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:02:29 -0400
Received: from smtp.citrix.com ([66.165.176.89]:12929 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZE3NC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:02:28 -0400
X-IronPort-AV: E=Sophos;i="4.41,275,1241409600"; 
   d="scan'208";a="4473755"
Subject: Re: [PATCH 8/9] swiotlb: support HIGHMEM in swiotlb_bus_to_virt
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: <linux-kernel@vger.kernel.org>, Becky Bruce <beckyb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ingo Molnar <mingo@elte.hu>, <linuxppc-dev@ozlabs.org>
In-Reply-To: <4A20060C.2050701@goop.org>
References: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
	 <1243586643-5554-9-git-send-email-ian.campbell@citrix.com>
	 <4A20060C.2050701@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Sat, 30 May 2009 14:02:27 +0100
Message-ID: <1243688547.4399.65.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 08:58 -0700, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:

> > -void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
> > +#ifdef CONFIG_HIGHMEM
> > +static void * swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
> >   
> 
> I think it would be better to put the #ifdef within the function body so 
> that there's no chance of prototype-drift.

Yes, good idea.

> > +{
> > +	unsigned long pfn = PFN_DOWN(dma_to_phys(hwdev, addr));
> > +	void *pageaddr = page_address(pfn_to_page(pfn));
> > +
> > +	if (pageaddr != NULL)
> > +		return pageaddr + (addr % PAGE_SIZE);
> >   
> Is there an arch-independent test to see if a pfn is considered highmem 
> or not (which returns a constant on non-highmem configurations)?  If so, 
> then I think this could be common without having to go via a struct page.

I'm not aware of a way apart from PageHighMem -- which needs the struct
page. Highmem is a property of the zone, I think, so you have to go
through the struct page back to the zone to find out if it is high or
not.

At first glance it looks like many of the callers of bus_to_virt
eventually end up in swiotlb_bounce which converts to a struct page
anyway. I'll take a look next week whether it makes any sense to go to
struct page further up the call chain and pass that around instead.

Ian.


