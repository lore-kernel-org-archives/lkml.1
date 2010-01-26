Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744Ab0A0AEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0A0AEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113Ab0A0ADt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:03:49 -0500
Received: from kroah.org ([198.145.64.141]:35138 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab0AZXnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:23 2010
Message-Id: <20100126233923.224478017@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Danny Wood <danwood76@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [18/98] V4L/DVB (13168): Add support for Asus Europa Hybrid DVB-T card (SAA7134 SubVendor ID: 0x1043 Device ID: 0x4847)
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Danny Wood <danwood76@gmail.com>

commit e3c6e1aaa5db7822524f5b1355960fd732910068 upstream.

Adds the device IDs and driver linking to allow the Asus Europa DVB-T
card to operate with these drivers.
The device has a SAA7134 chipset with a TD1316 Hybrid Tuner.
All inputs work on the card including switching between DVB-T and
Analogue TV, there is also no IR with this card.

[mchehab@redhat.com: CodingStyle fixes]

Signed-off-by: Danny Wood <danwood76@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/video4linux/CARDLIST.saa7134  |    1 
 drivers/media/video/saa7134/saa7134-cards.c |   31 ++++++++++++++++++++++++++++
 drivers/media/video/saa7134/saa7134-dvb.c   |    1 
 drivers/media/video/saa7134/saa7134.h       |    1 
 4 files changed, 34 insertions(+)

--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -172,3 +172,4 @@
 171 -> Beholder BeholdTV X7                     [5ace:7595]
 172 -> RoverMedia TV Link Pro FM                [19d1:0138]
 173 -> Zolid Hybrid TV Tuner PCI                [1131:2004]
+174 -> Asus Europa Hybrid OEM                   [1043:4847]
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5279,6 +5279,30 @@ struct saa7134_board saa7134_boards[] = 
 			.amux = TV,
 		},
 	},
+	[SAA7134_BOARD_ASUS_EUROPA_HYBRID] = {
+		.name           = "Asus Europa Hybrid OEM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TD1316,
+		.radio_type     = UNSET,
+		.tuner_addr	= 0x61,
+		.radio_addr	= ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs = { {
+			.name   = name_tv,
+			.vmux   = 3,
+			.amux   = TV,
+			.tv     = 1,
+		}, {
+			.name   = name_comp1,
+			.vmux   = 4,
+			.amux   = LINE2,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE2,
+		} },
+	},
 
 };
 
@@ -6418,6 +6442,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subdevice    = 0x2004,
 		.driver_data  = SAA7134_BOARD_ZOLID_HYBRID_PCI,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x1043,
+		.subdevice    = 0x4847,
+		.driver_data  = SAA7134_BOARD_ASUS_EUROPA_HYBRID,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7079,6 +7109,7 @@ int saa7134_board_init2(struct saa7134_d
 		/* break intentionally omitted */
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_ASUS_EUROPA2_HYBRID:
+	case SAA7134_BOARD_ASUS_EUROPA_HYBRID:
 	{
 
 		/* The Philips EUROPA based hybrid boards have the tuner
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -1116,6 +1116,7 @@ static int dvb_init(struct saa7134_dev *
 		break;
 	case SAA7134_BOARD_PHILIPS_EUROPA:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
+	case SAA7134_BOARD_ASUS_EUROPA_HYBRID:
 		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 					       &philips_europa_config,
 					       &dev->i2c_adap);
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -297,6 +297,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_X7             171
 #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
 #define SAA7134_BOARD_ZOLID_HYBRID_PCI		173
+#define SAA7134_BOARD_ASUS_EUROPA_HYBRID	174
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8


