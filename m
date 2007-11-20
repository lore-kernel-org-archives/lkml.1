Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbXKTS27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbXKTS27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761258AbXKTS0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761216AbXKTS0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:16 -0500
Date: Tue, 20 Nov 2007 10:23:28 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, shannon.nelson@intel.com,
       dan.j.williams@intel.com, hskinnemoen@atmel.com
Subject: [patch 09/29] dmaengine: fix broken device refcounting
Message-ID: <20071120182328.GJ28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dmaengine-fix-broken-device-refcounting.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

patch 348badf1e825323c419dd118f65783db0f7d2ec8 in mainline.

When a DMA device is unregistered, its reference count is decremented twice
for each channel: Once dma_class_dev_release() and once in
dma_chan_cleanup().  This may result in the DMA device driver's remove()
function completing before all channels have been cleaned up, causing lots
of use-after-free fun.

Fix it by incrementing the device's reference count twice for each
channel during registration.

[dan.j.williams@intel.com: kill unnecessary client refcounting]
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/dma/dmaengine.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -182,10 +182,9 @@ static void dma_client_chan_alloc(struct
 				/* we are done once this client rejects
 				 * an available resource
 				 */
-				if (ack == DMA_ACK) {
+				if (ack == DMA_ACK)
 					dma_chan_get(chan);
-					kref_get(&device->refcount);
-				} else if (ack == DMA_NAK)
+				else if (ack == DMA_NAK)
 					return;
 			}
 		}
@@ -272,11 +271,8 @@ static void dma_clients_notify_removed(s
 		/* client was holding resources for this channel so
 		 * free it
 		 */
-		if (ack == DMA_ACK) {
+		if (ack == DMA_ACK)
 			dma_chan_put(chan);
-			kref_put(&chan->device->refcount,
-				dma_async_device_cleanup);
-		}
 	}
 
 	mutex_unlock(&dma_list_mutex);
@@ -316,11 +312,8 @@ void dma_async_client_unregister(struct 
 			ack = client->event_callback(client, chan,
 				DMA_RESOURCE_REMOVED);
 
-			if (ack == DMA_ACK) {
+			if (ack == DMA_ACK)
 				dma_chan_put(chan);
-				kref_put(&chan->device->refcount,
-					dma_async_device_cleanup);
-			}
 		}
 
 	list_del(&client->global_node);
@@ -397,6 +390,8 @@ int dma_async_device_register(struct dma
 			goto err_out;
 		}
 
+		/* One for the channel, one of the class device */
+		kref_get(&device->refcount);
 		kref_get(&device->refcount);
 		kref_init(&chan->refcount);
 		chan->slow_ref = 0;

-- 
