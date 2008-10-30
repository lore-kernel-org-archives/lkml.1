Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYJ3QMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYJ3QMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbYJ3QLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:11:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:63968 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbYJ3QLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=VheMmzd3YUfgwZkSLfnL5+u9uxfagWqDdHFbrYB865ncXgFnlRzsN/hrG27TJZKr1i
         /FfzffeGQ6JjbYUWq+n180wdK+5e4F8vwGpuKOWuzakYg/0pZW8WxNyxHYF8i7YrrdD+
         /NzTIGOO2ijUWuzeWuS/nai5yu919rfV1m/4g=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 6/7] w35und: remove ->skb_array from struct wbsoft_priv
Date: Thu, 30 Oct 2008 18:12:06 +0200
Message-Id: <1225383127-16406-6-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1225383127-16406-5-git-send-email-penberg@cs.helsinki.fi>
References: <>
 <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-4-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-5-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not actually used for anything, so remove it.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/core.h    |    3 ---
 drivers/staging/winbond/wblinux.c |   16 ----------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index c6dd223..9c9d5d2 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -31,10 +31,7 @@ struct wbsoft_priv {
 	u32 RxByteCount;
 	u32 TxByteCount;
 
-	struct sk_buff *skb_array[WBLINUX_PACKET_ARRAY_SIZE];
 	struct sk_buff *packet_return;
-	s32 skb_SetIndex;
-	s32 skb_GetIndex;
 	s32 netif_state_stop;	// 1: stop  0: normal
 	struct iw_statistics iw_stats;
 
diff --git a/drivers/staging/winbond/wblinux.c b/drivers/staging/winbond/wblinux.c
index 433aa0d..0461516 100644
--- a/drivers/staging/winbond/wblinux.c
+++ b/drivers/staging/winbond/wblinux.c
@@ -19,25 +19,9 @@
 void
 WBLINUX_stop(  struct wbsoft_priv * adapter )
 {
-	struct sk_buff *pSkb;
-
 	if (atomic_inc_return(&adapter->ThreadCount) == 1) {
 		// Shutdown module immediately
 		adapter->shutdown = 1;
-
-		while (adapter->skb_array[ adapter->skb_GetIndex ]) {
-			// Trying to free the un-sending packet
-			pSkb = adapter->skb_array[ adapter->skb_GetIndex ];
-			adapter->skb_array[ adapter->skb_GetIndex ] = NULL;
-			if( in_irq() )
-				dev_kfree_skb_irq( pSkb );
-			else
-				dev_kfree_skb( pSkb );
-
-			adapter->skb_GetIndex++;
-			adapter->skb_GetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
-		}
-
 #ifdef _PE_STATE_DUMP_
 		WBDEBUG(( "[w35und] SKB_RELEASE OK\n" ));
 #endif
-- 
1.5.3.7

