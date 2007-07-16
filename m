Return-Path: <linux-kernel-owner+w=401wt.eu-S1763437AbXGPUl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763437AbXGPUl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXGPUlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:41:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:49309 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbXGPUlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UzGT4ucRu7qH8sfsvyWGHzKtLEWGTUZcEx6Qv5DRpOnuyR3QIggPVAJkcf+6nMjAOrdsrFSKPMgfDi2YBOtZMcTIndruOItXyVKrQaCZQFPiylRnS5PLYskjQ0Csz7pX0dG0Iz87xH7XjUm0QxUs5XlsEgxUhO1mf7E3Du+3icA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Valerie Henson <val@nmt.edu>
Subject: [PATCH][RFC] Semi-pointless NULL test in uli526x driver
Date: Mon, 16 Jul 2007 22:40:29 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tulip-users@lists.sourceforge.net, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707162240.29230.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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


