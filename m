Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYJ3TQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYJ3TQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYJ3TQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:16:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34844 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbYJ3TQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:16:04 -0400
Date: Thu, 30 Oct 2008 20:17:31 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] w35und: clean up wblinux.c a bit
Message-ID: <20081030191731.GG22185@elf.ucw.cz>
References: <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi> <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-30 18:12:02, Pekka Enberg wrote:
> This patch removes wrapper functions from wblinux.c and moves the hardware init
> and halt functions to wbusb.c which has the only callers of them.

Acked-by: Pavel Machek <pavel@suse.cz>

> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  drivers/staging/winbond/wblinux.c   |  167 -----------------------------------
>  drivers/staging/winbond/wblinux_f.h |    5 -
>  drivers/staging/winbond/wbusb.c     |  150 ++++++++++++++++++++++++++++++-
>  3 files changed, 147 insertions(+), 175 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wblinux.c b/drivers/staging/winbond/wblinux.c
> index 31f2d20..433aa0d 100644
> --- a/drivers/staging/winbond/wblinux.c
> +++ b/drivers/staging/winbond/wblinux.c
> @@ -16,22 +16,6 @@
>  #include "wbhal_f.h"
>  #include "wblinux_f.h"
>  
> -unsigned char
> -WBLINUX_Initial(struct wbsoft_priv * adapter)
> -{
> -	spin_lock_init( &adapter->SpinLock );
> -	return true;
> -}
> -
> -void
> -WBLINUX_Destroy(struct wbsoft_priv * adapter)
> -{
> -	WBLINUX_stop( adapter );
> -#ifdef _PE_USB_INI_DUMP_
> -	WBDEBUG(("[w35und] unregister_netdev!\n"));
> -#endif
> -}
> -
>  void
>  WBLINUX_stop(  struct wbsoft_priv * adapter )
>  {
> @@ -61,154 +45,3 @@ WBLINUX_stop(  struct wbsoft_priv * adapter )
>  
>  	atomic_dec(&adapter->ThreadCount);
>  }
> -
> -void
> -WbWlanHalt(  struct wbsoft_priv * adapter )
> -{
> -	//---------------------
> -	adapter->sLocalPara.ShutDowned = true;
> -
> -	Mds_Destroy( adapter );
> -
> -	// Turn off Rx and Tx hardware ability
> -	hal_stop( &adapter->sHwData );
> -#ifdef _PE_USB_INI_DUMP_
> -	WBDEBUG(("[w35und] Hal_stop O.K.\n"));
> -#endif
> -	msleep(100);// Waiting Irp completed
> -
> -	// Destroy the NDIS module
> -	WBLINUX_Destroy( adapter );
> -
> -	// Halt the HAL
> -	hal_halt(&adapter->sHwData, NULL);
> -}
> -
> -unsigned char
> -WbWLanInitialize(struct ieee80211_hw *hw)
> -{
> -	struct wbsoft_priv *priv = hw->priv;
> -	phw_data_t	pHwData;
> -	u8		*pMacAddr;
> -	u8		*pMacAddr2;
> -	u32		InitStep = 0;
> -	u8		EEPROM_region;
> -	u8		HwRadioOff;
> -
> -	//
> -	// Setting default value for Linux
> -	//
> -	priv->sLocalPara.region_INF = REGION_AUTO;
> -	priv->sLocalPara.TxRateMode = RATE_AUTO;
> -	priv->sLocalPara.bMacOperationMode = MODE_802_11_BG;	// B/G mode
> -	priv->Mds.TxRTSThreshold = DEFAULT_RTSThreshold;
> -	priv->Mds.TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
> -	hal_set_phy_type( &priv->sHwData, RF_WB_242_1 );
> -	priv->sLocalPara.MTUsize = MAX_ETHERNET_PACKET_SIZE;
> -	priv->sLocalPara.bPreambleMode = AUTO_MODE;
> -	priv->sLocalPara.RadioOffStatus.boSwRadioOff = false;
> -	pHwData = &priv->sHwData;
> -	hal_set_phy_type( pHwData, RF_DECIDE_BY_INF );
> -
> -	//
> -	// Initial each module and variable
> -	//
> -	if (!WBLINUX_Initial(priv)) {
> -#ifdef _PE_USB_INI_DUMP_
> -		WBDEBUG(("[w35und]WBNDIS initialization failed\n"));
> -#endif
> -		goto error;
> -	}
> -
> -	// Initial Software variable
> -	priv->sLocalPara.ShutDowned = false;
> -
> -	//added by ws for wep key error detection
> -	priv->sLocalPara.bWepKeyError= false;
> -	priv->sLocalPara.bToSelfPacketReceived = false;
> -	priv->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
> -
> -	// Initial USB hal
> -	InitStep = 1;
> -	pHwData = &priv->sHwData;
> -	if (!hal_init_hardware(hw))
> -		goto error;
> -
> -	EEPROM_region = hal_get_region_from_EEPROM( pHwData );
> -	if (EEPROM_region != REGION_AUTO)
> -		priv->sLocalPara.region = EEPROM_region;
> -	else {
> -		if (priv->sLocalPara.region_INF != REGION_AUTO)
> -			priv->sLocalPara.region = priv->sLocalPara.region_INF;
> -		else
> -			priv->sLocalPara.region = REGION_USA;	//default setting
> -	}
> -
> -	// Get Software setting flag from hal
> -	priv->sLocalPara.boAntennaDiversity = false;
> -	if (hal_software_set(pHwData) & 0x00000001)
> -		priv->sLocalPara.boAntennaDiversity = true;
> -
> -	//
> -	// For TS module
> -	//
> -	InitStep = 2;
> -
> -	// For MDS module
> -	InitStep = 3;
> -	Mds_initial(priv);
> -
> -	//=======================================
> -	// Initialize the SME, SCAN, MLME, ROAM
> -	//=======================================
> -	InitStep = 4;
> -	InitStep = 5;
> -	InitStep = 6;
> -
> -	// If no user-defined address in the registry, use the addresss "burned" on the NIC instead.
> -	pMacAddr = priv->sLocalPara.ThisMacAddress;
> -	pMacAddr2 = priv->sLocalPara.PermanentAddress;
> -	hal_get_permanent_address( pHwData, priv->sLocalPara.PermanentAddress );// Reading ethernet address from EEPROM
> -	if (memcmp(pMacAddr, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH) == 0)
> -		memcpy(pMacAddr, pMacAddr2, MAC_ADDR_LENGTH);
> -	else {
> -		// Set the user define MAC address
> -		hal_set_ethernet_address(pHwData, priv->sLocalPara.ThisMacAddress);
> -	}
> -
> -	//get current antenna
> -	priv->sLocalPara.bAntennaNo = hal_get_antenna_number(pHwData);
> -#ifdef _PE_STATE_DUMP_
> -	WBDEBUG(("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo));
> -#endif
> -	hal_get_hw_radio_off( pHwData );
> -
> -	// Waiting for HAL setting OK
> -	while (!hal_idle(pHwData))
> -		msleep(10);
> -
> -	MTO_Init(priv);
> -
> -	HwRadioOff = hal_get_hw_radio_off( pHwData );
> -	priv->sLocalPara.RadioOffStatus.boHwRadioOff = !!HwRadioOff;
> -
> -	hal_set_radio_mode( pHwData, (unsigned char)(priv->sLocalPara.RadioOffStatus.boSwRadioOff || priv->sLocalPara.RadioOffStatus.boHwRadioOff) );
> -
> -	hal_driver_init_OK(pHwData) = 1; // Notify hal that the driver is ready now.
> -	//set a tx power for reference.....
> -//	sme_set_tx_power_level(priv, 12);	FIXME?
> -	return true;
> -
> -error:
> -	switch (InitStep) {
> -	case 5:
> -	case 4:
> -	case 3: Mds_Destroy( priv );
> -	case 2:
> -	case 1: WBLINUX_Destroy( priv );
> -		hal_halt( pHwData, NULL );
> -	case 0: break;
> -	}
> -
> -	return false;
> -}
> diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
> index 15e6a65..f531a01 100644
> --- a/drivers/staging/winbond/wblinux_f.h
> +++ b/drivers/staging/winbond/wblinux_f.h
> @@ -9,15 +9,10 @@
>  //
>  // wblinux_f.h
>  //
> -unsigned char WBLINUX_Initial(  struct wbsoft_priv *adapter );
>  int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev );
>  void WBLINUX_stop(  struct wbsoft_priv *adapter );
> -void WBLINUX_Destroy(  struct wbsoft_priv *adapter );
>  void wb35_set_multicast( struct net_device *netdev );
>  struct net_device_stats * wb35_netdev_stats( struct net_device *netdev );
>  void WBLINUX_stop(  struct wbsoft_priv *adapter );
> -void WbWlanHalt(  struct wbsoft_priv *adapter );
> -unsigned char WbWLanInitialize(struct ieee80211_hw *hw);
> -
>  
>  #endif
> diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
> index 67847c8..673875d 100644
> --- a/drivers/staging/winbond/wbusb.c
> +++ b/drivers/staging/winbond/wbusb.c
> @@ -7,7 +7,9 @@
>  #include <linux/usb.h>
>  
>  #include "core.h"
> +#include "mds_f.h"
>  #include "mlmetxrx_f.h"
> +#include "mto_f.h"
>  #include "wbhal_f.h"
>  #include "wblinux_f.h"
>  
> @@ -180,7 +182,7 @@ static u64 wbsoft_get_tsf(struct ieee80211_hw *dev)
>  
>  static const struct ieee80211_ops wbsoft_ops = {
>  	.tx			= wbsoft_tx,
> -	.start			= wbsoft_start,		/* Start can be pretty much empty as we do WbWLanInitialize() during probe? */
> +	.start			= wbsoft_start,		/* Start can be pretty much empty as we do wb35_hw_init() during probe? */
>  	.stop			= wbsoft_stop,
>  	.add_interface		= wbsoft_add_interface,
>  	.remove_interface	= wbsoft_remove_interface,
> @@ -193,6 +195,124 @@ static const struct ieee80211_ops wbsoft_ops = {
>  // conf_tx: hal_set_cwmin()/hal_set_cwmax;
>  };
>  
> +static unsigned char wb35_hw_init(struct ieee80211_hw *hw)
> +{
> +	struct wbsoft_priv *priv = hw->priv;
> +	phw_data_t	pHwData;
> +	u8		*pMacAddr;
> +	u8		*pMacAddr2;
> +	u32		InitStep = 0;
> +	u8		EEPROM_region;
> +	u8		HwRadioOff;
> +
> +	//
> +	// Setting default value for Linux
> +	//
> +	priv->sLocalPara.region_INF = REGION_AUTO;
> +	priv->sLocalPara.TxRateMode = RATE_AUTO;
> +	priv->sLocalPara.bMacOperationMode = MODE_802_11_BG;	// B/G mode
> +	priv->Mds.TxRTSThreshold = DEFAULT_RTSThreshold;
> +	priv->Mds.TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
> +	hal_set_phy_type( &priv->sHwData, RF_WB_242_1 );
> +	priv->sLocalPara.MTUsize = MAX_ETHERNET_PACKET_SIZE;
> +	priv->sLocalPara.bPreambleMode = AUTO_MODE;
> +	priv->sLocalPara.RadioOffStatus.boSwRadioOff = false;
> +	pHwData = &priv->sHwData;
> +	hal_set_phy_type( pHwData, RF_DECIDE_BY_INF );
> +
> +	// Initial Software variable
> +	priv->sLocalPara.ShutDowned = false;
> +
> +	//added by ws for wep key error detection
> +	priv->sLocalPara.bWepKeyError= false;
> +	priv->sLocalPara.bToSelfPacketReceived = false;
> +	priv->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
> +
> +	// Initial USB hal
> +	InitStep = 1;
> +	pHwData = &priv->sHwData;
> +	if (!hal_init_hardware(hw))
> +		goto error;
> +
> +	EEPROM_region = hal_get_region_from_EEPROM( pHwData );
> +	if (EEPROM_region != REGION_AUTO)
> +		priv->sLocalPara.region = EEPROM_region;
> +	else {
> +		if (priv->sLocalPara.region_INF != REGION_AUTO)
> +			priv->sLocalPara.region = priv->sLocalPara.region_INF;
> +		else
> +			priv->sLocalPara.region = REGION_USA;	//default setting
> +	}
> +
> +	// Get Software setting flag from hal
> +	priv->sLocalPara.boAntennaDiversity = false;
> +	if (hal_software_set(pHwData) & 0x00000001)
> +		priv->sLocalPara.boAntennaDiversity = true;
> +
> +	//
> +	// For TS module
> +	//
> +	InitStep = 2;
> +
> +	// For MDS module
> +	InitStep = 3;
> +	Mds_initial(priv);
> +
> +	//=======================================
> +	// Initialize the SME, SCAN, MLME, ROAM
> +	//=======================================
> +	InitStep = 4;
> +	InitStep = 5;
> +	InitStep = 6;
> +
> +	// If no user-defined address in the registry, use the addresss "burned" on the NIC instead.
> +	pMacAddr = priv->sLocalPara.ThisMacAddress;
> +	pMacAddr2 = priv->sLocalPara.PermanentAddress;
> +	hal_get_permanent_address( pHwData, priv->sLocalPara.PermanentAddress );// Reading ethernet address from EEPROM
> +	if (memcmp(pMacAddr, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH) == 0)
> +		memcpy(pMacAddr, pMacAddr2, MAC_ADDR_LENGTH);
> +	else {
> +		// Set the user define MAC address
> +		hal_set_ethernet_address(pHwData, priv->sLocalPara.ThisMacAddress);
> +	}
> +
> +	//get current antenna
> +	priv->sLocalPara.bAntennaNo = hal_get_antenna_number(pHwData);
> +#ifdef _PE_STATE_DUMP_
> +	WBDEBUG(("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo));
> +#endif
> +	hal_get_hw_radio_off( pHwData );
> +
> +	// Waiting for HAL setting OK
> +	while (!hal_idle(pHwData))
> +		msleep(10);
> +
> +	MTO_Init(priv);
> +
> +	HwRadioOff = hal_get_hw_radio_off( pHwData );
> +	priv->sLocalPara.RadioOffStatus.boHwRadioOff = !!HwRadioOff;
> +
> +	hal_set_radio_mode( pHwData, (unsigned char)(priv->sLocalPara.RadioOffStatus.boSwRadioOff || priv->sLocalPara.RadioOffStatus.boHwRadioOff) );
> +
> +	hal_driver_init_OK(pHwData) = 1; // Notify hal that the driver is ready now.
> +	//set a tx power for reference.....
> +//	sme_set_tx_power_level(priv, 12);	FIXME?
> +	return true;
> +
> +error:
> +	switch (InitStep) {
> +	case 5:
> +	case 4:
> +	case 3: Mds_Destroy( priv );
> +	case 2:
> +	case 1: WBLINUX_stop(priv);
> +		hal_halt( pHwData, NULL );
> +	case 0: break;
> +	}
> +
> +	return false;
> +}
> +
>  static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
>  {
>  	PWBUSB		pWbUsb;
> @@ -225,6 +345,8 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
>  
>  	priv = dev->priv;
>  
> +	spin_lock_init(&priv->SpinLock);
> +
>  	pWbUsb = &priv->sHwData.WbUsb;
>  	pWbUsb->udev = udev;
>  
> @@ -236,7 +358,7 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
>  		pWbUsb->IsUsb20 = 1;
>  	}
>  
> -	if (!WbWLanInitialize(dev)) {
> +	if (!wb35_hw_init(dev)) {
>  		err = -EINVAL;
>  		goto error_free_hw;
>  	}
> @@ -300,11 +422,33 @@ void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize
>  	ieee80211_rx_irqsafe(hw, skb, &rx_status);
>  }
>  
> +static void wb35_hw_halt(struct wbsoft_priv *adapter)
> +{
> +	//---------------------
> +	adapter->sLocalPara.ShutDowned = true;
> +
> +	Mds_Destroy( adapter );
> +
> +	// Turn off Rx and Tx hardware ability
> +	hal_stop( &adapter->sHwData );
> +#ifdef _PE_USB_INI_DUMP_
> +	WBDEBUG(("[w35und] Hal_stop O.K.\n"));
> +#endif
> +	msleep(100);// Waiting Irp completed
> +
> +	// Destroy the NDIS module
> +	WBLINUX_stop(adapter);
> +
> +	// Halt the HAL
> +	hal_halt(&adapter->sHwData, NULL);
> +}
> +
> +
>  static void wb35_disconnect(struct usb_interface *intf)
>  {
>  	struct wbsoft_priv *priv = usb_get_intfdata(intf);
>  
> -	WbWlanHalt(priv);
> +	wb35_hw_halt(priv);
>  
>  	usb_set_intfdata(intf, NULL);
>  	usb_put_dev(interface_to_usbdev(intf));

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
