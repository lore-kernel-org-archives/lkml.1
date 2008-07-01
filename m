Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYGANxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYGANxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYGANxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:53:32 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48668 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYGANxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:53:31 -0400
Date: Tue, 1 Jul 2008 15:53:23 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmatest: Simple DMA memcpy test client
Message-ID: <20080701155323.2e2e351e@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <7F38996F7185A24AB9071ED4950AD8C101C21EB2@swsmsx413.ger.corp.intel.com>
References: <f12847240806270219g29393497kea78dba6e3d66d8@mail.gmail.com>
	<7F38996F7185A24AB9071ED4950AD8C101C21EB2@swsmsx413.ger.corp.intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2008 13:53:26.0667 (UTC) FILETIME=[D5F115B0:01C8DB81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] dmatest: Return DMA_NAK if nr_channels >= max_channels

"Sosnowski, Maciej" <maciej.sosnowski@intel.com> wrote:
> In case when nr_channels exceeds max_channels 
> ack should be rather set to DMA_NAK than DMA_DUP.

You're right. The below patch should take care of this.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/dma/dmatest.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 5c9fd10..a08d197 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -398,13 +398,13 @@ dmatest_event(struct dma_client *client, struct dma_chan *chan,
 
 	switch (state) {
 	case DMA_RESOURCE_AVAILABLE:
-		if (dmatest_match_channel(chan)
-				&& dmatest_match_device(chan->device)
-				&& (!max_channels
-					|| nr_channels < max_channels))
-			ack = dmatest_add_channel(chan);
-		else
+		if (!dmatest_match_channel(chan)
+				|| !dmatest_match_device(chan->device))
 			ack = DMA_DUP;
+		else if (max_channels && nr_channels >= max_channels)
+			ack = DMA_NAK;
+		else
+			ack = dmatest_add_channel(chan);
 		break;
 
 	case DMA_RESOURCE_REMOVED:
-- 
1.5.6

