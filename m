Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbYGANx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbYGANx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYGANxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:53:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:19166 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944AbYGANxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:53:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,731,1204531200"; 
   d="scan'208";a="583869918"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v4 2/6] dmaengine: Add dma_chan_is_in_use() function
Date: Tue, 1 Jul 2008 14:52:59 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101C21EC7@swsmsx413.ger.corp.intel.com>
In-Reply-To: <f12847240806270224v29de65e8h612a077e12c4d5e1@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v4 2/6] dmaengine: Add dma_chan_is_in_use() function
thread-index: AcjYN42+BODmtciGRRCrupvaxymocADSfUGQ
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: <haavard.skinnemoen@atmel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, <drzeus-list@drzeus.cx>,
       "lkml" <linux-kernel@vger.kernel.org>, <linux-embedded@vger.kernel.org>,
       <kernel@avr32linux.org>, "Nelson, Shannon" <shannon.nelson@intel.com>,
       <david-b@pacbell.net>
X-OriginalArrivalTime: 01 Jul 2008 13:53:00.0512 (UTC) FILETIME=[C65A2600:01C8DB81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Original message ----------
> From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Date: Jun 26, 2008 3:23 PM
> Subject: [PATCH v4 2/6] dmaengine: Add dma_chan_is_in_use() function
> To: Dan Williams <dan.j.williams@intel.com>, Pierre Ossman
> <drzeus-list@drzeus.cx>
> Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
> kernel@avr32linux.org, shannon.nelson@intel.com, David Brownell
> <david-b@pacbell.net>, Haavard Skinnemoen
> <haavard.skinnemoen@atmel.com>
> 
> 
> This moves the code checking if a DMA channel is in use from
> show_in_use() into an inline helper function, dma_is_in_use(). DMA
> controllers can use this in order to give clients exclusive access to
> channels (usually necessary when setting up slave DMA.)
> 
> I have to admit that I don't really understand the channel refcounting
> logic at all... dma_chan_get() simply increments a per-cpu value. How
> can we be sure that whatever CPU calls dma_chan_is_in_use() sees the
> same value?
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---
>  drivers/dma/dmaengine.c   |   12 +-----------
>  include/linux/dmaengine.h |   17 +++++++++++++++++
>  2 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index a57c337..ad8d811 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -105,17 +105,7 @@ static ssize_t show_bytes_transferred(struct
> device *dev, struct device_attribut
>  static ssize_t show_in_use(struct device *dev, struct
> device_attribute *attr, char *buf)
>  {
>        struct dma_chan *chan = to_dma_chan(dev);
> -       int in_use = 0;
> -
> -       if (unlikely(chan->slow_ref) &&
> -               atomic_read(&chan->refcount.refcount) > 1)
> -               in_use = 1;
> -       else {
> -               if (local_read(&(per_cpu_ptr(chan->local,
> -                       get_cpu())->refcount)) > 0)
> -                       in_use = 1;
> -               put_cpu();
> -       }
> +       int in_use = dma_chan_is_in_use(chan);
> 
>        return sprintf(buf, "%d\n", in_use);
>  }
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index cffb95f..4b602d3 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -180,6 +180,23 @@ static inline void dma_chan_put(struct dma_chan
*chan)
>        }
>  }
> 
> +static inline bool dma_chan_is_in_use(struct dma_chan *chan)
> +{
> +       bool in_use = false;
> +
> +       if (unlikely(chan->slow_ref) &&
> +               atomic_read(&chan->refcount.refcount) > 1)
> +               in_use = true;
> +       else {
> +               if (local_read(&(per_cpu_ptr(chan->local,
> +                       get_cpu())->refcount)) > 0)
> +                       in_use = true;
> +               put_cpu();
> +       }
> +
> +       return in_use;
> +}
> +
>  /*
>  * typedef dma_event_callback - function pointer to a DMA event
callback
>  * For each channel added to the system this routine is called for
each
> client. --
> 1.5.5.4

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

Regards,
Maciej
