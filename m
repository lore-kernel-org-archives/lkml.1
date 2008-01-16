Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbYAPF4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbYAPF4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 00:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYAPFz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 00:55:58 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:60400 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYAPFz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 00:55:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=abCdYqWdxUjlczzPbLQoo0elWo5TSmZ2jmFSu4VE85EjjMNg0UkS51FI4GpxinR1mOpD8jLbgCKMGevd4fNKqzz1pO5meaazkIpopflzFPbQd9lbV25k88x/ejvnEvYBY767n37O5gT2kZyxE7ob2f5ap5Qa5jOVFkOOKOcPMZ8=
Message-ID: <a8e1da0801152155x18cfd0dcvfe638323275e539d@mail.gmail.com>
Date: Wed, 16 Jan 2008 13:55:54 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: pnpacpi : exceeded the max number of IO resources
Cc: "Frans Pop" <elendil@planet.nl>, bjorn.helgaas@hp.com,
       "Len Brown" <lenb@kernel.org>, akpm@osdl.org, cholvenstot@comcast.net,
       linux-kernel@vger.kernel.org, shaohua.li@intel.com, trenn@suse.de,
       yakui.zhao@intel.com
In-Reply-To: <4784DE94.8020508@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196428488.7066.6.camel@localhost> <47508D3C.9050507@keyaccess.nl>
	 <475436A3.90906@keyaccess.nl> <200801082250.51026.lenb@kernel.org>
	 <E1JCXK5-0002GH-0x@faramir.fjphome.nl> <4784DE94.8020508@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 10:47 PM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 09-01-08 10:34, Frans Pop wrote:
>
> Bjorn:
>
> > Len Brown wrote:
>
> >>>> Well, yes, the warning is actually new as well. Previously your kernel
> >>>> just silently ignored 8 more mem resources than it does now it seems.
> >>>>
> >>>> Given that people are hitting these limits, it might make sense to just
> >>>> do away with the warning for 2.6.24 again while waiting for the dynamic
> >>>> code?
> >>> Ping. Should these warnings be reverted for 2.6.24?
> >> No. I don't think hiding this issue again is a good idea.
> >> I'd rather live with people complaining about an addition dmesg line.
> >
> > We're not talking about "a" additional line. In my case [1] we're talking
> > about 22 (!) additional identical lines.
>
> You lucky devil. Someone else reported 92 if I remember rightly. This really
> needs to be called a 2.6.24 bug. Stick the word "regression" in the subject
> line and someone will notice...
>
> The warning might provide useful information to someone looking at a dmesg
> but given that people are hitting them way too hard with the only difference
> versus 2.6.23 being tke kernel now complaining about it, they're not useful
> enough to be printed more than once, or at more then DEBUG level or even at
> all in fact since we already know the static limit isn't enough for everyone
> and needs be turned dynamic -- really, what else is someone going to debug
> with it?
>
> I'd consider Bjorn Helgaas the PnP maintainer and he earlier agreed that
> this needed something:
>
> http://lkml.org/lkml/2007/12/5/301
>
> Printing the warning only once per type as per attached fixes the problenm
> as well.
>
> Bjorn, could you push your preference into 2.6.24?
>
>
> > Not fixing this before 2.6.24 seems completely inconsistent:
> > - either this is a real bug and the ERR level message is correct, in which
> >   case the limits should be increased;
> > - or hitting the limits is harmless and the message should be changed to
> >   DEBUG level.
> >
> > It is great to hear that the memory allocation will become dynamic in the
> > future and maybe that could just justify your standpoint, but having the
> > messages is damn ugly and alarming from a user point of view.
> >
> > Please keep in mind that depending on distro release schedules, 2.6.24 could
> > live for quite a bit longer than just the period needed to release 2.6.25
> > (if that is when the dynamic allocation will be implemented).
> >
> > Cheers,
> > FJP
> >
> > [1] http://lkml.org/lkml/2008/1/6/279
>
>
>
> diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
> index 3c5eb37..cd9d4a8 100644
> --- a/drivers/pnp/pnpacpi/rsparser.c
> +++ b/drivers/pnp/pnpacpi/rsparser.c
> @@ -73,6 +73,7 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res,
>                                                 u32 gsi, int triggering,
>                                                 int polarity, int shareable)
>  {
> +       static int warned;
>         int i = 0;
>         int irq;
>         int p, t;
> @@ -84,8 +85,9 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res,
>                i < PNP_MAX_IRQ)
>                 i++;
>         if (i >= PNP_MAX_IRQ) {
> -               printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
> -                               "resources: %d \n", PNP_MAX_IRQ);
> +               if (!warned++)
> +                       printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
> +                                       "resources: %d \n", PNP_MAX_IRQ);
>                 return;
>         }
>         /*
> @@ -168,6 +170,7 @@ static void pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res,
>                                                 u32 dma, int type,
>                                                 int bus_master, int transfer)
>  {
> +       static int warned;
>         int i = 0;
>
>         while (i < PNP_MAX_DMA &&
> @@ -183,7 +186,7 @@ static void pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res,
>                 }
>                 res->dma_resource[i].start = dma;
>                 res->dma_resource[i].end = dma;
> -       } else {
> +       } else if (!warned++) {
>                 printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
>                                 "resources: %d \n", PNP_MAX_DMA);
>         }
> @@ -192,6 +195,7 @@ static void pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res,
>  static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
>                                                u64 io, u64 len, int io_decode)
>  {
> +       static int warned;
>         int i = 0;
>
>         while (!(res->port_resource[i].flags & IORESOURCE_UNSET) &&
> @@ -207,7 +211,7 @@ static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
>                 }
>                 res->port_resource[i].start = io;
>                 res->port_resource[i].end = io + len - 1;
> -       } else {
> +       } else if (!warned++) {
>                 printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
>                                 "resources: %d \n", PNP_MAX_PORT);
>         }
> @@ -217,6 +221,7 @@ static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
>                                                 u64 mem, u64 len,
>                                                 int write_protect)
>  {
> +       static int warned;
>         int i = 0;
>
>         while (!(res->mem_resource[i].flags & IORESOURCE_UNSET) &&
> @@ -233,7 +238,7 @@ static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
>
>                 res->mem_resource[i].start = mem;
>                 res->mem_resource[i].end = mem + len - 1;
> -       } else {
> +       } else if (!warned++) {
>                 printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
>                                 "resources: %d\n", PNP_MAX_MEM);
>         }
>
>

I noticed the port number changed to 40 in 2.6.24-rc8, but it's not
enough for me still.

Regards
dave
