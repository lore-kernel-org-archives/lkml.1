Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZASWEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZASWEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZASWEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:04:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:10446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZASWEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:04:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,291,1231142400"; 
   d="scan'208";a="482934102"
Subject: Re: WARNING: at drivers/dma/dmaengine.c:352
	dma_issue_pending_all+0x77/0x15d()
From: Dan Williams <dan.j.williams@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20090119213106.GA9648@elte.hu>
References: <20090119213106.GA9648@elte.hu>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 15:04:40 -0700
Message-Id: <1232402680.22432.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 14:31 -0700, Ingo Molnar wrote:
> FYI, i'm getting this on a testbox, on v2.6.29-rc2:

Thanks for the report.  I assume this is with CONFIG_DMA_ENGINE=n?
dma_issue_pending_all should be a nop in that case.  I'll apply the
following with your confirmation.

Regards,
Dan

---
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 6df144a..9c53e5e 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -330,7 +330,7 @@ struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type)
 	int cpu;
 
 	WARN_ONCE(dmaengine_ref_count == 0,
-		  "client called %s without a reference", __func__);
+		  "client called %s without a reference\n", __func__);
 
 	cpu = get_cpu();
 	chan = per_cpu_ptr(channel_table[tx_type], cpu)->chan;
@@ -349,7 +349,7 @@ void dma_issue_pending_all(void)
 	struct dma_chan *chan;
 
 	WARN_ONCE(dmaengine_ref_count == 0,
-		  "client called %s without a reference", __func__);
+		  "client called %s without a reference\n", __func__);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(device, &dma_device_list, global_node) {
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 64dea2a..c4a560e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -390,11 +390,16 @@ static inline enum dma_status dma_async_is_complete(dma_cookie_t cookie,
 enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
+void dma_issue_pending_all(void);
 #else
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
 	return DMA_SUCCESS;
 }
+static inline void dma_issue_pending_all(void)
+{
+	do { } while (0);
+}
 #endif
 
 /* --- DMA device --- */
@@ -403,7 +408,6 @@ int dma_async_device_register(struct dma_device *device);
 void dma_async_device_unregister(struct dma_device *device);
 void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
 struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
-void dma_issue_pending_all(void);
 #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
 struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
 void dma_release_channel(struct dma_chan *chan);






