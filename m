Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbZE2No5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbZE2No5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbZE2NnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:43:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:10836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760375AbZE2Nm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:42:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="416798742"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "maan@systemlinux.org" <maan@systemlinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 29 May 2009 14:42:15 +0100
Subject: RE: [PATCH v2 09/11] async_tx: add support for asynchronous RAID6
 recovery operations
Thread-Topic: [PATCH v2 09/11] async_tx: add support for asynchronous RAID6
 recovery operations
Thread-Index: AcndIvrgbptFoN1/SgeLLo6Es5optQDOa+8Q
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C73@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010012.4104.50825.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250323q2e14efd6q69022a62cc7fd01f@mail.gmail.com>
In-Reply-To: <f12847240905250323q2e14efd6q69022a62cc7fd01f@mail.gmail.com>
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
>  async_raid6_2data_recov() recovers two data disk failures
> 
>  async_raid6_datap_recov() recovers a data disk and the P disk
> 
> These routines are a port of the synchronous versions found in
> drivers/md/raid6recov.c.  The primary difference is breaking out the xor
> operations into separate calls to async_xor.  Two helper routines are
> introduced to perform scalar multiplication where needed.
> async_sum_product() multiplies two sources by scalar coefficients and
> then sums (xor) the result.  async_mult() simply multiplies a single
> source by a scalar.
> 
> [ Impact: asynchronous raid6 recovery routines for 2data and datap cases ]
> 
> Cc: Yuri Tikhonov <yur@emcraft.com>
> Cc: Ilya Yanok <yanok@emcraft.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  crypto/async_tx/Kconfig             |    5 +
>  crypto/async_tx/Makefile            |    1
>  crypto/async_tx/async_raid6_recov.c |  292 +++++++++++++++++++++++++++++++++++
>  include/linux/async_tx.h            |    8 +
>  4 files changed, 306 insertions(+), 0 deletions(-)
>  create mode 100644 crypto/async_tx/async_raid6_recov.c

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
 
With a minor comment:

> +static struct dma_async_tx_descriptor *
> +async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
> +          struct async_submit_ctl *submit)
> +{
> +       struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
> +                                                     &dest, 1, srcs, 2, len);
> +       struct dma_device *dma = chan ? chan->device : NULL;
> +       const u8 *qmul; /* Q multiplier table */
> +       u8 *d, *s;
> +
> +       if (dma) {
> +               dma_addr_t dma_dest[2];
> +               dma_addr_t dma_src[1];
> +               struct device *dev = dma->dev;
> +               struct dma_async_tx_descriptor *tx;
> +               enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
> +
> +               dma_dest[1] = dma_map_page(dev, dest, 0, len,
> DMA_BIDIRECTIONAL);
> +               dma_src[0] = dma_map_page(dev, src, 0, len, DMA_TO_DEVICE);
> +               tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 1, &coef,
> +                                            len, dma_flags);
> +               if (tx) {
> +                       async_tx_submit(chan, tx, submit);
> +                       return tx;
> +               }
> +       }

How about adding "run the operation synchronously" comment at this point, just like it is in async_sum_product?

Maciej