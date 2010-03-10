Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab0CJWKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:10:04 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47759 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785Ab0CJWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:10:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=AK8lpHTeP/1oemA6ES8fdIq1qN35IlA20GOxSCJCLg6tSt7id1HGkw4Ne37JdctG6K
         lLQ+wQwUaU8ZTH0ZeAmOxvLtioE0gEF09jRlJWq4gsCXrimsJPbzn1d2w0fs5n+EXTbQ
         oftHmso/rXi9xy5waF1s4ed7JYqJxwx4Sy2D4=
Subject: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT
 entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 23:09:54 +0100
Message-ID: <1268258994.2183.14.camel@carter>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The commit 5877960869333e42ebeb733e8d9d5630ff96d350 (included since 2.6.32.4) crashes (locks up) the 82915G/GV/910GL Controller when intel-agp.c tries to access nonexistent GTT entries at:

-		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
+		for (i = intel_private.gtt_entries; i < intel_private.gtt_total_size; i++) {

Rationale: I915 (gma900) has 128 MB of video memory (maximum), as per intel.com ( http://www.intel.com/support/graphics/intel915g/sb/CS-012579.htm ) and lscpi:

00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL Integrated Graphics Controller (rev 04) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation Device 4147
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at ff480000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ec00 [size=8]
        Region 2: Memory at d8000000 (32-bit, prefetchable) [size=128M]
        Region 3: Memory at ff440000 (32-bit, non-prefetchable) [size=256K]
        Capabilities: <access denied>


AFAIK, that implies that its gtt_total_size (in pages) should be 32K (as num_entries showed before the commit) instead of 64K.

Note: The IS_I915 macro includes 945; however, only GMA900 (I915) had 128 MB as the maximum AFAIK. Therefore, I divided the IS_I915 macro. I do not know about the "E7221" (please check).

How to reproduce: Access kernel.org in iceweasel (Debian Lenny) and the X server will crash. Sometimes, the kernel freezes.
 
Please review. The fix should be applied to stable series, as well as 2.6.33 and 2.6.34-rc1.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
--- linux-2.6.32.stable/drivers/char/agp/intel-agp.c.old	2010-03-10 15:32:36.000000000 +0100
+++ linux-2.6.32.stable/drivers/char/agp/intel-agp.c	2010-03-10 22:38:23.000000000 +0100
@@ -65,11 +65,11 @@
 #define PCI_DEVICE_ID_INTEL_IGDNG_MC2_HB    0x006a
 #define PCI_DEVICE_ID_INTEL_IGDNG_M_IG	    0x0046
 
-/* cover 915 and 945 variants */
 #define IS_I915 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_E7221_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB || \
-		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB || \
-		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB || \
+		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB)
+
+#define IS_I945 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB)
 
@@ -724,14 +724,14 @@ static void intel_i830_init_gtt_entries(
 			break;
 		case I915_GMCH_GMS_STOLEN_48M:
 			/* Check it's really I915G */
-			if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
+			if (IS_I915 || IS_I945 || IS_I965 || IS_G33 || IS_G4X)
 				gtt_entries = MB(48) - KB(size);
 			else
 				gtt_entries = 0;
 			break;
 		case I915_GMCH_GMS_STOLEN_64M:
 			/* Check it's really I915G */
-			if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
+			if (IS_I915 || IS_I945 || IS_I965 || IS_G33 || IS_G4X)
 				gtt_entries = MB(64) - KB(size);
 			else
 				gtt_entries = 0;
@@ -1305,6 +1305,8 @@ static int intel_i915_create_gatt_table(
 
 	if (IS_G33)
 	    gtt_map_size = 1024 * 1024; /* 1M on G33 */
+	else if (IS_I915)
+	    gtt_map_size = 128 * 1024; /* 128K on I915 */
 	intel_private.gtt = ioremap(temp2, gtt_map_size);
 	if (!intel_private.gtt)
 		return -ENOMEM;


