Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYKPKwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYKPKwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYKPKwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:52:47 -0500
Received: from ppp-111-253.adsl.restena.lu ([158.64.111.253]:37706 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751709AbYKPKwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:52:45 -0500
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Nov 2008 05:52:45 EST
Date: Sun, 16 Nov 2008 11:42:12 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: JosephChan@via.com.tw, Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] viafb: fix releasing of /proc/viafb/ subtree
Message-ID: <20081116114212.26370ef8@neptune.home>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unloading viafb module it does not remove it's /proc/viafb/
subtree which causes multiple viafb directories to appear below
proc when mobprobing viafb and also lets kernel WARN() on duplicate
proc entries:

[  145.458387] WARNING: at /usr/src/linux-2.6.28-rc3-git6/fs/proc/generic.c:551 proc_register+0xe6/0x160()
[  145.458945] proc_dir_entry '/proc/viafb' already registered
[  145.459278] Modules linked in: viafb(+) i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc sg via_agp agpgart [last unloaded: drm]
[  145.460647] Pid: 1904, comm: modprobe Tainted: G        W  2.6.28-rc3-git6 #4
[  145.461064] Call Trace:
[  145.461248]  [<c01066f1>] ? dump_stack+0x1/0x80
[  145.461533]  [<c01228a3>] warn_slowpath+0x63/0x80
[  145.461851]  [<c0253ec9>] ? idr_get_empty_slot+0xe9/0x250
[  145.462186]  [<c0254120>] ? ida_get_new_above+0xf0/0x150
[  145.462528]  [<c019fb86>] proc_register+0xe6/0x160
[  145.462827]  [<c019fdc6>] proc_mkdir_mode+0x36/0x50
[  145.463135]  [<c019fdef>] proc_mkdir+0xf/0x20
[  145.463457]  [<f807173c>] viafb_init+0x73c/0xc86 [viafb]
[  145.463823]  [<f8071000>] ? viafb_init+0x0/0xc86 [viafb]
[  145.464147]  [<c010111d>] do_one_initcall+0x2d/0x160
[  145.464460]  [<c01a6543>] ? sysfs_add_file+0x13/0x20
[  145.464786]  [<c015f031>] ? vfree+0x21/0x30
[  145.465049]  [<c01433b5>] ? load_module+0x1215/0x1500
[  145.465381]  [<c014e455>] ? __alloc_pages_internal+0x95/0x400
[  145.465755]  [<c0143723>] sys_init_module+0x83/0x1a0
[  145.466065]  [<c016ceed>] ? sys_read+0x3d/0x70
[  145.466354]  [<c0103bc1>] sysenter_do_call+0x12/0x25
[  145.466653] ---[ end trace c84b37826e16748c ]---

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
--- linux-2.6.28-rc3-git6.orig/drivers/video/via/viafbdev.c	2008-11-09 19:36:47.000000000 +0100
+++ linux-2.6.28-rc3-git6/drivers/video/via/viafbdev.c	2008-11-16 00:20:10.000000000 +0100
@@ -2036,30 +2036,30 @@ static int viafb_vt1636_proc_write(struc
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
@@ -2068,7 +2068,7 @@ static void viafb_init_proc(struct proc_
 		if (VT1636_LVDS == viaparinfo->chip_info->lvds_chip_info.
 			lvds_chip_name || VT1636_LVDS ==
 		    viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name) {
-			entry = create_proc_entry("vt1636", 0, viafb_entry);
+			entry = create_proc_entry("vt1636", 0, *viafb_entry);
 			if (entry) {
 				entry->owner = THIS_MODULE;
 				entry->read_proc = viafb_vt1636_proc_read;
@@ -2087,6 +2087,7 @@ static void viafb_remove_proc(struct pro
 	remove_proc_entry("dfpl", viafb_entry);
 	remove_proc_entry("vt1636", viafb_entry);
 	remove_proc_entry("vt1625", viafb_entry);
+	remove_proc_entry("viafb", NULL);
 }
 
 static int __devinit via_pci_probe(void)
@@ -2348,7 +2349,7 @@ static int __devinit via_pci_probe(void)
 		  viafbinfo->node, viafbinfo->fix.id, default_var.xres,
 		  default_var.yres, default_var.bits_per_pixel);
 
-	viafb_init_proc(viaparinfo->proc_entry);
+	viafb_init_proc(&viaparinfo->proc_entry);
 	viafb_init_dac(IGA2);
 	return 0;
 }
