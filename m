Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYISXcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYISXcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYISXcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:32:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724AbYISXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:32:07 -0400
Date: Fri, 19 Sep 2008 16:31:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timur Tabi <timur@freescale.com>
Cc: dan.j.williams@intel.com, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmatest: properly handle duplicate DMA channels
Message-Id: <20080919163145.de9866ac.akpm@linux-foundation.org>
In-Reply-To: <1221751279-24936-1-git-send-email-timur@freescale.com>
References: <1221751279-24936-1-git-send-email-timur@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 10:21:19 -0500
Timur Tabi <timur@freescale.com> wrote:

> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -321,10 +321,15 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
>  
>  static enum dma_state_client dmatest_add_channel(struct dma_chan *chan)
>  {
> -	struct dmatest_chan	*dtc;
> +	struct dmatest_chan	*dtc, *_dtc;
>  	struct dmatest_thread	*thread;
>  	unsigned int		i;
>  
> +	/* Have we already been told about this channel? */
> +	list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node)
> +		if (dtc->chan == chan)
> +			return DMA_DUP;
> +
>  	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_ATOMIC);
>  	if (!dtc) {
>  		pr_warning("dmatest: No memory for %s\n", chan->dev.bus_id);

hm.  A few lines after that GFP_ATOMIC the driver does a GFP_KERNEL
allocation.

One of them is incorrect.  The interface is undocumented (natch), but I
assume that GFP_KERNEL is the one to use here.

--- a/drivers/dma/dmatest.c~a
+++ a/drivers/dma/dmatest.c
@@ -330,7 +330,7 @@ static enum dma_state_client dmatest_add
 		if (dtc->chan == chan)
 			return DMA_DUP;
 
-	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_ATOMIC);
+	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_KERNEL);
 	if (!dtc) {
 		pr_warning("dmatest: No memory for %s\n", chan->dev.bus_id);
 		return DMA_NAK;
_

