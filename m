Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZJLK1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZJLK1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZJLK1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:27:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34791
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755793AbZJLK1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:27:01 -0400
Date: Mon, 12 Oct 2009 03:26:57 -0700 (PDT)
Message-Id: <20091012.032657.24181291.davem@davemloft.net>
To: heyongli@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux guest domain with two vnets bound to the same vswitch
 experiences hung in bootup (sun_netraT5220)
From: David Miller <davem@davemloft.net>
In-Reply-To: <505766fa0910120123l51b57b8aja30a5d0fd1225c0d@mail.gmail.com>
References: <20091009.150829.218507309.davem@davemloft.net>
	<20091009.162120.164441279.davem@davemloft.net>
	<505766fa0910120123l51b57b8aja30a5d0fd1225c0d@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hyl <heyongli@gmail.com>
Date: Mon, 12 Oct 2009 16:23:47 +0800

> look the console output, system seems hang on a live lock:
> tl0_irq5 triggered just after the irq been re-enable in the handler
> of irq5: the ldc_rx.
> 
> i have no idea about the t10_irq5, just guess that: the special
> configuration lead to t10_irq5 been triggered continuously, and
> the trigger condition can not been cleared.

Yes, it seems that stack is exhausted.  Ho hum...

I guess the following patch works too?  Please make sure you've
removed your changes when testing this.

Thanks.

diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index adf5f27..cb3c72c 100644
--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -1242,13 +1242,13 @@ int ldc_bind(struct ldc_channel *lp, const char *name)
 	snprintf(lp->tx_irq_name, LDC_IRQ_NAME_MAX, "%s TX", name);
 
 	err = request_irq(lp->cfg.rx_irq, ldc_rx,
-			  IRQF_SAMPLE_RANDOM | IRQF_SHARED,
+			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED | IRQF_SHARED,
 			  lp->rx_irq_name, lp);
 	if (err)
 		return err;
 
 	err = request_irq(lp->cfg.tx_irq, ldc_tx,
-			  IRQF_SAMPLE_RANDOM | IRQF_SHARED,
+			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED | IRQF_SHARED,
 			  lp->tx_irq_name, lp);
 	if (err) {
 		free_irq(lp->cfg.rx_irq, lp);
