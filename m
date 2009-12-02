Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZLBXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZLBXvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZLBXvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:51:16 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36934 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZLBXvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:51:16 -0500
MIME-Version: 1.0
In-Reply-To: <20091202014733.GD10295@tux1.beaverton.ibm.com>
References: <20091202014733.GD10295@tux1.beaverton.ibm.com>
Date: Wed, 2 Dec 2009 17:51:19 -0600
Message-ID: <61b968730912021551m23c9859doda2d414529c59ac6@mail.gmail.com>
Subject: Re: [PATCH] Calgary: Find nearest matching Calgary while walking up 
	the PCI tree
From: Jon Mason <jdmason@kudzu.us>
To: djwong@us.ibm.com
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, discuss@x86-64.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Corinna Schultz <coschult@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 1, 2009 at 7:47 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> On a multi-node x3950M2 system, there's a slight oddity in the PCI device tree
> for all secondary nodes:
>
> 30:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
>  \-33:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01)
>    \-34:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)
>
> ...as compared to the primary node:
>
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
>  \-01:00.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
> 03:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01)
>  \-04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)
>
> In both nodes, the LSI RAID controller hangs off a CalIOC2 device, but on the
> secondary nodes, the BIOS hides the VGA device and substitutes the device tree
> ending with the disk controller.
>
> It would seem that Calgary devices don't necessarily appear at the top of the
> PCI tree, which means that the current code to find the Calgary IOMMU that goes
> with a particular device is buggy.  Rather than walk all the way to the top of
> the PCI device tree and try to match bus number with Calgary descriptor, the
> code needs to examine each parent of the particular device; if it encounters a
> Calgary with a matching bus number, simply use that.  Otherwise, we BUG() when
> the bus number of the Calgary doesn't match the bus number of whatever's at the
> top of the device tree.
>
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
>
>  arch/x86/kernel/pci-calgary_64.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
>
>
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index 971a3be..e6ec8a2 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -318,13 +318,15 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
>
>        pdev = to_pci_dev(dev);
>
> +       /* search up the device tree for an iommu */
>        pbus = pdev->bus;
> -
> -       /* is the device behind a bridge? Look for the root bus */
> -       while (pbus->parent)
> +       do {
> +               tbl = pci_iommu(pbus);
> +               if (tbl && tbl->it_busno == pbus->number)
> +                       break;
> +               tbl = NULL;

I believe the NULL assignment is unnecessary.  If not, then the if
check and BUG_ON are busted.

>                pbus = pbus->parent;
> -
> -       tbl = pci_iommu(pbus);
> +       } while (pbus);
>
>        BUG_ON(tbl && (tbl->it_busno != pbus->number));
>
>
