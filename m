Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbZKFP4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbZKFP4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 10:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759370AbZKFP4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 10:56:06 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:10121 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362AbZKFP4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 10:56:05 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: linux-next: Tree for November 5
Date: Fri, 6 Nov 2009 09:56:08 -0600
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       jbarnes@virtuousgeek.org
References: <20091105190426.c9cadada.sfr@canb.auug.org.au> <200911050931.04838.bjorn.helgaas@hp.com> <200911051017.12135.bjorn.helgaas@hp.com>
In-Reply-To: <200911051017.12135.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911060856.09405.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 November 2009 10:17:11 am Bjorn Helgaas wrote:
> On Thursday 05 November 2009 09:31:04 am Bjorn Helgaas wrote:
> > On Thursday 05 November 2009 03:38:27 am Sachin Sant wrote:
> > > Today's next tree fails to build on i386 with
> > > 
> > > arch/x86/pci/built-in.o: In function `align_resource':
> > > arch/x86/pci/acpi.c:82: undefined reference to `__udivdi3'
> > > 
> > > The code in question was added by commit
> > > 03db42adfeeabe856dbb6894dd3aaff55838330a.
> > 
> > I'll look into this.  I did build and test a 32-bit x86 kernel, but
> > I built it on an x86_64 box using "linux32 make ...", which looks like
> > it used gcc 4.3.2.
> 
> Can you try the patch below, please?

Sachin, can you please try this patch and report whether it
fixes the undefined reference?  I hate to have linux-next
broken longer than necessary.

> commit 00f16f0a2f4826eadec0565e4b454ab8bc7824cc
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Thu Nov 5 10:03:57 2009 -0700
> 
>     x86/PCI: remove 64-bit division
>     
>     The roundup() caused a build error (undefined reference to `__udivdi3').
>     We're aligning to power-of-two boundaries, so it's simpler to just use
>     ALIGN() anyway, which avoids the division.
>     
>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 8ddf4f4..959e548 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -69,17 +69,17 @@ align_resource(struct acpi_device *bridge, struct resource *res)
>  	 * that claim this address space have starting alignment and length
>  	 * constraints, so fix any obvious BIOS goofs.
>  	 */
> -	if (res->start & (align - 1)) {
> +	if (!IS_ALIGNED(res->start, align)) {
>  		dev_printk(KERN_DEBUG, &bridge->dev,
>  			   "host bridge window %pR invalid; "
>  			   "aligning start to %d-byte boundary\n", res, align);
>  		res->start &= ~(align - 1);
>  	}
> -	if ((res->end + 1) & (align - 1)) {
> +	if (!IS_ALIGNED(res->end + 1, align)) {
>  		dev_printk(KERN_DEBUG, &bridge->dev,
>  			   "host bridge window %pR invalid; "
>  			   "aligning end to %d-byte boundary\n", res, align);
> -		res->end = roundup(res->end, align) - 1;
> +		res->end = ALIGN(res->end, align) - 1;
>  	}
>  }
>  
> 


