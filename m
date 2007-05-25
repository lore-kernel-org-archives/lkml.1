Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbXEYNES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbXEYNES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXEYNEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:04:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4785 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753340AbXEYNEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:04:10 -0400
Date: Fri, 25 May 2007 23:04:04 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rmmod e1000 hangs (Was Re: 2.6.22-rc2-mm1)
Message-ID: <20070525130404.GA30071@gondor.apana.org.au>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46556AA6.7040503@goop.org> <20070524104713.GA9174@gondor.apana.org.au> <20070524105403.GA9285@gondor.apana.org.au> <4655A4CD.8010901@intel.com> <20070525125413.GA29433@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525125413.GA29433@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:54:13PM +1000, Herbert Xu wrote:
> 
> So please revert my patch.
> 
> We need to find out why we're getting IRQs before calling
> e1000_irq_enable in e1000_open.

In the mean time this should be a safe fix.  This is against
the current mainline tree.

[E1000]: Call netif_poll_enable in e1000_open

This restores the previously removed netif_poll_enable call in
e1000_open.  It's needed on all but the first call to e1000_open
for a NIC as e1000_close always calls netif_poll_disable.

netif_poll_enable can only be called safely if no polls have been
scheduled.  This should be the case as long as we don't enter our
IRQ handler.  Just in case someone has left IRQs enabled, we call
this before the IRQ handler is installed.

Of course we should really make sure that IRQs are disabled as
early as possible, i.e., when we're still in the probe routine.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index cbc7feb..d91a378 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -1424,6 +1424,10 @@ e1000_open(struct net_device *netdev)
 	 * clean_rx handler before we do so.  */
 	e1000_configure(adapter);
 
+#ifdef CONFIG_E1000_NAPI
+	netif_poll_enable(netdev);
+#endif
+
 	err = e1000_request_irq(adapter);
 	if (err)
 		goto err_req_irq;
