Return-Path: <linux-kernel-owner+w=401wt.eu-S938796AbXHLWZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938796AbXHLWZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 18:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765520AbXHLWZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 18:25:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:48581 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765084AbXHLWZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 18:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fONvxnqUrUCO4XsblGk9LmtC7uWGHXvAyrBOXPKOpRzUXPMO5s2kPUIhNNotg1db+WxafhUmcrGX5D+BQapQPyAylr0a9nUxHGLGg0LXs+a+0UiiZM5FUw2YSO3Nt8gWz5wmXFYNt02t7b2Ao37yk/L9nY2n+HcCvylqFyoO0Mk=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/6][RESEND] Avoid possible NULL pointer deref in 3c359 driver
Date: Mon, 13 Aug 2007 00:22:53 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Phillips <mikep@linuxtr.net>, netdev@vger.kernel.org,
       linux-tr@linuxtr.net, davem@davemloft.net,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200708130016.11281.jesper.juhl@gmail.com>
In-Reply-To: <200708130016.11281.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130022.53998.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending old patch originally submitted at 1/7-2007 02:19, 04-Aug-2007 20:31)

In xl_freemem(), if dev_if is NULL, the line
  struct xl_private *xl_priv =(struct xl_private *)dev->priv;
will cause a NULL pointer dereference. However, if we move
that assignment below the 'if' statement that tests for a NULL
'dev', then that NULL deref can never happen.
It never hurts to be safe :-)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index e22a3f5..671f4da 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -1044,15 +1044,17 @@ static void xl_freemem(struct net_device *dev)
 static irqreturn_t xl_interrupt(int irq, void *dev_id) 
 {
 	struct net_device *dev = (struct net_device *)dev_id;
- 	struct xl_private *xl_priv =(struct xl_private *)dev->priv;
-	u8 __iomem * xl_mmio = xl_priv->xl_mmio ; 
-	u16 intstatus, macstatus  ;
+ 	struct xl_private *xl_priv;
+	u8 __iomem * xl_mmio; 
+	u16 intstatus, macstatus;
 
 	if (!dev) { 
-		printk(KERN_WARNING "Device structure dead, aaahhhh !\n") ;
+		printk(KERN_WARNING "3c359: Device structure dead, aaahhhh!\n");
 		return IRQ_NONE; 
 	}
 
+	xl_priv = (struct xl_private *)dev->priv;
+	xl_mmio = xl_priv->xl_mmio;
 	intstatus = readw(xl_mmio + MMIO_INTSTATUS) ;  
 
 	if (!(intstatus & 1)) /* We didn't generate the interrupt */



