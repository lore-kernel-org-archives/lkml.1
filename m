Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYKJVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYKJVJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYKJVJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:09:10 -0500
Received: from ppp-111-12.adsl.restena.lu ([158.64.111.12]:45326 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752014AbYKJVJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:09:08 -0500
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2008 16:09:07 EST
Date: Mon, 10 Nov 2008 22:00:46 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, JosephChan@via.com.tw,
       <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
Message-ID: <20081110220046.10376327@neptune.home>
In-Reply-To: <20081109145959.6a8d9e8e.akpm@linux-foundation.org>
References: <20081109202537.33ead0a2@neptune.home>
	<20081109113603.d45361ad.akpm@linux-foundation.org>
	<20081109122515.1deb9ec2@infradead.org>
	<20081109213811.4b85adc6@neptune.home>
	<20081109125522.b5266352.akpm@linux-foundation.org>
	<20081109223748.3182e31d@neptune.home>
	<20081109145959.6a8d9e8e.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 November 2008 Andrew Morton wrote:
> > It show a nice candidate, viafb_ioctl in top-6:
> > 0xc011612b identity_mapped [vmlinux]:                   4096
> 
> erk!
> 
> > 0xc017896b do_sys_poll [vmlinux]:                       888
> > 0xc0178bdd do_sys_poll [vmlinux]:                       888
> > 0xc024506b sha256_transform [vmlinux]:                  752
> > 0xc024768b sha256_transform [vmlinux]:                  752
> > 0xc027d933 viafb_ioctl [vmlinux]:                       728
> > 0xc01783c8 do_select [vmlinux]:                         708
> > 0xc0178853 do_select [vmlinux]:                         708
> > 
> > 
> > On a new attempt the box survived fbset "1280x1024-60" though
> > I did wait some time after boot up before calling it.
> > So it's pretty probable that either it gets near the limit of stack
> > or this time the neighborhood of the stack was not just as
> > critical :/
> > 
> > Shall I trim down that function's stack usage as well?
> > (many structs allocated from stack)
> 
> Yes please.

I did a first attempt, based on suggested technique.
For viafb_ioctl() I did put all the structs in a single union (on stack)
and used the appropriate one depending on the cmd.
This saves 276 bytes out of 728 according to check_stack.pl

The most clean approach would probably be to split out the parts using
bigger structs into separate functions and allocating the required
memory from there.

I also switched viafb_cursor() to the struct technique.

See patch below for both.




During conversion of viafb_ioctl() I noticed the following:

Those two cases just copy_from_user and do nothing with copied data,
incomplete implementation?:
        case VIAFB_SET_PANEL_POSITION:
                if (copy_from_user(&u.panel_pos_size_para, argp,
                                   sizeof(u.panel_pos_size_para)))
                        return -EFAULT;
                break;
        case VIAFB_SET_PANEL_SIZE:
                if (copy_from_user(&u.panel_pos_size_para, argp,
                                   sizeof(u.panel_pos_size_para)))
                        return -EFAULT;
                break;

Handling of GET/SET GAMMA looks buggy:
In each case 256*4 bytes are allocated but only 4 bytes (size of pointer)
are copied to/from userspace though viafb_(get|set)_gamma_table() operates
on the full 256 elements...
        case VIAFB_SET_GAMMA_LUT:
                viafb_gamma_table = kmalloc(256 * sizeof(u32), GFP_KERNEL);
                if (!viafb_gamma_table)
                        return -ENOMEM;
                if (copy_from_user(viafb_gamma_table, argp,
                                sizeof(viafb_gamma_table))) {
                        kfree(viafb_gamma_table);
                        return -EFAULT;
                }
                viafb_set_gamma_table(viafb_bpp, viafb_gamma_table);
                kfree(viafb_gamma_table);
                break;

        case VIAFB_GET_GAMMA_LUT:
                viafb_gamma_table = kmalloc(256 * sizeof(u32), GFP_KERNEL);
                if (!viafb_gamma_table)
                        return -ENOMEM;
                viafb_get_gamma_table(viafb_gamma_table);
                if (copy_to_user(argp, viafb_gamma_table,
                        sizeof(viafb_gamma_table))) {
                        kfree(viafb_gamma_table);
                        return -EFAULT;
                }
                kfree(viafb_gamma_table);
                break;

I don't know if there is a userspace app that uses these VIA IOCTLs...
so the ioctl part is just compile-tested.
After checking, fbset just uses some generic framebuffer IOCTLs outside
of viafb's scope, thus not passing through viafb_ioctl().



---
--- linux-2.6.28-rc3/drivers/video/via/viafbdev.c.orig	2008-11-09 19:36:47.000000000 +0100
+++ linux-2.6.28-rc3/drivers/video/via/viafbdev.c	2008-11-10 20:50:32.000000000 +0100
@@ -546,23 +546,25 @@ static int viafb_blank(int blank_mode, s
 
 static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 {
-	struct viafb_ioctl_mode viamode;
-	struct viafb_ioctl_samm viasamm;
-	struct viafb_driver_version driver_version;
-	struct fb_var_screeninfo sec_var;
-	struct _panel_size_pos_info panel_pos_size_para;
+	union {
+		struct viafb_ioctl_mode viamode;
+		struct viafb_ioctl_samm viasamm;
+		struct viafb_driver_version driver_version;
+		struct fb_var_screeninfo sec_var;
+		struct _panel_size_pos_info panel_pos_size_para;
+		struct viafb_ioctl_setting viafb_setting;
+		struct device_t active_dev;
+	} u;
 	u32 state_info = 0;
-	u32 viainfo_size = sizeof(struct viafb_ioctl_info);
 	u32 *viafb_gamma_table;
 	char driver_name[] = "viafb";
 
 	u32 __user *argp = (u32 __user *) arg;
 	u32 gpu32;
 	u32 video_dev_info = 0;
-	struct viafb_ioctl_setting viafb_setting = {};
-	struct device_t active_dev = {};
 
 	DEBUG_MSG(KERN_INFO "viafb_ioctl: 0x%X !!\n", cmd);
+	memset(&u, 0, sizeof(u));
 
 	switch (cmd) {
 	case VIAFB_GET_CHIP_INFO:
@@ -571,7 +573,7 @@ static int viafb_ioctl(struct fb_info *i
 			return -EFAULT;
 		break;
 	case VIAFB_GET_INFO_SIZE:
-		return put_user(viainfo_size, argp);
+		return put_user((u32)sizeof(struct viafb_ioctl_info), argp);
 	case VIAFB_GET_INFO:
 		return viafb_ioctl_get_viafb_info(arg);
 	case VIAFB_HOTPLUG:
@@ -584,60 +586,60 @@ static int viafb_ioctl(struct fb_info *i
 		viafb_hotplug = (gpu32) ? 1 : 0;
 		break;
 	case VIAFB_GET_RESOLUTION:
-		viamode.xres = (u32) viafb_hotplug_Xres;
-		viamode.yres = (u32) viafb_hotplug_Yres;
-		viamode.refresh = (u32) viafb_hotplug_refresh;
-		viamode.bpp = (u32) viafb_hotplug_bpp;
+		u.viamode.xres = (u32) viafb_hotplug_Xres;
+		u.viamode.yres = (u32) viafb_hotplug_Yres;
+		u.viamode.refresh = (u32) viafb_hotplug_refresh;
+		u.viamode.bpp = (u32) viafb_hotplug_bpp;
 		if (viafb_SAMM_ON == 1) {
-			viamode.xres_sec = viafb_second_xres;
-			viamode.yres_sec = viafb_second_yres;
-			viamode.virtual_xres_sec = viafb_second_virtual_xres;
-			viamode.virtual_yres_sec = viafb_second_virtual_yres;
-			viamode.refresh_sec = viafb_refresh1;
-			viamode.bpp_sec = viafb_bpp1;
+			u.viamode.xres_sec = viafb_second_xres;
+			u.viamode.yres_sec = viafb_second_yres;
+			u.viamode.virtual_xres_sec = viafb_second_virtual_xres;
+			u.viamode.virtual_yres_sec = viafb_second_virtual_yres;
+			u.viamode.refresh_sec = viafb_refresh1;
+			u.viamode.bpp_sec = viafb_bpp1;
 		} else {
-			viamode.xres_sec = 0;
-			viamode.yres_sec = 0;
-			viamode.virtual_xres_sec = 0;
-			viamode.virtual_yres_sec = 0;
-			viamode.refresh_sec = 0;
-			viamode.bpp_sec = 0;
+			u.viamode.xres_sec = 0;
+			u.viamode.yres_sec = 0;
+			u.viamode.virtual_xres_sec = 0;
+			u.viamode.virtual_yres_sec = 0;
+			u.viamode.refresh_sec = 0;
+			u.viamode.bpp_sec = 0;
 		}
-		if (copy_to_user(argp, &viamode, sizeof(viamode)))
+		if (copy_to_user(argp, &u.viamode, sizeof(u.viamode)))
 			return -EFAULT;
 		break;
 	case VIAFB_GET_SAMM_INFO:
-		viasamm.samm_status = viafb_SAMM_ON;
+		u.viasamm.samm_status = viafb_SAMM_ON;
 
 		if (viafb_SAMM_ON == 1) {
 			if (viafb_dual_fb) {
-				viasamm.size_prim = viaparinfo->fbmem_free;
-				viasamm.size_sec = viaparinfo1->fbmem_free;
+				u.viasamm.size_prim = viaparinfo->fbmem_free;
+				u.viasamm.size_sec = viaparinfo1->fbmem_free;
 			} else {
 				if (viafb_second_size) {
-					viasamm.size_prim =
+					u.viasamm.size_prim =
 					    viaparinfo->fbmem_free -
 					    viafb_second_size * 1024 * 1024;
-					viasamm.size_sec =
+					u.viasamm.size_sec =
 					    viafb_second_size * 1024 * 1024;
 				} else {
-					viasamm.size_prim =
+					u.viasamm.size_prim =
 					    viaparinfo->fbmem_free >> 1;
-					viasamm.size_sec =
+					u.viasamm.size_sec =
 					    (viaparinfo->fbmem_free >> 1);
 				}
 			}
-			viasamm.mem_base = viaparinfo->fbmem;
-			viasamm.offset_sec = viafb_second_offset;
+			u.viasamm.mem_base = viaparinfo->fbmem;
+			u.viasamm.offset_sec = viafb_second_offset;
 		} else {
-			viasamm.size_prim =
+			u.viasamm.size_prim =
 			    viaparinfo->memsize - viaparinfo->fbmem_used;
-			viasamm.size_sec = 0;
-			viasamm.mem_base = viaparinfo->fbmem;
-			viasamm.offset_sec = 0;
+			u.viasamm.size_sec = 0;
+			u.viasamm.mem_base = viaparinfo->fbmem;
+			u.viasamm.offset_sec = 0;
 		}
 
-		if (copy_to_user(argp, &viasamm, sizeof(viasamm)))
+		if (copy_to_user(argp, &u.viasamm, sizeof(u.viasamm)))
 			return -EFAULT;
 
 		break;
@@ -662,74 +664,75 @@ static int viafb_ioctl(struct fb_info *i
 			viafb_lcd_disable();
 		break;
 	case VIAFB_SET_DEVICE:
-		if (copy_from_user(&active_dev, (void *)argp,
-			sizeof(active_dev)))
+		if (copy_from_user(&u.active_dev, (void *)argp,
+			sizeof(u.active_dev)))
 			return -EFAULT;
-		viafb_set_device(active_dev);
+		viafb_set_device(u.active_dev);
 		viafb_set_par(info);
 		break;
 	case VIAFB_GET_DEVICE:
-		active_dev.crt = viafb_CRT_ON;
-		active_dev.dvi = viafb_DVI_ON;
-		active_dev.lcd = viafb_LCD_ON;
-		active_dev.samm = viafb_SAMM_ON;
-		active_dev.primary_dev = viafb_primary_dev;
-
-		active_dev.lcd_dsp_cent = viafb_lcd_dsp_method;
-		active_dev.lcd_panel_id = viafb_lcd_panel_id;
-		active_dev.lcd_mode = viafb_lcd_mode;
-
-		active_dev.xres = viafb_hotplug_Xres;
-		active_dev.yres = viafb_hotplug_Yres;
-
-		active_dev.xres1 = viafb_second_xres;
-		active_dev.yres1 = viafb_second_yres;
-
-		active_dev.bpp = viafb_bpp;
-		active_dev.bpp1 = viafb_bpp1;
-		active_dev.refresh = viafb_refresh;
-		active_dev.refresh1 = viafb_refresh1;
-
-		active_dev.epia_dvi = viafb_platform_epia_dvi;
-		active_dev.lcd_dual_edge = viafb_device_lcd_dualedge;
-		active_dev.bus_width = viafb_bus_width;
+		u.active_dev.crt = viafb_CRT_ON;
+		u.active_dev.dvi = viafb_DVI_ON;
+		u.active_dev.lcd = viafb_LCD_ON;
+		u.active_dev.samm = viafb_SAMM_ON;
+		u.active_dev.primary_dev = viafb_primary_dev;
+
+		u.active_dev.lcd_dsp_cent = viafb_lcd_dsp_method;
+		u.active_dev.lcd_panel_id = viafb_lcd_panel_id;
+		u.active_dev.lcd_mode = viafb_lcd_mode;
+
+		u.active_dev.xres = viafb_hotplug_Xres;
+		u.active_dev.yres = viafb_hotplug_Yres;
+
+		u.active_dev.xres1 = viafb_second_xres;
+		u.active_dev.yres1 = viafb_second_yres;
+
+		u.active_dev.bpp = viafb_bpp;
+		u.active_dev.bpp1 = viafb_bpp1;
+		u.active_dev.refresh = viafb_refresh;
+		u.active_dev.refresh1 = viafb_refresh1;
+
+		u.active_dev.epia_dvi = viafb_platform_epia_dvi;
+		u.active_dev.lcd_dual_edge = viafb_device_lcd_dualedge;
+		u.active_dev.bus_width = viafb_bus_width;
 
-		if (copy_to_user(argp, &active_dev, sizeof(active_dev)))
+		if (copy_to_user(argp, &u.active_dev, sizeof(u.active_dev)))
 			return -EFAULT;
 		break;
 
 	case VIAFB_GET_DRIVER_VERSION:
-		driver_version.iMajorNum = VERSION_MAJOR;
-		driver_version.iKernelNum = VERSION_KERNEL;
-		driver_version.iOSNum = VERSION_OS;
-		driver_version.iMinorNum = VERSION_MINOR;
+		u.driver_version.iMajorNum = VERSION_MAJOR;
+		u.driver_version.iKernelNum = VERSION_KERNEL;
+		u.driver_version.iOSNum = VERSION_OS;
+		u.driver_version.iMinorNum = VERSION_MINOR;
 
-		if (copy_to_user(argp, &driver_version,
-			sizeof(driver_version)))
+		if (copy_to_user(argp, &u.driver_version,
+			sizeof(u.driver_version)))
 			return -EFAULT;
 
 		break;
 
 	case VIAFB_SET_DEVICE_INFO:
-		if (copy_from_user(&viafb_setting,
-			argp, sizeof(viafb_setting)))
+		if (copy_from_user(&u.viafb_setting,
+			argp, sizeof(u.viafb_setting)))
 			return -EFAULT;
-		if (apply_device_setting(viafb_setting, info) < 0)
+		if (apply_device_setting(u.viafb_setting, info) < 0)
 			return -EINVAL;
 
 		break;
 
 	case VIAFB_SET_SECOND_MODE:
-		if (copy_from_user(&sec_var, argp, sizeof(sec_var)))
+		if (copy_from_user(&u.sec_var, argp, sizeof(u.sec_var)))
 			return -EFAULT;
-		apply_second_mode_setting(&sec_var);
+		apply_second_mode_setting(&u.sec_var);
 		break;
 
 	case VIAFB_GET_DEVICE_INFO:
 
-		retrieve_device_setting(&viafb_setting);
+		retrieve_device_setting(&u.viafb_setting);
 
-		if (copy_to_user(argp, &viafb_setting, sizeof(viafb_setting)))
+		if (copy_to_user(argp, &u.viafb_setting,
+				 sizeof(u.viafb_setting)))
 			return -EFAULT;
 
 		break;
@@ -806,51 +809,51 @@ static int viafb_ioctl(struct fb_info *i
 		break;
 
 	case VIAFB_GET_PANEL_MAX_SIZE:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
-		panel_pos_size_para.x = panel_pos_size_para.y = 0;
-		if (copy_to_user(argp, &panel_pos_size_para,
-		     sizeof(panel_pos_size_para)))
+		u.panel_pos_size_para.x = u.panel_pos_size_para.y = 0;
+		if (copy_to_user(argp, &u.panel_pos_size_para,
+		     sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
 	case VIAFB_GET_PANEL_MAX_POSITION:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
-		panel_pos_size_para.x = panel_pos_size_para.y = 0;
-		if (copy_to_user(argp, &panel_pos_size_para,
-		     sizeof(panel_pos_size_para)))
+		u.panel_pos_size_para.x = u.panel_pos_size_para.y = 0;
+		if (copy_to_user(argp, &u.panel_pos_size_para,
+				 sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
 
 	case VIAFB_GET_PANEL_POSITION:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
-		panel_pos_size_para.x = panel_pos_size_para.y = 0;
-		if (copy_to_user(argp, &panel_pos_size_para,
-		     sizeof(panel_pos_size_para)))
+		u.panel_pos_size_para.x = u.panel_pos_size_para.y = 0;
+		if (copy_to_user(argp, &u.panel_pos_size_para,
+				 sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
 	case VIAFB_GET_PANEL_SIZE:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
-		panel_pos_size_para.x = panel_pos_size_para.y = 0;
-		if (copy_to_user(argp, &panel_pos_size_para,
-		     sizeof(panel_pos_size_para)))
+		u.panel_pos_size_para.x = u.panel_pos_size_para.y = 0;
+		if (copy_to_user(argp, &u.panel_pos_size_para,
+				 sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
 
 	case VIAFB_SET_PANEL_POSITION:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
 	case VIAFB_SET_PANEL_SIZE:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
 
@@ -1052,10 +1055,8 @@ static void viafb_imageblit(struct fb_in
 
 static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
-	u8 data[CURSOR_SIZE / 8];
-	u32 data_bak[CURSOR_SIZE / 32];
 	u32 temp, xx, yy, bg_col = 0, fg_col = 0;
-	int size, i, j = 0;
+	int i, j = 0;
 	static int hw_cursor;
 	struct viafb_par *p_viafb_par;
 
@@ -1178,22 +1179,29 @@ static int viafb_cursor(struct fb_info *
 	}
 
 	if (cursor->set & FB_CUR_SETSHAPE) {
-		size =
+		struct {
+			u8 data[CURSOR_SIZE / 8];
+			u32 bak[CURSOR_SIZE / 32];
+		} *cr_data = kzalloc(sizeof(*cr_data), GFP_ATOMIC);
+		int size =
 		    ((viacursor.image.width + 7) >> 3) *
 		    viacursor.image.height;
 
+		if (cr_data == NULL)
+			goto out;
+
 		if (MAX_CURS == 32) {
 			for (i = 0; i < (CURSOR_SIZE / 32); i++) {
-				data_bak[i] = 0x0;
-				data_bak[i + 1] = 0xFFFFFFFF;
+				cr_data->bak[i] = 0x0;
+				cr_data->bak[i + 1] = 0xFFFFFFFF;
 				i += 1;
 			}
 		} else if (MAX_CURS == 64) {
 			for (i = 0; i < (CURSOR_SIZE / 32); i++) {
-				data_bak[i] = 0x0;
-				data_bak[i + 1] = 0x0;
-				data_bak[i + 2] = 0xFFFFFFFF;
-				data_bak[i + 3] = 0xFFFFFFFF;
+				cr_data->bak[i] = 0x0;
+				cr_data->bak[i + 1] = 0x0;
+				cr_data->bak[i + 2] = 0xFFFFFFFF;
+				cr_data->bak[i + 3] = 0xFFFFFFFF;
 				i += 3;
 			}
 		}
@@ -1201,12 +1209,12 @@ static int viafb_cursor(struct fb_info *
 		switch (viacursor.rop) {
 		case ROP_XOR:
 			for (i = 0; i < size; i++)
-				data[i] = viacursor.mask[i];
+				cr_data->data[i] = viacursor.mask[i];
 			break;
 		case ROP_COPY:
 
 			for (i = 0; i < size; i++)
-				data[i] = viacursor.mask[i];
+				cr_data->data[i] = viacursor.mask[i];
 			break;
 		default:
 			break;
@@ -1214,23 +1222,25 @@ static int viafb_cursor(struct fb_info *
 
 		if (MAX_CURS == 32) {
 			for (i = 0; i < size; i++) {
-				data_bak[j] = (u32) data[i];
-				data_bak[j + 1] = ~data_bak[j];
+				cr_data->bak[j] = (u32) cr_data->data[i];
+				cr_data->bak[j + 1] = ~cr_data->bak[j];
 				j += 2;
 			}
 		} else if (MAX_CURS == 64) {
 			for (i = 0; i < size; i++) {
-				data_bak[j] = (u32) data[i];
-				data_bak[j + 1] = 0x0;
-				data_bak[j + 2] = ~data_bak[j];
-				data_bak[j + 3] = ~data_bak[j + 1];
+				cr_data->bak[j] = (u32) cr_data->data[i];
+				cr_data->bak[j + 1] = 0x0;
+				cr_data->bak[j + 2] = ~cr_data->bak[j];
+				cr_data->bak[j + 3] = ~cr_data->bak[j + 1];
 				j += 4;
 			}
 		}
 
 		memcpy(((struct viafb_par *)(info->par))->fbmem_virt +
 		       ((struct viafb_par *)(info->par))->cursor_start,
-		       data_bak, CURSOR_SIZE);
+		       cr_data->bak, CURSOR_SIZE);
+out:
+		kfree(cr_data);
 	}
 
 	if (viacursor.enable)
