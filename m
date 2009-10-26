Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZJZQdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZJZQdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZJZQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:33:00 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:42276 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbZJZQc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:32:57 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: only release that resource index is less than 3
Date: Mon, 26 Oct 2009 10:32:57 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <4AE2C827.8040905@kernel.org>
In-Reply-To: <4AE2C827.8040905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910261032.58231.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 October 2009 03:25:59 am Yinghai Lu wrote:
> after
> 
> | commit 308cf8e13f42f476dfd6552aeff58fdc0788e566
> |
> |    PCI: get larger bridge ranges when space is available
> 
> found one of resource of peer root bus (0x00) get released from root
> resource. later one hotplug device can not get big range anymore.
> other peer root buses is ok.
> 
> it turns out it is from transparent path.
> 
> those resources will be used for pci bridge BAR updated.
> so need to limit it to 3.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -344,9 +344,14 @@ static struct resource *find_free_bus_re
>  			 * if there is no child under that, we should release
>  			 * and use it. don't need to reset it, pbus_size_* will
>  			 * set it again
> +			 * need to be less 3, otherwise can not write it to
> +			 * bridge, also need to avoid releasing it from
> +			 * transparent bus path
>  			 */
> -			if (!r->child && !release_resource(r))
> -				return r;
> +			if (i < 3 && !r->child) {
> +				if (!release_resource(r))
> +					return r;
> +			}

I am bewildered.

308cf8e13f42f added the release_resource() call here in
find_free_bus_resource().  I don't understand why the release
should be there in the first place -- it doesn't seem to
logically fit there.  A "release" should be connected to an
event, maybe a hot-remove or a move of a device from one place
to another.  It shouldn't be something we do as a side-effect
of searching for a free resource.

Now you're adding the magic number "3", which seems even less
related to the job of "finding an available bus resource."  I'm
guessing the "3" is related to PCI_BRIDGE_RESOURCES or something,
but that should be made explicit, and I really don't think it
belongs in this function.

Bjorn
