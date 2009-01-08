Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZAHJ5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZAHJ5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZAHJ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:56:57 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47032 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZAHJ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:56:56 -0500
Subject: Re: [PATCH 1/3] w35und: Move ETH_LENGTH_OF_ADDRESS to wbhal_s.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1231408018.5539.6.camel@brick>
References: <Pine.LNX.4.64.0901081130160.15334@melkki.cs.Helsinki.FI>
	 <1231408018.5539.6.camel@brick>
Date: Thu, 08 Jan 2009 11:56:53 +0200
Message-Id: <1231408613.9373.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 01:46 -0800, Harvey Harrison wrote:
> On Thu, 2009-01-08 at 11:30 +0200, Pekka J Enberg wrote:
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> >  
> > +#define ETH_LENGTH_OF_ADDRESS 6
> 
> Or just use ETH_ALEN like the rest of the kernel and drop this guy.

Even better, thanks Harvey! Greg, please use this one instead. The rest
of the series is unaffected by the changes in this patch.

>From c849ed5b5e68953a72f8dc43066513f118822f94 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Thu, 8 Jan 2009 11:10:06 +0200
Subject: [PATCH] w35und: convert code to use ETH_ALEN

As suggested by Harvey Harrison, convert driver to use ETH_ALEN and kill a
private macro from common.h that is used for the same thing.

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/common.h  |    1 -
 drivers/staging/winbond/reg.c     |    5 ++---
 drivers/staging/winbond/wb35reg.c |    2 +-
 drivers/staging/winbond/wbhal.c   |    2 +-
 drivers/staging/winbond/wbhal_s.h |    6 +++---
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/common.h b/drivers/staging/winbond/common.h
index c4d9604..61ccc86 100644
--- a/drivers/staging/winbond/common.h
+++ b/drivers/staging/winbond/common.h
@@ -16,7 +16,6 @@
 // Common function definition
 //==================================================================================================
 #define DEBUG_ENABLED
-#define ETH_LENGTH_OF_ADDRESS	6
 #ifdef DEBUG_ENABLED
 #define WBDEBUG( _M )	printk _M
 #else
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index c365c5d..ed08e00 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -948,14 +948,13 @@ Uxx_ReadEthernetAddress(  phw_data_t pHwData )
 //  Return Value:
 //    None.
 //==============================================================================================================
-void CardGetMulticastBit(   u8 Address[ETH_LENGTH_OF_ADDRESS],
-						   u8 *Byte,  u8 *Value )
+void CardGetMulticastBit( u8 Address[ETH_ALEN], u8 *Byte, u8 *Value )
 {
     u32 Crc;
     u32 BitNumber;
 
     // First compute the CRC.
-    Crc = CardComputeCrc(Address, ETH_LENGTH_OF_ADDRESS);
+    Crc = CardComputeCrc(Address, ETH_ALEN);
 
 	// The computed CRC is bit0~31 from left to right
 	//At first we should do right shift 25bits, and read 7bits by using '&', 2^7=128
diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index c74b3fd..87c2c43 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -599,7 +599,7 @@ unsigned char Wb35Reg_initial(phw_data_t pHwData)
 	Wb35Reg_ReadSync( pHwData, 0x03b4, &Region_ScanInterval );
 
 	// Update Ethernet address
-	memcpy( pHwData->CurrentMacAddress, pHwData->PermanentMacAddress, ETH_LENGTH_OF_ADDRESS );
+	memcpy( pHwData->CurrentMacAddress, pHwData->PermanentMacAddress, ETH_ALEN );
 
 	// Update software variable
 	pHwData->SoftwareSet = (u16)(SoftwareSet & 0xffff);
diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index d7bbb9a..a2cc077 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -8,7 +8,7 @@ void hal_set_ethernet_address( phw_data_t pHwData, u8 *current_address )
 
 	if( pHwData->SurpriseRemove ) return;
 
-	memcpy( pHwData->CurrentMacAddress, current_address, ETH_LENGTH_OF_ADDRESS );
+	memcpy( pHwData->CurrentMacAddress, current_address, ETH_ALEN );
 
 	ltmp[0]= cpu_to_le32( *(u32 *)pHwData->CurrentMacAddress );
 	ltmp[1]= cpu_to_le32( *(u32 *)(pHwData->CurrentMacAddress + 4) ) & 0xffff;
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 276d2b1..9353ac2 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -2,6 +2,7 @@
 #define __WINBOND_WBHAL_S_H
 
 #include <linux/types.h>
+#include <linux/if_ether.h> /* for ETH_ALEN */
 
 #include "common.h"
 
@@ -427,7 +428,6 @@ typedef struct _TXVGA_FOR_50 {
 #include "wb35tx_s.h"
 #include "wb35rx_s.h"
 
-
 // For Hal using ==================================================================
 typedef struct _HW_DATA_T
 {
@@ -452,8 +452,8 @@ typedef struct _HW_DATA_T
 	//===============================================
 	// Definition for MAC address
 	//===============================================
-	u8		PermanentMacAddress[ETH_LENGTH_OF_ADDRESS + 2]; // The Enthernet addr that are stored in EEPROM.  + 2 to 8-byte alignment
-	u8		CurrentMacAddress[ETH_LENGTH_OF_ADDRESS + 2]; // The Enthernet addr that are in used.  + 2 to 8-byte alignment
+	u8		PermanentMacAddress[ETH_ALEN + 2]; // The Enthernet addr that are stored in EEPROM.  + 2 to 8-byte alignment
+	u8		CurrentMacAddress[ETH_ALEN + 2]; // The Enthernet addr that are in used.  + 2 to 8-byte alignment
 
 	//=====================================================================
 	// Definition for 802.11
-- 
1.5.4.3



