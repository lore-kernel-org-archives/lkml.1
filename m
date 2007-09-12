Return-Path: <linux-kernel-owner+w=401wt.eu-S1765533AbXILHue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765533AbXILHue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765150AbXILHrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:47:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:34637 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765259AbXILHrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tl0q6zi3qYzb3M1KWcH5lZfuIYfqd0SBXe1qM0XvzqSEGzhsS7N1eWDLy1a7AyB3zo8z/VoNHtZCtt+7y/uSN7Q3MnlO0RVi0uFR0mms4IS8UflXzmksbj99ABeX2TOcx9ZOE6AP85osQsqmO/thuG3WuR5wyqtpQ0oCrxEIMVE=
Message-ID: <406fe6c90709120047g1cf0a995r391e9fe1fbac7101@mail.gmail.com>
Date: Wed, 12 Sep 2007 09:47:45 +0200
From: "=?ISO-8859-1?Q?K=F6vedi_Kriszti=E1n?=" <kovedi@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [Sparc64 BUG] hangup under booting 2.6.22.X whith Sparc64
Cc: linux-kernel@vger.kernel.org, stable-bounces@kernel.org,
       davem@sunset.davemloft.net
In-Reply-To: <20070911.083823.15264559.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <406fe6c90709100442j1ae0ef79v3188eb10b8be451b@mail.gmail.com>
	 <20070910.053642.71114977.davem@davemloft.net>
	 <406fe6c90709102233m2472e6c4h7d329a3f64692645@mail.gmail.com>
	 <20070911.083823.15264559.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/11, David Miller <davem@davemloft.net>:
>
> I think this patch should fix the problem.
>
> Please give it a try, thanks.
>
> diff --git a/arch/sparc64/kernel/pci.c b/arch/sparc64/kernel/pci.c
> index 139b4cf..e8dac81 100644
> --- a/arch/sparc64/kernel/pci.c
> +++ b/arch/sparc64/kernel/pci.c
> @@ -744,7 +744,7 @@ static void __devinit pci_of_scan_bus(struct pci_pbm_info *pbm,
>  {
>         struct device_node *child;
>         const u32 *reg;
> -       int reglen, devfn;
> +       int reglen, devfn, prev_devfn;
>         struct pci_dev *dev;
>
>         if (ofpci_verbose)
> @@ -752,14 +752,25 @@ static void __devinit pci_of_scan_bus(struct pci_pbm_info *pbm,
>                        node->full_name, bus->number);
>
>         child = NULL;
> +       prev_devfn = -1;
>         while ((child = of_get_next_child(node, child)) != NULL) {
>                 if (ofpci_verbose)
>                         printk("  * %s\n", child->full_name);
>                 reg = of_get_property(child, "reg", &reglen);
>                 if (reg == NULL || reglen < 20)
>                         continue;
> +
>                 devfn = (reg[0] >> 8) & 0xff;
>
> +               /* This is a workaround for some device trees
> +                * which list PCI devices twice.  On the V100
> +                * for example, device number 3 is listed twice.
> +                * Once as "pm" and once again as "lomp".
> +                */
> +               if (devfn == prev_devfn)
> +                       continue;
> +               prev_devfn = devfn;
> +
>                 /* create a new pci_dev for this device */
>                 dev = of_create_pci_dev(pbm, child, bus, devfn, 0);
>                 if (!dev)
>

Thanks
The patch work fine the kernel booting up without error messages.


when i patch the kernel become this error message:

patch -p1 < ~/2.6.22.6.patch
patching file arch/sparc64/kernel/pci.c
Hunk #1 FAILED at 744.
Hunk #2 FAILED at 752.
2 out of 2 hunks FAILED -- saving rejects to file arch/sparc64/kernel/pci.c.rej

but i add manual this patch the kernel and it works.
