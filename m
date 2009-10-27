Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZJ0Ay3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZJ0Ay3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbZJ0Ay3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:54:29 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:50541 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbZJ0Ay2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:54:28 -0400
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: KMS + i915 + modeset=1 fails to detect correct output on laptop, blank/black screen
Date: Tue, 27 Oct 2009 02:54:26 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910270254.26865.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I try to compile 2.6.32-rc5-git3 with enabled CONFIG_DRM_I915_KMS, but got 
black screen on boot. After short investigation, i notice that i915.modeset=0 
is fine for me.

Here is what i got with modeset=1
[    1.053570] [drm] Initialized drm 1.1.0 20060810
[    1.063552] [drm] set up 7M of stolen space
[    1.608955] [drm] TV-14: set mode NTSC 480i 0
[    1.758390] fb0: inteldrmfb frame buffer device
[    1.771866] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 
0

I did just short patch to test my idea, and it was right, wrong output was 
detected:

static enum drm_connector_status
intel_tv_detect(struct drm_connector *connector)
{
        struct drm_crtc *crtc;
        struct drm_display_mode mode;
        struct intel_output *intel_output = to_intel_output(connector);
        struct intel_tv_priv *tv_priv = intel_output->dev_priv;
        struct drm_encoder *encoder = &intel_output->enc;
        int dpms_mode;
        int type = tv_priv->type;

+       return connector_status_disconnected;
+

It works! So case is invalid detection of output device.
With patch it is:
[    0.620081] [drm] Initialized drm 1.1.0 20060810
[    0.632764] [drm] set up 7M of stolen space
[    0.879117] fb0: inteldrmfb frame buffer device
[    0.893140] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 
0

My hardware is:

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory 
Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 
Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated 
Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 
(rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface 
Controller (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE 
Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA 
AHCI Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 
03)
01:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg 
Wireless PCI Express Adapter (rev 01)
02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated 
Graphics Controller (rev 03)
        Subsystem: Hewlett-Packard Company Presario C700
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at d1100000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+


Manufacturer: Hewlett-Packard
Product Name: Compaq Presario A900 Notebook PC
Version: F.34

Let me know if you need more information. I can apply also patches to get 
additional information.
