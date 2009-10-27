Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZJ0Wm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZJ0Wm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 18:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbZJ0Wmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 18:42:55 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:46407 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbZJ0Wmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 18:42:54 -0400
Date: Tue, 27 Oct 2009 15:36:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Gregory Haskins" <ghaskins@novell.com>, <linux-kernel@vger.kernel.org>
Subject: [patch] Re: Zillions of warnings in -next
Message-Id: <20091027153651.6d636fe8.randy.dunlap@oracle.com>
In-Reply-To: <20091027222112.74058162@lxorguk.ukuu.org.uk>
References: <20091027152530.75ca60e4@lxorguk.ukuu.org.uk>
	<4AE7258D0200005A000576F6@sinclair.provo.novell.com>
	<20091027222112.74058162@lxorguk.ukuu.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AE77767.0151:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 22:21:12 +0000 Alan Cox wrote:

> > I just did a 32-bit build and indeed reproduced the warnings.  However, the warnings
> > appear to be dubious as the code is properly (afaict) annotated with explicit casts, and
> > I believe they are doing what I intended.
> > 
> > Basically I have structures that are always 64 bit (so we can have a mixed-mode 32-bit
> > guest talk to a 64-bit hypervisor, for instance).  Therefore I am casting between native
> > and u64, but the compiler doesn't like this.  Does anyone have any suggestions on ways
> > to fix this so the compiler is happy?
> 
> 	foo = (void *)(unsigned long)x
> 
> works for the general case because Linux assumes ptr fits ulong
> 
> Similarly in the other direction.

Yes, I already had this done for venet and pci-bridge.  Patch below.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Eliminate all cast warnings in vbus-enet.c and pci-bridge.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/vbus-enet.c   |   52 ++++++++++++++++++------------------
 drivers/vbus/pci-bridge.c |   13 ++++-----
 2 files changed, 33 insertions(+), 32 deletions(-)

--- linux-next-20091027.orig/drivers/net/vbus-enet.c
+++ linux-next-20091027/drivers/net/vbus-enet.c
@@ -162,18 +162,18 @@ rxdesc_alloc(struct vbus_enet_priv *priv
 		 * larger than MTU, the host will grab pages out of the
 		 * page-queue and populate additional IOVs
 		 */
-		struct venet_sg *vsg = (struct venet_sg *)desc->cookie;
+		struct venet_sg *vsg = (struct venet_sg *)(unsigned long)desc->cookie;
 		struct venet_iov *iov = &vsg->iov[0];
 
 		memset(vsg, 0, SG_DESC_SIZE);
 
-		vsg->cookie  = (u64)skb;
+		vsg->cookie  = (u64)(unsigned long)skb;
 		vsg->count   = 1;
 
 		iov->ptr     = (u64)__pa(skb->data);
 		iov->len     = len;
 	} else {
-		desc->cookie = (u64)skb;
+		desc->cookie = (u64)(unsigned long)skb;
 		desc->ptr    = (u64)__pa(skb->data);
 		desc->len    = len; /* total length  */
 	}
@@ -207,7 +207,7 @@ rx_pageq_refill(struct vbus_enet_priv *p
 		page = alloc_page(GFP_KERNEL);
 		BUG_ON(!page);
 
-		iter.desc->cookie = (u64)page;
+		iter.desc->cookie = (u64)(unsigned long)page;
 		iter.desc->ptr    = (u64)__pa(page_address(page));
 		iter.desc->len    = PAGE_SIZE;
 
@@ -253,7 +253,7 @@ rx_setup(struct vbus_enet_priv *priv)
 			void *addr = &priv->l4ro.pool[offset];
 
 			iter.desc->ptr    = (u64)offset;
-			iter.desc->cookie = (u64)addr;
+			iter.desc->cookie = (u64)(unsigned long)addr;
 			iter.desc->len    = SG_DESC_SIZE;
 		}
 
@@ -297,19 +297,19 @@ rx_rxq_teardown(struct vbus_enet_priv *p
 			struct venet_sg *vsg;
 			int i;
 
-			vsg = (struct venet_sg *)iter.desc->cookie;
+			vsg = (struct venet_sg *)(unsigned long)iter.desc->cookie;
 
 			/* skip i=0, since that is the skb->data IOV */
 			for (i = 1; i < vsg->count; i++) {
 				struct venet_iov *iov = &vsg->iov[i];
-				struct page *page = (struct page *)iov->ptr;
+				struct page *page = (struct page *)(unsigned long)iov->ptr;
 
 				put_page(page);
 			}
 
-			skb = (struct sk_buff *)vsg->cookie;
+			skb = (struct sk_buff *)(unsigned long)vsg->cookie;
 		} else
-			skb = (struct sk_buff *)iter.desc->cookie;
+			skb = (struct sk_buff *)(unsigned long)iter.desc->cookie;
 
 		iter.desc->valid = 0;
 		wmb();
@@ -341,7 +341,7 @@ rx_l4ro_teardown(struct vbus_enet_priv *
 	 * free each valid descriptor
 	 */
 	while (iter.desc->sown) {
-		struct page *page = (struct page *)iter.desc->cookie;
+		struct page *page = (struct page *)(unsigned long)iter.desc->cookie;
 
 		iter.desc->valid = 0;
 		wmb();
@@ -432,7 +432,7 @@ tx_setup(struct vbus_enet_priv *priv)
 			iter.desc->ptr = (u64)__pa(vsg);
 		}
 
-		iter.desc->cookie = (u64)vsg;
+		iter.desc->cookie = (u64)(unsigned long)vsg;
 		iter.desc->len    = SG_DESC_SIZE;
 
 		ret = ioq_iter_seek(&iter, ioq_seek_next, 0, 0);
@@ -480,7 +480,7 @@ tx_teardown(struct vbus_enet_priv *priv)
 	 * free each valid descriptor
 	 */
 	while (iter.desc->cookie) {
-		struct venet_sg *vsg = (struct venet_sg *)iter.desc->cookie;
+		struct venet_sg *vsg = (struct venet_sg *)(unsigned long)iter.desc->cookie;
 
 		iter.desc->valid = 0;
 		wmb();
@@ -597,8 +597,8 @@ vbus_enet_change_mtu(struct net_device *
 static struct sk_buff *
 vbus_enet_l4ro_import(struct vbus_enet_priv *priv, struct ioq_ring_desc *desc)
 {
-	struct venet_sg *vsg = (struct venet_sg *)desc->cookie;
-	struct sk_buff *skb = (struct sk_buff *)vsg->cookie;
+	struct venet_sg *vsg = (struct venet_sg *)(unsigned long)desc->cookie;
+	struct sk_buff *skb = (struct sk_buff *)(unsigned long)vsg->cookie;
 	struct skb_shared_info *sinfo = skb_shinfo(skb);
 	int i;
 
@@ -618,7 +618,7 @@ vbus_enet_l4ro_import(struct vbus_enet_p
 	/* skip i=0, since that is the skb->data IOV */
 	for (i = 1; i < vsg->count; i++) {
 		struct venet_iov *iov = &vsg->iov[i];
-		struct page *page = (struct page *)iov->ptr;
+		struct page *page = (struct page *)(unsigned long)iov->ptr;
 		skb_frag_t *f = &sinfo->frags[i-1];
 
 		f->page        = page;
@@ -691,7 +691,7 @@ fail:
 static struct sk_buff *
 vbus_enet_flat_import(struct vbus_enet_priv *priv, struct ioq_ring_desc *desc)
 {
-	struct sk_buff *skb = (struct sk_buff *)desc->cookie;
+	struct sk_buff *skb = (struct sk_buff *)(unsigned long)desc->cookie;
 
 	if (!desc->len) {
 		/*
@@ -816,7 +816,7 @@ vbus_enet_tx_start(struct sk_buff *skb, 
 	BUG_ON(iter.desc->sown);
 
 	if (priv->sg) {
-		struct venet_sg *vsg = (struct venet_sg *)iter.desc->cookie;
+		struct venet_sg *vsg = (struct venet_sg *)(unsigned long)iter.desc->cookie;
 		struct scatterlist sgl[MAX_SKB_FRAGS+1];
 		struct scatterlist *sg;
 		int count, maxcount = ARRAY_SIZE(sgl);
@@ -825,7 +825,7 @@ vbus_enet_tx_start(struct sk_buff *skb, 
 
 		memset(vsg, 0, sizeof(*vsg));
 
-		vsg->cookie = (u64)skb;
+		vsg->cookie = (u64)(unsigned long)skb;
 		vsg->len    = skb->len;
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
@@ -873,7 +873,7 @@ vbus_enet_tx_start(struct sk_buff *skb, 
 		 * non scatter-gather mode: simply put the skb right onto the
 		 * ring.
 		 */
-		iter.desc->cookie = (u64)skb;
+		iter.desc->cookie = (u64)(unsigned long)skb;
 		iter.desc->len = (u64)skb->len;
 		iter.desc->ptr = (u64)__pa(skb->data);
 	}
@@ -950,10 +950,10 @@ vbus_enet_tx_reap_one(struct vbus_enet_p
 		if (priv->sg) {
 			struct venet_sg *vsg;
 
-			vsg = (struct venet_sg *)iter.desc->cookie;
-			skb = (struct sk_buff *)vsg->cookie;
+			vsg = (struct venet_sg *)(unsigned long)iter.desc->cookie;
+			skb = (struct sk_buff *)(unsigned long)vsg->cookie;
 		} else
-			skb = (struct sk_buff *)iter.desc->cookie;
+			skb = (struct sk_buff *)(unsigned long)iter.desc->cookie;
 
 		/* Reset the descriptor */
 		iter.desc->valid  = 0;
@@ -1069,7 +1069,7 @@ evq_txc_event(struct vbus_enet_priv *pri
 
 	vbus_enet_tx_reap(priv);
 
-	vbus_enet_skb_complete(priv, (struct sk_buff *)event->cookie);
+	vbus_enet_skb_complete(priv, (struct sk_buff *)(unsigned long)event->cookie);
 }
 
 static void
@@ -1097,7 +1097,7 @@ deferred_evq_isr(unsigned long data)
 	while (!iter.desc->sown) {
 		struct venet_event_header *header;
 
-		header = (struct venet_event_header *)iter.desc->cookie;
+		header = (struct venet_event_header *)(unsigned long)iter.desc->cookie;
 
 		switch (header->id) {
 		case VENET_EVENT_LINKSTATE:
@@ -1112,7 +1112,7 @@ deferred_evq_isr(unsigned long data)
 			break;
 		}
 
-		memset((void *)iter.desc->cookie, 0, priv->evq.evsize);
+		memset((void *)(unsigned long)iter.desc->cookie, 0, priv->evq.evsize);
 
 		/* Advance the in-use tail */
 		ret = ioq_iter_pop(&iter, 0);
@@ -1254,7 +1254,7 @@ vbus_enet_evq_negcap(struct vbus_enet_pr
 			void *addr = &priv->evq.pool[offset];
 
 			iter.desc->ptr    = (u64)offset;
-			iter.desc->cookie = (u64)addr;
+			iter.desc->cookie = (u64)(unsigned long)addr;
 			iter.desc->len    = query.evsize;
 
 			ret = ioq_iter_push(&iter, 0);
--- linux-next-20091027.orig/drivers/vbus/pci-bridge.c
+++ linux-next-20091027/drivers/vbus/pci-bridge.c
@@ -325,9 +325,10 @@ vbus_pci_device_shm(struct vbus_device_p
 		 */
 		shm_signal_get(&_signal->signal);
 
-		params.signal.offset = (u64)sdesc - (u64)ptr;
+		params.signal.offset = (u64)(unsigned long)sdesc -
+					(u64)(unsigned long)ptr;
 		params.signal.prio   = prio;
-		params.signal.cookie = (u64)_signal;
+		params.signal.cookie = (u64)(unsigned long)_signal;
 
 	} else
 		params.signal.offset = -1; /* yes, this is a u32, but its ok */
@@ -526,7 +527,7 @@ event_devdrop(struct vbus_pci_handle_eve
 static void
 event_shmsignal(struct vbus_pci_handle_event *event)
 {
-	struct _signal *_signal = (struct _signal *)event->handle;
+	struct _signal *_signal = (struct _signal *)(unsigned long)event->handle;
 	struct irq_desc *desc = _signal->desc;
 
 	vbus_pci.stats.notify++;
@@ -536,7 +537,7 @@ event_shmsignal(struct vbus_pci_handle_e
 static void
 event_shmclose(struct vbus_pci_handle_event *event)
 {
-	struct _signal *_signal = (struct _signal *)event->handle;
+	struct _signal *_signal = (struct _signal *)(unsigned long)event->handle;
 
 	/*
 	 * This reference was taken during the DEVICESHM call
@@ -593,7 +594,7 @@ eventq_init(int qlen)
 
 		BUG_ON(iter.desc->valid);
 
-		desc->cookie = (u64)event;
+		desc->cookie = (u64)(unsigned long)event;
 		desc->ptr    = (u64)__pa(event);
 		desc->len    = len; /* total length  */
 		desc->valid  = 1;
@@ -643,7 +644,7 @@ eventq_wakeup(struct ioq_notifier *notif
 		struct ioq_ring_desc *desc  = iter.desc;
 		struct vbus_pci_event *event;
 
-		event = (struct vbus_pci_event *)desc->cookie;
+		event = (struct vbus_pci_event *)(unsigned long)desc->cookie;
 
 		switch (event->eventid) {
 		case VBUS_PCI_EVENT_DEVADD:
