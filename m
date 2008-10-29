Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYJ2SLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYJ2SLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYJ2SLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:11:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYJ2SLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:11:22 -0400
Date: Wed, 29 Oct 2008 20:10:32 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] w35und: remove atomic op wrappers
Message-ID: <Pine.LNX.4.64.0810292010110.16596@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Use the kernel provided atomic op functions and remove the OS_ATOMIC and
related wrapper macros.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/adapter.h         |    3 +--
 drivers/staging/winbond/linux/common.h    |    8 --------
 drivers/staging/winbond/linux/wb35reg.c   |    8 ++++----
 drivers/staging/winbond/linux/wb35reg_s.h |    2 +-
 drivers/staging/winbond/linux/wb35rx.c    |    9 ++++-----
 drivers/staging/winbond/linux/wb35rx_s.h  |    2 +-
 drivers/staging/winbond/linux/wb35tx.c    |   16 ++++++++--------
 drivers/staging/winbond/linux/wb35tx_s.h  |    4 ++--
 drivers/staging/winbond/mds.c             |    6 +++---
 drivers/staging/winbond/mds_s.h           |    4 ++--
 drivers/staging/winbond/wbhal.c           |    2 +-
 drivers/staging/winbond/wbhal_s.h         |    2 +-
 drivers/staging/winbond/wblinux.c         |   29 ++---------------------------
 drivers/staging/winbond/wblinux_f.h       |    2 --
 14 files changed, 30 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/winbond/adapter.h b/drivers/staging/winbond/adapter.h
index e102dcb..bc09e41 100644
--- a/drivers/staging/winbond/adapter.h
+++ b/drivers/staging/winbond/adapter.h
@@ -32,11 +32,10 @@ struct wb35_adapter {
 	hw_data_t sHwData;	//For HAL
 	MDS Mds;
 
-	spinlock_t AtomicSpinLock;
 	spinlock_t SpinLock;
 	u32 shutdown;
 
-	OS_ATOMIC ThreadCount;
+	atomic_t ThreadCount;
 
 	u32 LinkStatus;		// OS_DISCONNECTED or OS_CONNECTED
 
diff --git a/drivers/staging/winbond/linux/common.h b/drivers/staging/winbond/linux/common.h
index 521b68a..925e1b6 100644
--- a/drivers/staging/winbond/linux/common.h
+++ b/drivers/staging/winbond/linux/common.h
@@ -73,14 +73,6 @@
 #define OS_EVENT_INDICATE( _A, _B, _F )
 #define OS_PMKID_STATUS_EVENT( _A )
 
-
-/* Uff, no, longs are not atomic on all architectures Linux
- * supports. This should really use atomic_t */
-
-#define OS_ATOMIC			u32
-#define OS_ATOMIC_READ( _A, _V )	_V
-#define OS_ATOMIC_INC( _A, _V )		EncapAtomicInc( _A, (void*)_V )
-#define OS_ATOMIC_DEC( _A, _V )		EncapAtomicDec( _A, (void*)_V )
 #define OS_MEMORY_CLEAR( _A, _S )	memset( (u8 *)_A,0,_S)
 #define OS_MEMORY_COMPARE( _A, _B, _S )	(memcmp(_A,_B,_S)? 0 : 1) // Definition is reverse with Ndis 1: the same 0: different
 
diff --git a/drivers/staging/winbond/linux/wb35reg.c b/drivers/staging/winbond/linux/wb35reg.c
index e9b1386..cc856a8 100644
--- a/drivers/staging/winbond/linux/wb35reg.c
+++ b/drivers/staging/winbond/linux/wb35reg.c
@@ -386,11 +386,11 @@ Wb35Reg_EP0VM_start(  phw_data_t pHwData )
 {
 	struct wb35_reg *reg = &pHwData->reg;
 
-	if (OS_ATOMIC_INC( pHwData->adapter, &reg->RegFireCount) == 1) {
+	if (atomic_inc_return(&reg->RegFireCount) == 1) {
 		reg->EP0vm_state = VM_RUNNING;
 		Wb35Reg_EP0VM(pHwData);
 	} else
-		OS_ATOMIC_DEC( pHwData->adapter, &reg->RegFireCount );
+		atomic_dec(&reg->RegFireCount);
 }
 
 void
@@ -447,7 +447,7 @@ Wb35Reg_EP0VM(phw_data_t pHwData )
 
  cleanup:
 	reg->EP0vm_state = VM_STOP;
-	OS_ATOMIC_DEC( pHwData->adapter, &reg->RegFireCount );
+	atomic_dec(&reg->RegFireCount);
 }
 
 
@@ -465,7 +465,7 @@ Wb35Reg_EP0VM_complete(struct urb *urb)
 
 	if (pHwData->SurpriseRemove) { // Let WbWlanHalt to handle surprise remove
 		reg->EP0vm_state = VM_STOP;
-		OS_ATOMIC_DEC( pHwData->adapter, &reg->RegFireCount );
+		atomic_dec(&reg->RegFireCount);
 	} else {
 		// Complete to send, remove the URB from the first
 		spin_lock_irq( &reg->EP0VM_spin_lock );
diff --git a/drivers/staging/winbond/linux/wb35reg_s.h b/drivers/staging/winbond/linux/wb35reg_s.h
index c77306c..2f665d1 100644
--- a/drivers/staging/winbond/linux/wb35reg_s.h
+++ b/drivers/staging/winbond/linux/wb35reg_s.h
@@ -142,7 +142,7 @@ struct wb35_reg {
 	u32	        EP0VM_status;//$$
 	struct wb35_reg_queue *reg_first;
 	struct wb35_reg_queue *reg_last;
-	OS_ATOMIC       RegFireCount;
+	atomic_t       RegFireCount;
 
 	// Hardware status
 	u8	EP0vm_state;
diff --git a/drivers/staging/winbond/linux/wb35rx.c b/drivers/staging/winbond/linux/wb35rx.c
index e492fa5..f690298 100644
--- a/drivers/staging/winbond/linux/wb35rx.c
+++ b/drivers/staging/winbond/linux/wb35rx.c
@@ -10,17 +10,16 @@
 //============================================================================
 #include "sysdef.h"
 
-
 void Wb35Rx_start(phw_data_t pHwData)
 {
 	PWB35RX pWb35Rx = &pHwData->Wb35Rx;
 
 	// Allow only one thread to run into the Wb35Rx() function
-	if (OS_ATOMIC_INC(pHwData->adapter, &pWb35Rx->RxFireCounter) == 1) {
+	if (atomic_inc_return(&pWb35Rx->RxFireCounter) == 1) {
 		pWb35Rx->EP3vm_state = VM_RUNNING;
 		Wb35Rx(pHwData);
 	} else
-		OS_ATOMIC_DEC(pHwData->adapter, &pWb35Rx->RxFireCounter);
+		atomic_dec(&pWb35Rx->RxFireCounter);
 }
 
 // This function cannot reentrain
@@ -82,7 +81,7 @@ void Wb35Rx(  phw_data_t pHwData )
 error:
 	// VM stop
 	pWb35Rx->EP3vm_state = VM_STOP;
-	OS_ATOMIC_DEC( pHwData->adapter, &pWb35Rx->RxFireCounter );
+	atomic_dec(&pWb35Rx->RxFireCounter);
 }
 
 void Wb35Rx_Complete(struct urb *urb)
@@ -157,7 +156,7 @@ void Wb35Rx_Complete(struct urb *urb)
 
 error:
 	pWb35Rx->RxOwner[ RxBufferId ] = 1; // Set the owner to hardware
-	OS_ATOMIC_DEC( pHwData->adapter, &pWb35Rx->RxFireCounter );
+	atomic_dec(&pWb35Rx->RxFireCounter);
 	pWb35Rx->EP3vm_state = VM_STOP;
 }
 
diff --git a/drivers/staging/winbond/linux/wb35rx_s.h b/drivers/staging/winbond/linux/wb35rx_s.h
index b90c269..f18350b 100644
--- a/drivers/staging/winbond/linux/wb35rx_s.h
+++ b/drivers/staging/winbond/linux/wb35rx_s.h
@@ -18,7 +18,7 @@
 typedef struct _WB35RX
 {
 	u32			ByteReceived;// For calculating throughput of BulkIn
-	OS_ATOMIC		RxFireCounter;// Does Wb35Rx module fire?
+	atomic_t		RxFireCounter;// Does Wb35Rx module fire?
 
 	u8	RxBuffer[ MAX_USB_RX_BUFFER_NUMBER ][ ((MAX_USB_RX_BUFFER+3) & ~0x03 ) ];
 	u16	RxBufferSize[ ((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01) ];
diff --git a/drivers/staging/winbond/linux/wb35tx.c b/drivers/staging/winbond/linux/wb35tx.c
index 020c52d..a58a193 100644
--- a/drivers/staging/winbond/linux/wb35tx.c
+++ b/drivers/staging/winbond/linux/wb35tx.c
@@ -25,11 +25,11 @@ void Wb35Tx_start(phw_data_t pHwData)
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	// Allow only one thread to run into function
-	if (OS_ATOMIC_INC(pHwData->adapter, &pWb35Tx->TxFireCounter) == 1) {
+	if (atomic_inc_return(&pWb35Tx->TxFireCounter) == 1) {
 		pWb35Tx->EP4vm_state = VM_RUNNING;
 		Wb35Tx(pHwData);
 	} else
-		OS_ATOMIC_DEC( pHwData->adapter, &pWb35Tx->TxFireCounter );
+		atomic_dec(&pWb35Tx->TxFireCounter);
 }
 
 
@@ -81,7 +81,7 @@ void Wb35Tx(phw_data_t pHwData)
 
  cleanup:
 	pWb35Tx->EP4vm_state = VM_STOP;
-	OS_ATOMIC_DEC( pHwData->adapter, &pWb35Tx->TxFireCounter );
+	atomic_dec(&pWb35Tx->TxFireCounter);
 }
 
 
@@ -118,7 +118,7 @@ void Wb35Tx_complete(struct urb * pUrb)
 	return;
 
 error:
-	OS_ATOMIC_DEC( pHwData->adapter, &pWb35Tx->TxFireCounter );
+	atomic_dec(&pWb35Tx->TxFireCounter);
 	pWb35Tx->EP4vm_state = VM_STOP;
 }
 
@@ -211,12 +211,12 @@ void Wb35Tx_EP2VM_start(phw_data_t pHwData)
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	// Allow only one thread to run into function
-	if (OS_ATOMIC_INC( pHwData->adapter, &pWb35Tx->TxResultCount ) == 1) {
+	if (atomic_inc_return(&pWb35Tx->TxResultCount) == 1) {
 		pWb35Tx->EP2vm_state = VM_RUNNING;
 		Wb35Tx_EP2VM( pHwData );
 	}
 	else
-		OS_ATOMIC_DEC( pHwData->adapter, &pWb35Tx->TxResultCount );
+		atomic_dec(&pWb35Tx->TxResultCount);
 }
 
 
@@ -252,7 +252,7 @@ void Wb35Tx_EP2VM(phw_data_t pHwData)
 	return;
 error:
 	pWb35Tx->EP2vm_state = VM_STOP;
-	OS_ATOMIC_DEC( pHwData->adapter, &pWb35Tx->TxResultCount );
+	atomic_dec(&pWb35Tx->TxResultCount);
 }
 
 
@@ -301,7 +301,7 @@ void Wb35Tx_EP2VM_complete(struct urb * pUrb)
 
 	return;
 error:
-	OS_ATOMIC_DEC( pHwData->adapter, &pWb35Tx->TxResultCount );
+	atomic_dec(&pWb35Tx->TxResultCount);
 	pWb35Tx->EP2vm_state = VM_STOP;
 }
 
diff --git a/drivers/staging/winbond/linux/wb35tx_s.h b/drivers/staging/winbond/linux/wb35tx_s.h
index ac43257..8cb449f 100644
--- a/drivers/staging/winbond/linux/wb35tx_s.h
+++ b/drivers/staging/winbond/linux/wb35tx_s.h
@@ -21,8 +21,8 @@ typedef struct _WB35TX
 	// For Interrupt pipe
 	u8	EP2_buf[MAX_INTERRUPT_LENGTH];
 
-	OS_ATOMIC	TxResultCount;// For thread control of EP2 931130.4.m
-	OS_ATOMIC	TxFireCounter;// For thread control of EP4 931130.4.n
+	atomic_t	TxResultCount;// For thread control of EP2 931130.4.m
+	atomic_t	TxFireCounter;// For thread control of EP4 931130.4.n
 	u32			ByteTransfer;
 
 	u32	    TxSendIndex;// The next index of Mds array to be sent
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 8d3c8ad..20008e3 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -6,7 +6,7 @@ Mds_reset_descriptor(struct wb35_adapter * adapter)
 	PMDS pMds = &adapter->Mds;
 
 	pMds->TxPause = 0;
-	pMds->TxThreadCount = 0;
+	atomic_set(&pMds->TxThreadCount, 0);
 	pMds->TxFillIndex = 0;
 	pMds->TxDesIndex = 0;
 	pMds->ScanTxPause = 0;
@@ -52,7 +52,7 @@ Mds_Tx(struct wb35_adapter * adapter)
 		return;
 
 	//Only one thread can be run here
-	if (!OS_ATOMIC_INC( adapter, &pMds->TxThreadCount) == 1)
+	if (!atomic_inc_return(&pMds->TxThreadCount) == 1)
 		goto cleanup;
 
 	// Start to fill the data
@@ -172,7 +172,7 @@ Mds_Tx(struct wb35_adapter * adapter)
 		Wb35Tx_start(pHwData);
 
  cleanup:
-	OS_ATOMIC_DEC( adapter, &pMds->TxThreadCount );
+	atomic_dec(&pMds->TxThreadCount);
 }
 
 void
diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index ac1875f..e1d373e 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -96,9 +96,9 @@ typedef struct _MDS
 	u8	ScanTxPause;	//data Tx pause because the scanning is progressing, but probe request Tx won't.
 	u8	TxPause;//For pause the Mds_Tx modult
 
-	OS_ATOMIC	TxThreadCount;//For thread counting 931130.4.v
+	atomic_t	TxThreadCount;//For thread counting 931130.4.v
 //950301 delete due to HW
-//	OS_ATOMIC	TxConcurrentCount;//931130.4.w
+//	atomic_t	TxConcurrentCount;//931130.4.w
 
 	u16	TxResult[ ((MAX_USB_TX_DESCRIPTOR + 1) & ~0x01) ];//Collect the sending result of Mpdu
 
diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index 3edcc47..100a407 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -843,7 +843,7 @@ void hal_system_power_change(phw_data_t pHwData, u32 PowerState)
 void hal_surprise_remove(  phw_data_t pHwData )
 {
 	struct wb35_adapter * adapter = pHwData->adapter;
-	if (OS_ATOMIC_INC( adapter, &pHwData->SurpriseRemoveCount ) == 1) {
+	if (atomic_inc_return( &pHwData->SurpriseRemoveCount ) == 1) {
 		#ifdef _PE_STATE_DUMP_
 		WBDEBUG(("Calling hal_surprise_remove\n"));
 		#endif
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 2d3adfc..4eeb089 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -570,7 +570,7 @@ typedef struct _HW_DATA_T
 	u32		RxByteCountLast;
 	u32		TxByteCountLast;
 
-	s32		SurpriseRemoveCount;
+	atomic_t	SurpriseRemoveCount;
 
 	// For global timer
 	u32		time_count;//TICK_TIME_100ms 1 = 100ms
diff --git a/drivers/staging/winbond/wblinux.c b/drivers/staging/winbond/wblinux.c
index ca507e7..665d8e0 100644
--- a/drivers/staging/winbond/wblinux.c
+++ b/drivers/staging/winbond/wblinux.c
@@ -10,35 +10,10 @@
 //============================================================================
 #include "os_common.h"
 
-s32
-EncapAtomicInc(struct wb35_adapter * adapter, void* pAtomic)
-{
-	u32	ltmp;
-	u32 *	pltmp = (u32 *)pAtomic;
-	spin_lock_irq( &adapter->AtomicSpinLock );
-	(*pltmp)++;
-	ltmp = (*pltmp);
-	spin_unlock_irq( &adapter->AtomicSpinLock );
-	return ltmp;
-}
-
-s32
-EncapAtomicDec(struct wb35_adapter * adapter, void* pAtomic)
-{
-	u32	ltmp;
-	u32 *	pltmp = (u32 *)pAtomic;
-	spin_lock_irq( &adapter->AtomicSpinLock );
-	(*pltmp)--;
-	ltmp = (*pltmp);
-	spin_unlock_irq( &adapter->AtomicSpinLock );
-	return ltmp;
-}
-
 unsigned char
 WBLINUX_Initial(struct wb35_adapter * adapter)
 {
 	spin_lock_init( &adapter->SpinLock );
-	spin_lock_init( &adapter->AtomicSpinLock );
 	return true;
 }
 
@@ -75,7 +50,7 @@ WBLINUX_stop(  struct wb35_adapter * adapter )
 {
 	struct sk_buff *pSkb;
 
-	if (OS_ATOMIC_INC( adapter, &adapter->ThreadCount ) == 1) {
+	if (atomic_inc_return(&adapter->ThreadCount) == 1) {
 		// Shutdown module immediately
 		adapter->shutdown = 1;
 
@@ -97,7 +72,7 @@ WBLINUX_stop(  struct wb35_adapter * adapter )
 #endif
 	}
 
-	OS_ATOMIC_DEC( adapter, &adapter->ThreadCount );
+	atomic_dec(&adapter->ThreadCount);
 }
 
 void
diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
index f19c0ee..d763820 100644
--- a/drivers/staging/winbond/wblinux_f.h
+++ b/drivers/staging/winbond/wblinux_f.h
@@ -3,8 +3,6 @@
 //
 // wblinux_f.h
 //
-s32 EncapAtomicInc(  struct wb35_adapter *adapter,  void* pAtomic );
-s32 EncapAtomicDec(  struct wb35_adapter *adapter,  void* pAtomic );
 void WBLinux_ReceivePacket(  struct wb35_adapter *adapter,  PRXLAYER1 pRxLayer1 );
 unsigned char WBLINUX_Initial(  struct wb35_adapter *adapter );
 int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev );
-- 
1.5.3.7

