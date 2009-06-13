Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbZFMT2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbZFMT2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 15:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZFMT22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 15:28:28 -0400
Received: from mail-yx0-f200.google.com ([209.85.210.200]:35242 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZFMT22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 15:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iksY5NYFgva2XGRxhHFGHkRpY1TBRzwwNOdkE7d5nSMNaq6QjDX4pNLf7adAx3Royc
         2T39Nr3Zk8JtFNOjUE/CU92AzUtqRbCXFPqpeo2YuwV9+C2+ANLkqrxG8SiN/epsa7yy
         Y4I/+6XOsBOJkMHCJZJaBwn6sLUBtzPMqJ+XE=
MIME-Version: 1.0
In-Reply-To: <ada1vpozrf9.fsf@cisco.com>
References: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
	 <ada1vpozrf9.fsf@cisco.com>
Date: Sat, 13 Jun 2009 12:28:29 -0700
Message-ID: <86802c440906131228y6365f23fi59cd04f381fe92fc@mail.gmail.com>
Subject: Re: mthca double free irqs
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Barnes, Jesse" <jesse.barnes@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 9:30 PM, Roland Dreier<rdreier@cisco.com> wrote:
> Something like this should help -- can you verify this fixes the double
> free of irq?
>
>  drivers/infiniband/hw/mthca/mthca_eq.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
> index 28f0e0c..90e4e45 100644
> --- a/drivers/infiniband/hw/mthca/mthca_eq.c
> +++ b/drivers/infiniband/hw/mthca/mthca_eq.c
> @@ -641,9 +641,11 @@ static void mthca_free_irqs(struct mthca_dev *dev)
>        if (dev->eq_table.have_irq)
>                free_irq(dev->pdev->irq, dev);
>        for (i = 0; i < MTHCA_NUM_EQ; ++i)
> -               if (dev->eq_table.eq[i].have_irq)
> +               if (dev->eq_table.eq[i].have_irq) {
>                        free_irq(dev->eq_table.eq[i].msi_x_vector,
>                                 dev->eq_table.eq + i);
> +                       dev->eq_table.eq[i].have_irq = 0;
> +               }
>  }
>
>  static int mthca_map_reg(struct mthca_dev *dev,
>

thanks, that fixes the problem.

got

[  688.153102] ib_mthca: Mellanox InfiniBand HCA driver v1.0 (April 4, 2008)
[  688.164128] ib_mthca: Initializing 0000:c4:00.0
[  688.170696] ib_mthca 0000:c4:00.0: PCI INT A -> GSI 98 (level, low) -> IRQ 98
[  688.184033] ib_mthca 0000:c4:00.0: setting latency timer to 64
[  688.188594] ib_mthca 0000:c4:00.0: using 64bit DMA mask
[  688.208718] ib_mthca 0000:c4:00.0: using 64bit consistent DMA mask
[  688.217191] reserve_memtype added 0xfbef0000-0xfbef1000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  688.232259] free_memtype request 0xfbef0000-0xfbef1000
[  689.243254] reserve_memtype added 0xfbe80000-0xfbe81000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  689.537336] reserve_memtype added 0xfa800000-0xfa801000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  689.587286] ib_mthca 0000:c4:00.0: HCA FW version 4.7.400 is old
(4.8.200 is current).
[  689.592067] ib_mthca 0000:c4:00.0: If you have problems, try
updating your HCA FW.
[  689.603264] reserve_memtype added 0xfbe82000-0xfbe83000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  689.622765]   alloc irq_desc for 230 on node 0
[  689.629521]   alloc kstat_irqs on node 0
[  689.641401] ib_mthca 0000:c4:00.0: irq 230 for MSI/MSI-X
[  689.645155]   alloc irq_desc for 231 on node 0
[  689.647072]   alloc kstat_irqs on node 0
[  689.663348] ib_mthca 0000:c4:00.0: irq 231 for MSI/MSI-X
[  689.666000]   alloc irq_desc for 232 on node 0
[  689.682655]   alloc kstat_irqs on node 0
[  689.685768] ib_mthca 0000:c4:00.0: irq 232 for MSI/MSI-X
[  689.701511] reserve_memtype added 0xfa802000-0xfa803000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  689.721752] reserve_memtype added 0xe5800000-0xe6000000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  689.731141] reserve_memtype added 0xe0000000-0xe4000000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  689.753919] reserve_memtype added 0xfbef0000-0xfbef1000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  689.770375] Overlap at 0xfbe80000-0xfbe81000
[  689.782317] reserve_memtype added 0xfbe80000-0xfbe81000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  689.902837] ib_mthca 0000:c4:00.0: NOP command failed to generate
interrupt (IRQ 232).
[  689.907900] ib_mthca 0000:c4:00.0: Trying again with MSI-X disabled.
[  689.923292] free_memtype request 0xfbe80000-0xfbe81000
[  689.926430] free_memtype request 0xfbef0000-0xfbef1000
[  689.942964] free_memtype request 0xe0000000-0xe4000000
[  689.947059] free_memtype request 0xe5800000-0xe6000000
[  689.962869] free_memtype request 0xfa802000-0xfa803000
[  689.967293] free_memtype request 0xfbe82000-0xfbe83000
[  689.980961] reserve_memtype added 0xfa802000-0xfa803000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  690.003659] reserve_memtype added 0xe5800000-0xe6000000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  690.015144] reserve_memtype added 0xe0000000-0xe4000000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  690.033814] reserve_memtype added 0xfbef0000-0xfbef1000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  690.046945] Overlap at 0xfbe80000-0xfbe81000
[  690.062803] reserve_memtype added 0xfbe80000-0xfbe81000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  690.182718] ib_mthca 0000:c4:00.0: NOP command failed to generate
interrupt (IRQ 98), aborting.
[  690.188676] ib_mthca 0000:c4:00.0: BIOS or ACPI interrupt routing problem?
[  690.203724] free_memtype request 0xfbe80000-0xfbe81000
[  690.205768] free_memtype request 0xfbef0000-0xfbef1000
[  690.224080] free_memtype request 0xe0000000-0xe4000000
[  690.228558] free_memtype request 0xe5800000-0xe6000000
[  690.241523] free_memtype request 0xfa802000-0xfa803000
[  690.246196] free_memtype request 0xfbe80000-0xfbe81000
[  690.263133] free_memtype request 0xfa800000-0xfa801000
[  690.268628] ib_mthca 0000:c4:00.0: PCI INT A disabled
[  690.281553] ib_mthca: probe of 0000:c4:00.0 failed with error -16

as expected.

YH
