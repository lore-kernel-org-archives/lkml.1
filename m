Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYISG35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYISG35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 02:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYISG3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 02:29:50 -0400
Received: from 8bytes.org ([88.198.83.132]:57340 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYISG3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 02:29:49 -0400
Date: Fri, 19 Sep 2008 08:29:46 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
Message-ID: <20080919062946.GH27426@8bytes.org>
References: <20080917192827.GA18515@8bytes.org> <20080918102931Z.fujita.tomonori@lab.ntt.co.jp> <20080918140350.GE24392@amd.com> <20080919081020S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919081020S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 08:10:32AM +0900, FUJITA Tomonori wrote:
> On Thu, 18 Sep 2008 16:03:50 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Thu, Sep 18, 2008 at 10:29:24AM +0900, FUJITA Tomonori wrote:
> > > On Wed, 17 Sep 2008 21:28:27 +0200
> > > Joerg Roedel <joro@8bytes.org> wrote:
> > > 
> > > > On Thu, Sep 18, 2008 at 04:20:18AM +0900, FUJITA Tomonori wrote:
> > > > > On Wed, 17 Sep 2008 18:52:37 +0200
> > > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > > 
> > > > > > The IO/TLB flushing on every unmaping operation is the most expensive
> > > > > > part there and not strictly necessary. It is sufficient to do the flush
> > > > > > before any entries are reused. This is patch implements lazy IO/TLB
> > > > > > flushing which does exactly this.
> > > > > > 
> > > > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > > > > ---
> > > > > >  Documentation/kernel-parameters.txt |    5 +++++
> > > > > >  arch/x86/kernel/amd_iommu.c         |   26 ++++++++++++++++++++++----
> > > > > >  arch/x86/kernel/amd_iommu_init.c    |   10 +++++++++-
> > > > > >  include/asm-x86/amd_iommu_types.h   |    9 +++++++++
> > > > > >  4 files changed, 45 insertions(+), 5 deletions(-)
> > > > > > 
> > > > > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > > > > index c2e00ee..5f0aefe 100644
> > > > > > --- a/Documentation/kernel-parameters.txt
> > > > > > +++ b/Documentation/kernel-parameters.txt
> > > > > > @@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
> > > > > >  			isolate - enable device isolation (each device, as far
> > > > > >  			          as possible, will get its own protection
> > > > > >  			          domain)
> > > > > > +			unmap_flush - enable flushing of IO/TLB entries when
> > > > > > +			              they are unmapped. Otherwise they are
> > > > > > +				      flushed before they will be reused, which
> > > > > > +				      is a lot of faster
> > > > > > +
> > > > > 
> > > > > Would it be nice to have consistency of IOMMU parameters?
> > > > 
> > > > True. We should merge common parameters across IOMMUs into the
> > > > iommu= parameter some time in the future, I think. It would also be the
> > > > place for the IOMMU size parameter.
> > > 
> > > Hmm, now is better than the future? I think that now you can add
> > > something like 'disable_batching_flush' as a common parameter and
> > > change AMD IOMMU to use it.
> > 
> > Ok, I queued the following patch in the AMD IOMMU updates and changed
> > this patch to use iommu_fullflush instead. Is this patch ok? It changes
> > the behavior of GART to use lazy flushing by default. But I don't think
> > that this is a problem.
> > 
> > commit 9769771290fddcfc0362c5d30242151d4eb1cc46
> > Author: Joerg Roedel <joerg.roedel@amd.com>
> > Date:   Thu Sep 18 15:23:43 2008 +0200
> > 
> >     x86: move GART TLB flushing options to generic code
> >     
> >     The GART currently implements the iommu=[no]fullflush command line
> >     parameters which influence its IO/TLB flushing strategy. This patch
> >     makes these parameters generic so that they can be used by the AMD IOMMU
> >     too.
> >     
> >     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index c2e00ee..569527e 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -888,6 +888,10 @@ and is between 256 and 4096 characters. It is defined in the file
> >  		nomerge
> >  		forcesac
> >  		soft
> > +		fullflush
> > +			Flush IO/TLB at every deallocation
> > +		nofullflush
> > +			Flush IO/TLB only when addresses are reused (default)
> 
> I'm not sure about making 'nofullflush' a generic option. Enabling
> nofullflush option doesn't change anything. So what's the point of the
> option?

Backwards compatability with the GART code. These two options are
basically just moved from the GART code to pci-dma.c. But otherwise its
pointless, I can remove it if everybody else agrees.

Joerg

