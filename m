Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbYD1VtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbYD1VtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934023AbYD1Vs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:48:56 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:59154 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933764AbYD1Vsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:48:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
Date: Mon, 28 Apr 2008 23:48:14 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, vojtech@suse.cz,
       muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com
References: <200804232055.13102.mb@bu3sch.de> <20080428165352.GD18210@elte.hu> <200804281004.07989.jbarnes@virtuousgeek.org>
In-Reply-To: <200804281004.07989.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804282348.15330.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008 19:04:07 Jesse Barnes wrote:
> On Monday, April 28, 2008 9:53 am Ingo Molnar wrote:
> > * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > > > This untested patch is supposed to fix DMAing on some VIA
> > > > > > boards. Currently the DMA subsystem returns an error, if the
> > > > > > driver does tell that it supports a 64bit DMA mask. So the
> > > > > > driver probing would fail in that case.
> > > > >
> > > > > The driver is broken then. It is supposed to retry with a small
> > > > > mask on an error. Please fix the driver.
> > > >
> > > > I already added a workaround to the driver. Why do we need to
> > > > workaround this in _every_ driver? (Note that _every_ driver
> > > > supporting a 64bit mask is affected). Why not fix it in the DMA
> > > > layer?
> > >
> > > Some hardware wants to know it can get a given DMA mask or failure. I
> > > agree however that a "pci_prefer_64bit_dma(pdev)" function would be a
> > > good patch for someone to submit tot he PCI layer code.
> >
> > yes, and i suspect Michael is correct in suggesting that the majority of
> > drivers would use that interface and would let the PCI layer handle the
> > probing/fallback details. (Jesse Cc:-ed)
> 
> With an implied fallback to 32 bits?  Michael's right (at least I think 
> Michael's the one being quoted there) that "try 64 then fallback to 32 on 
> error" is a pretty common sight, so having a hint that says you'd like 64 but 
> don't really care would be a win for drivers.
> 
> Michael, want to hack something up?

Something like this? (untested)


Index: wireless-testing/drivers/base/dma-mapping.c
===================================================================
--- wireless-testing.orig/drivers/base/dma-mapping.c	2008-04-28 23:34:19.000000000 +0200
+++ wireless-testing/drivers/base/dma-mapping.c	2008-04-28 23:46:25.000000000 +0200
@@ -216,3 +216,38 @@ void dmam_release_declared_memory(struct
 EXPORT_SYMBOL(dmam_release_declared_memory);
 
 #endif
+
+/**
+ * dma_set_mask_weak - Set the DMA mask. Retry with smaller masks.
+ * @dev: Device to set the mask on.
+ * @mask: Pointer to the mask that you want to set. The function will
+ * 	modify the mask and set it to the actually used mask, in case
+ * 	it had to fall back to a smaller mask.
+ *
+ * Set the DMA mask and allow falling back to smaller masks in
+ * case of an error.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int dma_set_mask_weak(struct device *dev, u64 *mask)
+{
+	u64 m = *mask;
+	int err;
+
+	if (m < DMA_MIN_FALLBACK_MASK)
+		return -EINVAL;
+	while (1) {
+		err = dma_set_mask(dev, m);
+		if (!err)
+			break;
+		/* Did not like this one. Try a smaller one. */
+		m >>= 1;
+		if (m < DMA_MIN_FALLBACK_MASK)
+			return err;
+	}
+	*mask = m;
+
+	return 0;
+}
+EXPORT_SYMBOL(dma_set_mask_weak);
Index: wireless-testing/include/linux/dma-mapping.h
===================================================================
--- wireless-testing.orig/include/linux/dma-mapping.h	2008-04-28 23:34:19.000000000 +0200
+++ wireless-testing/include/linux/dma-mapping.h	2008-04-28 23:35:35.000000000 +0200
@@ -60,6 +60,11 @@ static inline int is_device_dma_capable(
 
 extern u64 dma_get_required_mask(struct device *dev);
 
+extern int dma_set_mask_weak(struct device *dev, u64 *mask);
+/* Smallest mask fallback used by dma_set_mask_weak(). */
+#define DMA_MIN_FALLBACK_MASK	DMA_BIT_MASK(24) /* 16 MB */
+
+
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
 {
 	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;


-- 
Greetings Michael.
