Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbYGJQra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbYGJQra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759239AbYGJQrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:47:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:15360 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759231AbYGJQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:47:08 -0400
X-BigFish: VPS-24(ze98mz1432R98dR7efV1805M873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3SULT-04-SDB-01
Date: Thu, 10 Jul 2008 18:46:44 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 23/34] AMD IOMMU: add functions to find IOMMU device resources
Message-ID: <20080710164644.GR14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-24-git-send-email-joerg.roedel@amd.com> <20080709191827.dbdfcd96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080709191827.dbdfcd96.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 16:46:45.0064 (UTC) FILETIME=[89964C80:01C8E2AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 07:18:27PM -0700, Andrew Morton wrote:
> On Thu, 26 Jun 2008 21:27:59 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds functions necessary to find the IOMMU resources for a specific
> > device.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu.c |   75 +++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 75 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index c43d15d..47e80b5 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -461,3 +461,78 @@ free_dma_dom:
> >  	return NULL;
> >  }
> >  
> > +static struct protection_domain *domain_for_device(u16 devid)
> > +{
> > +	struct protection_domain *dom;
> > +	unsigned long flags;
> > +
> > +	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
> 
> Why is this cheerfully undocumented lock irq-safe?  Is it ever taken from
> IRQ context?

This function is called from the dma-mapping path. As far as I know the
DMA mapping functions can be called from interrupt context.

> 
> > +	dom = amd_iommu_pd_table[devid];
> > +	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
> > +
> > +	return dom;
> > +}
> 
> The locking in this function makes no sense.  We drop the lock then return
> a value which the caller cannot use in a race-free fashion, because the
> lock is no longer held.

The lock only protects the protection domain table (and the device
table) itself. It does not protect the values the pointers in that list
point to. In this case its also not racy because a value to that list is
only written once and then never changed again (currently). If this
changes in the future (and it will) I will change the locking too. This
will also need reference counting for 'struct protection_domain' which
is not implemented yet.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

