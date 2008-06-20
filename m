Return-Path: <linux-kernel-owner+w=401wt.eu-S1759196AbYFTUTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196AbYFTUTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbYFTUQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:16:53 -0400
Received: from relay.netbox.cz ([83.240.0.201]:35608 "EHLO relay.netbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759594AbYFTUQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:16:51 -0400
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 16:16:51 EDT
Date: Fri, 20 Jun 2008 23:52:42 +0200
From: Zbynek Hrabovsky <hrabosh@t-email.cz>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com,
       "Nicolas Marot" <nicolas.marot@gmail.com>,
       nicolas <nicolas@nikoland.homelinux.org>,
       "Michel Lespinasse" <walken@zoy.org>
Subject: Re: [PATCH][RESEND] New type of DTV2000H TV Card
Message-Id: <20080620235242.e1e97f18.hrabosh@t-email.cz>
In-Reply-To: <20080613151843.240a62cb@gaivota>
References: <20080207002224.e26d6bb1.hrabosh@t-email.cz>
	<20080613151843.240a62cb@gaivota>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

thanks for your answer.

I've tried to apply the updated patch you've sent me and it is working, but ....

... there is a little problem with this:

--- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Fri Jun 13 15:07:34 2008 -0300
@@ -148,6 +148,12 @@
 			cx_write(TS_SOP_STAT, 0);
 			cx_write(TS_VALERR_CNTRL, 0);
 			udelay(100);
+			break;
+		case CX88_BOARD_WINFAST_DTV2000H_2:
+			/* switch signal input to antena */
+			cx_write(MO_GP0_IO, 0x00017300);
+
+			cx_write(TS_SOP_STAT, 0x00);
 			break;
 		default:
 			cx_write(TS_SOP_STAT, 0x00);


This piece of code used to switch the input of RF signal to "Air Antenna" mode. When I was writing the patch, this code was executed every time I was tunning DVB-T station. (using Kaffeine, or sth.) But now ( I don't know why ... ) this code is ran only if the station is succesfully tuned ... which is late for switching RF input. 

So ... all the things about sound in analog TV and video inputs, etc. are working well, but switching between Cable and Air Antenna RF inputs must be done using programs for analog TV ... such as TvTime for example. 

It would be nice, if this patch (and driver) would be able to switch RF inputs in DVB-T mode somehow. My idea is, to have two DVB-T devices ... one would use Air Antenna input as a source of signal, second the Cable input as source of signal. This will provide us to receive DVB-T from both inputs (BTW ... original Windows driver is not able to do this). The problem is, that I'm not sure if I'm able to do it ... I have very poor idea how all the things around this driver works ...for example which c. file I should focus on. If you would give me a small piece of advise, where to start, I would be pleased.

OK, I'm not sure if I understood what you meant by adding sign-off-by and reviewed-by line ... I hope I did what you want me to:


So .. thanks for your time,
Zbynek

Signed-off-by: Zbynek Hrabovsky <hrabosh@t-email.cz>

Reviewed-by: Zbynek Hrbaovsky <hrabosh@t-email.cz>

diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Fri Jun 13 15:07:33 2008 -0300
@@ -1284,7 +1284,7 @@
 	},
 	[CX88_BOARD_WINFAST_DTV2000H] = {
 		/* video inputs and radio still in testing */
-		.name           = "WinFast DTV2000 H",
+		.name           = "WinFast DTV2000 H ver. I (old)",
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
@@ -1298,6 +1298,45 @@
 			.gpio2  = 0x00017304,
 			.gpio3  = 0x02000000,
 		}},
+		.mpeg           = CX88_MPEG_DVB,
+	},
+	[CX88_BOARD_WINFAST_DTV2000H_2] = {
+		/* this is just a try */
+		.name           = "WinFast DTV2000 H ver. J (new)",
+		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.input          = { {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00017300,
+			.gpio1  = 0x00008207,
+			.gpio2	= 0x00000000,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00018300,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_GENIATECH_DVBS] = {
@@ -1963,6 +2002,10 @@
 		.subdevice = 0x665e,
 		.card      = CX88_BOARD_WINFAST_DTV2000H,
 	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6f2b,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_2,
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Fri Jun 13 15:07:34 2008 -0300
@@ -561,6 +561,7 @@
 		}
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_2:
 	case CX88_BOARD_HAUPPAUGE_HVR1100:
 	case CX88_BOARD_HAUPPAUGE_HVR1100LP:
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-input.c
--- a/linux/drivers/media/video/cx88/cx88-input.c	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-input.c	Fri Jun 13 15:07:34 2008 -0300
@@ -242,6 +242,7 @@
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_2:
 		ir_codes = ir_codes_winfast;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;

diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h	Fri Jun 13 15:07:34 2008 -0300
@@ -224,6 +224,7 @@
 #define CX88_BOARD_DVICO_FUSIONHDTV_7_GOLD 65
 #define CX88_BOARD_PROLINK_PV_8000GT       66
 #define CX88_BOARD_KWORLD_ATSC_120         67
+#define CX88_BOARD_WINFAST_DTV2000H_2      68
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,



