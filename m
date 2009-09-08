Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbZIHKP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbZIHKP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZIHKP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:15:59 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:56869 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbZIHKP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:15:58 -0400
X-Greylist: delayed 1631 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2009 06:15:58 EDT
From: =?utf-8?q?Luk=C3=A1=C5=A1_Karas?= <lukas.karas@centrum.cz>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix saa7134-input.c for IR controller over i2c
Date: Tue, 8 Sep 2009 11:48:23 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc6muj11; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909081148.23791.lukas.karas@centrum.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All, 
I have DVB card with IR controller connected over i2c bus (this card is 
supported by module saa7134). This IR controller work mostly fine, bud when I 
execute 
rmmod ir-kbd-i2c and modprobe ir-kbd-i2c again, IR controller stops working.
I found problem in aa7134-input.c, metod saa7134_probe_i2c_ir. 

Please, see this:

struct IR_i2c_init_data init_data; // inicialize init_data as local variable
...
info.platform_data = &init_data; // put pointer to local variable to 
		// platform_data
...
i2c_new_device(&dev->i2c_adap, &info); // publish this for other modules
...
} // end of function, so kernel can use memory used for local variable again

Here is my patch for fix this problem:

Signed-off-by: Lukas Karas <lukas.karas@centrum.cz>
--- ./video.2b49813f8482/saa7134/saa7134-input.c	2009-09-03 12:06:34.000000000 
+0200
+++ video/saa7134/saa7134-input.c	2009-09-07 00:51:46.000000000 +0200
@@ -742,7 +808,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	struct i2c_board_info info;
-	struct IR_i2c_init_data init_data;
+	struct IR_i2c_init_data *init_data;
 	const unsigned short addr_list[] = {
 		0x7a, 0x47, 0x71, 0x2d,
 		I2C_CLIENT_END
@@ -770,7 +836,8 @@ void saa7134_probe_i2c_ir(struct saa7134

 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	memset(&init_data, 0, sizeof(struct IR_i2c_init_data));
+	init_data = kzalloc(sizeof(struct IR_i2c_init_data), GFP_KERNEL);
 	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);

 #endif
@@ -780,15 +847,15 @@ void saa7134_probe_i2c_ir(struct saa7134
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
 		snprintf(ir->c.name, sizeof(ir->c.name), "Pinnacle PCTV");
 #else
-		init_data.name = "Pinnacle PCTV";
+		init_data->name = "Pinnacle PCTV";
 #endif
 		if (pinnacle_remote == 0) {
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
 			ir->get_key   = get_key_pinnacle_color;
 			ir->ir_codes = &ir_codes_pinnacle_color_table;
 #else
-			init_data.get_key = get_key_pinnacle_color;
-			init_data.ir_codes = &ir_codes_pinnacle_color_table;
+			init_data->get_key = get_key_pinnacle_color;
+			init_data->ir_codes = &ir_codes_pinnacle_color_table;
 			info.addr = 0x47;
 #endif
 		} else {
@@ -796,8 +863,8 @@ void saa7134_probe_i2c_ir(struct saa7134
 			ir->get_key   = get_key_pinnacle_grey;
 			ir->ir_codes = &ir_codes_pinnacle_grey_table;
 #else
-			init_data.get_key = get_key_pinnacle_grey;
-			init_data.ir_codes = &ir_codes_pinnacle_grey_table;
+			init_data->get_key = get_key_pinnacle_grey;
+			init_data->ir_codes = &ir_codes_pinnacle_grey_table;
 			info.addr = 0x47;
 #endif
 		}
@@ -808,9 +875,9 @@ void saa7134_probe_i2c_ir(struct saa7134
 		ir->get_key   = get_key_purpletv;
 		ir->ir_codes  = &ir_codes_purpletv_table;
 #else
-		init_data.name = "Purple TV";
-		init_data.get_key = get_key_purpletv;
-		init_data.ir_codes = &ir_codes_purpletv_table;
+		init_data->name = "Purple TV";
+		init_data->get_key = get_key_purpletv;
+		init_data->ir_codes = &ir_codes_purpletv_table;
 #endif
 		break;
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
@@ -819,9 +886,9 @@ void saa7134_probe_i2c_ir(struct saa7134
 		ir->get_key  = get_key_msi_tvanywhere_plus;
 		ir->ir_codes = &ir_codes_msi_tvanywhere_plus_table;
 #else
-		init_data.name = "MSI TV@nywhere Plus";
-		init_data.get_key = get_key_msi_tvanywhere_plus;
-		init_data.ir_codes = &ir_codes_msi_tvanywhere_plus_table;
+		init_data->name = "MSI TV@nywhere Plus";
+		init_data->get_key = get_key_msi_tvanywhere_plus;
+		init_data->ir_codes = &ir_codes_msi_tvanywhere_plus_table;
 		info.addr = 0x30;
 		/* MSI TV@nywhere Plus controller doesn't seem to
 		   respond to probes unless we read something from
@@ -839,9 +906,9 @@ void saa7134_probe_i2c_ir(struct saa7134
 		ir->get_key   = get_key_hvr1110;
 		ir->ir_codes  = &ir_codes_hauppauge_new_table;
 #else
-		init_data.name = "HVR 1110";
-		init_data.get_key = get_key_hvr1110;
-		init_data.ir_codes = &ir_codes_hauppauge_new_table;
+		init_data->name = "HVR 1110";
+		init_data->get_key = get_key_hvr1110;
+		init_data->ir_codes = &ir_codes_hauppauge_new_table;
 #endif
 		break;
 	case SAA7134_BOARD_BEHOLD_607FM_MK3:
@@ -862,9 +929,21 @@ void saa7134_probe_i2c_ir(struct saa7134
 		ir->get_key   = get_key_beholdm6xx;
 		ir->ir_codes  = &ir_codes_behold_table;
 #else
-		init_data.name = "BeholdTV";
-		init_data.get_key = get_key_beholdm6xx;
-		init_data.ir_codes = &ir_codes_behold_table;
+		init_data->name = "BeholdTV";
+		init_data->get_key = get_key_beholdm6xx;
+		init_data->ir_codes = &ir_codes_behold_table;
 #endif
 		break;
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
@@ -879,8 +958,9 @@ void saa7134_probe_i2c_ir(struct saa7134
 	}

 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
-	if (init_data.name)
-		info.platform_data = &init_data;
+	if (init_data->name)
+		info.platform_data = init_data;
 	/* No need to probe if address is known */
 	if (info.addr) {
 		i2c_new_device(&dev->i2c_adap, &info);
