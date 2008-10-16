Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYJPOk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYJPOk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYJPOkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:40:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:33341 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbYJPOkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=oA51HDD+9A4XBY5sqWkF3RNL1nzuswjcKqK5v4RP6w96pO9DXq3knpHFl8XtFNk9Mr
         ZklJrwHBtMXfFGMhKHADi1h1T48IXkdF7MfRvEbG8i2DaviI2JIYqatKY1lH3xWKMJfo
         v1jSzrrIKfvKgR1QTzTw2Dh0orZfoPh3f9E3U=
Date: Thu, 16 Oct 2008 10:38:40 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] ibm_newemac: Fix new MAL feature handling
Message-ID: <20081016143840.GA29805@yoda.jdub.homelinux.org>
References: <20081015213337.a99a9595.akpm@linux-foundation.org> <1224133010.8157.543.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224133010.8157.543.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 03:56:50PM +1100, Benjamin Herrenschmidt wrote:
>> drivers/net/ibm_newemac/mal.c: In function 'mal_txeob':
>> drivers/net/ibm_newemac/mal.c:284: error: implicit declaration of function 'mtdcri'
>> drivers/net/ibm_newemac/mal.c:284: error: 'SDR0' undeclared (first use in this function)
>> drivers/net/ibm_newemac/mal.c:284: error: (Each undeclared identifier is reported only once
>> drivers/net/ibm_newemac/mal.c:284: error: for each function it appears in.)
>> drivers/net/ibm_newemac/mal.c:285: error: implicit declaration of function 'mfdcri'
>> drivers/net/ibm_newemac/mal.c: In function 'mal_rxeob':
>> drivers/net/ibm_newemac/mal.c:302: error: 'SDR0' undeclared (first use in this function)
>
>That's annoying, I'll have a look.

Support for new features needed by the PPC 405EZ boards
introduced some errors in the MAL and EMAC feature handling.
This broke 'allmodconfig' builds as CONFIG_PPC_DCR_NATIVE is
not set for those.

This patch fixes these errors by wrapping the code in the
appropriate #ifdefs.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---

diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index efcf21c..2ee2622 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -2604,8 +2604,16 @@ static int __devinit emac_init_config(struct emac_instance *dev)
 		if (of_device_is_compatible(np, "ibm,emac-440ep") ||
 		    of_device_is_compatible(np, "ibm,emac-440gr"))
 			dev->features |= EMAC_FTR_440EP_PHY_CLK_FIX;
-		if (of_device_is_compatible(np, "ibm,emac-405ez"))
+		if (of_device_is_compatible(np, "ibm,emac-405ez")) {
+#ifdef CONFIG_IBM_NEW_EMAC_NO_FLOW_CONTROL
 			dev->features |= EMAC_FTR_NO_FLOW_CONTROL_40x;
+#else
+			printk(KERN_ERR "%s: Flow control not disabled!\n",
+					np->full_name);
+			return -ENXIO;
+#endif
+		}
+
 	}
 
 	/* Fixup some feature bits based on the device tree */
diff --git a/drivers/net/ibm_newemac/mal.c b/drivers/net/ibm_newemac/mal.c
index 1839d3f..ecf9798 100644
--- a/drivers/net/ibm_newemac/mal.c
+++ b/drivers/net/ibm_newemac/mal.c
@@ -280,9 +280,11 @@ static irqreturn_t mal_txeob(int irq, void *dev_instance)
 	mal_schedule_poll(mal);
 	set_mal_dcrn(mal, MAL_TXEOBISR, r);
 
+#ifdef CONFIG_PPC_DCR_NATIVE
 	if (mal_has_feature(mal, MAL_FTR_CLEAR_ICINTSTAT))
 		mtdcri(SDR0, DCRN_SDR_ICINTSTAT,
 				(mfdcri(SDR0, DCRN_SDR_ICINTSTAT) | ICINTSTAT_ICTX));
+#endif
 
 	return IRQ_HANDLED;
 }
@@ -298,9 +300,11 @@ static irqreturn_t mal_rxeob(int irq, void *dev_instance)
 	mal_schedule_poll(mal);
 	set_mal_dcrn(mal, MAL_RXEOBISR, r);
 
+#ifdef CONFIG_PPC_DCR_NATIVE
 	if (mal_has_feature(mal, MAL_FTR_CLEAR_ICINTSTAT))
 		mtdcri(SDR0, DCRN_SDR_ICINTSTAT,
 				(mfdcri(SDR0, DCRN_SDR_ICINTSTAT) | ICINTSTAT_ICRX));
+#endif
 
 	return IRQ_HANDLED;
 }
@@ -572,9 +576,18 @@ static int __devinit mal_probe(struct of_device *ofdev,
 		goto fail;
 	}
 
-	if (of_device_is_compatible(ofdev->node, "ibm,mcmal-405ez"))
+	if (of_device_is_compatible(ofdev->node, "ibm,mcmal-405ez")) {
+#if defined(CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT) && \
+		defined(CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR)
 		mal->features |= (MAL_FTR_CLEAR_ICINTSTAT |
 				MAL_FTR_COMMON_ERR_INT);
+#else
+		printk(KERN_ERR "%s: Support for 405EZ not enabled!\n",
+				ofdev->node->full_name);
+		err = -ENODEV;
+		goto fail;
+#endif
+	}
 
 	mal->txeob_irq = irq_of_parse_and_map(ofdev->node, 0);
 	mal->rxeob_irq = irq_of_parse_and_map(ofdev->node, 1);

