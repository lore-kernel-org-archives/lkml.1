Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbZBYWjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbZBYWjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZBYWjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:39:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:13033 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbZBYWjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:39:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,266,1233561600"; 
   d="scan'208";a="668544855"
Subject: Re: [PATCH] fsldma: dev_err 1 too early.
From: Dan Williams <dan.j.williams@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <49A53DCA.4060004@gmail.com>
References: <49A53DCA.4060004@gmail.com>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 15:38:58 -0700
Message-Id: <1235601538.21542.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 05:47 -0700, Roel Kluin wrote:
> If unsuccessful, i reaches 101 after the loop, so 100 is still success.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 70126a6..444c4e4 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -168,7 +168,7 @@ static void dma_halt(struct fsl_dma_chan *fsl_chan)
>  
>  	while (!dma_is_idle(fsl_chan) && (i++ < 100))
>  		udelay(10);
> -	if (i >= 100 && !dma_is_idle(fsl_chan))
> +	if (i > 100 && !dma_is_idle(fsl_chan))
>  		dev_err(fsl_chan->dev, "DMA halt timeout!\n");
>  }
>  

Thanks for the report.  I prefer a more canonical loop.  Objections?

--
Dan

<-----
fsldma: fix off by one in dma_halt

From: Dan Williams <dan.j.williams@intel.com>

Prevent dev_err from firing even if we successfully detected 'dma-idle'
before the full 1ms timeout has elapsed.

Reported-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/fsldma.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 70126a6..86d6da4 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -158,7 +158,8 @@ static void dma_start(struct fsl_dma_chan *fsl_chan)
 
 static void dma_halt(struct fsl_dma_chan *fsl_chan)
 {
-	int i = 0;
+	int i;
+
 	DMA_OUT(fsl_chan, &fsl_chan->reg_base->mr,
 		DMA_IN(fsl_chan, &fsl_chan->reg_base->mr, 32) | FSL_DMA_MR_CA,
 		32);
@@ -166,8 +167,11 @@ static void dma_halt(struct fsl_dma_chan *fsl_chan)
 		DMA_IN(fsl_chan, &fsl_chan->reg_base->mr, 32) & ~(FSL_DMA_MR_CS
 		| FSL_DMA_MR_EMS_EN | FSL_DMA_MR_CA), 32);
 
-	while (!dma_is_idle(fsl_chan) && (i++ < 100))
+	for (i = 0; i < 100; i++) {
+		if (dma_is_idle(fsl_chan))
+			break;
 		udelay(10);
+	}
 	if (i >= 100 && !dma_is_idle(fsl_chan))
 		dev_err(fsl_chan->dev, "DMA halt timeout!\n");
 }


