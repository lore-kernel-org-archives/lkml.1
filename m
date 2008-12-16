Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbYLPU0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbYLPU0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759346AbYLPUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:24:28 -0500
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:41161 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752933AbYLPUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:24:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=RTaRDn1nZSqYqJ9jCv21BmXKQjH93v2qGJ0vo7nSeG+C9hv9zNZiXDTiXdldTFpjy4TrayR/1MdmdjR/KGwKvQpAywHycgcD+ZmOWGfK6laHDwJf3YyklhzAx7KNPPje;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>, Adam Jackson <ajax@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ajax@redhat.com: [PATCH] PCI: Don't carp about BAR allocation failures in quiet boot]
Date: Tue, 16 Dec 2008 12:24:18 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
References: <20081212054940.GA12451@elte.hu>
In-Reply-To: <20081212054940.GA12451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161224.18719.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the heads-up, applied this to my linux-next branch.

Jesse

On Thursday, December 11, 2008 9:49 pm Ingo Molnar wrote:
> FYI.
>
> ----- Forwarded message from Adam Jackson <ajax@redhat.com> -----
>
> Date: Thu, 11 Dec 2008 17:13:45 -0500
> From: Adam Jackson <ajax@redhat.com>
> To: linux-kernel@vger.kernel.org
> Subject: [PATCH] PCI: Don't carp about BAR allocation failures in quiet
> boot Cc: Adam Jackson <ajax@redhat.com>
>
> These are easy to trigger (more or less harmlessly) with multiple video
> cards, since the ROM BAR will typically not be given any space by the
> BIOS bridge setup.  No reason to punish quiet boot for this.
>
> Signed-off-by: Adam Jackson <ajax@redhat.com>
> ---
>  arch/x86/pci/i386.c     |    4 ++--
>  drivers/pci/setup-res.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 844df0c..43d9783 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -129,7 +129,7 @@ static void __init
> pcibios_allocate_bus_resources(struct list_head *bus_list) pr =
> pci_find_parent_resource(dev, r);
>  				if (!r->start || !pr ||
>  				    request_resource(pr, r) < 0) {
> -					dev_err(&dev->dev, "BAR %d: can't allocate resource\n", idx);
> +					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
>  					/*
>  					 * Something is wrong with the region.
>  					 * Invalidate the resource to prevent
> @@ -170,7 +170,7 @@ static void __init pcibios_allocate_resources(int pass)
>  					r->flags, disabled, pass);
>  				pr = pci_find_parent_resource(dev, r);
>  				if (!pr || request_resource(pr, r) < 0) {
> -					dev_err(&dev->dev, "BAR %d: can't allocate resource\n", idx);
> +					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
>  					/* We'll assign a new address later */
>  					r->end -= r->start;
>  					r->start = 0;
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index 2dbd96c..4e37563 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -134,7 +134,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>
>  	align = resource_alignment(res);
>  	if (!align) {
> -		dev_err(&dev->dev, "BAR %d: can't allocate resource (bogus "
> +		dev_info(&dev->dev, "BAR %d: can't allocate resource (bogus "
>  			"alignment) %pR flags %#lx\n",
>  			resno, res, res->flags);
>  		return -EINVAL;
> @@ -157,7 +157,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>  	}
>
>  	if (ret) {
> -		dev_err(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
> +		dev_info(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
>  			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
>  	} else {
>  		res->flags &= ~IORESOURCE_STARTALIGN;

-- 
Jesse Barnes, Intel Open Source Technology Center

