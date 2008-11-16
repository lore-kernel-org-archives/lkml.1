Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYKPLBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYKPLBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 06:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYKPLBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 06:01:08 -0500
Received: from ppp-111-253.adsl.restena.lu ([158.64.111.253]:41850 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751736AbYKPLBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 06:01:06 -0500
Date: Sun, 16 Nov 2008 12:01:03 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: JosephChan@via.com.tw
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: viafb + drm/via: modprobe/rmmod issue
Message-ID: <20081116120103.2c6ae405@neptune.home>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/FNOjNY3Co2sZtlniVx.99=X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/FNOjNY3Co2sZtlniVx.99=X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

When booting into VGA console and executing the following command sequence I
end up with the trace below (which seems to imply that unichrome DRM driver
[via] and viafb enter a race for some memory resource or disagree on the state
of the chipset after unloading).
This looks like the race happens only on modprobing viafb after having unloaded
via drm module while viafb was already unloaded.

Sample trigger sequence 1:
modprobe via
  (loads modules via, drm)
modprobe viafb
  (loads modules i2c_algo_bit, cfbcopyarea, cfbimgblt, cfbfillrect, viafb)
  switches to framebuffer console
echo 0 > /sys/class/vtconsole/vtcon1/bind
  (switch back to vga-console - display stays configured with framebuffer
   mode)
rmmod viafb
  (display stays configured with framebuffer mode)
rmmod via
modprobe via
modprobe viafb
  Segmentation fault


Sample trigger sequence 2:
 modprobe viafb
 modprobe via
 echo 0 > /sys/class/vtconsole/vtcon1/bind
 rmmod viafb
 modprobe viafb
 echo 0 > /sys/class/vtconsole/vtcon1/bind
 rmmod via  
 rmmod viafb
 modprobe via
 rmmod via
 modprobe viafb
   Segmentation fault


Kernel used:
  linux-2.6.28-rc3-git6 with attached patch
  (fixes issues with 4k-stack and viafb not releasing /proc files on rmmod,
  combination of patches:
    http://lkml.org/lkml/2008/11/16/87
    http://lkml.org/lkml/2008/11/10/294)

Extract of kernel config:
#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_VIA=m
CONFIG_DRM=m
CONFIG_DRM_VIA=m
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y
#
# Frame buffer hardware drivers
#
CONFIG_FB_VIA=m
...
CONFIG_4KSTACKS=y

Hardware (Commell LE365):
00:00.0 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:0324] (rev 03)
00:00.1 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:1324]
00:00.2 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:2324]
00:00.3 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:3324]
00:00.4 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:4324]
00:00.7 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:7324]
00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8237 PCI Bridge [1106:b198]
00:0f.0 IDE interface [0101]: VIA Technologies, Inc. Device [1106:0581]
00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 90)
00:10.4 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 90)
00:11.0 ISA bridge [0601]: VIA Technologies, Inc. CX700 PCI to ISA Bridge [1106:8324]
00:11.7 Host bridge [0600]: VIA Technologies, Inc. CX700 Internal Module Bus [1106:324e]
00:13.0 Host bridge [0600]: VIA Technologies, Inc. CX700 Host Bridge [1106:324b]
00:13.1 PCI bridge [0604]: VIA Technologies, Inc. CX700 PCI to PCI Bridge [1106:324a]
01:00.0 VGA compatible controller [0300]: VIA Technologies, Inc. CX700M2 UniChrome PRO II Graphics [1106:3157] (rev 03)
02:08.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet [10ec:8169] (rev 10)
80:01.0 Audio device [0403]: VIA Technologies, Inc. VIA High Definition Audio Controller [1106:3288] (rev 10)


[  856.022761] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[  856.128903] Console: switching to colour frame buffer device 160x64
[  877.052305] Console: switching to colour VGA+ 80x25
[  888.937098] [drm] Module unloaded
[  900.046155] [drm] Initialized via 2.11.1 20070202 on minor 0
[  904.576098] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[  904.661809] ------------[ cut here ]------------
[  904.661951] kernel BUG at /usr/src/linux-2.6.28-rc3-git6/mm/vmalloc.c:293!
[  904.662080] invalid opcode: 0000 [#1] 
[  904.662241] last sysfs file: /sys/devices/platform/w83627hf.656/temp2_input
[  904.662370] Modules linked in: viafb(+) via i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect
               drm snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc sg via_agp
               agpgart [last unloaded: via]
[  904.663579] 
[  904.663680] Pid: 1892, comm: modprobe Not tainted (2.6.28-rc3-git6 #4) CX700+W697HG
[  904.663843] EIP: 0060:[<c015f3ec>] EFLAGS: 00010207 CPU: 0
[  904.663982] EIP is at alloc_vmap_area+0x1ec/0x230
[  904.664100] EAX: 01401000 EBX: fd400000 ECX: f6410800 EDX: f68de50c
[  904.664226] ESI: f6410800 EDI: 04001000 EBP: f642bdbc ESP: f642bd9c
[  904.664352]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  904.664475] Process modprobe (pid: 1892, ti=f642b000 task=f70e2a20 task.ti=f642b000)
[  904.664629] Stack:
[  904.664723]  c011b067 00080000 fff80000 f6410800 00000000 f7305c60 04001000 00080000
[  904.665225]  f642bde4 c015f4d3 ff7fe000 ffffffff 000000d0 f7ffe000 00000001 f7ffe000
[  904.665998]  00000010 a3fff000 f642be00 c015f91b ff7fe000 ffffffff 000000d0 f8074220
[  904.666704] Call Trace:
[  904.666802]  [<c011b067>] ? reserve_memtype+0x277/0x600
[  904.666992]  [<c015f4d3>] ? __get_vm_area_node+0xa3/0x150
[  904.667176]  [<c015f91b>] ? get_vm_area_caller+0x4b/0x60
[  904.667357]  [<f8074220>] ? viafb_init+0x220/0xc86 [viafb]
[  904.667574]  [<c0119609>] ? __ioremap_caller+0x169/0x280
[  904.667759]  [<c0119846>] ? ioremap_nocache+0x16/0x20
[  904.667934]  [<f8074220>] ? viafb_init+0x220/0xc86 [viafb]
[  904.668138]  [<f8074220>] ? viafb_init+0x220/0xc86 [viafb]
[  904.668347]  [<f8074000>] ? viafb_init+0x0/0xc86 [viafb]
[  904.668554]  [<c010111d>] ? do_one_initcall+0x2d/0x160
[  904.668730]  [<c01a6543>] ? sysfs_add_file+0x13/0x20
[  904.668909]  [<c015f031>] ? vfree+0x21/0x30
[  904.669080]  [<c01433b5>] ? load_module+0x1215/0x1500
[  904.669263]  [<c014e455>] ? __alloc_pages_internal+0x95/0x400
[  904.669473]  [<c0143723>] ? sys_init_module+0x83/0x1a0
[  904.669780]  [<c016ceed>] ? sys_read+0x3d/0x70
[  904.669957]  [<c0103bc1>] ? sysenter_do_call+0x12/0x25
[  904.670008] Code: c9 c7 04 24 dc 5d 4a c0 e8 62 41 fc ff c7 45 ec f0 ff ff ff eb b4 8b 4d
                     ec 8b 41 04 3b 42 f4 76 0a 8d 42 04 89 d1 e9 49 ff ff ff <0f> 0b eb fe 8b
                     45 ec 8b 4d ec 8b 15 84 fc 50 c0 83 c0 18 c7 40 
[  904.670008] EIP: [<c015f3ec>] alloc_vmap_area+0x1ec/0x230 SS:ESP 0068:f642bd9c
[  904.674256] ---[ end trace cd2172874c1a60ae ]---

--MP_/FNOjNY3Co2sZtlniVx.99=X
Content-Type: text/x-patch; name=patch-viafb-fixes.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=patch-viafb-fixes.diff

--- linux-2.6.28-rc3-git6.orig/drivers/video/via/viafbdev.c	2008-11-09 19:36:47.000000000 +0100
+++ linux-2.6.28-rc3-git6/drivers/video/via/viafbdev.c	2008-11-16 00:20:10.000000000 +0100
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
@@ -2036,30 +2046,30 @@ static int viafb_vt1636_proc_write(struc
 	return count;
 }
 
-static void viafb_init_proc(struct proc_dir_entry *viafb_entry)
+static void viafb_init_proc(struct proc_dir_entry **viafb_entry)
 {
 	struct proc_dir_entry *entry;
-	viafb_entry = proc_mkdir("viafb", NULL);
+	*viafb_entry = proc_mkdir("viafb", NULL);
 	if (viafb_entry) {
-		entry = create_proc_entry("dvp0", 0, viafb_entry);
+		entry = create_proc_entry("dvp0", 0, *viafb_entry);
 		if (entry) {
 			entry->owner = THIS_MODULE;
 			entry->read_proc = viafb_dvp0_proc_read;
 			entry->write_proc = viafb_dvp0_proc_write;
 		}
-		entry = create_proc_entry("dvp1", 0, viafb_entry);
+		entry = create_proc_entry("dvp1", 0, *viafb_entry);
 		if (entry) {
 			entry->owner = THIS_MODULE;
 			entry->read_proc = viafb_dvp1_proc_read;
 			entry->write_proc = viafb_dvp1_proc_write;
 		}
-		entry = create_proc_entry("dfph", 0, viafb_entry);
+		entry = create_proc_entry("dfph", 0, *viafb_entry);
 		if (entry) {
 			entry->owner = THIS_MODULE;
 			entry->read_proc = viafb_dfph_proc_read;
 			entry->write_proc = viafb_dfph_proc_write;
 		}
-		entry = create_proc_entry("dfpl", 0, viafb_entry);
+		entry = create_proc_entry("dfpl", 0, *viafb_entry);
 		if (entry) {
 			entry->owner = THIS_MODULE;
 			entry->read_proc = viafb_dfpl_proc_read;
@@ -2068,7 +2078,7 @@ static void viafb_init_proc(struct proc_
 		if (VT1636_LVDS == viaparinfo->chip_info->lvds_chip_info.
 			lvds_chip_name || VT1636_LVDS ==
 		    viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name) {
-			entry = create_proc_entry("vt1636", 0, viafb_entry);
+			entry = create_proc_entry("vt1636", 0, *viafb_entry);
 			if (entry) {
 				entry->owner = THIS_MODULE;
 				entry->read_proc = viafb_vt1636_proc_read;
@@ -2087,6 +2097,7 @@ static void viafb_remove_proc(struct pro
 	remove_proc_entry("dfpl", viafb_entry);
 	remove_proc_entry("vt1636", viafb_entry);
 	remove_proc_entry("vt1625", viafb_entry);
+	remove_proc_entry("viafb", NULL);
 }
 
 static int __devinit via_pci_probe(void)
@@ -2348,7 +2359,7 @@ static int __devinit via_pci_probe(void)
 		  viafbinfo->node, viafbinfo->fix.id, default_var.xres,
 		  default_var.yres, default_var.bits_per_pixel);
 
-	viafb_init_proc(viaparinfo->proc_entry);
+	viafb_init_proc(&viaparinfo->proc_entry);
 	viafb_init_dac(IGA2);
 	return 0;
 }

--MP_/FNOjNY3Co2sZtlniVx.99=X--
