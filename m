Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbYEHKWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbYEHKWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbYEHKWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:22:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32772
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754790AbYEHKWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:22:45 -0400
Date: Thu, 08 May 2008 03:22:38 -0700 (PDT)
Message-Id: <20080508.032238.23875845.davem@davemloft.net>
To: benh@kernel.crashing.org
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH]: radeon: Misc corrections.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a new PCI-E radeon RV380 series card (PCI device ID 5b64) that
hangs in my sparc64 boxes when the init scripts set the font.  The
problem goes away if I disable acceleration.

I haven't figured out that bug yet, but along the way
I found some corrections to make based upon some auditing.

1) The RB2D_DC_FLUSH_ALL value used by the kernel fb driver
   and the XORG video driver differ.  I've made the kernel
   match what XORG is using.

2) In radeonfb_engine_reset() we have top-level code structure
   that roughly looks like:

	if (family is 300, 350, or V350)
		do this;
	else
		do that;
	...
	if (family is NOT 300, OR
	    family is NOT 350, OR
	    family is NOT V350)
		do another thing;

   this last conditional makes no sense, is always true,
   and obviously was likely meant to be "family is NOT
   300, 350, or V350".  So I've made the code match the
   intent.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/video/aty/radeon_accel.c b/drivers/video/aty/radeon_accel.c
index 3ca27cb..4d13f68 100644
--- a/drivers/video/aty/radeon_accel.c
+++ b/drivers/video/aty/radeon_accel.c
@@ -241,8 +241,8 @@ void radeonfb_engine_reset(struct radeonfb_info *rinfo)
 	INREG(HOST_PATH_CNTL);
 	OUTREG(HOST_PATH_CNTL, host_path_cntl);
 
-	if (rinfo->family != CHIP_FAMILY_R300 ||
-	    rinfo->family != CHIP_FAMILY_R350 ||
+	if (rinfo->family != CHIP_FAMILY_R300 &&
+	    rinfo->family != CHIP_FAMILY_R350 &&
 	    rinfo->family != CHIP_FAMILY_RV350)
 		OUTREG(RBBM_SOFT_RESET, rbbm_soft_reset);
 
diff --git a/include/video/radeon.h b/include/video/radeon.h
index 83467e1..95a1f20 100644
--- a/include/video/radeon.h
+++ b/include/video/radeon.h
@@ -527,8 +527,9 @@
 
 
 /* DSTCACHE_CTLSTAT bit constants */
-#define RB2D_DC_FLUSH				   (3 << 0)
-#define RB2D_DC_FLUSH_ALL			   0xf
+#define RB2D_DC_FLUSH_2D			   (1 << 0)
+#define RB2D_DC_FREE_2D				   (1 << 2)
+#define RB2D_DC_FLUSH_ALL			   (RB2D_DC_FLUSH_2D | RB2D_DC_FREE_2D)
 #define RB2D_DC_BUSY				   (1 << 31)
 
 
