Return-Path: <linux-kernel-owner+w=401wt.eu-S1764569AbYBOJxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764569AbYBOJxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYBOJxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:53:11 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64428 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755722AbYBOJxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:53:09 -0500
Date: Fri, 15 Feb 2008 10:53:02 +0100
From: Haavard Skinnemoen <hskinnemoen@norway.atmel.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
Message-ID: <20080215105302.1e4251a3@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080213202402.22818482@siona>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20802131107x4c9e6859p3bc6527b19c416cb@mail.gmail.com>
	<20080213202402.22818482@siona>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 20:24:02 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> But looking at your latest patch series, I guess we can use the new
> "next" field instead. It's not like we really need the full
> capabilities of list_head.

On second thought, if we do this, we would be using the "next" field in
an undocumented way. It is currently documented as follows:

 * @next: at completion submit this descriptor

But that's not how we're going to use it when doing slave transfers:
We're using it to keep track of all the descriptors that have already
been submitted.

I think it would actually be better to go the other way and have the
async_tx API extend the descriptor as well for its private fields. That
way, we get the pointer we need, but we can document it differently.

So how about we do something along the lines of the patch below? We
need to update all the users too of course, but apart from making the
dma_slave_descriptor struct smaller, I don't think it will change the
actual memory layout at all.

Haavard

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 9bb3407..abaf324 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -267,8 +267,7 @@ struct dma_client {
 
 typedef void (*dma_async_tx_callback)(void *dma_async_param);
 /**
- * struct dma_async_tx_descriptor - async transaction descriptor
- * ---dma generic offload fields---
+ * struct dma_descriptor - generic dma offload descriptor
  * @cookie: tracking cookie for this transaction, set to -EBUSY if
  *	this tx is sitting on a dependency list
  * @ack: the descriptor can not be reused until the client acknowledges
@@ -280,12 +279,8 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  * @tx_submit: set the prepared descriptor(s) to be executed by the engine
  * @callback: routine to call after this operation is complete
  * @callback_param: general parameter to pass to the callback routine
- * ---async_tx api specific fields---
- * @next: at completion submit this descriptor
- * @parent: pointer to the next level up in the dependency chain
- * @lock: protect the parent and next pointers
  */
-struct dma_async_tx_descriptor {
+struct dma_descriptor {
 	dma_cookie_t cookie;
 	int ack;
 	dma_addr_t phys;
@@ -294,6 +289,17 @@ struct dma_async_tx_descriptor {
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
+};
+
+/**
+ * struct dma_async_tx_descriptor - async transaction descriptor
+ * @dma: generic dma descriptor
+ * @next: at completion submit this descriptor
+ * @parent: pointer to the next level up in the dependency chain
+ * @lock: protect the parent and next pointers
+ */
+struct dma_async_tx_descriptor {
+	struct dma_descriptor dma;
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
 	spinlock_t lock;
@@ -301,13 +307,13 @@ struct dma_async_tx_descriptor {
 
 /**
  * struct dma_slave_descriptor - extended DMA descriptor for slave DMA
- * @async_tx: async transaction descriptor
- * @client_node: for use by the client, for example when operating on
- *	scatterlists.
+ * @dma: generic dma descriptor
+ * @next: for use by the client, for example to keep track of
+ *	submitted descriptors when dealing with scatterlists.
  */
 struct dma_slave_descriptor {
-	struct dma_async_tx_descriptor txd;
-	struct list_head client_node;
+	struct dma_descriptor dma;
+	struct dma_slave_descriptor *next;
 };
 
 /**
