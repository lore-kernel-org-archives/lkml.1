Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYJWJpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYJWJpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYJWJpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:45:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46402 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbYJWJpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:45:34 -0400
Date: Thu, 23 Oct 2008 11:47:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] w35und: remove dead code from wbusb_f.h
Message-ID: <20081023094713.GD1849@elf.ucw.cz>
References: <Pine.LNX.4.64.0810221906140.1679@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221906140.1679@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-22 19:06:41, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Remove dead code from wbusb_f.h and move the WbWLanInitialize() definition to
> wblinux_f.h where it arguably belongs to. As the wbusb_f.h is now empty, we can
> remove it completely.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

> ---
>  drivers/staging/winbond/linux/wbusb.c   |   12 ------
>  drivers/staging/winbond/linux/wbusb_f.h |   25 -------------
>  drivers/staging/winbond/wbhal.c         |   57 ++++++++++++++-----------------
>  drivers/staging/winbond/wbhal_f.h       |    2 -
>  drivers/staging/winbond/wblinux_f.h     |    3 +-
>  5 files changed, 27 insertions(+), 72 deletions(-)
>  delete mode 100644 drivers/staging/winbond/linux/wbusb_f.h
> 
> diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
> index c3394bf..8b6d99c 100644
> --- a/drivers/staging/winbond/linux/wbusb.c
> +++ b/drivers/staging/winbond/linux/wbusb.c
> @@ -296,18 +296,6 @@ void packet_came(char *pRxBufferAddress, int PacketSize)
>  	ieee80211_rx_irqsafe(my_dev, skb, &rx_status);
>  }
>  
> -unsigned char
> -WbUsb_initial(phw_data_t pHwData)
> -{
> -	return 1;
> -}
> -
> -
> -void
> -WbUsb_destroy(phw_data_t pHwData)
> -{
> -}
> -
>  static void wb35_disconnect(struct usb_interface *intf)
>  {
>  	struct wb35_adapter * adapter = usb_get_intfdata(intf);
> diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
> deleted file mode 100644
> index a1d5946..0000000
> --- a/drivers/staging/winbond/linux/wbusb_f.h
> +++ /dev/null
> @@ -1,25 +0,0 @@
> -//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> -// Copyright (c) 1996-2004 Winbond Electronic Corporation
> -//
> -//  Module Name:
> -//    wbusb_f.h
> -//
> -//  Abstract:
> -//    Linux driver.
> -//
> -//  Author:
> -//
> -//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> -
> -unsigned char WbUsb_initial(phw_data_t pHwData);
> -void WbUsb_destroy(phw_data_t pHwData);
> -unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
> -#define	WbUsb_Stop( _A )
> -
> -#define WbUsb_CheckForHang( _P )
> -#define WbUsb_DetectStart( _P, _I )
> -
> -
> -
> -
> -
> diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
> index 8da441c..356bd91 100644
> --- a/drivers/staging/winbond/wbhal.c
> +++ b/drivers/staging/winbond/wbhal.c
> @@ -37,34 +37,32 @@ u8 hal_init_hardware(phw_data_t pHwData, struct wb35_adapter * adapter)
>  	pHwData->MaxReceiveLifeTime = DEFAULT_MSDU_LIFE_TIME; // Setting Rx maximum MSDU life time
>  	pHwData->FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD; // Setting default fragment threshold
>  
> -	if (WbUsb_initial(pHwData)) {
> -		pHwData->InitialResource = 1;
> -		if( Wb35Reg_initial(pHwData)) {
> -			pHwData->InitialResource = 2;
> -			if (Wb35Tx_initial(pHwData)) {
> -				pHwData->InitialResource = 3;
> -				if (Wb35Rx_initial(pHwData)) {
> -					pHwData->InitialResource = 4;
> -					OS_TIMER_INITIAL( &pHwData->LEDTimer, hal_led_control, pHwData );
> -					OS_TIMER_SET( &pHwData->LEDTimer, 1000 ); // 20060623
> -
> -					//
> -					// For restrict to vendor's hardware
> -					//
> -					SoftwareSet = hal_software_set( pHwData );
> -
> -					#ifdef Vendor2
> -					// Try to make sure the EEPROM contain
> -					SoftwareSet >>= 8;
> -					if( SoftwareSet != 0x82 )
> -						return FALSE;
> -					#endif
> -
> -					Wb35Rx_start( pHwData );
> -					Wb35Tx_EP2VM_start( pHwData );
> -
> -					return TRUE;
> -				}
> +	pHwData->InitialResource = 1;
> +	if( Wb35Reg_initial(pHwData)) {
> +		pHwData->InitialResource = 2;
> +		if (Wb35Tx_initial(pHwData)) {
> +			pHwData->InitialResource = 3;
> +			if (Wb35Rx_initial(pHwData)) {
> +				pHwData->InitialResource = 4;
> +				OS_TIMER_INITIAL( &pHwData->LEDTimer, hal_led_control, pHwData );
> +				OS_TIMER_SET( &pHwData->LEDTimer, 1000 ); // 20060623
> +
> +				//
> +				// For restrict to vendor's hardware
> +				//
> +				SoftwareSet = hal_software_set( pHwData );
> +
> +				#ifdef Vendor2
> +				// Try to make sure the EEPROM contain
> +				SoftwareSet >>= 8;
> +				if( SoftwareSet != 0x82 )
> +					return FALSE;
> +				#endif
> +
> +				Wb35Rx_start( pHwData );
> +				Wb35Tx_EP2VM_start( pHwData );
> +
> +				return TRUE;
>  			}
>  		}
>  	}
> @@ -84,7 +82,6 @@ void hal_halt(phw_data_t pHwData, void *ppa_data)
>  			Wb35Rx_destroy( pHwData ); // Release the Rx
>  		case 2: Wb35Tx_destroy( pHwData ); // Release the Tx
>  		case 1: Wb35Reg_destroy( pHwData ); // Release the Wb35 Regisster resources
> -				WbUsb_destroy( pHwData );// Release the WbUsb
>  	}
>  }
>  
> @@ -330,8 +327,6 @@ void hal_stop(  phw_data_t pHwData )
>  
>  	reg->D00_DmaControl &= ~0xc0000000;//Tx Off, Rx Off
>  	Wb35Reg_Write( pHwData, 0x0400, reg->D00_DmaControl );
> -
> -	WbUsb_Stop( pHwData ); // 20051230 Add.4
>  }
>  
>  unsigned char hal_idle(phw_data_t pHwData)
> diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
> index 4ecf191..9f0436b 100644
> --- a/drivers/staging/winbond/wbhal_f.h
> +++ b/drivers/staging/winbond/wbhal_f.h
> @@ -2,12 +2,10 @@
>  // Device related include
>  //=====================================================================
>  #ifdef WB_LINUX
> -	#include "linux/wbusb_f.h"
>  	#include "linux/wb35reg_f.h"
>  	#include "linux/wb35tx_f.h"
>  	#include "linux/wb35rx_f.h"
>  #else
> -	#include "wbusb_f.h"
>  	#include "wb35reg_f.h"
>  	#include "wb35tx_f.h"
>  	#include "wb35rx_f.h"
> diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
> index 446ace9..1d09c65 100644
> --- a/drivers/staging/winbond/wblinux_f.h
> +++ b/drivers/staging/winbond/wblinux_f.h
> @@ -18,6 +18,5 @@ struct net_device_stats * wb35_netdev_stats( struct net_device *netdev );
>  void WBLINUX_stop(  struct wb35_adapter *adapter );
>  void WbWlanHalt(  struct wb35_adapter *adapter );
>  void WBLINUX_ConnectStatus(  struct wb35_adapter *adapter,  u32 flag );
> -
> -
> +unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
