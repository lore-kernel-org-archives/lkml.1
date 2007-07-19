Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbXGSXOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbXGSXOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbXGSXOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:14:38 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:12126 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012AbXGSXOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:14:37 -0400
X-Trace: 8790749-mk-filter-3.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.93.154
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=kH7YyzfC6u9jrfZvOJ0A:9 a=ZxGdWev86_L3MjKs2tFsCmOnuyUA:4
X-IronPort-AV: E=Sophos;i="4.16,558,1175468400"; 
   d="scan'208";a="8790749"
Subject: [PATCH] Fix Dreamcast DMA
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linuxsh-dev@lists.sourceforge.net>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 19:56:14 +0100
Message-Id: <1184871374.6043.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/arch/sh/drivers/dma/dma-api.c
b/arch/sh/drivers/dma/dma-api.c
index cf8e119..0c9b3bc 100644
--- a/arch/sh/drivers/dma/dma-api.c
+++ b/arch/sh/drivers/dma/dma-api.c
@@ -31,8 +31,8 @@ struct dma_info *get_dma_info(unsigned int chan)
 	 * the channel is.
 	 */
 	list_for_each_entry(info, &registered_dmac_list, list) {
-		if ((chan <  info->first_channel_nr) ||
-		    (chan >= info->first_channel_nr + info->nr_channels))
+		if ((chan <  info->first_vchannel_nr) ||
+		    (chan >= info->first_vchannel_nr + info->nr_channels))
 			continue;
 
 		return info;
@@ -82,7 +82,7 @@ struct dma_channel *get_dma_channel(unsigned int chan)
 
 	for (i = 0; i < info->nr_channels; i++) {
 		channel = &info->channels[i];
-		if (channel->chan == chan)
+		if (channel->chan == (chan - info->first_vchannel_nr))
 			return channel;
 	}
 
@@ -183,6 +183,7 @@ int dmac_search_free_channel(const char *dev_id)
 			return result;
 
 		atomic_set(&channel->busy, 1);
+
 		return channel->chan;
 	}
 
@@ -194,7 +195,6 @@ int request_dma(unsigned int chan, const char
*dev_id)
 	struct dma_channel *channel = { 0 };
 	struct dma_info *info = get_dma_info(chan);
 	int result;
-
 	channel = get_dma_channel(chan);
 	if (atomic_xchg(&channel->busy, 1))
 		return -EBUSY;
@@ -369,6 +369,7 @@ int register_dmac(struct dma_info *info)
 	}
 
 	total_channels = get_nr_channels();
+	info->first_vchannel_nr = total_channels;
 	for (i = 0; i < info->nr_channels; i++) {
 		struct dma_channel *chan = &info->channels[i];
 
@@ -387,7 +388,7 @@ int register_dmac(struct dma_info *info)
 	}
 
 	list_add(&info->list, &registered_dmac_list);
-
+	
 	return 0;
 }
 EXPORT_SYMBOL(register_dmac);
diff --git a/include/asm-sh/dma.h b/include/asm-sh/dma.h
index 6034d4a..4c75b70 100644
--- a/include/asm-sh/dma.h
+++ b/include/asm-sh/dma.h
@@ -111,6 +111,7 @@ struct dma_info {
 
 	struct list_head list;
 	int first_channel_nr;
+	int first_vchannel_nr;
 };
 
 struct dma_chan_caps {

