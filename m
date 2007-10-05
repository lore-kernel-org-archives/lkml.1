Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbXJEL4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbXJEL4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXJELzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:55:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37732 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbXJELzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:55:53 -0400
Date: Fri, 5 Oct 2007 13:55:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       adaplas@gmail.com
Subject: [PATCH] vc bell config
Message-ID: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It is already possible to deactivate the vc bell on a per-tty basis,
by using echo -en "\e[11;0]", but this is reset on reset(1).

This adds a sysfs parameter to globally control the vc bell, as well
as sysfs parameters for default pitch and duration.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/char/vt.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.23/drivers/char/vt.c
===================================================================
--- linux-2.6.23.orig/drivers/char/vt.c
+++ linux-2.6.23/drivers/char/vt.c
@@ -134,8 +134,12 @@ const struct consw *conswitchp;
 /*
  * Here is the default bell parameters: 750HZ, 1/8th of a second
  */
-#define DEFAULT_BELL_PITCH	750
-#define DEFAULT_BELL_DURATION	(HZ/8)
+static unsigned int default_bell_pitch = 750;
+static unsigned int default_bell_duration = HZ / 8;
+static unsigned int vc_bell_enabled = true;
+module_param_named(bell_pitch, default_bell_pitch, uint, S_IRUGO | S_IWUSR);
+module_param_named(bell_duration, default_bell_duration, uint, S_IRUGO | S_IWUSR);
+module_param_named(bell_enabled, vc_bell_enabled, uint, S_IRUGO | S_IWUSR);
 
 struct vc vc_cons [MAX_NR_CONSOLES];
 
@@ -1401,14 +1405,14 @@ static void setterm_command(struct vc_da
 			if (vc->vc_npar >= 1)
 				vc->vc_bell_pitch = vc->vc_par[1];
 			else
-				vc->vc_bell_pitch = DEFAULT_BELL_PITCH;
+				vc->vc_bell_pitch = default_bell_pitch;
 			break;
 		case 11: /* set bell duration in msec */
 			if (vc->vc_npar >= 1)
 				vc->vc_bell_duration = (vc->vc_par[1] < 2000) ?
 					vc->vc_par[1] * HZ / 1000 : 0;
 			else
-				vc->vc_bell_duration = DEFAULT_BELL_DURATION;
+				vc->vc_bell_duration = default_bell_duration;
 			break;
 		case 12: /* bring specified console to the front */
 			if (vc->vc_par[1] >= 1 && vc_cons_allocated(vc->vc_par[1] - 1))
@@ -1554,8 +1558,8 @@ static void reset_terminal(struct vc_dat
 	vc->vc_tab_stop[3]	=
 	vc->vc_tab_stop[4]	= 0x01010101;
 
-	vc->vc_bell_pitch = DEFAULT_BELL_PITCH;
-	vc->vc_bell_duration = DEFAULT_BELL_DURATION;
+	vc->vc_bell_pitch = default_bell_pitch;
+	vc->vc_bell_duration = default_bell_duration;
 
 	gotoxy(vc, 0, 0);
 	save_cur(vc);
@@ -1574,7 +1578,7 @@ static void do_con_trol(struct tty_struc
 	case 0:
 		return;
 	case 7:
-		if (vc->vc_bell_duration)
+		if (vc_bell_enabled && vc->vc_bell_duration)
 			kd_mksound(vc->vc_bell_pitch, vc->vc_bell_duration);
 		return;
 	case 8:

