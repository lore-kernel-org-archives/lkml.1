Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0BSAzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:55:18 -0500
Received: from zimbra.ccs.neu.edu ([129.10.116.59]:34722 "EHLO
	zimbra.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0BSAzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:55:12 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Feb 2010 19:55:11 EST
Date: Thu, 18 Feb 2010 19:48:07 -0500 (EST)
From: atrigent@ccs.neu.edu
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <2582583.137891266540487930.JavaMail.root@zimbra>
In-Reply-To: <8618245.137111266537413491.JavaMail.root@zimbra>
Subject: [PATCH] Add a new VT mode which is like VT_PROCESS but doesn't
 require a VT_RELDISP ioctl call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [129.10.223.192]
X-Mailer: Zimbra 5.0.22_GA_3210.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.22_GA_3210.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Ari Entlich <atrigent@ccs.neu.edu>
---
This should apply to Linus' tree. It has been compile tested only - I just
want to see whether I'm on the right track/whether there's anything big I
overlooked/whether there are any obvious mistakes here.

I was advised to CC Linus and akpm because of the subsystem that this
touches. I hope that was appropriate.

Thanks!

 drivers/char/vt_ioctl.c |   39 ++++++++++++++++++++-------------------
 include/linux/vt.h      |    1 +
 2 files changed, 21 insertions(+), 19 deletions(-)

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
index d5dd0bc..dedf419 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -27,6 +27,7 @@ struct vt_mode {
 #define VT_SETMODE	0x5602	/* set mode of active vt */
 #define		VT_AUTO		0x00	/* auto vt switching */
 #define		VT_PROCESS	0x01	/* process controls switching */
+#define		VT_PROCESS_AUTO 0x02	/* process is notified of switching */
 #define		VT_ACKACQ	0x02	/* acknowledge switch */
 
 struct vt_stat {
-- 
1.6.4.4
