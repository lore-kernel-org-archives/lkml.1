Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155Ab0AHIC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0AHIC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037Ab0AHIBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:01:36 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54978 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0AHIBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:01:34 -0500
Message-Id: <20100108075921.128458726@vergenet.net>
User-Agent: quilt/0.48-1
Date: Fri, 08 Jan 2010 18:57:52 +1100
From: horms@vergenet.net
Subject: [patch 4/6] otus: Fix ZM_SEQ_DEBUG macro for no-debug case
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Peter Huewe <PeterHuewe@gmx.de>
References: <20100108075748.059645106@vergenet.net>
Content-Disposition: inline; filename=otus-no-effect.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tcp_seq is only initialised in case where ZM_ENABLE_PERFORMANCE_EVALUATION
is defined. So move the call to ZM_SEQ_DEBUG() and the decleration of
tcp_seq in there too.  This allows ZM_SEQ_DEBUG() to be removed from the
non-ZM_ENABLE_PERFORMANCE_EVALUATION case in the header file.

This resolves several compile warnings for the
non-ZM_ENABLE_PERFORMANCE_EVALUATION case.
However, the ZM_ENABLE_PERFORMANCE_EVALUATION
case seems to be completely broken.

$ gcc (Debian 4.4.2-8) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make
...
drivers/staging/otus/80211core/cagg.c: In function 'zfAggRxEnabled':
drivers/staging/otus/80211core/cagg.c:1872: warning: left-hand operand of
comma expression has no effect
drivers/staging/otus/80211core/cagg.c:1872: warning: left-hand operand of
comma expression has no effect
drivers/staging/otus/80211core/cagg.c:1872: warning: statement with no
effect
...

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/staging/otus/80211core/pub_zfi.h
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/pub_zfi.h	2010-01-08 17:36:50.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/pub_zfi.h	2010-01-08 17:39:03.000000000 +1100
@@ -814,7 +814,6 @@ extern void zfiRxPerformanceReg(zdev_t* 
 #define ZM_PERFORMANCE_RX_AMSDU(dev, buf, len)
 #define ZM_PERFORMANCE_RX_FLUSH(dev)
 #define ZM_PERFORMANCE_RX_CLEAR(dev)
-#define ZM_SEQ_DEBUG
 #define ZM_PERFORMANCE_RX_REORDER(dev)
 #endif
 /***** End of section 3 *****/
Index: linux-2.6/drivers/staging/otus/80211core/cagg.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/cagg.c	2010-01-08 17:38:36.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/cagg.c	2010-01-08 17:38:46.000000000 +1100
@@ -1838,7 +1838,6 @@ struct agg_tid_rx* zfAggRxEnabled(zdev_t
     u16_t frameType;
     u16_t frameCtrl;
     u16_t frameSubtype;
-    u32_t tcp_seq;
     //struct aggSta *agg_sta;
 #if ZM_AGG_FPGA_REORDERING
     struct agg_tid_rx *tid_rx;
@@ -1863,13 +1862,17 @@ struct agg_tid_rx* zfAggRxEnabled(zdev_t
         return NULL;
     }
 #ifdef ZM_ENABLE_PERFORMANCE_EVALUATION
-    tcp_seq = zmw_rx_buf_readb(dev, buf, 22+36) << 24;
-    tcp_seq += zmw_rx_buf_readb(dev, buf, 22+37) << 16;
-    tcp_seq += zmw_rx_buf_readb(dev, buf, 22+38) << 8;
-    tcp_seq += zmw_rx_buf_readb(dev, buf, 22+39);
+    {
+        u32_t tcp_seq;
+
+        tcp_seq = zmw_rx_buf_readb(dev, buf, 22+36) << 24;
+        tcp_seq += zmw_rx_buf_readb(dev, buf, 22+37) << 16;
+        tcp_seq += zmw_rx_buf_readb(dev, buf, 22+38) << 8;
+        tcp_seq += zmw_rx_buf_readb(dev, buf, 22+39);
+        ZM_SEQ_DEBUG("In                   %5d, %12u\n", seq_no, tcp_seq);
+    }
 #endif
 
-    ZM_SEQ_DEBUG("In                   %5d, %12u\n", seq_no, tcp_seq);
     dst0 = zmw_rx_buf_readh(dev, buf, offset+4);
 
     src[0] = zmw_rx_buf_readh(dev, buf, offset+10);

