Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYIRXLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYIRXLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYIRXKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:10:55 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35532 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbYIRXKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:10:54 -0400
Date: Fri, 19 Sep 2008 08:10:32 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, joro@8bytes.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080918140350.GE24392@amd.com>
References: <20080917192827.GA18515@8bytes.org>
	<20080918102931Z.fujita.tomonori@lab.ntt.co.jp>
	<20080918140350.GE24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080919081020S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 16:03:50 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, Sep 18, 2008 at 10:29:24AM +0900, FUJITA Tomonori wrote:
> > On Wed, 17 Sep 2008 21:28:27 +0200
> > Joerg Roedel <joro@8bytes.org> wrote:
> > 
> > > On Thu, Sep 18, 2008 at 04:20:18AM +0900, FUJITA Tomonori wrote:
> > > > On Wed, 17 Sep 2008 18:52:37 +0200
> > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > 
> > > > > The IO/TLB flushing on every unmaping operation is the most expensive
> > > > > part there and not strictly necessary. It is sufficient to do the flush
> > > > > before any entries are reused. This is patch implements lazy IO/TLB
> > > > > flushing which does exactly this.
> > > > > 
> > > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > > > ---
> > > > >  Documentation/kernel-parameters.txt |    5 +++++
> > > > >  arch/x86/kernel/amd_iommu.c         |   26 ++++++++++++++++++++++----
> > > > >  arch/x86/kernel/amd_iommu_init.c    |   10 +++++++++-
> > > > >  include/asm-x86/amd_iommu_types.h   |    9 +++++++++
> > > > >  4 files changed, 45 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > > > index c2e00ee..5f0aefe 100644
> > > > > --- a/Documentation/kernel-parameters.txt
> > > > > +++ b/Documentation/kernel-parameters.txt
> > > > > @@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
> > > > >  			isolate - enable device isolation (each device, as far
> > > > >  			          as possible, will get its own protection
> > > > >  			          domain)
> > > > > +			unmap_flush - enable flushing of IO/TLB entries when
> > > > > +			              they are unmapped. Otherwise they are
> > > > > +				      flushed before they will be reused, which
> > > > > +				      is a lot of faster
> > > > > +
> > > > 
> > > > Would it be nice to have consistency of IOMMU parameters?
> > > 
> > > True. We should merge common parameters across IOMMUs into the
> > > iommu= parameter some time in the future, I think. It would also be the
> > > place for the IOMMU size parameter.
> > 
> > Hmm, now is better than the future? I think that now you can add
> > something like 'disable_batching_flush' as a common parameter and
> > change AMD IOMMU to use it.
> 
> Ok, I queued the following patch in the AMD IOMMU updates and changed
> this patch to use iommu_fullflush instead. Is this patch ok? It changes
> the behavior of GART to use lazy flushing by default. But I don't think
> that this is a problem.
> 
> commit 9769771290fddcfc0362c5d30242151d4eb1cc46
> Author: Joerg Roedel <joerg.roedel@amd.com>
> Date:   Thu Sep 18 15:23:43 2008 +0200
> 
>     x86: move GART TLB flushing options to generic code
>     
>     The GART currently implements the iommu=[no]fullflush command line
>     parameters which influence its IO/TLB flushing strategy. This patch
>     makes these parameters generic so that they can be used by the AMD IOMMU
>     too.
>     
>     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index c2e00ee..569527e 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -888,6 +888,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  		nomerge
>  		forcesac
>  		soft
> +		fullflush
> +			Flush IO/TLB at every deallocation
> +		nofullflush
> +			Flush IO/TLB only when addresses are reused (default)

I'm not sure about making 'nofullflush' a generic option. Enabling
nofullflush option doesn't change anything. So what's the point of the
option?
