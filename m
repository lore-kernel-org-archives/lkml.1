Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZH3PjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZH3PjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 11:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZH3PjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 11:39:17 -0400
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:39016 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753783AbZH3PjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 11:39:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oKinmLIP2BY5j/YQ8G/rcFwqsmDOPViXs0gGMaz/5HUWH8E/MBUU+qQMO9DhN4SxlZinNADydIroj56j7dFxYYtg7xY3q+90BgnGXi+tOa/vs0Dih34i5vygb5CRgQW1;
Date: Sun, 30 Aug 2009 08:39:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Chris Wright <chrisw@sous-sol.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yu Zhao <yu.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH v2] SR-IOV: correct broken resource alignment
 calculations
Message-ID: <20090830083901.7d46e083@jbarnes-g45>
In-Reply-To: <20090828200006.GL10360@sequoia.sous-sol.org>
References: <20090828191714.GI10360@sequoia.sous-sol.org>
	<20090828194825.GM4884@parisc-linux.org>
	<20090828200006.GL10360@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 13:00:06 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> * Matthew Wilcox (matthew@wil.cx) wrote:
> > On Fri, Aug 28, 2009 at 12:17:14PM -0700, Chris Wright wrote:
> > > This patch adds a support for a new resource alignment type,
> > > IORESOURCE_VSIZEALIGN, and allows struct resource to keep track
> > > of the size requirements of a VF BAR which are smaller than the
> > > full resource size.  This could also be done all within the PCI
> > > layer w/out bloating struct resource or using the last available
> > > bit for alignment types.
> > 
> > Yes, I think that would be preferable.  We have a *LOT* of
> > resources in the kernel, and the embedded folks would not find it
> > funny if they all grew in size suddenly.
> 
> An SR-IOV capable device includes an SR-IOV PCIe capability which
> describes the Virtual Function (VF) BAR requirements.  A typical
> SR-IOV device can support multiple VFs whose BARs must be in a
> contiguous region, effectively an array of VF BARs.  The BAR reports
> the size requirement for a single VF.  We calculate the full range
> needed by simply multiplying the VF BAR size with the number of
> possible VFs and create a resource spanning the full range.
> 
> This all seems sane enough except it artificially inflates the
> alignment requirement for the VF BAR.  The VF BAR need only be
> aligned to the size of a single BAR not the contiguous range of VF
> BARs.  This can cause us to fail to allocate resources for the BAR
> despite the fact that we actually have enough space.
> 
> This patch adds a thin PCI specific layer over the generic
> resource_alignment() function which is aware of the special nature of
> VF BARs and does sorting and allocation based on the smaller alignment
> requirement.
> 
> I recognize that while resource_alignment is generic, it's basically a
> PCI helper.  An alternative to this patch is to add PCI VF BAR
> specific information to struct resource.  I opted for the extra layer
> rather than adding such PCI specific information to struct resource.
> This does have the slight downside that we don't cache the BAR size
> and re-read for each alignment query (happens a small handful of
> times during boot for each VF BAR).
> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Yu Zhao <yu.zhao@intel.com>
> Cc: stable@kernel.org

Yeah, I like this one better.  I've applied it to my for-linus branch;
would be nice to have a Tested-by for it before I send it to Linus...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
