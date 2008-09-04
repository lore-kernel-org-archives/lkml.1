Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbYIDI6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbYIDI6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYIDI5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:57:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbYIDI5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:57:50 -0400
Date: Thu, 4 Sep 2008 01:57:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080904015701.5959623a.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809040143350.3452@nehalem.linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>
	<20080903223318.84b6ce8b.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040045190.3378@nehalem.linux-foundation.org>
	<20080904012544.cabed847.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040143350.3452@nehalem.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 01:50:58 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> commit 5f17cfce5776c566d64430f543a289e5cfa4538b
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Sep 4 01:33:59 2008 -0700
> 
>     PCI: fix pbus_size_mem() resource alignment for CardBus controllers
>     
>     Commit 884525655d07fdee9245716b998ecdc45cdd8007 ("PCI: clean up resource
>     alignment management") changed the resource handling to mark how a
>     resource was aligned on a per-resource basis.
>     
>     Thus, instead of looking at the resource number to determine whether it
>     was a bridge resource or a regular resource (they have different
>     alignment rules), we should just ask the resource for its alignment
>     directly.
>     
>     The reason this broke only cardbus resources was that for the other
>     types of resources, the old way of deciding alignment actually still
>     happened to work.  But CardBus bridge resources had been changed by
>     commit 934b7024f0ed29003c95cef447d92737ab86dc4f ("Fix cardbus resource
>     allocation") to look more like regular resources than PCI bridge
>     resources from an alignment handling standpoint.
>     
>     Reported-and-tested-by: Andrew Morton <akpm@linux-foundation.org>
>     Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
>     Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/pci/setup-bus.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 82634a2..1aad599 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -352,11 +352,12 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
>  				continue;
>  			r_size = r->end - r->start + 1;
>  			/* For bridges size != alignment */
> -			align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
> +			align = resource_alignment(r);
>  			order = __ffs(align) - 20;
>  			if (order > 11) {
> -				dev_warn(&dev->dev, "BAR %d too large: "
> +				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
>  				       "%#016llx-%#016llx\n", i,
> +				       (unsigned long long)align,
>  				       (unsigned long long)r->start,
>  				       (unsigned long long)r->end);
>  				r->flags = 0;

Is this worth backporting into 2.6.26.x?
