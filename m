Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYJVLmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYJVLmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYJVLl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:41:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47517 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYJVLl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:41:57 -0400
Date: Wed, 22 Oct 2008 13:41:55 +0200
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] w35und: merge wblinux struct to adapter
Message-ID: <20081022114155.GF7843@atrey.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0810221103200.13366@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221103200.13366@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Zaps another compatability layer from the driver code.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

> ---
>  drivers/staging/winbond/adapter.h      |   60 ++++++++++++++++++++++++-------
>  drivers/staging/winbond/linux/sysdef.h |    1 -
>  drivers/staging/winbond/linux/wbusb.c  |    5 ---
>  drivers/staging/winbond/wblinux.c      |   37 ++++++++------------
>  drivers/staging/winbond/wblinux_s.h    |   45 ------------------------
>  5 files changed, 61 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/staging/winbond/adapter.h b/drivers/staging/winbond/adapter.h
> index 8925dad..fc4205d 100644
> --- a/drivers/staging/winbond/adapter.h
> +++ b/drivers/staging/winbond/adapter.h
> @@ -1,23 +1,55 @@
> -//
> -// ADAPTER.H -
> -// Windows NDIS global variable 'adapter' typedef
> -//
> +#define OS_MEMORY_ALLOC( _V, _S )	WBLINUX_MemoryAlloc( _V, _S )
> +#define OS_LINK_STATUS			(adapter->LinkStatus == OS_CONNECTED)
> +#define OS_SET_SHUTDOWN( _A )		_A->shutdown=1
> +#define OS_SET_RESUME( _A )		_A->shutdown=0
> +#define OS_CONNECT_STATUS_INDICATE( _A, _F )		WBLINUX_ConnectStatus( _A, _F )
> +#define OS_DISCONNECTED	0
> +#define OS_CONNECTED	1
> +#define OS_STOP( _A )	WBLINUX_stop( _A )
> +
> +#define OS_CURRENT_RX_BYTE( _A )		_A->RxByteCount
> +#define OS_CURRENT_TX_BYTE( _A )		_A->TxByteCount
> +#define OS_EVENT_INDICATE( _A, _B, _F )
> +#define OS_PMKID_STATUS_EVENT( _A )
> +#define OS_RECEIVE_PACKET_INDICATE( _A, _D )		WBLinux_ReceivePacket( _A, _D )
> +#define OS_RECEIVE_802_1X_PACKET_INDICATE( _A, _D )	EAP_ReceivePacket( _A, _D )
> +#define OS_GET_PACKET( _A, _D )				WBLINUX_GetNextPacket( _A, _D )
> +#define OS_GET_PACKET_COMPLETE( _A, _D )	WBLINUX_GetNextPacketCompleted( _A, _D )
> +#define OS_SEND_RESULT( _A, _ID, _R )
> +
> +#define WBLINUX_PACKET_ARRAY_SIZE	(ETHERNET_TX_DESCRIPTORS*4)
> +
>  #define MAX_ANSI_STRING		40
>  
>  struct wb35_adapter {
> -	u32 adapterIndex; // 20060703.4 Add for using padapterContext global adapter point
> +	u32 adapterIndex;	// 20060703.4 Add for using padapterContext global adapter point
> +
> +	WB_LOCALDESCRIPT sLocalPara;	// Myself connected parameters
> +	PWB_BSSDESCRIPTION asBSSDescriptElement;
> +
> +	MLME_FRAME sMlmeFrame;	// connect to peerSTA parameters
> +
> +	MTO_PARAMETERS sMtoPara;	// MTO_struct ...
> +	hw_data_t sHwData;	//For HAL
> +	MDS Mds;
> +
> +	spinlock_t AtomicSpinLock;
> +	spinlock_t SpinLock;
> +	u32 shutdown;
>  
> -	WB_LOCALDESCRIPT	sLocalPara;		// Myself connected parameters
> -	PWB_BSSDESCRIPTION	asBSSDescriptElement;
> +	OS_ATOMIC ThreadCount;
>  
> -	MLME_FRAME		sMlmeFrame;		// connect to peerSTA parameters
> +	u32 LinkStatus;		// OS_DISCONNECTED or OS_CONNECTED
>  
> -	MTO_PARAMETERS		sMtoPara; // MTO_struct ...
> -	hw_data_t			sHwData; //For HAL
> -	MDS					Mds;
> +	u32 RxByteCount;
> +	u32 TxByteCount;
>  
> -	WBLINUX		WbLinux;
> -        struct iw_statistics iw_stats;
> +	struct sk_buff *skb_array[WBLINUX_PACKET_ARRAY_SIZE];
> +	struct sk_buff *packet_return;
> +	s32 skb_SetIndex;
> +	s32 skb_GetIndex;
> +	s32 netif_state_stop;	// 1: stop  0: normal
> +	struct iw_statistics iw_stats;
>  
> -	u8	LinkName[MAX_ANSI_STRING];
> +	u8 LinkName[MAX_ANSI_STRING];
>  };
> diff --git a/drivers/staging/winbond/linux/sysdef.h b/drivers/staging/winbond/linux/sysdef.h
> index d46d63e..4b35a97 100644
> --- a/drivers/staging/winbond/linux/sysdef.h
> +++ b/drivers/staging/winbond/linux/sysdef.h
> @@ -53,7 +53,6 @@
>  #include "../sme_api.h"
>  #include "../gl_80211.h"
>  #include "../mto.h"
> -#include "../wblinux_s.h"
>  #include "../wbhal_s.h"
>  
>  
> diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
> index 245021d..9f1064d 100644
> --- a/drivers/staging/winbond/linux/wbusb.c
> +++ b/drivers/staging/winbond/linux/wbusb.c
> @@ -178,7 +178,6 @@ struct wbsoft_priv {
>  int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
>  {
>  	struct wb35_adapter *adapter;
> -	PWBLINUX	pWbLinux;
>  	PWBUSB		pWbUsb;
>          struct usb_host_interface *interface;
>  	struct usb_endpoint_descriptor *endpoint;
> @@ -204,7 +203,6 @@ int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
>  	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
>  
>  	my_adapter = adapter;
> -	pWbLinux = &adapter->WbLinux;
>  	pWbUsb = &adapter->sHwData.WbUsb;
>  	pWbUsb->udev = udev;
>  
> @@ -344,12 +342,9 @@ int wb35_close(struct net_device *netdev)
>  
>  void wb35_disconnect(struct usb_interface *intf)
>  {
> -	PWBLINUX pWbLinux;
>  	struct wb35_adapter * adapter = usb_get_intfdata(intf);
>  	usb_set_intfdata(intf, NULL);
>  
> -        pWbLinux = &adapter->WbLinux;
> -
>  	// Card remove
>  	WbWlanHalt(adapter);
>  
> diff --git a/drivers/staging/winbond/wblinux.c b/drivers/staging/winbond/wblinux.c
> index 4e6f8cf..1668e54 100644
> --- a/drivers/staging/winbond/wblinux.c
> +++ b/drivers/staging/winbond/wblinux.c
> @@ -23,36 +23,32 @@ WBLINUX_MemoryAlloc(void* *VirtualAddress, u32 Length)
>  s32
>  EncapAtomicInc(struct wb35_adapter * adapter, void* pAtomic)
>  {
> -	PWBLINUX pWbLinux = &adapter->WbLinux;
>  	u32	ltmp;
>  	u32 *	pltmp = (u32 *)pAtomic;
> -	spin_lock_irq( &pWbLinux->AtomicSpinLock );
> +	spin_lock_irq( &adapter->AtomicSpinLock );
>  	(*pltmp)++;
>  	ltmp = (*pltmp);
> -	spin_unlock_irq( &pWbLinux->AtomicSpinLock );
> +	spin_unlock_irq( &adapter->AtomicSpinLock );
>  	return ltmp;
>  }
>  
>  s32
>  EncapAtomicDec(struct wb35_adapter * adapter, void* pAtomic)
>  {
> -	PWBLINUX pWbLinux = &adapter->WbLinux;
>  	u32	ltmp;
>  	u32 *	pltmp = (u32 *)pAtomic;
> -	spin_lock_irq( &pWbLinux->AtomicSpinLock );
> +	spin_lock_irq( &adapter->AtomicSpinLock );
>  	(*pltmp)--;
>  	ltmp = (*pltmp);
> -	spin_unlock_irq( &pWbLinux->AtomicSpinLock );
> +	spin_unlock_irq( &adapter->AtomicSpinLock );
>  	return ltmp;
>  }
>  
>  unsigned char
>  WBLINUX_Initial(struct wb35_adapter * adapter)
>  {
> -	PWBLINUX pWbLinux = &adapter->WbLinux;
> -
> -	spin_lock_init( &pWbLinux->SpinLock );
> -	spin_lock_init( &pWbLinux->AtomicSpinLock );
> +	spin_lock_init( &adapter->SpinLock );
> +	spin_lock_init( &adapter->AtomicSpinLock );
>  	return TRUE;
>  }
>  
> @@ -87,24 +83,23 @@ WBLINUX_Destroy(struct wb35_adapter * adapter)
>  void
>  WBLINUX_stop(  struct wb35_adapter * adapter )
>  {
> -	PWBLINUX	pWbLinux = &adapter->WbLinux;
>  	struct sk_buff *pSkb;
>  
> -	if (OS_ATOMIC_INC( adapter, &pWbLinux->ThreadCount ) == 1) {
> +	if (OS_ATOMIC_INC( adapter, &adapter->ThreadCount ) == 1) {
>  		// Shutdown module immediately
> -		pWbLinux->shutdown = 1;
> +		adapter->shutdown = 1;
>  
> -		while (pWbLinux->skb_array[ pWbLinux->skb_GetIndex ]) {
> +		while (adapter->skb_array[ adapter->skb_GetIndex ]) {
>  			// Trying to free the un-sending packet
> -			pSkb = pWbLinux->skb_array[ pWbLinux->skb_GetIndex ];
> -			pWbLinux->skb_array[ pWbLinux->skb_GetIndex ] = NULL;
> +			pSkb = adapter->skb_array[ adapter->skb_GetIndex ];
> +			adapter->skb_array[ adapter->skb_GetIndex ] = NULL;
>  			if( in_irq() )
>  				dev_kfree_skb_irq( pSkb );
>  			else
>  				dev_kfree_skb( pSkb );
>  
> -			pWbLinux->skb_GetIndex++;
> -			pWbLinux->skb_GetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
> +			adapter->skb_GetIndex++;
> +			adapter->skb_GetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
>  		}
>  
>  #ifdef _PE_STATE_DUMP_
> @@ -112,7 +107,7 @@ WBLINUX_stop(  struct wb35_adapter * adapter )
>  #endif
>  	}
>  
> -	OS_ATOMIC_DEC( adapter, &pWbLinux->ThreadCount );
> +	OS_ATOMIC_DEC( adapter, &adapter->ThreadCount );
>  }
>  
>  void
> @@ -268,8 +263,6 @@ error:
>  
>  void WBLINUX_ConnectStatus(struct wb35_adapter * adapter, u32 flag)
>  {
> -	PWBLINUX	pWbLinux = &adapter->WbLinux;
> -
> -	pWbLinux->LinkStatus = flag; // OS_DISCONNECTED	or  OS_CONNECTED
> +	adapter->LinkStatus = flag; // OS_DISCONNECTED	or  OS_CONNECTED
>  }
>  
> diff --git a/drivers/staging/winbond/wblinux_s.h b/drivers/staging/winbond/wblinux_s.h
> index 619843f..e69de29 100644
> --- a/drivers/staging/winbond/wblinux_s.h
> +++ b/drivers/staging/winbond/wblinux_s.h
> @@ -1,45 +0,0 @@
> -//============================================================
> -// wblinux_s.h
> -//
> -#define OS_MEMORY_ALLOC( _V, _S )	WBLINUX_MemoryAlloc( _V, _S )
> -#define OS_LINK_STATUS			(adapter->WbLinux.LinkStatus == OS_CONNECTED)
> -#define OS_SET_SHUTDOWN( _A )		_A->WbLinux.shutdown=1
> -#define OS_SET_RESUME( _A )		_A->WbLinux.shutdown=0
> -#define OS_CONNECT_STATUS_INDICATE( _A, _F )		WBLINUX_ConnectStatus( _A, _F )
> -#define OS_DISCONNECTED	0
> -#define OS_CONNECTED	1
> -#define OS_STOP( _A )	WBLINUX_stop( _A )
> -
> -#define OS_CURRENT_RX_BYTE( _A )		_A->WbLinux.RxByteCount
> -#define OS_CURRENT_TX_BYTE( _A )		_A->WbLinux.TxByteCount
> -#define OS_EVENT_INDICATE( _A, _B, _F )
> -#define OS_PMKID_STATUS_EVENT( _A )
> -#define OS_RECEIVE_PACKET_INDICATE( _A, _D )		WBLinux_ReceivePacket( _A, _D )
> -#define OS_RECEIVE_802_1X_PACKET_INDICATE( _A, _D )	EAP_ReceivePacket( _A, _D )
> -#define OS_GET_PACKET( _A, _D )				WBLINUX_GetNextPacket( _A, _D )
> -#define OS_GET_PACKET_COMPLETE( _A, _D )	WBLINUX_GetNextPacketCompleted( _A, _D )
> -#define OS_SEND_RESULT( _A, _ID, _R )
> -
> -#define WBLINUX_PACKET_ARRAY_SIZE	(ETHERNET_TX_DESCRIPTORS*4)
> -
> -typedef struct _WBLINUX
> -{
> -	spinlock_t	AtomicSpinLock;
> -	spinlock_t	SpinLock;
> -	u32	shutdown;
> -
> -	OS_ATOMIC	ThreadCount;
> -
> -	u32	LinkStatus;		// OS_DISCONNECTED or OS_CONNECTED
> -
> -	u32	RxByteCount;
> -	u32	TxByteCount;
> -
> -	struct sk_buff *skb_array[ WBLINUX_PACKET_ARRAY_SIZE ];
> -	struct sk_buff *packet_return;
> -	s32	skb_SetIndex;
> -	s32	skb_GetIndex;
> -	s32	netif_state_stop; // 1: stop  0: normal
> -} WBLINUX, *PWBLINUX;
> -
> -

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
