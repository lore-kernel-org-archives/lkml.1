Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYFBWXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYFBWXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYFBWXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:23:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:17300 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYFBWXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tLtFVy79jVl8w9gRSBSygt6MFDfd9dGMMeRATxXm+6ZAVXYh9kRsCEf4KOdsZJvuwjqLNIquBWs7tyPODfFv45y01wbamUWtayc+g/zf1sT1A/WCw0X/wupXGJWYKq2pEnyIbtzPnqy+XSHvNHqBKCDUWVjWgdgdzMpoh1Cn/qM=
Message-ID: <3aa654a40806021523k5b89cd0cjbcddf5810d05072b@mail.gmail.com>
Date: Mon, 2 Jun 2008 15:23:28 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my ALSA intel8x0 sound card regression
Cc: "Rene Herman" <rene.herman@keyaccess.nl>,
       "Rene Herman" <rene.herman@gmail.com>,
       "Len Brown" <len.brown@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200806021605.14519.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>
	 <3aa654a40806012025ic6b9d0dlec05211bad782581@mail.gmail.com>
	 <484444A4.80206@keyaccess.nl>
	 <200806021605.14519.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 3:05 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Monday 02 June 2008 01:06:12 pm Rene Herman wrote:
>> On 02-06-08 05:25, Avuton Olrich wrote:
>>
>> > On Sun, Jun 1, 2008 at 9:20 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:
>> >> On 01-06-08 16:42, Avuton Olrich wrote:
>> >>
>> >>> My intel8x0 card stops working due to a regression; bisection and
>> >>> information below.
>
> Thank you very much for doing all the work to bisect this and write
> up such a complete report.
>
> Can you try the patch below, please?
>
> PNP: mark resources that conflict with PCI devices "disabled"
>
> Both the PNP/PCI conflict detection quirk and the PNP system
> driver must use the same mechanism to mark resources as disabled.
>
> I think it's best to keep the resource and to keep the type bit
> (IORESOURCE_MEM, etc), so that we match the list from firmware
> as closely as possible.
>
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>
> Index: work11/drivers/pnp/quirks.c
> ===================================================================
> --- work11.orig/drivers/pnp/quirks.c    2008-06-02 14:59:03.000000000 -0600
> +++ work11/drivers/pnp/quirks.c 2008-06-02 15:42:35.000000000 -0600
> @@ -286,7 +286,7 @@ static void quirk_system_pci_resources(s
>                                        pci_name(pdev), i,
>                                        (unsigned long long) pci_start,
>                                        (unsigned long long) pci_end);
> -                               res->flags = 0;
> +                               res->flags |= IORESOURCE_DISABLED;
>                        }
>                }
>        }
> Index: work11/drivers/pnp/system.c
> ===================================================================
> --- work11.orig/drivers/pnp/system.c    2008-06-02 14:58:56.000000000 -0600
> +++ work11/drivers/pnp/system.c 2008-06-02 15:44:36.000000000 -0600
> @@ -81,7 +81,7 @@ static void reserve_resources_of_dev(str
>        }
>
>        for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
> -               if (res->flags & IORESOURCE_UNSET)
> +               if (res->flags & IORESOURCE_DISABLED)
>                        continue;
>
>                reserve_range(dev, res->start, res->end, 0);
>

Sweet! That works, thanks for the quick fix. Feel free to add me as Tested-by:.
-- 
avuton
--
 "I've got a fever. And the only prescription is more cowbell." --
Christopher Walken
