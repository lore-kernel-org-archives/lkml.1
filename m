Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYIUVIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYIUVIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYIUVIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:08:12 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:44914 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYIUVIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:08:11 -0400
Date: Mon, 22 Sep 2008 01:06:49 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Arjan van de Ven <arjan@infradead.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921210649.GB2135@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru> <20080921110422.1d010b96@infradead.org> <20080921182835.GA11473@2ka.mipt.ru> <20080921113513.16677c4e@infradead.org> <20080921190050.GA20484@2ka.mipt.ru> <1222024444.3023.53.camel@johannes.berg> <20080921193809.GA8735@2ka.mipt.ru> <20080921200518.GK7736@localhost> <20080921202656.GC25052@2ka.mipt.ru> <20080921203503.GL7736@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921203503.GL7736@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 12:35:03AM +0400, Cyrill Gorcunov (gorcunov@gmail.com) wrote:
> yes Evgeniy - all could know that but this register info could help
> firmware engineers to distinguish problems (without additional efforts
> like ask users to pass debug argument - kerneloops will have it
> by default) if there not only one exist. I mean I don't think anyone
> would reject additional info about problem ever :)

Agreed.

diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index 19a401c..36cdd57 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -206,6 +206,9 @@ MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
 
 static u32 ipw2100_debug_level = IPW_DL_NONE;
 
+static int ipw2100_max_fatal_ints = 10;
+module_param(ipw2100_max_fatal_ints, int, 0644);
+
 #ifdef CONFIG_IPW2100_DEBUG
 #define IPW_DEBUG(level, message...) \
 do { \
@@ -3174,16 +3177,21 @@ static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
 	if (inta & IPW2100_INTA_FATAL_ERROR) {
 		printk(KERN_WARNING DRV_NAME
 		       ": Fatal interrupt. Scheduling firmware restart.\n");
+
+		printk(KERN_WARNING DRV_NAME ": INTA: 0x%08lX\n",
+			(unsigned long)inta & IPW_INTERRUPT_MASK);
+
 		priv->inta_other++;
 		write_register(dev, IPW_REG_INTA, IPW2100_INTA_FATAL_ERROR);
 
 		read_nic_dword(dev, IPW_NIC_FATAL_ERROR, &priv->fatal_error);
-		IPW_DEBUG_INFO("%s: Fatal error value: 0x%08X\n",
+		printk(KERN_WARNING "%s: Fatal error value: 0x%08X\n",
 			       priv->net_dev->name, priv->fatal_error);
 
 		read_nic_dword(dev, IPW_ERROR_ADDR(priv->fatal_error), &tmp);
-		IPW_DEBUG_INFO("%s: Fatal error address value: 0x%08X\n",
+		printk(KERN_WARNING "%s: Fatal error address value: 0x%08X\n",
 			       priv->net_dev->name, tmp);
+		WARN_ON(ipw2100_max_fatal_ints-- >= 0);
 
 		/* Wake up any sleeping jobs */
 		schedule_reset(priv);


-- 
	Evgeniy Polyakov
