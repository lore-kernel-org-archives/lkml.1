Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZGAP6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZGAP6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZGAP6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:58:37 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:61902 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZGAP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:58:36 -0400
From: Frans Pop <elendil@planet.nl>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [2.6.31-rc1] iwlagn (4965): regression when hardware rf switch is used
Date: Wed, 1 Jul 2009 17:58:35 +0200
User-Agent: KMail/1.9.9
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200906291128.05639.elendil@planet.nl> <1246383858.17896.527.camel@rc-desk>
In-Reply-To: <1246383858.17896.527.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011758.36621.elendil@planet.nl>
X-OriginalArrivalTime: 01 Jul 2009 15:58:37.0052 (UTC) FILETIME=[CB41A3C0:01C9FA64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009, reinette chatre wrote:
> Subject: [PATCH] iwlagn: do not send key clear commands when rfkill
> enabled
>
> Do all key clearing except sending sommands to device when rfkill
> enabled. When rfkill enabled the interface is brought down and will
> be brought back up correctly after rfkill is enabled again.
>
> Same change is not needed for iwl3945 as it ignores return code when
> sending key clearing command to device.

With this patch things look a lot cleaner:

[enable hardware rf kill switch]
iwlagn 0000:10:00.0: RF_KILL bit toggled to disable radio.
wlan0: deauthenticating by local choice (reason=3)
usb 3-1: USB disconnect, address 2
[disable hardware rf kill switch]
iwlagn 0000:10:00.0: RF_KILL bit toggled to enable radio.
usb 3-1: new full speed USB device using uhci_hcd and address 3
usb 3-1: configuration #1 chosen from 1 choice
[ifdown wlan0]
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ifup wlan0]
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: authenticate with AP 00:14:c1:38:e5:15
wlan0: authenticated
wlan0: associate with AP 00:14:c1:38:e5:15
wlan0: RX AssocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present


One thing I do not quite get is why both ifdown and ifup result in leds 
getting registered. It does not happen when I do a "normal" ifdown (when 
the wireless interface is up and rfkill is not enabled).

I could understand the leds being registered immediately after I disable 
the rf kill switch, but don't understand why it gets postponed until I do 
ifdown. That makes it seem as if the change in RF_KILL only gets 
processed halfway through with the registering of leds left dangling.


> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reported-by: Frans Pop <elendil@planet.nl>
Tested-by: Frans Pop <elendil@planet.nl>


> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -960,7 +960,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv
> *priv) CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
>  			hw_rf_kill = 1;
>
> -		IWL_DEBUG_RF_KILL(priv, "RF_KILL bit toggled to %s.\n",
> +		IWL_WARN(priv, "RF_KILL bit toggled to %s.\n",
>  				hw_rf_kill ? "disable radio" : "enable radio");
>
>  		priv->isr_stats.rfkill++;
> @@ -1133,7 +1133,7 @@ static void iwl_irq_tasklet(struct iwl_priv
> *priv) CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
>  			hw_rf_kill = 1;
>
> -		IWL_DEBUG_RF_KILL(priv, "RF_KILL bit toggled to %s.\n",
> +		IWL_WARN(priv, "RF_KILL bit toggled to %s.\n",
>  				hw_rf_kill ? "disable radio" : "enable radio");

If these two messages get promoted to regular user messages, maybe they 
could be made a bit less technical? I doubt "RF_KILL bit toggled" is 
going to mean all that much to most users.

Thanks,
FJP
