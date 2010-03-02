Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0CBXiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:38:01 -0500
Received: from kroah.org ([198.145.64.141]:51657 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab0CBXhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ari Entlich <atrigent@ccs.neu.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/36] tty: Add a new VT mode which is like VT_PROCESS but doesn't require a VT_RELDISP ioctl call
Date: Tue,  2 Mar 2010 15:36:41 -0800
Message-Id: <1267573003-782-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ari Entlich <atrigent@ccs.neu.edu>

This new VT mode (VT_PROCESS_AUTO) does everything that VT_PROCESS does
except that it doesn't wait for a VT_RELDISP ioctl before switching
away from a VT with that mode.

If the X server eventually uses this new mode, debugging and crash
recovery should become easier. This is because even when currently in
the VT of a frozen X server it would still be possible to switch out
by doing SysRq-r and then CTRL-<number of a text vt>, sshing in and
doing chvt <number of a text vt>, or any other method of VT switching.
The general concensus on #xorg-devel seems to be that it should be
safe to use this with X now that we have KMS.

This also moves the VT_ACKACQ define to a more appropriate place,
for clarity's sake.

Signed-off-by: Ari Entlich <atrigent@ccs.neu.edu>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt_ioctl.c |   39 ++++++++++++++++++++-------------------
 include/linux/vt.h      |    3 ++-
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 6aa1028..87778dc 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -888,7 +888,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 			ret = -EFAULT;
 			goto out;
 		}
-		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS) {
+		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS && tmp.mode != VT_PROCESS_AUTO) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1622,7 +1622,7 @@ static void complete_change_console(struct vc_data *vc)
 	 * telling it that it has acquired. Also check if it has died and
 	 * clean up (similar to logic employed in change_console())
 	 */
-	if (vc->vt_mode.mode == VT_PROCESS) {
+	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {
 		/*
 		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
@@ -1682,7 +1682,7 @@ void change_console(struct vc_data *new_vc)
 	 * vt to auto control.
 	 */
 	vc = vc_cons[fg_console].d;
-	if (vc->vt_mode.mode == VT_PROCESS) {
+	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {
 		/*
 		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
@@ -1693,27 +1693,28 @@ void change_console(struct vc_data *new_vc)
 		 */
 		vc->vt_newvt = new_vc->vc_num;
 		if (kill_pid(vc->vt_pid, vc->vt_mode.relsig, 1) == 0) {
+			if(vc->vt_mode.mode == VT_PROCESS)
+				/*
+				 * It worked. Mark the vt to switch to and
+				 * return. The process needs to send us a
+				 * VT_RELDISP ioctl to complete the switch.
+				 */
+				return;
+		} else {
 			/*
-			 * It worked. Mark the vt to switch to and
-			 * return. The process needs to send us a
-			 * VT_RELDISP ioctl to complete the switch.
+			 * The controlling process has died, so we revert back to
+			 * normal operation. In this case, we'll also change back
+			 * to KD_TEXT mode. I'm not sure if this is strictly correct
+			 * but it saves the agony when the X server dies and the screen
+			 * remains blanked due to KD_GRAPHICS! It would be nice to do
+			 * this outside of VT_PROCESS but there is no single process
+			 * to account for and tracking tty count may be undesirable.
 			 */
-			return;
+			reset_vc(vc);
 		}
 
 		/*
-		 * The controlling process has died, so we revert back to
-		 * normal operation. In this case, we'll also change back
-		 * to KD_TEXT mode. I'm not sure if this is strictly correct
-		 * but it saves the agony when the X server dies and the screen
-		 * remains blanked due to KD_GRAPHICS! It would be nice to do
-		 * this outside of VT_PROCESS but there is no single process
-		 * to account for and tracking tty count may be undesirable.
-		 */
-		reset_vc(vc);
-
-		/*
-		 * Fall through to normal (VT_AUTO) handling of the switch...
+		 * Fall through to normal (VT_AUTO and VT_PROCESS_AUTO) handling of the switch...
 		 */
 	}
 
diff --git a/include/linux/vt.h b/include/linux/vt.h
index d5dd0bc..778b7b2 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -27,7 +27,7 @@ struct vt_mode {
 #define VT_SETMODE	0x5602	/* set mode of active vt */
 #define		VT_AUTO		0x00	/* auto vt switching */
 #define		VT_PROCESS	0x01	/* process controls switching */
-#define		VT_ACKACQ	0x02	/* acknowledge switch */
+#define		VT_PROCESS_AUTO 0x02	/* process is notified of switching */
 
 struct vt_stat {
 	unsigned short v_active;	/* active vt */
@@ -38,6 +38,7 @@ struct vt_stat {
 #define VT_SENDSIG	0x5604	/* signal to send to bitmask of vts */
 
 #define VT_RELDISP	0x5605	/* release display */
+#define		VT_ACKACQ	0x02	/* acknowledge switch */
 
 #define VT_ACTIVATE	0x5606	/* make vt active */
 #define VT_WAITACTIVE	0x5607	/* wait for vt active */
-- 
1.7.0.1

