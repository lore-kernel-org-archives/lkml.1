Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbZE2No2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbZE2No2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760448AbZE2Nm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:42:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:56748 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760337AbZE2Nmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:42:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="416798738"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "maan@systemlinux.org" <maan@systemlinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 29 May 2009 14:42:11 +0100
Subject: RE: [PATCH v2 08/11] async_tx: add support for asynchronous GF
 multiplication
Thread-Topic: [PATCH v2 08/11] async_tx: add support for asynchronous GF
 multiplication
Thread-Index: AcnZIquQ36rFKbdbSyuia3Pgom4JHQHOUYjQ
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C72@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010006.4104.70181.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905200111q37457b29lb9e30879e251888@mail.gmail.com>
In-Reply-To: <f12847240905200111q37457b29lb9e30879e251888@mail.gmail.com>
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
> [ Based on an original patch by Yuri Tikhonov ]
> 
> This adds support for doing asynchronous GF multiplication by adding
> two additional functions to the async_tx API:
> 
>  async_gen_syndrome() does simultaneous XOR and Galois field
>    multiplication of sources.
> 
>  async_syndrome_val() validates the given source buffers against known P
>    and Q values.
> 
> When a request is made to run async_pq against more than the hardware
> maximum number of supported sources we need to reuse the previous
> generated P and Q values as sources into the next operation.  Care must
> be taken to remove Q from P' and P from Q'.  For example to perform a 5
> source pq op with hardware that only supports 4 sources at a time the
> following approach is taken:
> 
> p, q = PQ(src0, src1, src2, src3, COEF({01}, {02}, {04}, {08}))
> p', q' = PQ(p, q, q, src4, COEF({00}, {01}, {00}, {10}))
> 
> p' = p + q + q + src4 = p + src4
> q' = {00}*p + {01}*q + {00}*q + {10}*src4 = q + {10}*src4
> 
> Note: 4 is the minimum acceptable maxpq otherwise we punt to
> synchronous-software path.
> 
> The DMA_PREP_CONTINUE flag indicates to the driver to reuse p and q as
> sources (in the above manner) and fill the remaining slots up to maxpq
> with the new sources/coefficients.
> 
> Note: Some devices have native support for P+Q continuation and can skip
> this extra work.  Devices with this capability can advertise it with
> dma_set_maxpq.  It is up to each driver how the DMA_PREP_CONTINUE flag
> is honored.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/arm/mach-iop13xx/setup.c |    2
>  crypto/async_tx/Kconfig       |    4
>  crypto/async_tx/Makefile      |    1
>  crypto/async_tx/async_pq.c    |  399 +++++++++++++++++++++++++++++++++++++++++
>  crypto/async_tx/async_xor.c   |    2
>  drivers/dma/dmaengine.c       |    4
>  drivers/dma/iop-adma.c        |    2
>  include/linux/async_tx.h      |    9 +
>  include/linux/dmaengine.h     |   58 +++++-
>  9 files changed, 472 insertions(+), 9 deletions(-)
>  create mode 100644 crypto/async_tx/async_pq.c

(...)

> +               /* Since we have clobbered the src_list we are committed
> +                * to doing this asynchronously.  Drivers force forward
> +                * progress in case they can not provide a descriptor
> +                */
> +               for (;;) {
> +                       tx = dma->device_prep_dma_pq(chan, dma_dest,
> +                                                    &dma_src[src_off],
> +                                                    pq_src_cnt,
> +                                                    &coefs[src_off], len,
> +                                                    dma_flags);
> +                       if (likely(tx))
> +                               break;
> +                       async_tx_quiesce(&submit->depend_tx);
> +                       dma_async_issue_pending(chan);
> +               }

How about adding a timeout to the loop in case we do not get a descriptor at all for some reason?

> +               for (;;) {
> +                       tx = device->device_prep_dma_pq_val(chan, pq, dma_src,
> +                                                           disks - 2,
> +                                                           raid6_gfexp,
> +                                                           len, pqres,
> +                                                           dma_flags);
> +                       if (likely(tx))
> +                               break;
> +                       async_tx_quiesce(&submit->depend_tx);
> +                       dma_async_issue_pending(chan);
> +               }

Same as above...

Thanks,
Maciej