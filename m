Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbZCPVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbZCPVu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZCPVus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:50:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:14655 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZCPVus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:50:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="439402677"
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       "ralf@linux-mips.org" <ralf@linux-mips.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "haavard.skinnemoen@atmel.com" <haavard.skinnemoen@atmel.com>
In-Reply-To: <20090313.231659.41197617.anemo@mba.ocn.ne.jp>
References: <e9c3a7c20902251745t314c1e0cs114d2199ccc8cf36@mail.gmail.com>
	 <20090227.002436.106263719.anemo@mba.ocn.ne.jp>
	 <20090313.011950.61509382.anemo@mba.ocn.ne.jp>
	 <20090313.231659.41197617.anemo@mba.ocn.ne.jp>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 14:50:46 -0700
Message-Id: <1237240246.27945.6.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 07:16 -0700, Atsushi Nemoto wrote:
> On Fri, 13 Mar 2009 01:19:50 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > Subject: dmaengine: Use chan_id provided by DMA device driver
> > From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> > 
> > If chan_id was already given by the DMA device driver, use it.
> > Otherwise assign an incremental number for each channels.
> > 
> > This allows the DMA device driver to reserve some channel ID numbers.
> ...
> > @@ -663,7 +664,9 @@ int dma_async_device_register(struct dma_device *device)
> >  			continue;
> >  		}
> >  
> > -		chan->chan_id = chancnt++;
> > +		if (!chan->chan_id)
> > +			chan->chan_id = chan_id++;
> > +		chancnt++;
> >  		chan->dev->device.class = &dma_devclass;
> >  		chan->dev->device.parent = device->dev;
> >  		chan->dev->chan = chan;
> 
> This patch will fix another potential problem.  Some driver, for
> example ipu, assumes chan_id is an index of its internal array.  But
> dmaengine core does not guarantee it.
> 
> 	/* represent channels in sysfs. Probably want devs too */
> 	list_for_each_entry(chan, &device->channels, device_node) {
> 		chan->local = alloc_percpu(typeof(*chan->local));
> 		if (chan->local == NULL)
> 			continue;
> 		chan->dev = kzalloc(sizeof(*chan->dev), GFP_KERNEL);
> 		if (chan->dev == NULL) {
> 			free_percpu(chan->local);
> 			continue;
> 		}
> 
> 		chan->chan_id = chancnt++;
> 		...
> 	}
> 	device->chancnt = chancnt;
> 
> If alloc_percpu or kzalloc failed, chan_id does not match with its
> position in device->channels list.
> 
> 
> And above "continue" looks buggy anyway.  Keeping incomplete channels
> in device->channels list looks very dangerous...

Yes it does.  Here is the proposed fix:
----->
dmaengine: fail device registration if channel registration fails

From: Dan Williams <dan.j.williams@intel.com>

Atsushi points out:
"If alloc_percpu or kzalloc failed, chan_id does not match with its
position in device->channels list.

And above "continue" looks buggy anyway.  Keeping incomplete channels
in device->channels list looks very dangerous..."

Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmaengine.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index a589930..fa14e8b 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -652,13 +652,15 @@ int dma_async_device_register(struct dma_device *device)
 
 	/* represent channels in sysfs. Probably want devs too */
 	list_for_each_entry(chan, &device->channels, device_node) {
+		rc = -ENOMEM;
 		chan->local = alloc_percpu(typeof(*chan->local));
 		if (chan->local == NULL)
-			continue;
+			goto err_out;
 		chan->dev = kzalloc(sizeof(*chan->dev), GFP_KERNEL);
 		if (chan->dev == NULL) {
 			free_percpu(chan->local);
-			continue;
+			chan->local = NULL;
+			goto err_out;
 		}
 
 		chan->chan_id = chancnt++;
@@ -675,6 +677,8 @@ int dma_async_device_register(struct dma_device *device)
 		if (rc) {
 			free_percpu(chan->local);
 			chan->local = NULL;
+			kfree(chan->dev);
+			atomic_dec(idr_ref);
 			goto err_out;
 		}
 		chan->client_count = 0;


