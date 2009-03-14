Return-Path: <linux-kernel-owner+w=401wt.eu-S932236AbZCNBwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbZCNBwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZCNBVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:42 -0400
Received: from kroah.org ([198.145.64.141]:35623 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754864AbZCNBVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:44 2009
Message-Id: <20090314011044.265489107@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Martin Dauskardt <martin.dauskardt@gmx.de>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 087/114] V4L: saa7127: fix broken S-Video with saa7129
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=0003-V4L-saa7127-fix-broken-S-Video-with-saa7129.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Dauskardt <martin.dauskardt@gmx.de>

(backported from commit 0f3559ef17362a7dd5017521a4dd4cad31263395)

Register 0x2d has to be set differently in the saa7129 compared to the
saa7127. This was not done correctly, so S-Video was broken in certain
circumstances.

This fixes a regression introduced in 2.6.28.

Signed-off-by: Martin Dauskardt <martin.dauskardt@gmx.de>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/saa7127.c |   52 ++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

--- a/drivers/media/video/saa7127.c
+++ b/drivers/media/video/saa7127.c
@@ -149,7 +149,7 @@ static const struct i2c_reg_value saa712
 	{ SAA7127_REG_COPYGEN_0, 			0x77 },
 	{ SAA7127_REG_COPYGEN_1, 			0x41 },
 	{ SAA7127_REG_COPYGEN_2, 			0x00 },	/* Macrovision enable/disable */
-	{ SAA7127_REG_OUTPUT_PORT_CONTROL, 		0x9e },
+	{ SAA7127_REG_OUTPUT_PORT_CONTROL, 		0xbf },
 	{ SAA7127_REG_GAIN_LUMINANCE_RGB, 		0x00 },
 	{ SAA7127_REG_GAIN_COLORDIFF_RGB, 		0x00 },
 	{ SAA7127_REG_INPUT_PORT_CONTROL_1, 		0x80 },	/* for color bars */
@@ -479,12 +479,18 @@ static int saa7127_set_output_type(struc
 		break;
 
 	case SAA7127_OUTPUT_TYPE_COMPOSITE:
-		state->reg_2d = 0x08;	/* 00001000 CVBS only, RGB DAC's off (high impedance mode) */
+		if (state->ident == V4L2_IDENT_SAA7129)
+			state->reg_2d = 0x20;	/* CVBS only */
+		else
+			state->reg_2d = 0x08;	/* 00001000 CVBS only, RGB DAC's off (high impedance mode) */
 		state->reg_3a = 0x13;	/* by default switch YUV to RGB-matrix on */
 		break;
 
 	case SAA7127_OUTPUT_TYPE_SVIDEO:
-		state->reg_2d = 0xff;	/* 11111111  croma -> R, luma -> CVBS + G + B */
+		if (state->ident == V4L2_IDENT_SAA7129)
+			state->reg_2d = 0x18;	/* Y + C */
+		else
+			state->reg_2d = 0xff;   /*11111111  croma -> R, luma -> CVBS + G + B */
 		state->reg_3a = 0x13;	/* by default switch YUV to RGB-matrix on */
 		break;
 
@@ -499,7 +505,10 @@ static int saa7127_set_output_type(struc
 		break;
 
 	case SAA7127_OUTPUT_TYPE_BOTH:
-		state->reg_2d = 0xbf;
+		if (state->ident == V4L2_IDENT_SAA7129)
+			state->reg_2d = 0x38;
+		else
+			state->reg_2d = 0xbf;
 		state->reg_3a = 0x13;	/* by default switch YUV to RGB-matrix on */
 		break;
 
@@ -691,24 +700,6 @@ static int saa7127_probe(struct i2c_clie
 
 	i2c_set_clientdata(client, state);
 
-	/* Configure Encoder */
-
-	v4l_dbg(1, debug, client, "Configuring encoder\n");
-	saa7127_write_inittab(client, saa7127_init_config_common);
-	saa7127_set_std(client, V4L2_STD_NTSC);
-	saa7127_set_output_type(client, SAA7127_OUTPUT_TYPE_BOTH);
-	saa7127_set_vps(client, &vbi);
-	saa7127_set_wss(client, &vbi);
-	saa7127_set_cc(client, &vbi);
-	saa7127_set_xds(client, &vbi);
-	if (test_image == 1)
-		/* The Encoder has an internal Colorbar generator */
-		/* This can be used for debugging */
-		saa7127_set_input_type(client, SAA7127_INPUT_TYPE_TEST_IMAGE);
-	else
-		saa7127_set_input_type(client, SAA7127_INPUT_TYPE_NORMAL);
-	saa7127_set_video_enable(client, 1);
-
 	if (id->driver_data) {	/* Chip type is already known */
 		state->ident = id->driver_data;
 	} else {		/* Needs detection */
@@ -730,6 +721,23 @@ static int saa7127_probe(struct i2c_clie
 
 	v4l_info(client, "%s found @ 0x%x (%s)\n", client->name,
 			client->addr << 1, client->adapter->name);
+
+	v4l_dbg(1, debug, client, "Configuring encoder\n");
+	saa7127_write_inittab(client, saa7127_init_config_common);
+	saa7127_set_std(client, V4L2_STD_NTSC);
+	saa7127_set_output_type(client, SAA7127_OUTPUT_TYPE_BOTH);
+	saa7127_set_vps(client, &vbi);
+	saa7127_set_wss(client, &vbi);
+	saa7127_set_cc(client, &vbi);
+	saa7127_set_xds(client, &vbi);
+	if (test_image == 1)
+		/* The Encoder has an internal Colorbar generator */
+		/* This can be used for debugging */
+		saa7127_set_input_type(client, SAA7127_INPUT_TYPE_TEST_IMAGE);
+	else
+		saa7127_set_input_type(client, SAA7127_INPUT_TYPE_NORMAL);
+	saa7127_set_video_enable(client, 1);
+
 	if (state->ident == V4L2_IDENT_SAA7129)
 		saa7127_write_inittab(client, saa7129_init_config_extra);
 	return 0;


