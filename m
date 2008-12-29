Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbYL2Ojl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbYL2Ojl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbYL2Ojc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:39:32 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:52973 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYL2Ojb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:39:31 -0500
Date: Mon, 29 Dec 2008 23:39:32 +0900 (JST)
Message-Id: <20081229.233932.25909762.anemo@mba.ocn.ne.jp>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com
Subject: dw_dmac driver questions
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.  I'm writing a new DMA driver, using dw_dmac driver in kernel
2.6.28 as a reference implementation.

I can see an outline of the dw_dmac driver and framework (well,
hopefully), but have some questions in details.


1. map/unmap DMA buffers for slave transfer

For slave-DMA, it seems dmac driver is responsible for mapping DMA
buffers, and client is responsible for unmapping them.  Is it right?

Now dwc_descriptor_complete() unmaps DMA buffer unless
DMA_COMPL_SKIP_XXX_UNMAP set.  These unmapping should be done only for
non-slave transfers?  I.e. I suppose "if (!dwc->dws)" is required
around dma_unmap_page() pair.

I also wonder why dwc_prep_slave_sg() calculates total_len. The
total_len is stored in first descriptor of the chain and it is only
referenced for unmapping DMA buffers.  But the scatterlist may contain
uncontinuous buffers, so they can not be unmaped at a time.


2.  dwc_is_tx_complete() and dwc->lock

The function dwc_is_tx_complete() calls dwc_scan_descriptors() without
dwc->lock (and disabling bh).  Is it safe?  All other callers of
dwc_scan_descriptors() take dwc->lock and disable bh.


3.  dwc->queue list management

The function dwc_tx_submit() add the descriptor to dwc->queue list if
active list was not empty.  But it does not manage lli.llp list.  And
all descriptors in the queue list will be moved to active list at a
time.  So it seems non-first descriptors in queue list will never
processed by the hardware.

The dwc_tx_submit() should rewrite lli.llp of the last descriptor in
queue list (it it had children, the last children of it) by txd.phys
of newly queued descriptor.  Or, only first elements of queue list
should be moved to active list at a time.

Is my analysis correct?


BTW, I found some redundant code in the driver.

* memset(dw, 0, sizeof *dw) seems redundant while dw is allocated
  kzalloc().

* platform_get_drvdata(pdev) is called twice in dw_shutdown,
  dw_suspend_late.

Both of them harmless.

---
Atsushi Nemoto
