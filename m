Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbZCFPtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbZCFPtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZCFPtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:49:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:57675 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbZCFPta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:49:30 -0500
MIME-Version: 1.0
In-Reply-To: <20090227235456.4DED2448057@mail135-wa4.bigfish.com>
References: <20090227235456.4DED2448057@mail135-wa4.bigfish.com>
Date: Fri, 6 Mar 2009 08:49:26 -0700
Message-ID: <fa686aa40903060749l422386f0p5a720cbabc07ff74@mail.gmail.com>
Subject: Re: [PATCH] Xilinx: SPI: driver not releasing memory
From: Grant Likely <grant.likely@secretlab.ca>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linuxppc-dev@ozlabs.org, jwboyer@linux.vnet.ibm.com,
       akonovalov@ru.mvista.com, John Linn <John.Linn@xilinx.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Are you okay with this patch and okay with it going in via Ben's
powerpc tree?  Ben wants to ensure that changes outside arch/powerpc/
are properly acked before going into his tree.

Thanks,
g.

On Sat, Feb 28, 2009 at 9:09 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Feb 27, 2009 at 4:54 PM, John Linn <john.linn@xilinx.com> wrote:
>> The driver was not releasing memory when it was removed or
>> when there was a failure during probe. This fixes it.
>>
>> Signed-off-by: John Linn <john.linn@xilinx.com>
>
> Looks good.
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
> I'll pick this up into my -next branch and ask Ben to pull it in the
> next week or so.

> ---
> This is an incremental patch to the patch (updated driver
> for device tree) that is in the next branch.
> ---
>  drivers/spi/xilinx_spi.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
> index fe7e5f3..494d3f7 100644
> --- a/drivers/spi/xilinx_spi.c
> +++ b/drivers/spi/xilinx_spi.c
> @@ -354,7 +354,7 @@ static int __init xilinx_spi_of_probe(struct of_device *ofdev,
>        if (xspi->regs == NULL) {
>                rc = -ENOMEM;
>                dev_warn(&ofdev->dev, "ioremap failure\n");
> -               goto put_master;
> +               goto release_mem;
>        }
>        xspi->irq = r_irq->start;
>
> @@ -365,7 +365,7 @@ static int __init xilinx_spi_of_probe(struct of_device *ofdev,
>        prop = of_get_property(ofdev->node, "xlnx,num-ss-bits", &len);
>        if (!prop || len < sizeof(*prop)) {
>                dev_warn(&ofdev->dev, "no 'xlnx,num-ss-bits' property\n");
> -               goto put_master;
> +               goto unmap_io;
>        }
>        master->num_chipselect = *prop;
>
> @@ -397,6 +397,8 @@ free_irq:
>        free_irq(xspi->irq, xspi);
>  unmap_io:
>        iounmap(xspi->regs);
> +release_mem:
> +       release_mem_region(r_mem->start, resource_size(r_mem));
>  put_master:
>        spi_master_put(master);
>        return rc;
> @@ -406,6 +408,7 @@ static int __devexit xilinx_spi_remove(struct of_device *ofdev)
>  {
>        struct xilinx_spi *xspi;
>        struct spi_master *master;
> +       struct resource r_mem;
>
>        master = platform_get_drvdata(ofdev);
>        xspi = spi_master_get_devdata(master);
> @@ -413,6 +416,8 @@ static int __devexit xilinx_spi_remove(struct of_device *ofdev)
>        spi_bitbang_stop(&xspi->bitbang);
>        free_irq(xspi->irq, xspi);
>        iounmap(xspi->regs);
> +       if (!of_address_to_resource(ofdev->node, 0, &r_mem))
> +               release_mem_region(r_mem.start, resource_size(&r_mem));
>        dev_set_drvdata(&ofdev->dev, 0);
>        spi_master_put(xspi->bitbang.master);
>
> --
> 1.5.3.4
>
>
>
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
