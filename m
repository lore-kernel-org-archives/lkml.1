Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbXHUTgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbXHUTgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760972AbXHUTgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:36:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46685 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757451AbXHUTgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:36:24 -0400
From: akepner@sgi.com
Date: Tue, 21 Aug 2007 12:35:22 -0700
To: Jes Sorensen <jes@sgi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
Message-ID: <20070821193522.GD5592@sgi.com>
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C94FD5.6000006@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm a little concerned about changing the API for the dma_ foo
> functions, which are defined cross platform. If you want to change
> that, I think it will require updating the documentation explaining
> it.....

What do you think of the following? (And is there anyone else 
I should be cc-ing for review?)


Document semantics of dma_flags_set_dmaflush()

Signed-off-by: Arthur Kepner <akepner@sgi.com>
--
 DMA-API.txt |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index cc7a8c3..e117b72 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -392,6 +392,28 @@ Notes:  You must do this:
 
 See also dma_map_single().
 
+int
+dma_flags_set_dmaflush(int dir)
+
+Amend dir (one of the enum dma_data_direction values), with a platform-
+specific "dmaflush" attribute. Unless the platform supports "posted DMA" 
+this is a no-op. 
+
+On platforms that support posted DMA, dma_flags_set_dmaflush() causes 
+device writes to the associated memory region to flush in-flight DMA. 
+This can be important, for example, when (DMA) writes to the memory 
+region indicate that DMA of data is complete. If DMA of data and DMA of 
+the completion indication race, as they can do when the platform supports 
+posted DMA, then the completion indication may arrive in host memory 
+ahead of some data.
+
+To prevent this, you might map the memory region used for completion 
+indications as follows:
+
+	int count, flags = dma_flags_set_dmaflush(DMA_BIDIRECTIONAL);
+	.....
+	count = dma_map_sg(dev, sglist, nents, flags);
+
 
 Part II - Advanced dma_ usage
 -----------------------------
-- 
Arthur

