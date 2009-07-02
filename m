Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZGBTLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZGBTLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZGBTLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:11:12 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:47266 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbZGBTLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mh+Ms7szc+ymAhubaG+JTl6QZRKuTJQrfyLDehAtAJhDWamFGCklC5W2uw5kocKmg2
         3mcBIUgz97ZMFZOLt2jZBPBD2ZN3jipjKbJeQPAVvGFAGo1XJpT+gZmSLyZZ3ZcKw/wF
         sUOBhfN65VW7TGQoY+YB54Dl6bqSCu8ttuG/k=
MIME-Version: 1.0
Date: Thu, 2 Jul 2009 21:11:12 +0200
Message-ID: <13efd05e0907021211m1f21d113g97379ab07179fb6d@mail.gmail.com>
Subject: [PATCH] Add support for WinFast DTV2000H rev. J
From: Vlastimil Labsky <vlasta.labsky@gmail.com>
To: kraxel@bytesex.org
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I updated and simplyfied patch from Zbynek Hrabovsky for recent
kernel. It enables autodetection of card, sound in analog TV , sound
in FM radio and switching between antenna and cable RF input. Radio
tuner still doesn't work, I don't even know how it works. Some guys
wrote me that FM radio works with TV tuner used instead of radio part
(symlink video0 -> radio0).

Signed-off-by: Vlastimil Labsky <vlasta.labsky@gmail.com>

--- a/drivers/media/video/cx88/cx88-cards.c	2009-06-10 05:05:27.000000000 +0200
+++ b/drivers/media/video/cx88/cx88-cards.c	2002-01-02 22:35:26.000000000 +0100
@@ -1283,6 +1283,51 @@ static const struct cx88_board cx88_boar
 		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_WINFAST_DTV2000H_J] = {
+		.name           = "WinFast DTV2000 H rev. J",
+		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.input          = {{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00017300,
+			.gpio1  = 0x00008207,
+			.gpio2	= 0x00000000,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00018300,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		}},
+		.radio = {
+			 .type  = CX88_RADIO,
+			 .gpio0 = 0x00015702,
+			 .gpio1 = 0x0000f207,
+			 .gpio2 = 0x00015702,
+			 .gpio3 = 0x02000000,
+		},
+		.mpeg           = CX88_MPEG_DVB,
+	},
 	[CX88_BOARD_GENIATECH_DVBS] = {
 		.name          = "Geniatech DVB-S",
 		.tuner_type    = TUNER_ABSENT,
@@ -2222,6 +2267,10 @@ static const struct cx88_subid cx88_subi
 		.subdevice = 0x665e,
 		.card      = CX88_BOARD_WINFAST_DTV2000H,
 	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6f2b,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_J,
+	},{
 		.subvendor = 0x18ac,
 		.subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
--- a/drivers/media/video/cx88/cx88-dvb.c	2009-06-10 05:05:27.000000000 +0200
+++ b/drivers/media/video/cx88/cx88-dvb.c	2002-01-02 22:36:10.000000000 +0100
@@ -695,6 +695,7 @@ static int dvb_register(struct cx8802_de
 		}
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_J:
 	case CX88_BOARD_HAUPPAUGE_HVR1100:
 	case CX88_BOARD_HAUPPAUGE_HVR1100LP:
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
--- a/drivers/media/video/cx88/cx88-input.c	2009-06-10 05:05:27.000000000 +0200
+++ b/drivers/media/video/cx88/cx88-input.c	2002-01-02 22:36:57.000000000 +0100
@@ -222,6 +222,7 @@ int cx88_ir_init(struct cx88_core *core,
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_J:
 		ir_codes = ir_codes_winfast;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
--- a/drivers/media/video/cx88/cx88.h	2009-06-10 05:05:27.000000000 +0200
+++ b/drivers/media/video/cx88/cx88.h	2002-01-02 22:37:56.000000000 +0100
@@ -232,6 +232,7 @@ extern struct sram_channel cx88_sram_cha
 #define CX88_BOARD_TBS_8910                77
 #define CX88_BOARD_PROF_6200               78
 #define CX88_BOARD_TERRATEC_CINERGY_HT_PCI_MKII 79
+#define CX88_BOARD_WINFAST_DTV2000H_J        80

 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
