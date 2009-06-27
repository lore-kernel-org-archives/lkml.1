Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZF0PGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZF0PGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 11:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZF0PG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 11:06:26 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:49980 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbZF0PGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 11:06:25 -0400
Date: Sun, 28 Jun 2009 00:06:24 +0900 (JST)
Message-Id: <20090628.000624.208780184.anemo@mba.ocn.ne.jp>
To: nicolas.ferre@atmel.com
Cc: dan.j.williams@intel.com, maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] dmaengine: at_hdmac: new driver for the Atmel
 AHB DMA Controller
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 12:42:15 +0200, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
> at91sam9rl chip. It will be used on other products in the future.

It seems this driver was written based on dw_dmac driver.  A while ago
I had some investigation of that driver.
(http://lkml.org/lkml/2008/12/29/172)

Some of issues reported at that time could be applied on your driver
too.  With a quick look, the queue list management issue is a
candidate.  Here is an excerpt from the thread:

--- --- ---
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
--- --- ---

And one more comment.

> +	/*
> +	 * We use dma_unmap_page() regardless of how the buffers were
> +	 * mapped before they were submitted...
> +	 */

You can use DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE since 2.6.30.

---
Atsushi Nemoto
