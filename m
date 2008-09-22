Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbYIVAB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbYIVAB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 20:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYIVABr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 20:01:47 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:60064 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYIVABq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 20:01:46 -0400
Date: Mon, 22 Sep 2008 04:00:39 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080922000039.GA1878@2ka.mipt.ru>
References: <20080921190050.GA20484@2ka.mipt.ru> <1222024444.3023.53.camel@johannes.berg> <20080921193809.GA8735@2ka.mipt.ru> <20080921124332.67ddc13a@infradead.org> <20080921202057.GB25052@2ka.mipt.ru> <20080921132753.5689b564@infradead.org> <20080921205706.GA24545@2ka.mipt.ru> <20080921140203.4698a2ee@infradead.org> <20080921210554.GA2135@2ka.mipt.ru> <1222039667.6782.125.camel@californication>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222039667.6782.125.camel@californication>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 01:27:47AM +0200, Marcel Holtmann (holtmann@linux.intel.com) wrote:
> as Arjan and Alan pointed out already, WARN_ON_ONCE is enough and I
> agree with them. Just to make this perfectly clear, this is with my
> community hat on.
> 
> Please send a proper patch with a simple WARN_ON_ONCE and I am happy to
> sign off on it.

I really do not care about if there is warning at all, I just want that
bug to be fixed. And a we can see, something started to change, and that's
probably a good sign. I glad there is a result. I will check d3 states
tomorrow. Attached patch if you think it is yet needed.

diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index 19a401c..637dc05 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -3174,16 +3174,18 @@ static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
 	if (inta & IPW2100_INTA_FATAL_ERROR) {
 		printk(KERN_WARNING DRV_NAME
 		       ": Fatal interrupt. Scheduling firmware restart.\n");
+
 		priv->inta_other++;
 		write_register(dev, IPW_REG_INTA, IPW2100_INTA_FATAL_ERROR);
 
 		read_nic_dword(dev, IPW_NIC_FATAL_ERROR, &priv->fatal_error);
-		IPW_DEBUG_INFO("%s: Fatal error value: 0x%08X\n",
-			       priv->net_dev->name, priv->fatal_error);
-
 		read_nic_dword(dev, IPW_ERROR_ADDR(priv->fatal_error), &tmp);
-		IPW_DEBUG_INFO("%s: Fatal error address value: 0x%08X\n",
-			       priv->net_dev->name, tmp);
+
+		printk(KERN_WARNING "%s: Fatal error value: 0x%08X, "
+				"address: 0x%08X, inta: 0x%08lX\n",
+			priv->net_dev->name, priv->fatal_error, tmp,
+			(unsigned long)inta & IPW_INTERRUPT_MASK);
+		WARN_ON_ONCE(1);
 
 		/* Wake up any sleeping jobs */
 		schedule_reset(priv);

-- 
	Evgeniy Polyakov
