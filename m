Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbZE2Nmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbZE2Nmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbZE2NmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:42:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:26614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759539AbZE2NmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:42:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="519893708"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "maan@systemlinux.org" <maan@systemlinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 29 May 2009 14:41:31 +0100
Subject: RE: [PATCH v2 01/11] async_tx: rename zero_sum to val
Thread-Topic: [PATCH v2 01/11] async_tx: rename zero_sum to val
Thread-Index: AcnZInlYMeKtN4BmQRGsBgcZHL4SzQHMcf+g
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C69@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005931.4104.81475.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905200110x63b22601idbbdf3369984fa9a@mail.gmail.com>
In-Reply-To: <f12847240905200110x63b22601idbbdf3369984fa9a@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> 'zero_sum' does not properly describe the operation of generating parity
> and checking that it validates against an existing buffer.  Change the
> name of the operation to 'val' (for 'validate').  This is in
> anticipation of the p+q case where it is a requirement to identify the
> target parity buffers separately from the source buffers, because the
> target parity buffers will not have corresponding pq coefficients.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/arm/mach-iop13xx/setup.c |    8 ++++----
>  arch/arm/plat-iop/adma.c      |    2 +-
>  crypto/async_tx/async_xor.c   |   16 ++++++++--------
>  drivers/dma/dmaengine.c       |    4 ++--
>  drivers/dma/iop-adma.c        |   38 +++++++++++++++++++-------------------
>  drivers/md/raid5.c            |    2 +-
>  include/linux/async_tx.h      |    2 +-
>  include/linux/dmaengine.h     |    8 ++++----
>  8 files changed, 40 insertions(+), 40 deletions(-)

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

with following comments:

> @@ -1072,10 +1072,10 @@ iop_adma_xor_zero_sum_self_test(struct
> iop_adma_device *device)
>                dma_srcs[i] = dma_map_page(dma_chan->device->dev,
>                                           zero_sum_srcs[i], 0, PAGE_SIZE,
>                                           DMA_TO_DEVICE);
> -       tx = iop_adma_prep_dma_zero_sum(dma_chan, dma_srcs,
> -                                       IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
> -                                       &zero_sum_result,
> -                                       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +       tx = iop_adma_prep_dma_xor_val(dma_chan, dma_srcs,
> +                                      IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
> +                                      &zero_sum_result,
> +                                      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);

What about zero_sum_srcs and zero_sum_result? Shouldn't they be renamed too?

> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -854,7 +854,7 @@ static void ops_run_check(struct stripe_head *sh)
>                        xor_srcs[count++] = dev->page;
>        }
> 
> -       tx = async_xor_zero_sum(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
> +       tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
>                &sh->ops.zero_sum_result, 0, NULL, NULL, NULL);

And the same here...

Regards,
Maciej