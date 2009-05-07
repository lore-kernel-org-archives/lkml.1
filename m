Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbZEGJKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbZEGJKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZEGJKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:10:19 -0400
Received: from mga05.intel.com ([192.55.52.89]:62428 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbZEGJKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:10:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,308,1239001200"; 
   d="scan'208";a="454891212"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Date: Thu, 7 May 2009 17:10:46 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: kvm@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
References: <20090507082841.GA31751@redhat.com> <200905071651.24970.sheng@linux.intel.com> <20090507090506.GB32039@redhat.com>
In-Reply-To: <20090507090506.GB32039@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071710.47204.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009 17:05:06 Michael S. Tsirkin wrote:
> On Thu, May 07, 2009 at 04:51:24PM +0800, Sheng Yang wrote:
> > On Thursday 07 May 2009 16:28:41 Michael S. Tsirkin wrote:
> > > pci_enable_msix currently returns -EINVAL if you ask
> > > for more vectors than supported by the device, which would
> > > typically cause fallback to regular interrupts.
> > >
> > > It's better to return the table size, making the driver retry
> > > MSI-X with less vectors.
> >
> > Hi Michael
> >
> > I think driver should read from capability list to know how many vector
> > supported by this device before enable MSI-X for device, as
> > pci_msix_table_size() did...
>
> Drivers can do this, but it's more code. Since pci_enable_msix
> calls pci_msix_table_size already, let it do the work. Right?

If you don't know the vectors number before you enable MSI-X, how can you 
setup vectors? 

I don't think it's proper way to go.

-- 
regards
Yang, Sheng

>
> > --
> > regards
> > Yang, Sheng
> >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >
> > > Hi Jesse,
> > > This came up when I was adding MSI-X support to virtio pci driver,
> > > which does not know the exact table size upfront.
> > > Could you consider this patch for 2.6.31 please?
> > >
> > >
> > >  drivers/pci/msi.c |    6 +++---
> > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> > > index 6f2e629..f5bd1c9 100644
> > > --- a/drivers/pci/msi.c
> > > +++ b/drivers/pci/msi.c
> > > @@ -687,8 +687,8 @@ int pci_msix_table_size(struct pci_dev *dev)
> > >   * indicates the successful configuration of MSI-X capability
> > > structure * with new allocated MSI-X irqs. A return of < 0 indicates a
> > > failure. * Or a return of > 0 indicates that driver request is
> > > exceeding the number - * of irqs available. Driver should use the
> > > returned value to re-send - * its request.
> > > + * of irqs or MSI-X vectors available. Driver should use the returned
> > > value to + * re-send its request.
> > >   **/
> > >  int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries,
> > > int nvec) {
> > > @@ -704,7 +704,7 @@ int pci_enable_msix(struct pci_dev* dev, struct
> > > msix_entry *entries, int nvec)
> > >
> > >  	nr_entries = pci_msix_table_size(dev);
> > >  	if (nvec > nr_entries)
> > > -		return -EINVAL;
> > > +		return nr_entries;
> > >
> > >  	/* Check for any invalid entries */
> > >  	for (i = 0; i < nvec; i++) {


