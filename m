Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZEGIvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZEGIvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZEGIu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:50:57 -0400
Received: from mga07.intel.com ([143.182.124.22]:8950 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753198AbZEGIu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:50:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,308,1239001200"; 
   d="scan'208";a="140141283"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: kvm@vger.kernel.org
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Date: Thu, 7 May 2009 16:51:24 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
References: <20090507082841.GA31751@redhat.com>
In-Reply-To: <20090507082841.GA31751@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071651.24970.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009 16:28:41 Michael S. Tsirkin wrote:
> pci_enable_msix currently returns -EINVAL if you ask
> for more vectors than supported by the device, which would
> typically cause fallback to regular interrupts.
>
> It's better to return the table size, making the driver retry
> MSI-X with less vectors.

Hi Michael

I think driver should read from capability list to know how many vector 
supported by this device before enable MSI-X for device, as 
pci_msix_table_size() did...

-- 
regards
Yang, Sheng

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Hi Jesse,
> This came up when I was adding MSI-X support to virtio pci driver,
> which does not know the exact table size upfront.
> Could you consider this patch for 2.6.31 please?
>
>
>  drivers/pci/msi.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 6f2e629..f5bd1c9 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -687,8 +687,8 @@ int pci_msix_table_size(struct pci_dev *dev)
>   * indicates the successful configuration of MSI-X capability structure
>   * with new allocated MSI-X irqs. A return of < 0 indicates a failure.
>   * Or a return of > 0 indicates that driver request is exceeding the
> number - * of irqs available. Driver should use the returned value to
> re-send - * its request.
> + * of irqs or MSI-X vectors available. Driver should use the returned
> value to + * re-send its request.
>   **/
>  int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int
> nvec) {
> @@ -704,7 +704,7 @@ int pci_enable_msix(struct pci_dev* dev, struct
> msix_entry *entries, int nvec)
>
>  	nr_entries = pci_msix_table_size(dev);
>  	if (nvec > nr_entries)
> -		return -EINVAL;
> +		return nr_entries;
>
>  	/* Check for any invalid entries */
>  	for (i = 0; i < nvec; i++) {


