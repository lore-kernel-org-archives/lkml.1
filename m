Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbXEFWBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbXEFWBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 18:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXEFWBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 18:01:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:60514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXEFWBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 18:01:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,500,1170662400"; 
   d="scan'208";a="84422113"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.21-mm1
Date: Sun, 6 May 2007 15:01:32 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201CEB196@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070506135531.85417c86.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21-mm1
Thread-Index: AceQIOTP6XO9gBCpSQu/y2GSVhPRgwAB1u4A
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Dan Kruchinin" <dubalom@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 May 2007 22:01:34.0660 (UTC) FILETIME=[1C9FA840:01C7902A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> On Sun, 6 May 2007 22:44:29 +0200 Sam Ravnborg <sam@ravnborg.org>
wrote:
> 
> > On Sun, May 06, 2007 at 08:33:48AM +0400, Dan Kruchinin wrote:
> > > >
> > >
>
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6
.21-
> mm1/
> > >
> > > I have the following message after kernel compilation:
> > >
> > > ---
> > > ...
> > > WARNING: init/built-in.o - Section mismatch: reference to
.init.text:
> > > from .text between 'rest_init' (at offset 0x11e) and 'try_name'
> >
> > Covered in another mail.
> >
> > > ...
> > > ...
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x20)
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x24)
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x28)
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x2c)
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x30)
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x34)
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x38)
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x3c)
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x40)
> > > WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> > > .init.data: from .data after 'channel_table' (at offset 0x44)
> >
> > We have following code:
> > /* guarantee that calls that happen before init will not find a
channel */
> > static struct chan_ref_percpu __initdata null_chan_ref[NR_CPUS];
> >
> > static struct chan_ref_percpu *channel_table[] = {
> > 	DMA_TX_ARRAY_INIT(null_chan_ref)
> > };
> >
> > The DMA_TX_ARRAY_INIT is some macro obscufation that serves no
> > real use and just hide a few assignements.
> > What happens here is that we assign channel_table a value
> > that are used as cover-up until the real assignment happens
> > in the init function.
> > So the only real way to fix this seems to remove the otherwise
correct
> > __initdata mark on null_chan_ref.
> > Thats one pointer wasted pr. cpu (in total NR_CPUS).
> >
> 
> (add Dan to cc)

Not sure if there is a better way to do this, but I went ahead and added
a global flag that gets set after init.  It also lets DMA_TX_ARRAY_INIT
go away, but it adds another branch to the fast path.

I rebased "git://lost.foo-projects.org/~dwillia2/git/iop md-accel-linus"
with the following:

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index f2d8b75..95a87a0 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -76,27 +76,12 @@ enum dma_transaction_type {
 	DMA_PQ_ZERO_SUM,
 	DMA_MEMSET,
 	DMA_MEMCPY_CRC32C,
-	DMA_INTERRUPT, /* when updating, make this the last entry and 
-			* update the DMA_TX_ARRAY_INIT macro
-			*/
+	DMA_INTERRUPT, /* when updating, make this the last entry */
 };
 
 /* last transaction type for creation of the capabilities mask */
 #define DMA_TX_TYPE_END (DMA_INTERRUPT + 1)
 
-/* helper macro for clients defining transaction arrays */
-#define DMA_TX_ARRAY_INIT(x)	\
-	[DMA_MEMCPY] = x,	\
-	[DMA_XOR] = x,		\
-	[DMA_PQ_XOR] = x,	\
-	[DMA_DUAL_XOR] = x,	\
-	[DMA_PQ_UPDATE] = x,	\
-	[DMA_ZERO_SUM] = x,	\
-	[DMA_PQ_ZERO_SUM] = x,	\
-	[DMA_MEMSET] = x,	\
-	[DMA_MEMCPY_CRC32C] = x,\
-	[DMA_INTERRUPT] = x,
-
 /**
  * dma_cap_mask_t - capabilities bitmap modeled after cpumask_t.
  * See linux/cpumask.h
diff --git a/drivers/dma/async_tx.c b/drivers/dma/async_tx.c
index 6bbbacc..6450cfd 100644
--- a/drivers/dma/async_tx.c
+++ b/drivers/dma/async_tx.c
@@ -52,12 +52,8 @@ struct chan_ref_percpu {
 	struct dma_chan_ref *ref;
 };
 
-/* guarantee that calls that happen before init will not find a channel
*/
-static struct chan_ref_percpu __initdata null_chan_ref[NR_CPUS];
-
-static struct chan_ref_percpu *channel_table[] = {
-	DMA_TX_ARRAY_INIT(null_chan_ref)
-};
+static int channel_table_initialized;
+static struct chan_ref_percpu *channel_table[DMA_TX_TYPE_END];
 
 /**
  * async_tx_lock - protect modification of async_tx_master_list and
serialize
@@ -260,6 +256,7 @@ async_tx_init(void)
 
 	dma_async_client_register(&async_tx_dma);
 	dma_async_client_chan_request(&async_tx_dma);
+	channel_table_initialized = 1;
 
 	printk("async_tx: api initialized (async)\n");
 
@@ -309,13 +306,14 @@ async_tx_find_channel(struct
dma_async_tx_descriptor *depend_tx,
 	if (depend_tx &&
 		dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
 		return depend_tx->chan;
-	else {
+	else if (likely(channel_table_initialized)) {
 		struct dma_chan_ref *ref;
 		int cpu = get_cpu();
 		ref = per_cpu_ptr(channel_table[tx_type], cpu)->ref;
 		put_cpu();
 		return ref ? ref->chan : NULL;
-	}
+	} else
+		return NULL;
 }
 #else
 static int __init async_tx_init(void)
