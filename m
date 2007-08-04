Return-Path: <linux-kernel-owner+w=401wt.eu-S1765962AbXHDShz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765962AbXHDShz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933041AbXHDSeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:34:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:45415 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035AbXHDSeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:34:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:user-agent:cc:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=TFrHP44ZpvY+lFhFf0eski/ZZmA7o4Gy8qEEmlizPneGfD/aI/hlUr93rI/dTa8fS87jGrn6l8rrWwl+rJY4XHubmd7mKziHFP7poLynCK7Ixj7oniWMGi7UfP2NPHTfn39wXbOVPDa8dUDP7Th3Ce7mBIV7lkZi5DD9qLtq7jw=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND] Semi-pointless NULL test in uli526x driver
User-Agent: KMail/1.9.7
Cc: Valerie Henson <val@nmt.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tulip-users@lists.sourceforge.net, Jesper Juhl <jesper.juhl@gmail.com>,
       Kyle McMartin <kyle@mcmartin.ca>, david@lang.hm,
       Grant Grundler <grundler@parisc-linux.org>,
       Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 4 Aug 2007 20:32:12 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042032.12317.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(resending previously submitted patch from 16/7-2007 22:40)


Hi,

In drivers/net/tulip/uli526x.c::uli526x_interrupt() there's a test 
of the function argument 'void *dev_id' against NULL. But that 
test is pretty pointless, since if ever 'dev_id' is NULL we'll 
already have crashed inside "netdev_priv(dev)".

I don't think dev_id can ever actually be NULL, so the whole block 
inside "if (!dev) {" could probably just go away. But I guess 
there's a good reason someone put that ULI526X_DBUG() in there - and
if 'dev_id' /can/ actually be NULL then it's nice to have and in 
that case this patch actually fixes a possible crash (hence the 
version number update). 
So I guess that in this case we should just move the 
"db = netdev_priv(dev)" assignment past that NULL test. That's what 
this patch does.

Found by the Coverity checker.
Compile tested.


PS. Please keep me on Cc when replying.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/net/tulip/uli526x.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tulip/uli526x.c b/drivers/net/tulip/uli526x.c
index ca2548e..3df2376 100644
--- a/drivers/net/tulip/uli526x.c
+++ b/drivers/net/tulip/uli526x.c
@@ -13,8 +13,8 @@
 */
 
 #define DRV_NAME	"uli526x"
-#define DRV_VERSION	"0.9.3"
-#define DRV_RELDATE	"2005-7-29"
+#define DRV_VERSION	"0.9.4"
+#define DRV_RELDATE	"2007-7-16"
 
 #include <linux/module.h>
 
@@ -662,7 +662,7 @@ static int uli526x_stop(struct net_device *dev)
 static irqreturn_t uli526x_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
-	struct uli526x_board_info *db = netdev_priv(dev);
+	struct uli526x_board_info *db;
 	unsigned long ioaddr = dev->base_addr;
 	unsigned long flags;
 
@@ -670,6 +670,7 @@ static irqreturn_t uli526x_interrupt(int irq, void *dev_id)
 		ULI526X_DBUG(1, "uli526x_interrupt() without DEVICE arg", 0);
 		return IRQ_NONE;
 	}
+	db = netdev_priv(dev);
 
 	spin_lock_irqsave(&db->lock, flags);
 	outl(0, ioaddr + DCR7);


