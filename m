Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYJ2SLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYJ2SLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbYJ2SLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:11:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbYJ2SLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:11:32 -0400
Date: Wed, 29 Oct 2008 20:10:55 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] w35und: remove memcpy/memcmp wrappers
Message-ID: <Pine.LNX.4.64.0810292010330.16596@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The OS_MEMORY_CLEAR macro is not used so remove it. Also convert the one
call-site that uses OS_MEMORY_COMPARE to use memcmp() directly and remove the
wrapper macro.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/linux/common.h |    3 ---
 drivers/staging/winbond/wblinux.c      |    9 ++++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/linux/common.h b/drivers/staging/winbond/linux/common.h
index 925e1b6..046dab6 100644
--- a/drivers/staging/winbond/linux/common.h
+++ b/drivers/staging/winbond/linux/common.h
@@ -73,8 +73,5 @@
 #define OS_EVENT_INDICATE( _A, _B, _F )
 #define OS_PMKID_STATUS_EVENT( _A )
 
-#define OS_MEMORY_CLEAR( _A, _S )	memset( (u8 *)_A,0,_S)
-#define OS_MEMORY_COMPARE( _A, _B, _S )	(memcmp(_A,_B,_S)? 0 : 1) // Definition is reverse with Ndis 1: the same 0: different
-
 #endif // COMMON_DEF
 
diff --git a/drivers/staging/winbond/wblinux.c b/drivers/staging/winbond/wblinux.c
index 665d8e0..e43070e 100644
--- a/drivers/staging/winbond/wblinux.c
+++ b/drivers/staging/winbond/wblinux.c
@@ -181,12 +181,11 @@ WbWLanInitialize(struct wb35_adapter * adapter)
 	pMacAddr = adapter->sLocalPara.ThisMacAddress;
 	pMacAddr2 = adapter->sLocalPara.PermanentAddress;
 	hal_get_permanent_address( pHwData, adapter->sLocalPara.PermanentAddress );// Reading ethernet address from EEPROM
-	if (OS_MEMORY_COMPARE(pMacAddr, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH )) // Is equal
-	{
-		memcpy( pMacAddr, pMacAddr2, MAC_ADDR_LENGTH );
-	} else {
+	if (memcmp(pMacAddr, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH) == 0)
+		memcpy(pMacAddr, pMacAddr2, MAC_ADDR_LENGTH);
+	else {
 		// Set the user define MAC address
-		hal_set_ethernet_address( pHwData, adapter->sLocalPara.ThisMacAddress );
+		hal_set_ethernet_address(pHwData, adapter->sLocalPara.ThisMacAddress);
 	}
 
 	//get current antenna
-- 
1.5.3.7

