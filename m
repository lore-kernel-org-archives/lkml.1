Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZIGCXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZIGCXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 22:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758520AbZIGCXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 22:23:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:47964 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758742AbZIGCXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:23:30 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18dBKRsHhUdtIuoRsjtffdAourp4tPJ8MhCks9NdF
	8HvaCbCK+gUCKL
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/3] viafb: use read-only mode parsing
Date: Mon,  7 Sep 2009 02:24:44 +0000
Message-Id: <1252290284-3668-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1252290284-3668-2-git-send-email-FlorianSchandinat@gmx.de>
References: <1252290284-3668-1-git-send-email-FlorianSchandinat@gmx.de>
 <1252290284-3668-2-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: use read-only mode parsing

The previous method of mode parsing wrote to the strings resulting in
truncated mode strings in the sysfs.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |   44 +++++++++++++++++++++++------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index a5bbcab..4f7cf69 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1780,11 +1780,29 @@ static void viafb_remove_proc(struct proc_dir_entry *viafb_entry)
 	remove_proc_entry("viafb", NULL);
 }
 
+static void parse_mode(const char *str, u32 *xres, u32 *yres)
+{
+	char *ptr;
+
+	*xres = simple_strtoul(str, &ptr, 10);
+	if (ptr[0] != 'x')
+		goto out_default;
+
+	*yres = simple_strtoul(&ptr[1], &ptr, 10);
+	if (ptr[0])
+		goto out_default;
+
+	return;
+
+out_default:
+	printk(KERN_WARNING "viafb received invalid mode string: %s\n", str);
+	*xres = 640;
+	*yres = 480;
+}
+
 static int __devinit via_pci_probe(void)
 {
-	unsigned long default_xres, default_yres;
-	char *tmpc, *tmpm;
-	char *tmpc_sec, *tmpm_sec;
+	u32 default_xres, default_yres;
 	int vmode_index;
 	u32 viafb_par_length;
 
@@ -1861,26 +1879,14 @@ static int __devinit via_pci_probe(void)
 			viafb_second_size * 1024 * 1024;
 	}
 
-	tmpm = viafb_mode;
-	tmpc = strsep(&tmpm, "x");
-	strict_strtoul(tmpc, 0, &default_xres);
-	strict_strtoul(tmpm, 0, &default_yres);
-
+	parse_mode(viafb_mode, &default_xres, &default_yres);
 	vmode_index = viafb_get_mode_index(default_xres, default_yres);
 	DEBUG_MSG(KERN_INFO "0->index=%d\n", vmode_index);
 
 	if (viafb_SAMM_ON == 1) {
-		if (strcmp(viafb_mode, viafb_mode1)) {
-			tmpm_sec = viafb_mode1;
-			tmpc_sec = strsep(&tmpm_sec, "x");
-			strict_strtoul(tmpc_sec, 0,
-				(unsigned long *)&viafb_second_xres);
-			strict_strtoul(tmpm_sec, 0,
-				(unsigned long *)&viafb_second_yres);
-		} else {
-			viafb_second_xres = default_xres;
-			viafb_second_yres = default_yres;
-		}
+		parse_mode(viafb_mode1, &viafb_second_xres,
+			&viafb_second_yres);
+
 		if (0 == viafb_second_virtual_xres) {
 			switch (viafb_second_xres) {
 			case 1400:
-- 
1.6.3.2

