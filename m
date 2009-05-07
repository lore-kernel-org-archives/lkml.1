Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZEGJHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZEGJHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZEGJHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:07:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZEGJHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:07:16 -0400
Date: Thu, 7 May 2009 12:05:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: kvm@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Message-ID: <20090507090506.GB32039@redhat.com>
References: <20090507082841.GA31751@redhat.com> <200905071651.24970.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905071651.24970.sheng@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 04:51:24PM +0800, Sheng Yang wrote:
> On Thursday 07 May 2009 16:28:41 Michael S. Tsirkin wrote:
> > pci_enable_msix currently returns -EINVAL if you ask
> > for more vectors than supported by the device, which would
> > typically cause fallback to regular interrupts.
> >
> > It's better to return the table size, making the driver retry
> > MSI-X with less vectors.
> 
> Hi Michael
> 
> I think driver should read from capability list to know how many vector 
> supported by this device before enable MSI-X for device, as 
> pci_msix_table_size() did...

Drivers can do this, but it's more code. Since pci_enable_msix
calls pci_msix_table_size already, let it do the work. Right?


> -- 
> regards
> Yang, Sheng
> 
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >
> > Hi Jesse,
> > This came up when I was adding MSI-X support to virtio pci driver,
> > which does not know the exact table size upfront.
> > Could you consider this patch for 2.6.31 please?
> >
> >
> >  drivers/pci/msi.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> > index 6f2e629..f5bd1c9 100644
> > --- a/drivers/pci/msi.c
> > +++ b/drivers/pci/msi.c
> > @@ -687,8 +687,8 @@ int pci_msix_table_size(struct pci_dev *dev)
> >   * indicates the successful configuration of MSI-X capability structure
> >   * with new allocated MSI-X irqs. A return of < 0 indicates a failure.
> >   * Or a return of > 0 indicates that driver request is exceeding the
> > number - * of irqs available. Driver should use the returned value to
> > re-send - * its request.
> > + * of irqs or MSI-X vectors available. Driver should use the returned
> > value to + * re-send its request.
> >   **/
> >  int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int
> > nvec) {
> > @@ -704,7 +704,7 @@ int pci_enable_msix(struct pci_dev* dev, struct
> > msix_entry *entries, int nvec)
> >
> >  	nr_entries = pci_msix_table_size(dev);
> >  	if (nvec > nr_entries)
> > -		return -EINVAL;
> > +		return nr_entries;
> >
> >  	/* Check for any invalid entries */
> >  	for (i = 0; i < nvec; i++) {
> 

-- 
MST
