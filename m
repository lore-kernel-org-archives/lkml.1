Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbXJRAo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbXJRAo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760222AbXJRAot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:44:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43895 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760134AbXJRAos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:44:48 -0400
Date: Wed, 17 Oct 2007 17:44:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       shannon.nelson@intel.com, dan.j.williams@intel.com,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 5/5] I/OAT: Add completion callback for async_tx
 interface use
Message-Id: <20071017174438.f0d6fe2e.akpm@linux-foundation.org>
In-Reply-To: <20071018001439.31147.52329.stgit@localhost.localdomain>
References: <20071018001416.31147.86176.stgit@localhost.localdomain>
	<20071018001439.31147.52329.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 17:14:39 -0700
Shannon Nelson <shannon.nelson@intel.com> wrote:

> +	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(0x%04llx)\n",
> +		(u64)dma_async_param);

Generates a warning on 32-bit:

drivers/dma/ioat_dma.c: In function 'ioat_dma_test_callback':
drivers/dma/ioat_dma.c:660: warning: cast from pointer to integer of different size

and we can never ever print u64's anwyay: we dont' know what type the arch
uses to implement them.  The usual fix is to cast to unsigned long long,
but in this case %p will work nicely, no?

> +	tx->callback = (void *)ioat_dma_test_callback;

and when I remove this cast I get

drivers/dma/ioat_dma.c: In function 'ioat_dma_self_test':
drivers/dma/ioat_dma.c:718: warning: assignment from incompatible pointer type

because ioat_dma_test_callback isn't void-returning.  Something is wrong
here.  I assume that ioat_dma_test_callback() should just be
void-returning?



diff -puN drivers/dma/ioat_dma.c~i-oat-add-completion-callback-for-async_tx-interface-use-fix drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-add-completion-callback-for-async_tx-interface-use-fix
+++ a/drivers/dma/ioat_dma.c
@@ -654,11 +654,10 @@ static void ioat_dma_start_null_desc(str
  */
 #define IOAT_TEST_SIZE 2000
 
-static dma_async_tx_callback ioat_dma_test_callback(void *dma_async_param)
+static void ioat_dma_test_callback(void *dma_async_param)
 {
-	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(0x%04llx)\n",
-		(u64)dma_async_param);
-	return 0;
+	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(0x%p)\n",
+			dma_async_param);
 }
 
 /**
@@ -715,7 +714,7 @@ static int ioat_dma_self_test(struct ioa
 	addr = dma_map_single(dma_chan->device->dev, dest, IOAT_TEST_SIZE,
 			DMA_FROM_DEVICE);
 	ioat_set_dest(addr, tx, 0);
-	tx->callback = (void *)ioat_dma_test_callback;
+	tx->callback = ioat_dma_test_callback;
 	tx->callback_param = (void *)0x8086;
 	cookie = ioat_tx_submit(tx);
 	if (cookie < 0) {
_

