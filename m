Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZF2LWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZF2LWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZF2LVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:21:53 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42462 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZF2LVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:21:52 -0400
Date: Mon, 29 Jun 2009 05:21:55 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
	x86
Message-ID: <20090629112155.GJ5480@parisc-linux.org>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <4A45A5C1.5080701@zytor.com> <19013.59956.144640.331854@pilspetsen.it.uu.se> <20090629022911.GC20297@lackof.org> <4A484A8A.9020704@zytor.com> <19016.41349.636663.515540@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19016.41349.636663.515540@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 01:12:05PM +0200, Mikael Pettersson wrote:
> H. Peter Anvin writes:
>  > Grant Grundler wrote:
>  > > On Sat, Jun 27, 2009 at 11:45:24AM +0200, Mikael Pettersson wrote:
>  > > ...
>  > >>   fff00000-fffffffe : pnp 00:09
>  > >> 100000000-1ffffffff : System RAM
>  > >> 200000000-ffffffffffffffff : RAM buffer
>  > >>
>  > >> With 2.6.30 things look similar, except 2.6.30 does not show the
>  > >> last "200000000-ffffffffffffffff : RAM buffer" line.
>  > > 
>  > > BIOS e280 table didn't report that line.
>  > > I expect it's created by arch/x86/kernel/e820.c:
>  > > 1398         /*
>  > > 1399          * Try to bump up RAM regions to reasonable boundaries to
>  > > 1400          * avoid stolen RAM:
>  > > 1401          */
>  > > 1402         for (i = 0; i < e820.nr_map; i++) {
>  > > 1403                 struct e820entry *entry = &e820_saved.map[i];
>  > > 1404                 resource_size_t start, end;
>  > > 1405 
>  > > 1406                 if (entry->type != E820_RAM)
>  > > 1407                         continue;
>  > > 1408                 start = entry->addr + entry->size;
>  > > 1409                 end = round_up(start, ram_alignment(start));
>  > > 1410                 if (start == end)
>  > > 1411                         continue;
>  > > 1412                 reserve_region_with_split(&iomem_resource, start,
>  > > 1413                                                   end - 1, "RAM buffer");
>  > > 1414         }
>  > > 
>  > 
>  > OK, this seems more than a wee bit strange, to say the least.  We
>  > shouldn't be reserving the entire address space; this is legitimate I/O
>  > space.
>  > 
>  > However, the reservation suddenly being improper for the root resource
>  > would definitely make things unhappy...
> 
> Reverting the two e820 changes in 2.6.31-rc1,
> 5d423ccd7ba4285f1084e91b26805e1d0ae978ed and then
> 45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90,
> but keeping the iomem_resource.end cap change, makes 2.6.31-rc1
> work on my HIGHMEM64G machine.
> 
> Seems the e820 and the iomem_resource.end changes are Ok in
> isolation but break when combined.

With the e820 change reverted, what does /proc/iomem look like?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
