Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab0CNAfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 19:35:17 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50958 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759452Ab0CNAfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 19:35:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=MKrAQjNovHP33dL7WPe93i5o65gGQssrMgKxgGInn6lNPDalnsD7B6SNYI19F4RVLd
         Xw/HkI6PvIwTogwL98FzhemsGypkbXS2ad05h9zKyw/AlwJrKvi8cp9xGtmbt3gKTM7d
         k9/q6Ri3YqHwCs728j+sd3MHRLo0QRjK9uLcg=
Date: Sat, 13 Mar 2010 16:35:09 -0800
From: 640E9920 <640e9920@gmail.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dwalker@codeaurora.org, tiwai@suse.de, bruce.w.allan@intel.com,
       aili@codeaurora.org, khilman@deeprootsystems.com, pavel@ucw.cz,
       mgross@linux.intel.com
Subject: Re: [PATCH] PM_QOS updates 4 of 6
Message-ID: <20100314003509.GE17812@mgross-acer>
References: <20100313214857.GA3079@mgross-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100313214857.GA3079@mgross-acer>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 01:48:57PM -0800, mgross wrote:
> Date: Sat, 13 Mar 2010 13:48:57 -0800
> From: 640E9920 <640E9920@gmail.com>
> To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
> 	dwalker@codeaurora.org, tiwai@suse.de, bruce.w.allan@intel.com,
> 	aili@codeaurora.org, khilman@deeprootsystems.com, pavel@ucw.cz,
> 	mgross@linux.intel.com
> Subject: [PATCH] PM_QOS updates for 2.6.34-rc1
> User-Agent: Mutt/1.5.20 (2009-06-14)
>
 
>From fc3ec2c781d868031a77bc6ce5bfd6aae22d5551 Mon Sep 17 00:00:00 2001
From: mgross <mgross@linux.intel.com>
Date: Sat, 13 Mar 2010 08:22:37 -0800
Subject: [PATCH 4/6] PM_QOS-to-use-handle-based-requests-wireless-update

Signed-off-by: Mark Gross <mgross@linux.intel.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |   11 ++++++-----
 net/mac80211/mlme.c                    |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 9b72c45..2b05fe5 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -174,6 +174,8 @@ that only one external action is invoked at a time.
 #define DRV_DESCRIPTION	"Intel(R) PRO/Wireless 2100 Network Driver"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2006 Intel Corporation"
 
+struct pm_qos_request_list *ipw2100_pm_qos_req;
+
 /* Debugging stuff */
 #ifdef CONFIG_IPW2100_DEBUG
 #define IPW2100_RX_DEBUG	/* Reception debugging */
@@ -1739,7 +1741,7 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 	/* the ipw2100 hardware really doesn't want power management delays
 	 * longer than 175usec
 	 */
-	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100", 175);
+	pm_qos_update_request(ipw2100_pm_qos_req, 175);
 
 	/* If the interrupt is enabled, turn it off... */
 	spin_lock_irqsave(&priv->low_lock, flags);
@@ -1887,8 +1889,7 @@ static void ipw2100_down(struct ipw2100_priv *priv)
 	ipw2100_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 
-	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
-			PM_QOS_DEFAULT_VALUE);
+	pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
 
 	/* We have to signal any supplicant if we are disassociating */
 	if (associated)
@@ -6669,7 +6670,7 @@ static int __init ipw2100_init(void)
 	if (ret)
 		goto out;
 
-	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
+	ipw2100_pm_qos_req = pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
 			PM_QOS_DEFAULT_VALUE);
 #ifdef CONFIG_IPW2100_DEBUG
 	ipw2100_debug_level = debug;
@@ -6692,7 +6693,7 @@ static void __exit ipw2100_exit(void)
 			   &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&ipw2100_pci_driver);
-	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100");
+	pm_qos_remove_request(ipw2100_pm_qos_req);
 }
 
 module_init(ipw2100_init);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 41812a1..671669c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -489,7 +489,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		s32 beaconint_us;
 
 		if (latency < 0)
-			latency = pm_qos_requirement(PM_QOS_NETWORK_LATENCY);
+			latency = pm_qos_request(PM_QOS_NETWORK_LATENCY);
 
 		beaconint_us = ieee80211_tu_to_usec(
 					found->vif.bss_conf.beacon_int);
-- 
1.6.3.3

