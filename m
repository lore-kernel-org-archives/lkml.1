Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYCZX3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYCZX3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbYCZX31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:29:27 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:59572 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbYCZX30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:29:26 -0400
Date: Thu, 27 Mar 2008 02:29:22 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080326232922.GA15784@jurassic.park.msu.ru>
References: <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org> <20080326101450.GA9060@jurassic.park.msu.ru> <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org> <20080326205828.GA15225@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 02:41:44PM -0700, Linus Torvalds wrote:
> In fact, I think the old code was buggy too, because we actually *do* have 
> single-byte resources where start == end, as showb by google:
> 
> 	PCI: Ignore bogus resource 1 [3f6:3f6] of Symphony Labs SL82c105
> 	PCI: Ignore bogus resource 3 [376:376] of Symphony Labs SL82c105
> 
> where that resource actually looks valid, and should have a single byte 
> alignment! Admittedly I think it was created with a quirk (can you get 
> that kind of resource from actually _probing_ a PCI device?) but I do 
> think that a single-byte resource is valid.

Good point - even though 1-byte size/alignment is invalid for a regular BAR
(minimum is 8 bytes for IO and 16 bytes for MEM, IIRC), nothing prevents
us from using this code for non-standard stuff, including single-byte
resources.

> So I wonder if we shouldn't just make this a bit more readable and also a 
> bit more explicit with something like the appended..

Agreed, this looks better...

> NOTE! This will also consider a bridge resource at 0 to be an invalid 
> resource (since now the alignment will be zero), which is a bit odd and 
> makes me worry a bit. I wouldn't be surprised if some non-PC architectures 
> have PCI bridges at zero. But maybe they should be (or already are?) 
> marked IORESOURCE_PCI_FIXED?

Well, at this point (pdev_sort_resources call) bridge resource->start
has nothing to do with a bus address, it just a temporary storage for
required alignment, filled by sizing routines (and 0 is definitely invalid
here). I know, this is quite confusing, but I didn't want to add extra
fields to existing structures or create temporary per-bus trees...
But after pci_assign_resource() that resource can certainly be at 0,
depending on PCIBIOS_MIN_{IO,MEM} and free slots in the resource tree.

> +static inline resource_size_t get_resource_alignment(int resno, struct resource *r)
> +{
> +	resource_size_t start = r->start, end = r->end;
> +	resource_size_t alignment = 0;
> +
> +	/* End == start == 0 - invalid resource */
> +	if (end && start <= end) {
> +		alignment = end - start - 1;

Must be end - start + 1

> Also, the reason I *think* this issue is ok is that I think the only PCI 
> bus resources we can see in the whole pdev_sort_resources() mess is the 
> ones that are behind the bus that we're not sizing for, and they've been 
> set up by pbus_size_mem().
> 
> And pbus_size_mem() has this special magic setup where it calculates the 
> size and the alignment of the bus resource, and then makes
> 
> 	r->start = alignment;
> 	r->end = r->start + size - 1;
> 
> so using "r->start" *should* be ok in this case because it really means 
> "alignment" in this one case.

Yes, absolutely.

> I also wonder if we maybe should just add a separate "alignment" field to 
> the resources. Rather than playing games like these (and having to compare 
> the resource number to decide whether it is a bus resource or a normal PCI 
> device resource), just adding the dang field would be a whole lot saner.

Extra 4 or 8 bytes per resource? Well, if you think that people won't start
complain too much about that, I'll be absolutely happy with that.
It'd vastly improve readability.

> I dunno. I'm not going to do anything in this area before 2.6.25 is out 
> because this *does* make me a bit nervous, but if somebody wants to think 
> about this and perhaps write patches for testing, that would be good.

If the new "align" field (and then, maybe, "size" instead of "end"?)
is OK, then I'm definitely willing to give it a try.

Ivan.
